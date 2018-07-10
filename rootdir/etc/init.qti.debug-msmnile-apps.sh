#!/vendor/bin/sh

#Copyright (c) 2018, The Linux Foundation. All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of The Linux Foundation nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
#WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
#ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Function msmnile SLPI DCC configuration
enable_msmnile_dcc_config_apps()
{
    DCC_PATH="/sys/bus/platform/devices/10a2000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    echo 1 > $DCC_PATH/config_reset
    echo 2 > $DCC_PATH/curr_list

    echo 0x18200204 4 > $DCC_PATH/config
    echo 0x18200224 4 > $DCC_PATH/config
    echo 0x18200244 4 > $DCC_PATH/config
    echo 0x18200264 4 > $DCC_PATH/config
    echo 0x18200284 4 > $DCC_PATH/config
    echo 0x182002A4 4 > $DCC_PATH/config
    echo 0x182002C4 4 > $DCC_PATH/config
    echo 0x18210204 4 > $DCC_PATH/config
    echo 0x18210224 4 > $DCC_PATH/config
    echo 0x18210244 4 > $DCC_PATH/config
    echo 0x18210264 4 > $DCC_PATH/config
    echo 0x18210284 4 > $DCC_PATH/config
    echo 0x182102A4 4 > $DCC_PATH/config
    echo 0x182102C4 4 > $DCC_PATH/config
    echo 0x18200404 2 > $DCC_PATH/config
    echo 0x18200D00 2 > $DCC_PATH/config
    echo 0x18200D10 4 > $DCC_PATH/config
    echo 0x18200FB0 4 > $DCC_PATH/config
    echo 0x18201250 4 > $DCC_PATH/config
    echo 0x18200D30 4 > $DCC_PATH/config
    echo 0x18200D44 4 > $DCC_PATH/config
    echo 0x18200D58 4 > $DCC_PATH/config
    echo 0x18200D6C 4 > $DCC_PATH/config
    echo 0x18200D80 4 > $DCC_PATH/config
    echo 0x18200D94 4 > $DCC_PATH/config
    echo 0x18200DA8 4 > $DCC_PATH/config
    echo 0x18200DBC 4 > $DCC_PATH/config
    echo 0x18200DD0 4 > $DCC_PATH/config
    echo 0x18200DE4 4 > $DCC_PATH/config
    echo 0x18200DF8 4 > $DCC_PATH/config
    echo 0x18200E0C 4 > $DCC_PATH/config
    echo 0x18200E20 4 > $DCC_PATH/config
    echo 0x18200E34 4 > $DCC_PATH/config
    echo 0x18200E48 4 > $DCC_PATH/config
    echo 0x18200FD0 4 > $DCC_PATH/config
    echo 0x18200FE4 4 > $DCC_PATH/config
    echo 0x18200FF8 4 > $DCC_PATH/config
    echo 0x1820100C 4 > $DCC_PATH/config
    echo 0x18201020 4 > $DCC_PATH/config
    echo 0x18201034 4 > $DCC_PATH/config
    echo 0x18201048 4 > $DCC_PATH/config
    echo 0x1820105C 4 > $DCC_PATH/config
    echo 0x18201070 4 > $DCC_PATH/config
    echo 0x18201084 4 > $DCC_PATH/config
    echo 0x18201098 4 > $DCC_PATH/config
    echo 0x182010AC 4 > $DCC_PATH/config
    echo 0x182010C0 4 > $DCC_PATH/config
    echo 0x182010D4 4 > $DCC_PATH/config
    echo 0x182010E8 4 > $DCC_PATH/config
    echo 0x18201270 4 > $DCC_PATH/config
    echo 0x18201284 4 > $DCC_PATH/config
    echo 0x18201298 4 > $DCC_PATH/config
    echo 0x182012AC 4 > $DCC_PATH/config
    echo 0x182012C0 4 > $DCC_PATH/config
    echo 0x182012D4 4 > $DCC_PATH/config
    echo 0x182012E8 4 > $DCC_PATH/config
    echo 0x182012FC 4 > $DCC_PATH/config
    echo 0x18201310 4 > $DCC_PATH/config
    echo 0x18201324 4 > $DCC_PATH/config
    echo 0x18201338 4 > $DCC_PATH/config
    echo 0x1820134C 4 > $DCC_PATH/config
    echo 0x18201360 4 > $DCC_PATH/config
    echo 0x18201374 4 > $DCC_PATH/config
    echo 0x18201388 4 > $DCC_PATH/config
    echo 0x18210D00 2 > $DCC_PATH/config
    echo 0x18220D00 2 > $DCC_PATH/config
    echo 0x18210D10 4 > $DCC_PATH/config
    echo 0x18210FB0 4 > $DCC_PATH/config
    echo 0x18211250 4 > $DCC_PATH/config
    echo 0x18210D30 4 > $DCC_PATH/config
    echo 0x18210D44 4 > $DCC_PATH/config
    echo 0x18210D58 4 > $DCC_PATH/config
    echo 0x18210D6C 4 > $DCC_PATH/config
    echo 0x18210D80 4 > $DCC_PATH/config
    echo 0x18210D94 4 > $DCC_PATH/config
    echo 0x18210DA8 4 > $DCC_PATH/config
    echo 0x18210DBC 4 > $DCC_PATH/config
    echo 0x18210DD0 4 > $DCC_PATH/config
    echo 0x18210DE4 4 > $DCC_PATH/config
    echo 0x18210DF8 4 > $DCC_PATH/config
    echo 0x18210E0C 4 > $DCC_PATH/config
    echo 0x18210E20 4 > $DCC_PATH/config
    echo 0x18210E34 4 > $DCC_PATH/config
    echo 0x18210E48 4 > $DCC_PATH/config
    echo 0x18210FD0 4 > $DCC_PATH/config
    echo 0x18210FE4 4 > $DCC_PATH/config
    echo 0x18210FF8 4 > $DCC_PATH/config
    echo 0x1821100C 4 > $DCC_PATH/config
    echo 0x18211020 4 > $DCC_PATH/config
    echo 0x18211034 4 > $DCC_PATH/config
    echo 0x18211048 4 > $DCC_PATH/config
    echo 0x1821105C 4 > $DCC_PATH/config
    echo 0x18211070 4 > $DCC_PATH/config
    echo 0x18211084 4 > $DCC_PATH/config
    echo 0x18211098 4 > $DCC_PATH/config
    echo 0x182110AC 4 > $DCC_PATH/config
    echo 0x182110C0 4 > $DCC_PATH/config
    echo 0x182110D4 4 > $DCC_PATH/config
    echo 0x182110E8 4 > $DCC_PATH/config
    echo 0x18211270 4 > $DCC_PATH/config
    echo 0x18211284 4 > $DCC_PATH/config
    echo 0x18211298 4 > $DCC_PATH/config
    echo 0x182112AC 4 > $DCC_PATH/config
    echo 0x182112C0 4 > $DCC_PATH/config
    echo 0x182112D4 4 > $DCC_PATH/config
    echo 0x182112E8 4 > $DCC_PATH/config
    echo 0x182112FC 4 > $DCC_PATH/config
    echo 0x18211310 4 > $DCC_PATH/config
    echo 0x18211324 4 > $DCC_PATH/config
    echo 0x18211338 4 > $DCC_PATH/config
    echo 0x1821134C 4 > $DCC_PATH/config
    echo 0x18211360 4 > $DCC_PATH/config
    echo 0x18211374 4 > $DCC_PATH/config
    echo 0x18211388 4 > $DCC_PATH/config
    echo 0x18220D10 4 > $DCC_PATH/config
    echo 0x18220FB0 4 > $DCC_PATH/config
    echo 0x18221250 4 > $DCC_PATH/config
    echo 0x182214F0 4 > $DCC_PATH/config
    echo 0x18221790 4 > $DCC_PATH/config
    echo 0x18221A30 4 > $DCC_PATH/config
    echo 0x18221CD0 4 > $DCC_PATH/config
    echo 0x18220D30 4 > $DCC_PATH/config
    echo 0x18220D44 4 > $DCC_PATH/config
    echo 0x18220D58 4 > $DCC_PATH/config
    echo 0x18220D6C 4 > $DCC_PATH/config
    echo 0x18220D80 4 > $DCC_PATH/config
    echo 0x18220D94 4 > $DCC_PATH/config
    echo 0x18220DA8 4 > $DCC_PATH/config
    echo 0x18220DBC 4 > $DCC_PATH/config
    echo 0x18220DD0 4 > $DCC_PATH/config
    echo 0x18220DE4 4 > $DCC_PATH/config
    echo 0x18220DF8 4 > $DCC_PATH/config
    echo 0x18220E0C 4 > $DCC_PATH/config
    echo 0x18220E20 4 > $DCC_PATH/config
    echo 0x18220E34 4 > $DCC_PATH/config
    echo 0x18220E48 4 > $DCC_PATH/config
    echo 0x18220FD0 4 > $DCC_PATH/config
    echo 0x18220FE4 4 > $DCC_PATH/config
    echo 0x18220FF8 4 > $DCC_PATH/config
    echo 0x1822100C 4 > $DCC_PATH/config
    echo 0x18221020 4 > $DCC_PATH/config
    echo 0x18221034 4 > $DCC_PATH/config
    echo 0x18221048 4 > $DCC_PATH/config
    echo 0x1822105C 4 > $DCC_PATH/config
    echo 0x18221070 4 > $DCC_PATH/config
    echo 0x18221084 4 > $DCC_PATH/config
    echo 0x18221098 4 > $DCC_PATH/config
    echo 0x182210AC 4 > $DCC_PATH/config
    echo 0x182210C0 4 > $DCC_PATH/config
    echo 0x182210D4 4 > $DCC_PATH/config
    echo 0x182210E8 4 > $DCC_PATH/config
    echo 0x18221270 4 > $DCC_PATH/config
    echo 0x18221284 4 > $DCC_PATH/config
    echo 0x18221298 4 > $DCC_PATH/config
    echo 0x182212AC 4 > $DCC_PATH/config
    echo 0x182212C0 4 > $DCC_PATH/config
    echo 0x182212D4 4 > $DCC_PATH/config
    echo 0x182212E8 4 > $DCC_PATH/config
    echo 0x182212FC 4 > $DCC_PATH/config
    echo 0x18221310 4 > $DCC_PATH/config
    echo 0x18221324 4 > $DCC_PATH/config
    echo 0x18221338 4 > $DCC_PATH/config
    echo 0x1822134C 4 > $DCC_PATH/config
    echo 0x18221360 4 > $DCC_PATH/config
    echo 0x18221374 4 > $DCC_PATH/config
    echo 0x18221388 4 > $DCC_PATH/config
    echo 0x18221510 4 > $DCC_PATH/config
    echo 0x18221524 4 > $DCC_PATH/config
    echo 0x18221538 4 > $DCC_PATH/config
    echo 0x1822154C 4 > $DCC_PATH/config
    echo 0x18221560 4 > $DCC_PATH/config
    echo 0x18221574 4 > $DCC_PATH/config
    echo 0x18221588 4 > $DCC_PATH/config
    echo 0x1822159C 4 > $DCC_PATH/config
    echo 0x182215B0 4 > $DCC_PATH/config
    echo 0x182215C4 4 > $DCC_PATH/config
    echo 0x182215D8 4 > $DCC_PATH/config
    echo 0x182215EC 4 > $DCC_PATH/config
    echo 0x18221600 4 > $DCC_PATH/config
    echo 0x18221614 4 > $DCC_PATH/config
    echo 0x18221628 4 > $DCC_PATH/config
    echo 0x182217B0 4 > $DCC_PATH/config
    echo 0x182217C4 4 > $DCC_PATH/config
    echo 0x182217D8 4 > $DCC_PATH/config
    echo 0x182217EC 4 > $DCC_PATH/config
    echo 0x18221800 4 > $DCC_PATH/config
    echo 0x18221814 4 > $DCC_PATH/config
    echo 0x18221828 4 > $DCC_PATH/config
    echo 0x1822183C 4 > $DCC_PATH/config
    echo 0x18221850 4 > $DCC_PATH/config
    echo 0x18221864 4 > $DCC_PATH/config
    echo 0x18221878 4 > $DCC_PATH/config
    echo 0x1822188C 4 > $DCC_PATH/config
    echo 0x182218A0 4 > $DCC_PATH/config
    echo 0x182218B4 4 > $DCC_PATH/config
    echo 0x182218C8 4 > $DCC_PATH/config
    echo 0x18221A50 4 > $DCC_PATH/config
    echo 0x18221A64 4 > $DCC_PATH/config
    echo 0x18221A78 4 > $DCC_PATH/config
    echo 0x18221A8C 4 > $DCC_PATH/config
    echo 0x18221AA0 4 > $DCC_PATH/config
    echo 0x18221AB4 4 > $DCC_PATH/config
    echo 0x18221AC8 4 > $DCC_PATH/config
    echo 0x18221ADC 4 > $DCC_PATH/config
    echo 0x18221AF0 4 > $DCC_PATH/config
    echo 0x18221B04 4 > $DCC_PATH/config
    echo 0x18221B18 4 > $DCC_PATH/config
    echo 0x18221B2C 4 > $DCC_PATH/config
    echo 0x18221B40 4 > $DCC_PATH/config
    echo 0x18221B54 4 > $DCC_PATH/config
    echo 0x18221B68 4 > $DCC_PATH/config
    echo 0x18221CF0 4 > $DCC_PATH/config
    echo 0x18221D04 4 > $DCC_PATH/config
    echo 0x18221D18 4 > $DCC_PATH/config
    echo 0x18221D2C 4 > $DCC_PATH/config
    echo 0x18221D40 4 > $DCC_PATH/config
    echo 0x18221D54 4 > $DCC_PATH/config
    echo 0x18221D68 4 > $DCC_PATH/config
    echo 0x18221D7C 4 > $DCC_PATH/config
    echo 0x18221D90 4 > $DCC_PATH/config
    echo 0x18221DA4 4 > $DCC_PATH/config
    echo 0x18221DB8 4 > $DCC_PATH/config
    echo 0x18221DCC 4 > $DCC_PATH/config
    echo 0x18221DE0 4 > $DCC_PATH/config
    echo 0x18221DF4 4 > $DCC_PATH/config
    echo 0x18221E08 4 > $DCC_PATH/config
    echo 0x04130404 2 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

enable_msmnile_dcc_config_apps
