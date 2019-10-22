#!/bin/bash

#Si la récupération des données est en cours, on l'arrête avant de quitter le programme
if [ -f DATA_SCRIPTS/PID_PROCESS.txt ]
then
  DATA_SCRIPTS/./StopperRecuperationDonnees.sh
fi
echo "Programme quitté"
