#!/usr/bin/gnuplot -p -e
plot "xxx" u 4:(((stringcolumn(1) eq "threads") && (stringcolumn(2) eq "close" ))?$7:1/0) with linesp title "threads close",\
       "" u 4:(((stringcolumn(1) eq "threads") && (stringcolumn(2) eq "spread"))?$7:1/0) with linesp title "threads spread",\
       "" u 4:(((stringcolumn(1) eq "cores"  ) && (stringcolumn(2) eq "close" ))?$7:1/0) with linesp title "cores close",\
       "" u 4:(((stringcolumn(1) eq "cores"  ) && (stringcolumn(2) eq "spread"))?$7:1/0) with linesp title "cores spread",\
       "" u 4:(((stringcolumn(1) eq "sockets") && (stringcolumn(2) eq "spread"))?$7:1/0) with linesp title "sockets spread"
