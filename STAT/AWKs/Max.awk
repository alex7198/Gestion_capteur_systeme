#!/usr/bin/awk -f

BEGIN{max=-9999999}
{
  if($2>max)
  {
    max=$2
  }
}
END{print max}
