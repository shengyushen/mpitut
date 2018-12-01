# vader means share memory and replace sm
# ob1 tcp
#mpirun -mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H gpu1,gpu4 mpiomp.exe $1 $2 $3
mpirun -mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1 -bind-to numa -H gpu1,gpu4 mpionly.exe $1 $2 $3
# more proc than core
#mpirun -mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1 -H gpu1,gpu4 mpionly.exe $1 $2 $3

#ob1 openib with thread
#mpirun -mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H gpu1,gpu4 mpiomp.exe $1 $2 $3
# openib with proc
#mpirun -mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1 -bind-to numa -H gpu1,gpu4 mpionly.exe $1 $2 $3
# more proc than core
#mpirun -mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1  -H gpu1,gpu4 mpionly.exe $1 $2 $3

# ucs ib not support multi thread
#mpirun  -mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 --allow-run-as-root --oversubscribe  --npernode $1 -bind-to numa -H gpu1,gpu4 mpionly.exe $1 $2 $3
# with more process than core
#mpirun  -mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 --allow-run-as-root --oversubscribe  --npernode $1 -H gpu1,gpu4 mpionly.exe $1 $2 $3

