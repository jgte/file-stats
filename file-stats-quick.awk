#!/usr/bin/awk -f

#NOTICE: this awk script can handle arbitrarily large files (unlike files-stats.awk)

{
  for(i=1;i<=NF;i++)
  {
    if (NR==1) {
      min[i]=+9999999999999;
      max[i]=-9999999999999;
    }
    if (    $i  <    min[i])    min[i] =     $i;
    if (    $i  >    max[i])    max[i] =     $i;
    total[i]+=$i ;
    sq[i]+=$i*$i ;
  }
} END {
   printf "min: ";
   for(i=1;i<=NF;i++) printf "%g ",min[i] ;
   printf "\n" ;
   printf "max: ";
   for(i=1;i<=NF;i++) printf "%g ",max[i] ;
   printf "\n" ;
   printf "mean: ";
   for(i=1;i<=NF;i++) printf "%g ",total[i]/NR ;
   printf "\n" ;
   printf "std: ";
   for(i=1;i<=NF;i++) printf "%g ",sqrt(sq[i]*NR-total[i]**2)/NR ;
   printf "\n" ;
   printf "count: ";
   for(i=1;i<=NF;i++) printf "%i ",NR ;
   printf "\n" ;
}
