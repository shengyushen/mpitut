# openib with proc
#mpirun -mca pml ob1 -mca btl openib  --allow-run-as-root --oversubscribe  --npernode 2 -bind-to numa -H gpu1 mpi2mpi_vader.exe $1 $2
#mpirun -mca pml ob1 -mca btl vader,self  --allow-run-as-root --oversubscribe  --npernode 2 -bind-to numa -H gpu1 mpi2mpi_vader.exe $1 $2

# this is with rank file binding
mpirun -mca pml ob1 -mca btl vader,self  --allow-run-as-root  --mca btl_base_verbose 100 --rankfile rankfile $@
#mpirun -mca pml ob1 -mca btl openib  --allow-run-as-root  --mca btl_base_verbose 100 --rankfile rankfile $1 $2  $3

