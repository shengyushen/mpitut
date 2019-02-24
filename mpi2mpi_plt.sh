grep wall tt|sort -n -k 5 -k 8 > tt1
gnuplot -p -e 'set logscale x;set xlabel "queue length";set ylabel "matching time for 1M iteration";plot "tt1" u 8:($5==1?$10:1/0) w linesp, "" u 8:($5==2?$10:1/0) w linesp'
