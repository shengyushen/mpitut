#!/usr/bin/gnuplot -p -e
set logscale xyz
splot \
	"cores_close" u 1:2:3  with linesp,\
	"threads_close" u 1:2:3  with linesp,\
	"sockets_close" u 1:2:3  with linesp,\
	"cores_spread" u 1:2:3  with linesp,\
	"threads_spread" u 1:2:3  with linesp,\
	"sockets_spread" u 1:2:3  with linesp,\




#	                  "" u 4:6:((stringcolumn(1) eq "threads" && stringcolumn(2) eq "close")?$9:1/0)  with linesp,\
#	                  "" u 4:6:((stringcolumn(1) eq "sockets" && stringcolumn(2) eq "close")?$9:1/0)  with linesp,\
#	"threadbinding2.txt" u 4:6:((stringcolumn(1) eq "cores"   && stringcolumn(2) eq "spread")?$9:1/0) with linesp,\
#	                  "" u 4:6:((stringcolumn(1) eq "threads" && stringcolumn(2) eq "spread")?$9:1/0) with linesp,\
#	                  "" u 4:6:((stringcolumn(1) eq "sockets" && stringcolumn(2) eq "spread")?$9:1/0) with linesp,\
