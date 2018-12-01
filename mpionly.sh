mpirun  -mca pml ob1 -mca btl self,openib,tcp -mca btl_openib_if_include mlx5_0:1 --mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode 1 -bind-to numa -H gpu1,gpu4 mpionly.exe $1 $2 $3

