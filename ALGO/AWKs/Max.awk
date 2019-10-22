#!/usr/bin/awk -f

BEGIN{max = -99999}
$1!~/%/{if(max<$2){ max = $2; ligne = $0}}
END{print ligne}