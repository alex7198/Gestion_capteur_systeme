#!/bin/bash

init=0

#On crée un fichier regroupant les ID de tous les capteurs
ls -l SENSOR/ | grep ^d | cut -d' ' -f10 > STAT/INFO_CAPTEURS/ID_CAPTEURS.txt

if [ -f STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt ]
then
  rm STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt
  touch STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt
fi
#On crée un fichier regroupant les types de chaque capteur
while read line
  do
    grep "^%Mesure" SENSOR/$line/"$line".attrib | cut -d' ' -f2 >> STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt
  done < STAT/INFO_CAPTEURS/ID_CAPTEURS.txt
  #On demande à l'utilisateur de sélectionner le type de capteur pour lequel il souhaite faire la courbe
echo Selectionner un type parmi les suivants
cat STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt | uniq
  #On stocke dans un fichier les types de capteurs sans doublon
cat STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt| uniq > STAT/INFO_CAPTEURS/TYPE_CAPTEUR_UNIQUE.txt
read choix
#On demande la date pour laquelle il veut faire la courbe de mesure 3D
echo Veuillez saisir une date avec le format suivant YYYY-MM-DD
read date

if [ -f STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt ]
then
  rm STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt
  touch STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt
fi

#On parcourt les ID des capteurs
  while read line
  do
    #On cherche le type
    type=$(grep "^%Mesure" SENSOR/$line/"$line".attrib | cut -d' ' -f2)
    #S'il correspond au choix de l'utilisateur
    if [ $type = $choix ]
    then
      #Si on ne trouve pas le fichier correspondant à la date saisie, erreur
      if [ ! -f SENSOR/$line/DATA/$date'.txt' ]
      then
        echo Aucune donnée pour cette date
        exit
      fi
      #On crée le fichier dont on va se servir pour la courbe
      if [ $init -eq 0 ]
      then
        touch STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt
        init=1
      fi
      #On cherche la position du capteur
      lat=$(grep "^%Position" SENSOR/$line/"$line".attrib | cut -d' ' -f2 |cut -d ',' -f1)
      lon=$(grep "^%Position" SENSOR/$line/"$line".attrib | cut -d' ' -f3)
      #On cherche la moyenne
      moyenne=$(./STAT/AWKs/Moyenne.awk SENSOR/$line/DATA/$date'.txt')
      #On écrit tout ça dans un fichier
      echo $line $lat $lon $moyenne >> STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt
    fi
  done < STAT/INFO_CAPTEURS/ID_CAPTEURS.txt

  #Si on n'a pas créé le fichier ID_CAPTEUR_CHOIX_TEMP.txt, ça veut dire que le capteur n'existe pas
  if [ ! -f STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt ]
  then
    echo Aucun capteur de ce type
    exit
  fi

  #On crée le script de génération de la courbe nommé script_gnuplot
  #On spécifie le nom des axes.
  echo "set ylabel 'longitude'" > STAT/script_gnuplot
  echo "set xlabel 'latitude" >> STAT/script_gnuplot
  echo "set zlabel '$choix(Moyenne)'" >> STAT/script_gnuplot
  #On veut un PDF à la fin
  echo "set terminal pdf" >> STAT/script_gnuplot
  echo "set output 'STAT/COURBES3D_MESURE/"$choix"_"$date".pdf'" >> STAT/script_gnuplot
  #On crée la courbe : x->2ème colonne du fichier, y ->3ème colonne et z->4ème colonne
  echo "splot 'STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt' using 2:3:4" >> STAT/script_gnuplot
  #On génère la courbe
  gnuplot STAT/script_gnuplot
  #On supprime les fichiers inutiles
  rm STAT/script_gnuplot
  rm STAT/INFO_CAPTEURS/ID_CAPTEUR_CHOIX_TEMP.txt
  echo Graphique 3D généré.
