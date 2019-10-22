#!/bin/bash

if [ -f DATA_SCRIPTS/PID_PROCESS.txt ]
then
  while read line
    do
      kill -9 $line
    done < DATA_SCRIPTS/PID_PROCESS.txt
  rm DATA_SCRIPTS/PID_PROCESS.txt
  echo La récupération des données a été stoppée.
else
  echo -e "La récupération des données n'est pas en cours\n"
fi
