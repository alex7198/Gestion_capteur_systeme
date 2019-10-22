#!/bin/bash

i=0

#On crée un fichier regroupant les ID de tous les capteurs
ls -l SENSOR/ | grep ^d | cut -d' ' -f10 > STAT/INFO_CAPTEURS/ID_CAPTEURS.txt

#Pour chaque capteur
while read line
  do
    if [ $i -eq 0 ]
    then
      #On crée un fichier regroupant les dates des mesures
      ls -1 SENSOR/$line/DATA/ > STAT/INFO_CAPTEURS/DATE_MESURE.txt
      i=1
    fi
    #Pour chacune des dates...
    while read line2
    do
      #calcul minimum
      min=$(./STAT/AWKs/Min.awk SENSOR/$line/DATA/$line2)
      #calcul maximum
      max=$(./STAT/AWKs/Max.awk SENSOR/$line/DATA/$line2)
      #On va chercher le nom de l'ordonnée dans le fichier des atttributs
      nomOrdonne=$(grep "^%Mesure" SENSOR/$line/"$line".attrib | cut -d' ' -f2)
      #On ajuste le min et le max pour que la courbe ne soit pas collée à l'axe des abscisses ou au haut du graphique
      if [ "$nomOrdonne" = 'Température' ] || [ "$nomOrdonne" = 'HumiditéRelativeDeLaire' ] || [ "$nomOrdonne" = 'HumiditéDuSol' ] || [ "$nomOrdonne" = 'VitesseDuVent' ]
      then
        min=$(echo "scale=1;$min-5" | bc -l)
        max=$(echo "scale=1;$max+5" | bc -l)
      fi
      if [ "$nomOrdonne" = 'PressionAtmosphérique' ]
      then
        min=$(echo "scale=1;$min-100" | bc -l)
        max=$(echo "scale=1;$max+100" | bc -l)
      fi
      #On cherche l'unité
      unite=$(grep "^%Unité" SENSOR/$line/"$line".attrib | cut -d' ' -f2)
      nomAbscisse="Temps"
      #On crée le script de génération de la courbe
      #nom label axe
      echo "set ylabel '$nomOrdonne(en $unite)'" > STAT/script_gnuplot
      echo "set xlabel '$nomAbscisse'" >> STAT/script_gnuplot
      #On spécifie que l'axe X correxpond à du temps
      echo "set xdata time" >> STAT/script_gnuplot
      #On spécifie quel format pour le temps on veut afficher
      echo 'set format x "%H:%M"' >> STAT/script_gnuplot
      #On spécifie le format d'écriture du temps dans le fichier
      echo "set timefmt '"%Y/%m/%d-%H:%M:%S"'" >> STAT/script_gnuplot
      #On prend la date de début et de fin
      DateD=$(head -n 1 SENSOR/$line/DATA/$line2 | cut -d' ' -f1)
      DateF=$(tail -n 1 SENSOR/$line/DATA/$line2 | cut -d' ' -f1)
      #On spécifie les intervalles avec les valeurs vues précédemment
      echo "set yr ["$min":"$max"]" >> STAT/script_gnuplot
      echo "set xr ['"$DateD"':'"$DateF"']" >> STAT/script_gnuplot
      date=$(echo $line2 | cut -d'.' -f1)
      #On veut du PDF
      echo "set terminal pdf" >> STAT/script_gnuplot
      echo "set output 'STAT/COURBES_MESURE/"$line"_"$date".pdf'" >> STAT/script_gnuplot
      echo "plot 'SENSOR/$line/DATA/$line2' using 1:2 with lines smooth csplines" >> STAT/script_gnuplot
      #Génération du pdf
      gnuplot STAT/script_gnuplot
      #On supprime le script
      rm STAT/script_gnuplot
    done < STAT/INFO_CAPTEURS/DATE_MESURE.txt
  done < STAT/INFO_CAPTEURS/ID_CAPTEURS.txt
  echo Génération des graphiques pour chaque capteur réussie
