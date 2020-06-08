#!/usr/bin/awk -f 

function alen(arr, i,c) {
  c = 0
  for(i in arr) c++
  return c
}

function mean(arr, sum,c,i){
  sum=0;c=0;
  for (i in arr) { sum+=arr[i]; c++; }
  return sum/c
}

function std(arr, sum2,c,i){
  sum=0;sum2=0;c=0;
  for (i in arr) { sum+=arr[i];sum2+=arr[i]*arr[i]; c++; }
  return sqrt(sum2/c - ((sum/c)^2))
}

{
  #load the data: always the first column (no exceptions)
  v[NR-1]=$1;
} END {
  sigma=3; n_iter=5;
  for (j=0; j<n_iter; j++){
    m=mean(v);s=std(v);l=alen(v);
    for (i=0; i<l; i++) {
      if ( v[i]<m-sigma*s || v[i]>m+sigma*s ) {
        v[i]=0;
      }
    }
  }
  for (i=0; i<l; i++) {
    print v[i]
  }
}