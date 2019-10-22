#!/bin/bash

#Point d'entrée dans la programme

echo -e "Bienvenue dans le menu de l'application liée à la gestion des capteurs."
while :
do
  #Menu
  echo -e "\nMENU\n1 : Lancer la récupération des données\n2 : Stopper la récupération des données\n3 : Lancer la création des graphiques pour chaque jour\n4 : Dessiner une courbe 3D\n5 : Statistiques générales des capteurs\n6 : Calcul de statistiques sur les mesures\n7 : Quitter"
  echo -e "Selectionner une action :"
  read choix
  case $choix in
    '1') DATA_SCRIPTS/./RecupererDonnees.sh;;
    '2') DATA_SCRIPTS/./StopperRecuperationDonnees.sh;;
    '3') STAT/COURBE_MESURE.sh;;
    '4') STAT/COURBE_MESURE_3D.sh;;
    '5') STAT/StatistiquesGenerales.sh;;
    '6') echo 'Veuillez saisir le nom du fichier sous la forme <chemin>/ID.attrib'
         read choix
          ALGO/All.sh $choix;;
    '7') AUTRE/./Quitter.sh
        exit;;
  esac
done
