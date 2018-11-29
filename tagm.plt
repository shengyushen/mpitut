#!/usr/bin/gnuplot -p
set xlabel "thread number"
set ylabel "matching time(us)"
set logscale y
plot \
		"tagm.txt" u 1:($2/$1) with linesp title "x86 2p + cx4 ib + non-numa",\
						"" u 1:($2/$1):(sprintf("%.2f",$2/$1)) with labels notitle,\
						"" u 1:($3/$1) with linesp title "x86 2p + cx4 ib + numa",\
             "" u 1:($3/$1):(sprintf("%.2f",$3/$1)) with labels notitle,\
             "" u 1:($4/$1) with linesp title "arm1620 4p + cx5 ib + numa",\
             "" u 1:($4/$1):(sprintf("%.2f",$4/$1)) with labels notitle


