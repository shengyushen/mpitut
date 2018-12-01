#!/usr/bin/gnuplot -p
set title "run time of process/thread parallel and tcp/ucx/openib"
set xlabel "process/thread number"
set ylabel "run time"
#set logscale y
plot "tagm.txt" u 1:10 with linesp title "x86 cx5 tcp process",\
             "" u 1:9  with linesp title "x86 cx5 openib process",\
						""		u 1:8  with linesp title "x86 cx5 ucx process",\
						""		u 1:7  with linesp title "x86 cx5 openib thread",\
						""		u 1:6  with linesp title "x86 cx5 tcp thread",\
						""		u 1:5  with linesp title "arm cx5 tcp thread"
