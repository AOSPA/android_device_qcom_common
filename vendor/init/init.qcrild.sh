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

#
# start ril-daemon only for targets on which radio is present
#
baseband=`getprop ro.baseband`
sgltecsfb=`getprop persist.vendor.radio.sglte_csfb`

case "$baseband" in
    "apq" | "sda" | "qcs" )
    stop vendor.qcrild
    stop vendor.qcrild2
    stop vendor.qcrild3
esac

case "$baseband" in
    "msm" | "csfb" | "svlte2a" | "mdm" | "mdm2" | "sglte" | "sglte2" | "dsda2" | "unknown" | "dsda3" | "sdm" | "sdx" | "sm6")

    # start qcrild only for targets on which modem is present
    # modemvalue "enabled" indicates Modem is enabled
    # modemvalue "disabled" indicates Modem is not enabled
    qspamodemvalue="enabled"
    qspavalue=`getprop ro.boot.vendor.qspa`
    modemvalue="0x0"
    if [ "$qspavalue" = "true" ]; then
        qspamodemvalue=`getprop ro.boot.vendor.qspa.modem`
    else
        if [ -f /sys/devices/soc0/modem ]; then
            modemvalue=`cat /sys/devices/soc0/modem`
        fi
        if [ "$modemvalue" = "0x1" ] || [ "$modemvalue" = "0xff" ]; then
            qspamodemvalue="disabled"
        fi
    fi

    if [ "$qspamodemvalue" = "enabled" ]; then
        start vendor.qcrild

        multisim=`getprop persist.radio.multisim.config`

        if [ "$multisim" = "dsds" ] || [ "$multisim" = "dsda" ]; then
            start vendor.qcrild2
        elif [ "$multisim" = "tsts" ]; then
            start vendor.qcrild2
            start vendor.qcrild3
        fi

        case "$baseband" in
            "svlte2a" | "csfb")
              start qmiproxy
            ;;
            "sglte" | "sglte2" )
              if [ "x$sgltecsfb" != "xtrue" ]; then
                  start qmiproxy
              else
                  setprop persist.vendor.radio.voice.modem.index 0
              fi
            ;;
        esac
    else
        setprop ro.vendor.radio.noril yes
        stop vendor.qcrild
        stop vendor.qcrild2
        stop vendor.qcrild3
    fi
esac
