#!/usr/bin/awk -f

BEGIN{fic = ARGV[1];
	  "ALGO/./AWKs/Moyenne.awk " fic | getline moyenne;
	  compteur = 0;
	  somme = 0}
$1!~/%/{somme += ($2 - moyenne)^2; compteur++;}
END{print sqrt(somme/compteur)}
