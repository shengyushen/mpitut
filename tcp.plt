#!/usr/bin/gnuplot -p
set title "run time of TCP connection"
set xlabel "process number"
set ylabel "run time"
plot "tagm.txt" u 1:10 with linesp title "x86 cx5 tcp process",\
             "" u 1:9  with linesp title "x86 cx5 openib process",\
						""		u 1:8  with linesp title "x86 cx5 ucx process"
