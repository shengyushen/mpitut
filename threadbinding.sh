#!/bin/bash -v
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/targets/x86_64-linux/lib/:$LD_LIBRARY_PATH
# root opt
ROOTOPT="--allow-run-as-root --oversubscribe"
CMDOPT="-x PATH -x LD_LIBRARY_PATH"

# OMP opt
export OMP_DISPLAY_ENV=true
export OMP_WAIT_POLICY=active
export OMP_DYNAMIC=false
export OMP_PLACES=threads
export OMP_PROC_BIND=close
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

# ucx ib
for threadnum in 1 2 4 8 14 28
do
	for bufsize in  8 64 512 4096 32768 262144 2097152 16777216 134217728
	do
		for place in "threads" "cores" "sockets"
		do
			for bnd in "close" "spread"
			do
				export OMP_PLACES=${place}
				export OMP_PROC_BIND=${bnd}
				echo ${OMP_PLACES} ${OMP_PROC_BIND}
				set -x
				mpirun  ${ROOTOPT} ${CMDOPT} ${OMPOPT}   ${UCXOPT}           --npernode 1 -bind-to numa -H gpu1,gpu4 ./mpiomp2.exe ${threadnum} ${bufsize} 
			done
		done
	done
done


