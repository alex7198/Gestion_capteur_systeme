#!/bin/sh

#On vérifie que le fichier passé en paramètre se termine par ".attrib"
if [ `echo $1 | awk '$1~/.attrib$/{print "ok"}$1!~/.attrib$/{print "pasok"}'` = "ok" ]
then
	ID=`awk '$1~/Id/{print $2}' $1`
	#Calcul de l'ecartype
	resultat=`ALGO/./AWKs/EcartType.awk SENSOR/$ID/DATA/*`
	#Recherche de l'unité
	unite=`awk '$1~/Unite/{for(i=2;i<=NF;i++) print $i}' $1`
	echo -- Ecart-type pour le capteur $ID :
	echo ${resultat} ${unite}
else
	echo "/!\ Erreur : Seul le format .attrib est pris en charge /!\ "
fi
