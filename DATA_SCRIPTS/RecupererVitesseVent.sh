#!/bin/bash

#PID du processus en cours
monPID=$$
idCapteur=X54324
intervalle=4
D_WAIT=0
#On initialise le fichier .attrib
DATA_SCRIPTS/./InitEntete.sh -id $idCapteur -ma Vortex -mo OEM -u "km/h" -m VitesseDuVent -la 13.605 -lo 42.014782 -i $intervalle
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
    #On va chercher le nombre de fichiers ouverts (modifié pour avoir des valeurs cohérentes avec la vitesse du vent)
    set $(cat /proc/sys/fs/file-nr)
    nbFic=$(echo "scale=2;$1/1000" |bc -l)
    #On écrit dans un fichier pour pouvoir transmettre les données à JournaliserDonnees
    echo $idCapteur $nbFic > SENSOR/$idCapteur/"$idCapteur"_TEMP.txt
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
