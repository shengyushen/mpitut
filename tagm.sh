# vader means share memory and replace sm

#mpirun --allow-run-as-root --oversubscribe --npernode 1 -report-bindings -bind-to numa -H gpu1,gpu3 mpiomp.exe 28 100000
#mpirun  -x UCX_RC_TM_ENABLE=y -x UCX_RC_VERBS_TM_ENABLE=y  -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc,sm -mca pml ob1 -mca btl vader,tcp,openib --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3


# 3s
#mpirun  -x UCX_RC_TM_ENABLE=y -x UCX_RC_VERBS_TM_ENABLE=y  -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc,sm -mca pml ob1 -mca btl vader,tcp,openib --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3
#3.9
#mpirun  -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc,sm -mca pml ob1 -mca btl vader,tcp,openib --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3
#3.8
#mpirun   -x UCX_TLS=rc,sm -mca pml ob1 -mca btl vader,tcp,openib --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3
#3.9
#mpirun   -mca pml ob1 -mca btl openib --mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3
# 3.9
#mpirun   -mca pml ob1 --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3
#10s  some times, 3.9s sometimes
mpirun  -mca pml ob1 -mca btl self,tcp -mca btl_tcp_if_include ib0 --mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H gpu1,gpu4 mpiomp.exe $1 $2 $3

#3.9
#mpirun   -x UCX_TLS=rc,sm --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3

#removing bind to numa is faster on ARM
#mpirun  -x UCX_RC_TM_ENABLE=y -x UCX_RC_VERBS_TM_ENABLE=y  -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc,sm -mca pml ob1 -mca btl vader,tcp,openib --allow-run-as-root --oversubscribe  --npernode 1 -H node55,node61 mpiomp.exe $1 $2 $3
#mpirun  -x UCX_RC_TM_ENABLE=n -x UCX_RC_VERBS_TM_ENABLE=n   -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc,sm -mca pml ob1 -mca btl vader,tcp,openib --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H node55,node61 mpiomp.exe $1 $2 $3
