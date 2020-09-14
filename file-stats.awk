#!/usr/bin/awk -f

# https://stackoverflow.com/questions/11184915/absolute-value-in-awk-doesnt-work
function abs(x){return (x<0?-x:x);}

function show_stat(name,label,val,ncol){
  printf("%s%s: " ,name,label);
  for(i=1;i<=ncol;i++) printf "%g " ,val[i];
  printf "\n";
}

function compute_stats(d,nrows,ncols,m,s,label){
  #init records
  for( i = 1 ; i <= ncols ; i++ ){
           min[i]=+1e20;
           max[i]=-1e20;
        absmin[i]=+1e20;
        absmax[i]=-1e20;
       mindiff[i]=+1e20;
       maxdiff[i]=-1e20;
    absmindiff[i]=+1e20;
    absmaxdiff[i]=-1e20;
             c[i]=0
         total[i]=0
            sq[i]=0
     totaldiff[i]=0
        sqdiff[i]=0
          prev[i]=0
  }
  #loop over rows
  for( l = 1 ; l <= nrows ; l++ ){
    #loop over columns
    for( i = 1 ; i <= ncols ; i++ ){
      #ignore null data
      if (d[l,i]!=0) {
        #increment data counter
        c[i]=c[i]+1;
        if (    d[l,i]  <    min[i])    min[i] =     d[l,i];
        if (    d[l,i]  >    max[i])    max[i] =     d[l,i];
        if (abs(d[l,i]) < absmin[i]) absmin[i] = abs(d[l,i]);
        if (abs(d[l,i]) > absmax[i]) absmax[i] = abs(d[l,i]);
        total[i]+=d[l,i] ;
        sq[i]+=d[l,i]*d[l,i] ;
        #handle sequential diff statistics
        if (c[i]>1) {
          diff=d[l,i]-prev[i];
          if (    diff  <    mindiff[i])    mindiff[i] =     diff;
          if (    diff  >    maxdiff[i])    maxdiff[i] =     diff;
          if (abs(diff) < absmindiff[i]) absmindiff[i] = abs(diff);
          if (abs(diff) > absmaxdiff[i]) absmaxdiff[i] = abs(diff);
          totaldiff[i]+=diff
          sqdiff[i]+=diff*diff
        }
        prev[i]=d[l,i];
      }
    }
  }
  #assign relevant statistics for later
  for( i = 1 ; i <= ncols ; i++ ){
    if (c[i]>0) {
      m[i]=total[i]/c[i];
      s[i]=sqrt(sq[i]*c[i]-total[i]**2)/c[i];
      r[i]=sqrt(s[i]**2+m[i]**2)
    } else {
               m[i]=0;
               s[i]=0;
             min[i]=0;
             max[i]=0;
          absmin[i]=0;
          absmax[i]=0;
         mindiff[i]=0;
         maxdiff[i]=0;
      absmindiff[i]=0;
      absmaxdiff[i]=0;

    }
    if (c[i]>1) {
      md[i]=totaldiff[i]/(c[i]-1);
      sd[i]=sqrt(sqdiff[i]*(c[i]-1)-totaldiff[i]**2)/(c[i]-1);
      rd[i]=sqrt(sd[i]**2+md[i]**2)
    } else {
      md[i]=0;
      sd[i]=0;
      rd[i]=0;
    }
  }
  #show the statistics
  show_stat("min",         label, min,       ncols);
  show_stat("max",         label, max,       ncols);
  show_stat("absmin",      label, absmin,    ncols);
  show_stat("absmax",      label, absmax,    ncols);
  show_stat("mean",        label, m,         ncols);
  show_stat("std",         label, s,         ncols);
  show_stat("rms",         label, r,         ncols);
  show_stat("min-diff",    label, mindiff,   ncols);
  show_stat("max-diff",    label, maxdiff,   ncols);
  show_stat("absmin-diff", label, absmindiff,ncols);
  show_stat("absmax-diff", label, absmaxdiff,ncols);
  show_stat("mean-diff",   label, md,        ncols);
  show_stat("std-diff",    label, sd,        ncols);
  show_stat("rms-diff",    label, rd,        ncols);
  show_stat("count",       label, c,         ncols);
}

BEGIN {
  sigma= ENVIRON["sigma"];
  n_iter=ENVIRON["n_iter"];
  #enforce defaults
  if (length(sigma)  == 0) sigma=3
  if (length(n_iter) == 0) n_iter=1
} {
  #load the data for this line
  for(i=1;i<=NF;i++)
  {
    d[NR,i]=$i
  }
} END {
  #compute statistics (m and s are outputs)
  compute_stats(d,NR,NF,m,s,"")
  #remove outliers, iterate n_iter times
  for( n = 1 ; n <= n_iter ; n++ ){
    for( l = 1 ; l <= NR ; l++ ){
      for( i = 1 ; i <= NF ; i++ ){
        #skip if this is an outlier
        if ( m[i]-sigma*s[i]>d[l,i] || d[l,i]>m[i]+sigma*s[i] ) {
          d[l,i]=0;
        }
      }
    }
    #define label
    label=sprintf("-no-%s",n)
    #recompute statistics
    compute_stats(d,NR,NF,m,s,label)
  }
}
