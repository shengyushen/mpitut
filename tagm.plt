#!/usr/bin/gnuplot -p
set xlabel "thread number"
set ylabel "matching time(us)"
set logscale y
plot "tagm.txt" u 1:($3/$1) with linesp

