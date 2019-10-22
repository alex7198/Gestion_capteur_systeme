#!/bin/bash

#Initialisation des attributs d'un capteur
id=""
marque=""
modele=""
mesure=""
unite=""
intervalle=0
latitude=\-999
longitude=\-999

i=0
#On stocke dans un tableau les paramètres
for arg in $*
do
  tab[$i]=$arg
  i=$(($i+1))
done

#On affecte les variables en fonction des options données par l'utilisateur
for arg in ${tab[*]}
do
  case $arg in
    '-id') id=${tab[(($u+1))]};;
    '-ma') marque=${tab[(($u+1))]};;
    '-mo') modele=${tab[(($u+1))]};;
    '-m') mesure=${tab[(($u+1))]};;
    '-u') unite=${tab[(($u+1))]};;
    '-i') intervalle=${tab[(($u+1))]};;
    '-la') latitude=${tab[(($u+1))]};;
    '-lo') longitude=${tab[(($u+1))]};;
  esac
  u=$(($u+1))
done

#ID est obligatoire
if [ "$id" == "" ]
then
  echo "Id manquant"
  exit
fi

#Si le répertoire du capteur n'est pas créé, on le crée
if [ ! -d SENSOR/$id ]
then
  mkdir SENSOR/$id
fi

#Si le répertoire de données du capteur n'est pas créé, on le crée
if [ ! -d SENSOR/$id/DATA ]
then
  mkdir SENSOR/$id/DATA
fi

#On crée le fichier ID.attrib avec les valeurs des attributs du capteur
echo "%Id: $id" > SENSOR/$id/$id.attrib

if [ "$marque" != "" ]
then
  echo "%Marque: $marque" >> SENSOR/$id/$id.attrib
fi
if [ "$modele" != "" ]
then
  echo "%Modele: $modele" >> SENSOR/$id/$id.attrib
fi
echo "%Mesure: $mesure" >> SENSOR/$id/$id.attrib
echo "%Unité: $unite" >> SENSOR/$id/$id.attrib
echo "%Intervalle: $intervalle" >> SENSOR/$id/$id.attrib
if (($(echo "$latitude > -999" |bc -l))) || (($(echo "$longitude > -999" |bc -l))); then
  echo "%Position: $latitude, $longitude" >> SENSOR/$id/$id.attrib
fi
