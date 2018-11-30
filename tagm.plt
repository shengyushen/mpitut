#!/usr/bin/gnuplot -p
set multiplot layout 1,2

set xlabel "thread number"
set ylabel "matching time(us)"
set logscale y
set size square
#set autoscale fix
plot \
						"tagm.txt" u 1:($3/$1) with linesp title "x86 2p + cx4 ib + numa",\
             "" u 1:($3/$1):(sprintf("%.2f",$3/$1)) with labels notitle,\
             "" u 1:($4/$1) with linesp title "BUGGY!!! arm1620 4p + cx5 ib + numa",\
             "" u 1:($4/$1):(sprintf("%.2f",$4/$1)) with labels notitle,\
             "" u 1:($5/$1) with linesp title "arm1620 4p + cx5 tcp + numa",\
             "" u 1:($5/$1):(sprintf("%.2f",$5/$1)) with labels notitle

#		"tagm.txt" u 1:($2/$1) with linesp title "x86 2p + cx4 ib + non-numa",\
#						"" u 1:($2/$1):(sprintf("%.2f",$2/$1)) with labels notitle,\

set xlabel "thread number"
set ylabel "message per second"
unset logscale y
set size square
#set autoscale fix
plot \
						""  u 1:(1000000*$1/$3) with linesp title "x86 2p + cx4 ib + numa",\
             "" u 1:(1000000*$1/$3):(sprintf("%.2f",1000000*$1/$3)) with labels notitle,\
             "" u 1:(1000000*$1/$4) with linesp title "BUGGY!!! arm1620 4p + cx5 ib + numa",\
             "" u 1:(1000000*$1/$4):(sprintf("%.2f",1000000*$1/$4)) with labels notitle,\
             "" u 1:(1000000*$1/$5) with linesp title "arm1620 4p + cx5 tcp + numa",\
             "" u 1:(1000000*$1/$5):(sprintf("%.2f",1000000*$1/$5)) with labels notitle


#		"tagm.txt"  u 1:(1000000*$1/$2) with linesp title "x86 2p + cx4 ib + non-numa",\
#						""  u 1:(1000000*$1/$2):(sprintf("%.2f",1000000*$1/$2)) with labels notitle,\
