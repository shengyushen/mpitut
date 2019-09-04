#!/bin/bash
# root opt
ROOTOPT="--allow-run-as-root --oversubscribe"
CMDOPT="-x PATH -x LD_LIBRARY_PATH"

# OMP opt
:export OMP_DISPLAY_ENV=true
#export OMP_WAIT_POLICY=active
#export OMP_DYNAMIC=false
#export OMP_PLACES=cores
#export OMP_PROC_BIND=close
#OMPOPT="-x OMP_DISPLAY_ENV -x OMP_WAIT_POLICY -x OMP_DYNAMIC -x OMP_PLACES -x OMP_PROC_BIND "

# UCX setting
UCXOPT="-mca pml ucx -mca mtl ^mxm -x UCX_NET_DEVICES=mlx5_0:1 -x UCX_TLS=rc"
#OPENIB setting
OPENIBOPT="-mca pml ob1 -mca btl self,openib -mca btl_openib_if_include mlx5_0:1 -mca btl_base_verbose 100"
#TCP
TCPOPT="-mca pml ob1 -mca btl self,tcp    -mca btl_tcp_if_include ib0 -mca btl_base_verbose 100"

# task set
TASKSETOPT="taskset -c 0-13"

# tag matching opt
TMOPT="-x UCX_RC_VERBS_TM_ENABLE=y"


#rm -f threadV.txt
#touch threadV.txt
#for i in {0..10..1}
#do
# osu_latency_mt use pthread, no need for OMP
	echo "thread 1"
	mpirun  ${ROOTOPT} ${CMDOPT}   ${UCXOPT}    -H gpu1,gpu4  ./osu_latency_mt -t 1
	echo "thread 2"
	mpirun  ${ROOTOPT} ${CMDOPT}   ${UCXOPT}    -H gpu1,gpu4  ./osu_latency_mt -t 2
	echo "thread 4"
	mpirun  ${ROOTOPT} ${CMDOPT}   ${UCXOPT}    -H gpu1,gpu4  ./osu_latency_mt -t 4
	echo "thread 8"
	mpirun  ${ROOTOPT} ${CMDOPT}   ${UCXOPT}    -H gpu1,gpu4  ./osu_latency_mt -t 8
#done

