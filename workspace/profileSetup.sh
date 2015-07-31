#!/bin/bash
#used to generate more profiles
for i in disc134_800 disc134_1600 disc268_800 disc268_1600 disc536_800; do
  cd $i
  for i in profile1.48.mat profile1.19.mat profile1.39.mat profile5.42.mat profile6.48.mat profile6.5.mat profile6.38.mat profile6.13.mat; do
#    mkdir $i;
    cp -r basefiles/* $i; #copy files :) 
  pwd   
  done
  cd ../

done
