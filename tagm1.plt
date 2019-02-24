#!/usr/bin/gnuplot -p

set title "Total matching time(us)"
set xlabel "thread number"
set ylabel "total matching time(us)"
set logscale y
#set size square
#set autoscale fix
plot "tagm.txt"        u 1:($3) with linesp title "x86 2p + cx4 ib + thread",\
                    "" u 1:($3):(sprintf("%.2f",$3)) with labels notitle,\
                    "" u 1:($7) with linesp title "x86 2p + cx5 ib + thread",\
                    "" u 1:($7):(sprintf("%.2f",$7)) with labels notitle,\
                    "" u 1:($9) with linesp title "x86 2p + cx5 ib + process",\
                    "" u 1:($9):(sprintf("%.2f",$9)) with labels notitle,\
       						  "" u 1:($6) with linesp title "x86 2p + cx5 tcp + thread",\
                    "" u 1:($6):(sprintf("%.2f",$6)) with labels notitle,\
                    "" u 1:($4) with linesp title "BUGGY!!! arm1620 4p + cx5 ib + thread",\
                    "" u 1:($4):(sprintf("%.2f",$4)) with labels notitle,\
                    "" u 1:($5) with linesp title "arm1620 4p + cx5 tcp + thread",\
                    "" u 1:($5):(sprintf("%.2f",$5)) with labels notitle

#		"tagm.txt" u 1:($2/$1) with linesp title "x86 2p + cx4 ib + non-numa",\
#						"" u 1:($2/$1):(sprintf("%.2f",$2/$1)) with labels notitle,\

