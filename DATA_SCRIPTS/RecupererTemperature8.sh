#!/bin/bash

#SAMOA
#PID du processus en cours
monPID=$$
idCapteur=X54337
intervalle=1
D_WAIT=0
#On initialise le fichier .attrib
DATA_SCRIPTS/./InitEntete.sh -id $idCapteur -ma Xiaomi -mo Aqara -u "Degré Celsius" -m "Température" -i $intervalle -la \-39.254 -lo \-172.01478
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
    #On va chercher la température du CPU (modifiée pour avoir différentes valeures)
    set $(acpi -t)
    #On écrit dans un fichier pour pouvoir transmettre les données à JournaliserDonnees
    echo $idCapteur $(echo "scale=1;$4-22" | bc -l) > SENSOR/$idCapteur/"$idCapteur"_TEMP.txt
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
