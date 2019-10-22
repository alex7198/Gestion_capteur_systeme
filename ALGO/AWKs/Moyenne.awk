#!/usr/bin/awk -f

BEGIN{somme = 0; compteur = 0}
$1!~/%/{somme += $2;
		compteur ++}
END{print somme/compteur}
