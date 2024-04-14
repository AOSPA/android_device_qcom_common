#=============================================================================
# Copyright (c) 2023 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#=============================================================================

get_num_logical_cores_in_physical_cluster()
{
	i=0
	logical_cores=(0 0 0 0 0 0)
	if [ -f /sys/devices/system/cpu/cpu0/topology/cluster_id ] ; then
		physical_cluster="cluster_id"
	else
		physical_cluster="physical_package_id"
	fi
	for i in `ls -d /sys/devices/system/cpu/cpufreq/policy[0-9]*`
	do
		if [ -e $i ] ; then
			num_cores=$(cat $i/related_cpus | wc -w)
			first_cpu=$(echo "$i" | sed 's/[^0-9]*//g')
			cluster_id=$(cat /sys/devices/system/cpu/cpu$first_cpu/topology/$physical_cluster)
			logical_cores[cluster_id]=$num_cores
		fi
	done
	cpu_topology=""
	j=0
	physical_cluster_count=$1
	while [[ $j -lt $physical_cluster_count ]]; do
		cpu_topology+=${logical_cores[$j]}
		if [ $j -lt $physical_cluster_count-1 ]; then
			cpu_topology+="_"
		fi
		j=$((j+1))
	done
	echo $cpu_topology
}

#Implementing this mechanism to jump to powersave governor if the script is not running
#as it would be an indication for devs for debug purposes.
fallback_setting()
{
	governor="powersave"
	for i in `ls -d /sys/devices/system/cpu/cpufreq/policy[0-9]*`
	do
		if [ -f $i/scaling_governor ] ; then
			echo $governor > $i/scaling_governor
		fi
	done
}

enable_thp()
{
	# THP enablement settings
	echo always > /sys/kernel/mm/transparent_hugepage/enabled

	MemTotalStr=`cat /proc/meminfo | grep MemTotal`
	MemTotal=${MemTotalStr:16:8}
	let RamSizeGB="( $MemTotal / 1048576 ) + 1"

	# Set the min_free_kbytes to standard kernel value
	if [ $RamSizeGB -ge 8 ]; then
		MinFreeKbytes=11584
	elif [ $RamSizeGB -ge 4 ]; then
		MinFreeKbytes=8192
	elif [ $RamSizeGB -ge 2 ]; then
		MinFreeKbytes=5792
	else
		MinFreeKbytes=4096
	fi

	# We store min_free_kbytes into a vendor property so that the PASR
	# HAL can read and set the value for it.
	echo $MinFreeKbytes > /proc/sys/vm/min_free_kbytes
	setprop vendor.memory.min_free_kbytes $MinFreeKbytes

	#Enable the PASR support
	ddr_type=`od -An -tx /proc/device-tree/memory/ddr_device_type`
	ddr_type5="08"

	if [ -d /sys/kernel/mem-offline ]; then
		#only LPDDR5 supports PAAR
		if [ ${ddr_type:4:2} != $ddr_type5 ]; then
			setprop vendor.pasr.activemode.enabled false
		fi
		setprop vendor.pasr.enabled true
	fi
}

case "$2" in
	"632"|"643")
		#THP is disabled by default. Do nothing here.
		;;
	*)
		enable_thp
		;;
esac

variant=$(get_num_logical_cores_in_physical_cluster "$1")
echo "CPU topology: ${variant}"
case "$variant" in
	"3_4_1")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-cliffs_default_3_4_1.sh
	;;
	"3_3_1")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-cliffs_3_3_1.sh
	;;
	"2_3_0")
	/vendor/bin/sh /vendor/bin/init.kernel.post_boot-cliffs_2_3_0.sh
	;;
	"2_2_1")
	vendor/bin/sh /vendor/bin/init.kernel.post_boot-cliffs_2_2_1.sh
	;;
	*)
	echo "***WARNING***: Postboot script not present for the variant ${variant}"
	fallback_setting
	;;
esac
