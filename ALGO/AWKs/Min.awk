#!/usr/bin/awk -f

BEGIN{min = 99999}
$1!~/%/{if(min>$2){ min = $2; ligne = $0}}
END{print ligne}