#!/usr/bin/awk -f

BEGIN{i=0}
{
  total+=$2
  i++
}
END{print total/i}
