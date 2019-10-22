#!/bin/bash

#PID du processus en cours
monPID=$$
idCapteur=X54325
intervalle=2
D_WAIT=0
#On initialise le fichier .attrib
DATA_SCRIPTS/./InitEntete.sh -id $idCapteur -ma Campbell Scientific -mo CS100 -u "hPA" -m PressionAtmosphérique -la 15.605 -lo \-16.014782 -i $intervalle
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
    #On va chercher la mémoire cache utilisé en cache
    MemCache=$(($(vmstat |tail -n 1| awk '{print $6}')/1400))
    #On écrit dans un fichier pour pouvoir transmettre les données à JournaliserDonnees
    echo $idCapteur $MemCache > SENSOR/$idCapteur/"$idCapteur"_TEMP.txt
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
