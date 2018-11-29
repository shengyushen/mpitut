#!/usr/bin/gnuplot -p
set xlabel "thread number"
set ylabel "message per second"
set logscale y
plot \
		"tagm.txt"  u 1:(1000000*$1/$2) with linesp title "x86 2p + cx4 ib + non-numa",\
						""  u 1:(1000000*$1/$2):(sprintf("%.2f",1000000*$1/$2)) with labels notitle,\
						""  u 1:(1000000*$1/$3) with linesp title "x86 2p + cx4 ib + numa",\
             "" u 1:(1000000*$1/$3):(sprintf("%.2f",1000000*$1/$3)) with labels notitle,\
             "" u 1:(1000000*$1/$4) with linesp title "arm1620 4p + cx5 ib + numa",\
             "" u 1:(1000000*$1/$4):(sprintf("%.2f",1000000*$1/$4)) with labels notitle


