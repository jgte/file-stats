#!/usr/bin/awk -f

# https://stackoverflow.com/questions/11184915/absolute-value-in-awk-doesnt-work
function abs(x){return (x<0?-x:x);}

{
  for(i=1;i<=NF;i++)
  {
    if (NR==1) {
          min[i]=+9999999999999;
          max[i]=-9999999999999;
       absmin[i]=+9999999999999;
       absmax[i]=-9999999999999;
      mindiff[i]=+9999999999999;
      maxdiff[i]=-9999999999999;
   absmindiff[i]=+9999999999999;
   absmaxdiff[i]=-9999999999999;
    }
    if (    $i  <    min[i])    min[i] =     $i;
    if (    $i  >    max[i])    max[i] =     $i;
    if (abs($i) < absmin[i]) absmin[i] = abs($i);
    if (abs($i) > absmax[i]) absmax[i] = abs($i);
    total[i]+=$i ;
    sq[i]+=$i*$i ; 
    if (NR>1) {
      diff=$i-prev[i];
      if (    diff  < mindiff[i])    mindiff[i] =     diff;
      if (    diff  > maxdiff[i])    maxdiff[i] =     diff;
      if (abs(diff) < mindiff[i]) absmindiff[i] = abs(diff);
      if (abs(diff) > maxdiff[i]) absmaxdiff[i] = abs(diff);
      totaldiff[i]+=diff
      sqdiff[i]+=diff*diff
    }
    prev[i]=$i;
  } 
} END {
   printf "min: ";
   for(i=1;i<=NF;i++) printf "%g ",min[i] ;
   printf "\n" ;
   printf "max: ";
   for(i=1;i<=NF;i++) printf "%g ",max[i] ;
   printf "\n" ;
   printf "absmin: ";
   for(i=1;i<=NF;i++) printf "%g ",absmin[i] ;
   printf "\n" ;
   printf "absmax: ";
   for(i=1;i<=NF;i++) printf "%g ",absmax[i] ;
   printf "\n" ;
   printf "mean: ";
   for(i=1;i<=NF;i++) printf "%g ",total[i]/NR ;
   printf "\n" ;
   printf "std: ";
   for(i=1;i<=NF;i++) printf "%g ",sqrt(sq[i]*NR-total[i]**2)/NR ;
   printf "\n" ;
   printf "min-diff: ";
   for(i=1;i<=NF;i++) printf "%g ",mindiff[i] ;
   printf "\n" ;
   printf "max-diff: ";
   for(i=1;i<=NF;i++) printf "%g ",maxdiff[i] ;
   printf "\n" ;
   printf "absmin-diff: ";
   for(i=1;i<=NF;i++) printf "%g ",absmindiff[i] ;
   printf "\n" ;
   printf "absmax-diff: ";
   for(i=1;i<=NF;i++) printf "%g ",absmaxdiff[i] ;
   printf "\n" ;
   printf "mean-diff: ";
   for(i=1;i<=NF;i++) printf "%g ",totaldiff[i]/(NR-1) ;
   printf "\n" ;
   printf "std-diff: ";
   for(i=1;i<=NF;i++) printf "%g ",sqrt(sqdiff[i]*(NR-1)-totaldiff[i]**2)/(NR-1) ;
   printf "\n" ;
   printf "count: ";
   for(i=1;i<=NF;i++) printf "%i ",NR ;
   printf "\n" ;
}
