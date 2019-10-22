#!/bin/bash

#Si le fichier DATA_SCRIPTS/PID_PROCESS.txt ( fichier regoupant le PID de tous les processus du programme)
#existe déjà, cela signifie que le récupération des données est déjà en cours
if [ -f DATA_SCRIPTS/PID_PROCESS.txt ]
then
  echo "Recupération des données déjà en cours..."
else
  #On lance tous les scripts de récupération de données
  DATA_SCRIPTS/./RecupererHumiditeAir.sh &
  pidPourcC=$!
  echo $pidPourcC >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererHumiditeAir2.sh &
  pidPourcC=$!
  echo $pidPourcC >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererHumiditeAir3.sh &
  pidPourcC=$!
  echo $pidPourcC >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererHumiditeSol.sh &
  pidPourcM=$!
  echo $pidPourcM >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererVitesseVent.sh &
  pidNbFicO=$!
  echo "$pidNbFicO" >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererPressionAtmospherique.sh &
  pidMemC=$!
  echo "$pidMemC" >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature2.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature3.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature4.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature5.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature6.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature7.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature8.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature9.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature10.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature11.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature12.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature13.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  DATA_SCRIPTS/./RecupererTemperature14.sh &
  pidTemp=$!
  echo $pidTemp >> DATA_SCRIPTS/PID_PROCESS.txt
  echo La récupération des données a commencé...
fi
