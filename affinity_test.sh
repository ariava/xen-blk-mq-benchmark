#!/bin/bash

ENABLE_AFFINITY=${1-yes}
IOSIZE=${2-500G}
WL_TYPE=${3-read}
FILENAME=${4-/dev/sda}	# WARNING if setting a write workload...

function sync_drop_caches
{
	sync
	echo 3 > /proc/sys/vm/drop_caches
}

function start_fio
{
	FIONAME=$1
	FIOOP=$2
	FIOSIZE=$3
	FIOOFFSET=$4
	FIOFILE=$5

	fio --name=$FIONAME -rw=$FIOOP --numjobs=1 \
	    --size=$FIOSIZE --offset=$FIOOFFSET \
	    --filename=$FIOFILE > /dev/null &
}

function start_fio_with_affinity
{
	FIONAME=$1
	FIOOP=$2
	FIOSIZE=$3
	FIOOFFSET=$4
	FIOFILE=$5
	AFFINITY=$6

	taskset -c $AFFINITY fio --name=$FIONAME -rw=$FIOOP --numjobs=1 \
				 --size=$FIOSIZE --offset=$FIOOFFSET \
				 --filename=$FIOFILE > /dev/null &
}

function change_affinity
{
	PID=$1
	CPULIST=$2

	taskset -c -p $CPULIST $PID
}

MAXCPU=$(($(nproc)-1))
echo $MAXCPU

sync_drop_caches

for i in $(seq 0 $MAXCPU); do
	# XXX Letting fio overlap while reading/writing
	if [[ "$ENABLE_AFFINITY" == "yes" ]]; then
		# Affinity test
		start_fio_with_affinity $WL_TYPE$i $WL_TYPE $IOSIZE 0 $FILENAME 0
	else
		start_fio $WL_TYPE$i $WL_TYPE $IOSIZE 0 $FILENAME 0
	fi
	sleep 1
	# Get last started fio, which is the I/O process
	FIOPIDS[$i]=$(pgrep fio | tail -n 1)
	echo "Started reader $i: ${FIOPIDS[$i]}"
	#pgrep fio
done

#echo "Readers are: ${FIOPIDS[@]}"
if [[ "$ENABLE_AFFINITY" == "yes" ]]; then
	for i in $(seq 0 $MAXCPU); do
		# TODO: affinity allowing more than one CPU
		NEWAFF=$(($RANDOM%$(nproc)))
		change_affinity ${FIOPIDS[$i]} $NEWAFF
	done
fi

# Wait for all fio processes to terminate
for i in $(seq 0 $MAXCPU); do
	while pgrep fio > /dev/null; do sleep 1; done
done
