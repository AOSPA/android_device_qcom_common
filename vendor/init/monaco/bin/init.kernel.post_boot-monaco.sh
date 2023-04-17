#=============================================================================
# Copyright (c) 2020-2022 Qualcomm Technologies, Inc.
# All Rights Reserved.
# Confidential and Proprietary - Qualcomm Technologies, Inc.
#
# Copyright (c) 2009-2012, 2014-2019, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================


# Configure RT parameters:
# Long running RT task detection is confined to consolidated builds.
# Set RT throttle runtime to 50ms more than long running RT
# task detection time.
# Set RT throttle period to 100ms more than RT throttle runtime.
long_running_rt_task_ms=1200
sched_rt_runtime_ms=`expr $long_running_rt_task_ms + 50`
sched_rt_runtime_us=`expr $sched_rt_runtime_ms \* 1000`
sched_rt_period_ms=`expr $sched_rt_runtime_ms + 100`
sched_rt_period_us=`expr $sched_rt_period_ms \* 1000`
if [ -d /sys/module/sched_walt_debug ]; then
	echo $long_running_rt_task_ms > /proc/sys/walt/sched_long_running_rt_task_ms
fi
echo $sched_rt_period_us > /proc/sys/kernel/sched_rt_period_us
echo $sched_rt_runtime_us > /proc/sys/kernel/sched_rt_runtime_us

# enable core control
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
echo 0 1 1 1 > /sys/devices/system/cpu/cpu0/core_ctl/not_preferred
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/min_cpus
echo 4 > /sys/devices/system/cpu/cpu0/core_ctl/max_cpus
echo 71 71 60 50 > /sys/devices/system/cpu/cpu0/core_ctl/busy_up_thres
echo 30 > /sys/devices/system/cpu/cpu0/core_ctl/busy_down_thres
echo 1000 > /sys/devices/system/cpu/cpu0/core_ctl/offline_delay_ms
echo 1 > /sys/devices/system/cpu/cpu0/core_ctl/enable

# Setting b.L scheduler parameters
echo 40 > /proc/sys/walt/sched_cluster_util_thres_pct
echo 30 > /proc/sys/walt/sched_idle_enough

# set the threshold for low latency task boost feature which prioritize
# binder activity tasks
echo 325 > /proc/sys/walt/walt_low_latency_task_threshold

# Turn off scheduler boost at the end
echo 0 > /proc/sys/walt/sched_boost

# Reset the RT boost, which is 1024 (max) by default.
echo 0 > /proc/sys/kernel/sched_util_clamp_min_rt_default

# configure governor settings for silver cluster
echo "walt" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 0 > /sys/devices/system/cpu/cpufreq/policy0/walt/up_rate_limit_us
echo 1000 > /sys/devices/system/cpu/cpufreq/policy0/walt/down_rate_limit_us
echo 614000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq
echo 1363200 > /sys/devices/system/cpu/cpufreq/policy0/walt/hispeed_freq
echo 88 > /sys/devices/system/cpu/cpu0/cpufreq/walt/hispeed_load
echo 1 > /sys/devices/system/cpu/cpufreq/policy0/walt/pl
echo 1 > /proc/sys/walt/sched_prefer_spread
echo -10 > /sys/devices/system/cpu/cpu0/sched_load_boost
echo -10 > /sys/devices/system/cpu/cpu1/sched_load_boost
echo -10 > /sys/devices/system/cpu/cpu2/sched_load_boost
echo -10 > /sys/devices/system/cpu/cpu3/sched_load_boost

# configure bus-dcvs
bus_dcvs="/sys/devices/system/cpu/bus_dcvs"

for device in $bus_dcvs/*
do
	cat $device/hw_min_freq > $device/boost_freq
done

for ddrbw in $bus_dcvs/DDR/*bwmon-ddr
do
	echo "762 1144 1720 2086 2597 2929 3879 5161 5931 6881 7980" > $ddrbw/mbps_zones
	echo 4 > $ddrbw/sample_ms
	echo 68 > $ddrbw/io_percent
	echo 20 > $ddrbw/hist_memory
	echo 0 > $ddrbw/hyst_length
	echo 80 > $ddrbw/down_thres
	echo 30 > $ddrbw/guard_band_mbps
	echo 250 > $ddrbw/up_scale
	echo 762 > $ddrbw/idle_mbps
	echo 7980 > $ddrbw/max_freq
	echo 40 > $ddrbw/window_ms
done

for latfloor in $bus_dcvs/*/*latfloor
do
	echo 25000 > $latfloor/ipm_ceil
done

echo s2idle > /sys/power/mem_sleep
echo N > /sys/devices/system/cpu/qcom_lpm/parameters/sleep_disabled

# Let kernel know our image version/variant/crm_version
if [ -f /sys/devices/soc0/select_image ]; then
	image_version="10:"
	image_version+=`getprop ro.build.id`
	image_version+=":"
	image_version+=`getprop ro.build.version.incremental`
	image_variant=`getprop ro.product.name`
	image_variant+="-"
	image_variant+=`getprop ro.build.type`
	oem_version=`getprop ro.build.version.codename`
	echo 10 > /sys/devices/soc0/select_image
	echo $image_version > /sys/devices/soc0/image_version
	echo $image_variant > /sys/devices/soc0/image_variant
	echo $oem_version > /sys/devices/soc0/image_crm_version
fi

echo 4 > /proc/sys/kernel/printk

# Change console log level as per console config property
console_config=`getprop persist.vendor.console.silent.config`
case "$console_config" in
	"1")
		echo "Enable console config to $console_config"
		echo 0 > /proc/sys/kernel/printk
	;;
	*)
		echo "Enable console config to $console_config"
	;;
esac

setprop vendor.post_boot.parsed 1
