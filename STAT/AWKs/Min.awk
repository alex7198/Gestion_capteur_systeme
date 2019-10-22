#!/usr/bin/awk -f

BEGIN{min=99999999}
{
  if($2<min)
  {
    min=$2
  }
}
END{print min}
