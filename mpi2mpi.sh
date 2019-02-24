rm -f tt
touch tt
for i in 1 4 10 40 100 200 400
do
	./vader.sh mpi2mpi.exe 1000000 $i 1 >>tt
	./vader.sh mpi2mpi.exe 1000000 $i 2 >>tt
done 
