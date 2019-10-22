#!/bin/bash

PIDPere=$1
idCapteur=$2
#initialise X_WAIT à 1
X_WAIT=1
#Quand le signal SIGUSR1 est détecté, on modifie la valeur de X_WAIT à 0 pour sortir de la boucle d'attente
trap 'X_WAIT=0' SIGUSR1

while :
  do
    #X_WAIT = 0 <==>SIGUSR1 reçu donc on peut commencer la journalisation
    if [ $X_WAIT -eq 0 ]
    then
      #On lit les données inscrites dans TEMP.txt
      while read line
        do
          #Chaque mot dans $n
          set $line
          #date + heure pour mettre dans fichier
          d_h=$(date +%Y/%m/%d-%T)
          #date pour le nom du fichier
          d=$(date +%Y-%m-%d)
          if [ ! -f SENSOR/$1/DATA/$d ]
          then
            touch SENSOR/$1/DATA/$d.txt
          fi
          #On sauvegarde les données
          echo "$d_h $2" >> SENSOR/$1/DATA/$d.txt
        done < SENSOR/$idCapteur/"$idCapteur"_TEMP.txt
      #On change la valeur de X_WAIT pour aller dans la boucle d'attente
      X_WAIT=1
      #La sauvegarde a été effectuée->on renvoie le signal à RecupérerDonnees.sh
      kill -SIGUSR1 $PIDPere
    fi
    #Boucle d'attente
    while [ $X_WAIT -eq 1 ]
    do
      :
      #On ralentit la boucle d'attente pour ne pas surcharger le processeur
      sleep 0.001
    done
  done
