#tcp
mpirun --allow-run-as-root -np 2 --map-by node -mca btl_tcp_if_include ib0 -mca pml ob1 --mca btl tcp,self --machinefile mfile mpiomp.exe 8 100 100

#openib
mpirun --allow-run-as-root -np 2 --map-by node -mca btl_openib_if_exclude "mlx4_0:1,mlx4_0:2" -mca pml ob1 --mca btl openib --machinefile mfile mpiomp.exe 8 100 100

#ucx
mpirun --allow-run-as-root -np 2 --map-by node -mca pml ucx -x UCX_NET_DEVICES=mlx5_0 -x UCX_TLS=rc_x,sm,cma,kem --machinefile mfile mpiomp.exe 8 100 100
