#! /vendor/bin/sh
#==============================================================================
#       init.qti.media.sh
#
# Copyright (c) 2020-2021, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#===============================================================================

build_codename=`getprop vendor.media.system.build_codename`

if [ -f /sys/devices/soc0/soc_id ]; then
    soc_hwid=`cat /sys/devices/soc0/soc_id` 2> /dev/null
else
    soc_hwid=`cat /sys/devices/system/soc/soc0/id` 2> /dev/null
fi

target=`getprop ro.board.platform`
case "$target" in
   "bengal")
       case "$soc_hwid" in
           441|471|473|474)
               setprop vendor.media.target.version 2
               sku_ver=`cat /sys/devices/platform/soc/5a00000.qcom,vidc1/sku_version` 2> /dev/null
               if [ $sku_ver -eq 1 ]; then
                   setprop vendor.media.target.version 3
               fi
               ;;
           518)
               setprop vendor.media.target.version 3
               setprop vendor.netflix.bsp_rev "Q6115-31409-1"
               ;;
           *)
               sku_ver=`cat /sys/devices/platform/soc/5a00000.qcom,vidc/sku_version` 2> /dev/null
               if [ $sku_ver -eq 1 ]; then
                   setprop vendor.media.target.version 1
               fi
               setprop vendor.netflix.bsp_rev "Q6115-31409-1"
               ;;
       esac
       ;;
   "kona")
       setprop vendor.netflix.bsp_rev "Q8250-19134-1"
       ;;
   "lito")
       setprop vendor.netflix.bsp_rev "Q7250-19133-1"
       ;;
esac
