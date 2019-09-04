#!/bin/bash
cat vader.txt |grep "wall time "|awk '{print $5 " " $8 " " $10}' |sort -k1,1 -n -k2,2 > vader2.txt
./vader.plt

