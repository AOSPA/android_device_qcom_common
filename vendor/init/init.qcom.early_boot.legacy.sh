#! /vendor/bin/sh

# Copyright (c) 2012-2013,2016,2018-2020 The Linux Foundation. All rights reserved.
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
#

export PATH=/vendor/bin

# Set platform variables
if [ -f /sys/devices/soc0/hw_platform ]; then
    soc_hwplatform=`cat /sys/devices/soc0/hw_platform` 2> /dev/null
else
    soc_hwplatform=`cat /sys/devices/system/soc/soc0/hw_platform` 2> /dev/null
fi
if [ -f /sys/devices/soc0/soc_id ]; then
    soc_hwid=`cat /sys/devices/soc0/soc_id` 2> /dev/null
else
    soc_hwid=`cat /sys/devices/system/soc/soc0/id` 2> /dev/null
fi
if [ -f /sys/devices/soc0/platform_version ]; then
    soc_hwver=`cat /sys/devices/soc0/platform_version` 2> /dev/null
else
    soc_hwver=`cat /sys/devices/system/soc/soc0/platform_version` 2> /dev/null
fi

# Update permissions
chown root.system /dev/block/platform/soc/*/by-name/rawdump
chmod 0660 /dev/block/platform/soc/*/by-name/rawdump
chown system.system /sys/devices/platform/soc/18800000.qcom,icnss/net/wlan*/queues/rx-*/rps_cpus
chmod 0660 /sys/devices/platform/soc/17a10040.qcom,wcn6750/net/wlan*/queues/rx-*/rps_cpus
chown system.graphics /sys/class/drm/sde-crtc-*/lineptr_value
chmod 0664 /sys/class/drm/sde-crtc-*/lineptr_value

target=`getprop ro.board.platform`
case "$target" in
    "bengal")
        case "$soc_hwid" in
            441|473)
                # 441 is for scuba and 473 for scuba iot qcm
                setprop vendor.fastrpc.disable.cdsprpcd.daemon 1
                setprop vendor.media.target.version 2
                setprop vendor.gralloc.disable_ubwc 1
                setprop vendor.display.enhance_idle_time 1
                setprop vendor.netflix.bsp_rev ""
                # 196609 is decimal for 0x30001 to report version 3.1
                setprop vendor.opengles.version 196609
                sku_ver=`cat /sys/devices/platform/soc/5a00000.qcom,vidc1/sku_version` 2> /dev/null
                if [ $sku_ver -eq 1 ]; then
                   setprop vendor.media.target.version 3
                fi
                ;;
            471|474)
                # 471 is for scuba APQ and 474 for scuba iot qcs
                setprop vendor.fastrpc.disable.cdsprpcd.daemon 1
                setprop vendor.gralloc.disable_ubwc 1
                setprop vendor.display.enhance_idle_time 1
                setprop vendor.netflix.bsp_rev ""
                ;;
            518|561|586)
                setprop vendor.media.target.version 3
                ;;
            585)
                setprop vendor.media.target.version 4
                ;;
        esac
        ;;
esac
