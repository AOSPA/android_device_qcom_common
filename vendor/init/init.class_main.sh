#! /vendor/bin/sh

# Copyright (c) 2013-2014, 2019 The Linux Foundation. All rights reserved.
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
# Changes from Qualcomm Innovation Center, Inc. are provided under the following license:
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

#
# start ril-daemon only for targets on which radio is present
#
baseband=`getprop ro.baseband`
datamode=`getprop persist.vendor.data.mode`
low_ram=`getprop ro.config.low_ram`

case "$baseband" in
    "apq" | "sda" | "qcs" )
    setprop ro.vendor.radio.noril yes
esac

case "$baseband" in
    "msm" | "csfb" | "svlte2a" | "mdm" | "mdm2" | "sglte" | "sglte2" | "dsda2" | "unknown" | "dsda3" | "sdm" | "sdx" | "sm6")
    case "$datamode" in
        "tethered")
            start vendor.dataqti
            if [ "$low_ram" != "true" ]; then
              start vendor.dataadpl
            fi
            ;;
        "concurrent")
            start vendor.dataqti
            if [ "$low_ram" != "true" ]; then
              start vendor.dataadpl
            fi
            ;;
        *)
            ;;
    esac
esac

#
# Allow persistent faking of bms
# User needs to set fake bms charge in persist.vendor.bms.fake_batt_capacity
#
fake_batt_capacity=`getprop persist.vendor.bms.fake_batt_capacity`
case "$fake_batt_capacity" in
    "") ;; #Do nothing here
    * )
    echo "$fake_batt_capacity" > /sys/class/power_supply/battery/capacity
    ;;
esac
