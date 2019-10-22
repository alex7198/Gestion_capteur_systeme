#!/bin/bash

#On crée le fichier stockant le nombre de capteurs par type
if [ -f STAT/INFO_CAPTEURS/TYPE_CAPTEUR_OCCURANCE.txt ]
then
  rm STAT/INFO_CAPTEURS/TYPE_CAPTEUR_OCCURANCE.txt
  touch STAT/INFO_CAPTEURS/TYPE_CAPTEUR_OCCURANCE.txt
fi
#On crée le fichier stockant les ID de tous les capteurs
ls -l SENSOR/ | grep ^d | cut -d' ' -f10 > STAT/INFO_CAPTEURS/ID_CAPTEURS.txt

#On crée le fichier stockant les types de tous les capteurs
if [ -f STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt ]
then
  rm STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt
  touch STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt
fi

#On remplit le fichier avec les types de tous les capteurs
while read line
  do
    grep "^%Mesure" SENSOR/$line/"$line".attrib | cut -d' ' -f2 >> STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt
  done < STAT/INFO_CAPTEURS/ID_CAPTEURS.txt

#On crée un autre fichier en enlevant les doublons
cat STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt| uniq > STAT/INFO_CAPTEURS/TYPE_CAPTEUR_UNIQUE.txt

#On crée le fichier de données nécessaire à la création de l'histogramme (1ère col : typeC, 2ème col: nbOcc)
while read line
do
  nbOcc=$(grep -c $line STAT/INFO_CAPTEURS/TYPES_CAPTEURS.txt)
  echo $line $nbOcc >> STAT/INFO_CAPTEURS/TYPE_CAPTEUR_OCCURANCE.txt
done < STAT/INFO_CAPTEURS/TYPE_CAPTEUR_UNIQUE.txt

#Création du script de génération du graphique
echo 'set title "Nombre de capteurs en fonction de leur type"' > STAT/script_gnuplot
#On veut un histogramme
echo "set style data histogram " >> STAT/script_gnuplot
#On spécifie les labels pour x et y
echo "set xlabel 'Type de capteur'" >> STAT/script_gnuplot
echo "set ylabel 'Nombre de capteur'" >> STAT/script_gnuplot
echo "set style histogram cluster gap 1" >> STAT/script_gnuplot
#Style
echo "set style fill solid border -1" >> STAT/script_gnuplot
#Taille des barres
echo "set boxwidth 1" >> STAT/script_gnuplot
#On veut un png
echo "set terminal png" >>STAT/script_gnuplot
echo "set output 'STAT/Stat_Generale.png'" >> STAT/script_gnuplot
#On fait une rotation de la graduation de l'axe x pour améliorer la lisibilité.
echo "set xtics rotate by -45" >> STAT/script_gnuplot
#Génération du graphique
echo "plot 'STAT/INFO_CAPTEURS/TYPE_CAPTEUR_OCCURANCE.txt' using 2:xticlabels(1) " >> STAT/script_gnuplot
#On lance le script
gnuplot STAT/script_gnuplot
#Supprime le script
rm STAT/script_gnuplot

#On génère le pdf
cd STAT/STAT_GENERALES
pdflatex StatistiquesGenerales.tex > pdf_generation.txt
#On supprime les fichiers inutiles
rm pdf_generation.txt
rm StatistiquesGenerales.log
rm StatistiquesGenerales.aux
rm ../Stat_Generale.png
echo Génération du pdf des statistiques générales réussie.
cd ..
