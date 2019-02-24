./mt.sh ./osu_latency | tee tm.txt
cat tm.txt |grep -v "^#"|awk '{if($1 in arr1) {arr2[$1]=$2;} else {arr1[$1]=$2;}} END{for(x in arr1) {print x " " arr1[x] " " arr2[x] " " arr2[x]/arr1[x]}}'|sort -k 1 -n > tm1.txt
gnuplot -p -e 'set logscale x;plot "tm1.txt" u 1:4 with linesp'
