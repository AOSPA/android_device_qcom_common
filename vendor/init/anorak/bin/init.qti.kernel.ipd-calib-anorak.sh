#=============================================================================
# Copyright (c) 2022, 2023 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

enable_ipd_calb_data ()
{
	if [ ! -d /sys/bus/i2c/devices/0-0010 ]
	then
			return
	fi

	if [ ! -d /mnt/vendor/calib/ipd/ ]
	then
			return
	fi

	if [ ! -f /mnt/vendor/calib/ipd/ipd_calib.txt ]
	then
		return
	fi

	input="/mnt/vendor/calib/ipd/ipd_calib.txt"
	while read line; do
		# reading each line
		echo "$line"
		IFS=':'
		set $line
		var1=$1
		var2=$2
		echo $var2 > /sys/bus/i2c/devices/0-0010/$var1
	done < $input
}

enable_ipd_calb_data

