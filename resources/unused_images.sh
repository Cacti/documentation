#!/bin/sh

for file in `ls -1 ../images/*.png`;do 
  echo -n "$file - ";
  file=`basename $file`
  grep $file ../* 2>/dev/null | wc -l;
done | grep " - 0"
