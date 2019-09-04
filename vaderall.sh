#!/bin/bash

for i in 1 5 10 50 100 500 1000 5000 10000
do
	echo "in order " ${i}
	./vader.sh ./mpi2mpi.exe 1000000 ${i} 1
	echo "rev order " ${i}
	./vader.sh ./mpi2mpi.exe 1000000 ${i} 2
done
