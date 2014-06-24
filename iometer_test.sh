#!/bin/bash

declare -a loads=('linear' 'lighter' 'light' 'moderate' 'heavy')
declare -a iodepths=('1' '4' '8' '64' '256')

function get_iodepth_from_load {
	for (( i = 0; i < ${#loads[@]}; i++ )); do
		if [ "${loads[$i]}" = "$1" ]; then
			echo ${iodepths[$i]}
		fi
	done
}

# Defaults for the original iometer jobfile
LOAD=${1-moderate}
SIZE=${2-4g}

IODEPTH=$(get_iodepth_from_load $LOAD)
echo "Running IOmeter with $LOAD load (iodepth $IODEPTH) and size $SIZE"

fio iometer-jobfile --iodepth=$IODEPTH --size=$SIZE
