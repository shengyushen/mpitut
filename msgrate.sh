#!/bin/bash

device=""
duration="100"
num_of_qps="1"
num_of_args_given=0
myinline=8
mysize=8

function usage
{
	echo "Usage:"
	echo "Server: ibv_write_message_rate_full_stress_p2p.sh [-d ib_device] [-D duration] [-q qps]"
	echo "Client: ibv_write_message_rate_full_stress_p2p.sh [-d ib_device] [-D duration] [-q qps] <Server ip or hostname>"
	echo "Options:"
	echo "-d <IB device> Run test on this IB device (mlx5_0 for example). default: first one found"
	echo "-D <duration>  Run test for <duration> seconds. default: 60 seconds"
	echo "-q <QPs> Run test with <QPs> per port per process. default: 1 QP per port per process"
	echo "-i set max inline message size default: 8 "
	echo "-s set message size default: 8 bytes"
	echo " "
	exit 1
}

while getopts "d:D:i:s:q:h" opt
do
	case "$opt" in
		h) 	usage;;
		d) 	device=$OPTARG
			num_of_args_given=$[$num_of_args_given+1]
			;;
		i) 	myinline=$OPTARG
			num_of_args_given=$[$num_of_args_given+1]
			;;
		s) 	mysize=$OPTARG
			num_of_args_given=$[$num_of_args_given+1]
			;;
		D) 	duration=$OPTARG
			num_of_args_given=$[$num_of_args_given+1]
			;;
		q)	num_of_qps=$OPTARG
			num_of_args_given=$[$num_of_args_given+1]
			;;
		\?) usage;;
	esac
done

if [ -z $device ] ; then
	device=`ibv_devices | head -3 | tail -1 | awk '{print$1}'`
fi

port_1_status=`ibstat $device | grep "Port 1" -A 1 | tail -1 | awk '{print$2}'`
port_2_status=`ibstat $device | grep "Port 2" -A 1 | tail -1 | awk '{print$2}'`

#if [[ "$port_1_status" != "Active" || "$port_2_status" != "Active" ]] ; then 
#	echo "One of the ports is of "$device" not in Active, this test required Dual port"
#	exit 1
#fi

interface=`ibdev2netdev | grep $device | grep "port 1" | awk '{print$5}'`
numa_node=`cat /sys/class/net/$interface/device/numa_node`

if [[ "$numa_node" == "-1" ]] ; then 
	echo " Cannot identify HCA numa node ... guessing"
	numa_node=0
fi

close_cores=`numactl --ha | grep "node $numa_node cpus: " | cut -c 14-`

counter=0
for i in $(echo $close_cores | tr " " "\n")
do
	cpu_arr[${counter}]="$i"
	counter=$[$counter+1]
done

far_numa_node=$[1-$numa_node]
far_cores=`numactl --ha | grep "node $far_numa_node cpus: " | cut -c 14-`

for i in $(echo $far_cores | tr " " "\n")
do
	cpu_arr[${counter}]="$i"
	counter=$[$counter+1]
done

number_of_total_args=${#}
is_server=$(( $number_of_total_args - $(( $num_of_args_given * 2 )) ))

export thishost=$(hostname)

if [[ "$is_server" -eq "0" ]] ; then
	echo $is_server
        echo $counter
	for i in $(seq 0 $[$counter-1])
	do
		#( taskset -c ${cpu_arr[$i]} ib_write_bw -d $device -p $((i+15000)) -s 8 -D $duration -O -q $num_of_qps > /dev/null ) &
	         ( taskset -c ${cpu_arr[$i]} ib_write_bw -d $device -p $((i+15000)) -s $mysize -D $duration -q $num_of_qps > /dev/null ) &
	done
	wait

else
	echo "host   :#Processes #Total QPs #Message Rate #Bandwidth"
	#echo -n "$((counter))         $(( num_of_qps * counter * 2))          "
	export ii_counter=$counter
	export ii_num_of_qps=$(( num_of_qps * counter * 2))
	for i in $(seq 0 $[$counter-1])
	do
		#( MLX5_SINGLE_THREADED=1 taskset -c ${cpu_arr[$i]} ib_write_bw -d $device -p $((i+15000)) -s 8 -I $myinline -O -q $num_of_qps -F -D $duration "${@: -1}" | grep " 0.00 " ) &
		( MLX5_SINGLE_THREADED=1 taskset -c ${cpu_arr[$i]} ib_write_bw -d $device -p $((i+15000)) -s $mysize -I $myinline -q $num_of_qps -F -D $duration "${@: -1}" | grep " 0.00 " ) &
                #( MLX5_SINGLE_THREADED=1 taskset -c ${cpu_arr[$i]} ib_write_bw -d $device -p $((i+15000)) -s $mysize  -q $num_of_qps -F -D $duration "${@: -1}" | grep " 0.00 " ) &
	done | awk '{SUM1+=$5;SUM2+=$4} END { printf "%s:%s      %s          %s       %s\n",ENVIRON["thishost"],ENVIRON["ii_counter"],ENVIRON["ii_num_of_qps"],SUM1,(SUM2*8/1000) }'
	wait
fi 
exit 0 

