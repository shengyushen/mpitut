#!/usr/bin/gnuplot -p -e
set logscale xy
set xlabel "Queue length"
set ylabel "Average run time for 1 matching"
plot "vader2.txt"		u 2:(($1==1)?$3:1/0) with linesp title "in order",\
								""		u 2:(($1==2)?$3:1/0) with linesp title "rev order"
