#!/bin/bash
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/targets/x86_64-linux/lib/:$LD_LIBRARY_PATH
# root opt
ROOTOPT="--allow-run-as-root --oversubscribe"
CMDOPT="-x PATH -x LD_LIBRARY_PATH"

# OMP opt
export OMP_DISPLAY_ENV=true
export OMP_WAIT_POLICY=active
export OMP_DYNAMIC=false
export OMP_PLACES=cores
export OMP_PROC_BIND=close
#export OMP_PLACES=cores
#export OMP_PROC_BIND=spread
OMPOPT="-x OMP_DISPLAY_ENV -x OMP_WAIT_POLICY -x OMP_DYNAMIC -x OMP_PLACES -x OMP_PROC_BIND "

# UCX setting
UCXOPT="-mca pml ucx -mca mtl ^mxm -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc"
#OPENIB setting
OPENIBOPT="-mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100"
#TCP
TCPOPT="-mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100"

# task set
#TASKSETOPT="taskset -c 0-13"

# tag matching opt
TMOPT="-x UCX_RC_VERBS_TM_ENABLE=y"

# vader means share memory and replace sm
# ob1 tcp
#mpirun ${ROOTOPT} ${CMDOPT} ${OMPOPT} ${TCPOPT} --npernode 1 -bind-to numa -H gpu1,gpu4 ${TASKSETOPT} ./mpiomp.exe $1 $2 $3
#mpirun -mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1 -bind-to numa -H gpu1,gpu4 mpionly.exe $1 $2 $3
# more proc than core
#mpirun -mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1 -H gpu1,gpu4 mpionly.exe $1 $2 $3

#ob1 openib with thread
#mpirun ${ROOTOPT} ${CMDOPT} ${OMPOPT} ${OPENIBOPT} --npernode 1 -bind-to none -H gpu1,gpu4 ${TASKSETOPT} ./mpiomp.exe $1 $2 $3
# openib with proc
#mpirun -mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1 -bind-to numa -H gpu1,gpu4 mpiomp.exe $1 $2 $3
# more proc than core
#mpirun -mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  --npernode $1  -H gpu1,gpu4 mpionly.exe $1 $2 $3

# ucx ib
#mpirun  ${ROOTOPT} ${CMDOPT} ${OMPOPT}   ${UCXOPT} -mca orte_base_help_aggregate 0          --npernode 56 -bind-to numa -H gpu1,gpu4 "$@"
#mpirun  ${ROOTOPT} ${CMDOPT} ${OMPOPT}   ${OPENIB} -mca orte_base_help_aggregate 0          --npernode 2 -bind-to numa -H gpu1 taskset -c 0,1 ./mpi2mpi.exe  $1  $2 $3
mpirun  ${ROOTOPT} ${CMDOPT} ${OMPOPT}   ${OPENIB} -mca orte_base_help_aggregate 0          --rankfile rankfile  ./mpi2mpi.exe  $1  $2 $3
#mpirun  ${ROOTOPT} ${CMDOPT} ${OMPOPT}   ${UCXOPT} ${TMOPT}  --npernode 1 -bind-to numa -H gpu1,gpu4 "$@"
# with more process than core
#mpirun  -mca pml ucx -x UCX_NET_DEVICES=mlx5_0:1 --allow-run-as-root --oversubscribe  --npernode $1 -H gpu1,gpu4 mpionly.exe $1 $2 $3

#mpirun -mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100 --allow-run-as-root --oversubscribe  -bind-to numa  mpiomp.exe $1 $2 $3

