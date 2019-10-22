#!/bin/bash

#PID du processus en cours
monPID=$$
idCapteur=X54350
intervalle=3
D_WAIT=0
#On initialise le fichier .attrib
DATA_SCRIPTS/./InitEntete.sh -id $idCapteur -ma Campbell Scientific -mo CS215 -u "%" -m "HumiditéRelativeDeLaire" -la 18.00222 -lo 64.014782 -i $intervalle
#Lorsque l'on reçoit SIGUSR1, on sort de la boucle d'attente
trap 'D_WAIT=0' SIGUSR1
#On lance JournaliserDonnees en arrière plan
./SENSOR/JournaliserDonnees.sh $monPID $idCapteur &
PidJournaliser="$!"
#On écrit le PID de JournaliserDonnees dans un fichier pour pouvoir l'arrêter plus tard
echo $PidJournaliser >> DATA_SCRIPTS/PID_PROCESS.txt
while :
  do
    #On attend pour laisser le temps à ./SENSOR/JournaliserDonnees.sh de se lancer
    sleep 0.001
    #On va chercher l'utilisation du CPU
    pourceCPU=$(top -n1 -b | head -n 8 | tail -n 1 | awk '{print $9}')
    pourceCPU=$(echo $pourceCPU | sed s/','/'\.'/g)
    #On écrit dans un fichier pour pouvoir transmettre les données à JournaliserDonnees
    echo $idCapteur $(echo "scale=1;$pourceCPU/2+1" | bc -l)> SENSOR/$idCapteur/"$idCapteur"_TEMP.txt
    #On passe dans la boucle d'attente
    D_WAIT=1
    #On envoie le signal à JournaliserDonnees
    kill -SIGUSR1 $PidJournaliser
    #Boucle d'attente
    while [ $D_WAIT -eq 1 ]
    do
      :
        #On ralentit la boucle d'attente pour ne pas surcharger le processeur
        sleep 0.001
    done
    #On respecte l'intervalle de mesure demandé
    sleep $intervalle
  done
