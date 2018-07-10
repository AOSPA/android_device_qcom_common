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

# Function msmnile DCC configuration
enable_msmnile_dcc_config_modem()
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

    echo 0x4200204 4 > $DCC_PATH/config
    echo 0x4200224 4 > $DCC_PATH/config
    echo 0x4200244 4 > $DCC_PATH/config
    echo 0x4200264 4 > $DCC_PATH/config
    echo 0x4200284 4 > $DCC_PATH/config
    echo 0x4200404 2 > $DCC_PATH/config
    echo 0x4200D00 2 > $DCC_PATH/config
    echo 0x4200D10 4 > $DCC_PATH/config
    echo 0x4200FB0 4 > $DCC_PATH/config
    echo 0x4201250 4 > $DCC_PATH/config
    echo 0x42014F0 4 > $DCC_PATH/config
    echo 0x4201790 4 > $DCC_PATH/config
    echo 0x4201A30 4 > $DCC_PATH/config
    echo 0x4201CD0 4 > $DCC_PATH/config
    echo 0x4200D30 4 > $DCC_PATH/config
    echo 0x4200D44 4 > $DCC_PATH/config
    echo 0x4200D58 4 > $DCC_PATH/config
    echo 0x4200D6C 4 > $DCC_PATH/config
    echo 0x4200D80 4 > $DCC_PATH/config
    echo 0x4200D94 4 > $DCC_PATH/config
    echo 0x4200DA8 4 > $DCC_PATH/config
    echo 0x4200DBC 4 > $DCC_PATH/config
    echo 0x4200DD0 4 > $DCC_PATH/config
    echo 0x4200DE4 4 > $DCC_PATH/config
    echo 0x4200DF8 4 > $DCC_PATH/config
    echo 0x4200E0C 4 > $DCC_PATH/config
    echo 0x4200E20 4 > $DCC_PATH/config
    echo 0x4200E34 4 > $DCC_PATH/config
    echo 0x4200E48 4 > $DCC_PATH/config
    echo 0x4200FD0 4 > $DCC_PATH/config
    echo 0x4200FE4 4 > $DCC_PATH/config
    echo 0x4200FF8 4 > $DCC_PATH/config
    echo 0x420100C 4 > $DCC_PATH/config
    echo 0x4201020 4 > $DCC_PATH/config
    echo 0x4201034 4 > $DCC_PATH/config
    echo 0x4201048 4 > $DCC_PATH/config
    echo 0x420105C 4 > $DCC_PATH/config
    echo 0x4201070 4 > $DCC_PATH/config
    echo 0x4201084 4 > $DCC_PATH/config
    echo 0x4201098 4 > $DCC_PATH/config
    echo 0x42010AC 4 > $DCC_PATH/config
    echo 0x42010C0 4 > $DCC_PATH/config
    echo 0x42010D4 4 > $DCC_PATH/config
    echo 0x42010E8 4 > $DCC_PATH/config
    echo 0x4201270 4 > $DCC_PATH/config
    echo 0x4201284 4 > $DCC_PATH/config
    echo 0x4201298 4 > $DCC_PATH/config
    echo 0x42012AC 4 > $DCC_PATH/config
    echo 0x42012C0 4 > $DCC_PATH/config
    echo 0x42012D4 4 > $DCC_PATH/config
    echo 0x42012E8 4 > $DCC_PATH/config
    echo 0x42012FC 4 > $DCC_PATH/config
    echo 0x4201310 4 > $DCC_PATH/config
    echo 0x4201324 4 > $DCC_PATH/config
    echo 0x4201338 4 > $DCC_PATH/config
    echo 0x420134C 4 > $DCC_PATH/config
    echo 0x4201360 4 > $DCC_PATH/config
    echo 0x4201374 4 > $DCC_PATH/config
    echo 0x4201388 4 > $DCC_PATH/config
    echo 0x4201510 4 > $DCC_PATH/config
    echo 0x4201524 4 > $DCC_PATH/config
    echo 0x4201538 4 > $DCC_PATH/config
    echo 0x420154C 4 > $DCC_PATH/config
    echo 0x4201560 4 > $DCC_PATH/config
    echo 0x4201574 4 > $DCC_PATH/config
    echo 0x4201588 4 > $DCC_PATH/config
    echo 0x420159C 4 > $DCC_PATH/config
    echo 0x42015B0 4 > $DCC_PATH/config
    echo 0x42015C4 4 > $DCC_PATH/config
    echo 0x42015D8 4 > $DCC_PATH/config
    echo 0x42015EC 4 > $DCC_PATH/config
    echo 0x4201600 4 > $DCC_PATH/config
    echo 0x4201614 4 > $DCC_PATH/config
    echo 0x4201628 4 > $DCC_PATH/config
    echo 0x42017B0 4 > $DCC_PATH/config
    echo 0x42017C4 4 > $DCC_PATH/config
    echo 0x42017D8 4 > $DCC_PATH/config
    echo 0x42017EC 4 > $DCC_PATH/config
    echo 0x4201800 4 > $DCC_PATH/config
    echo 0x4201814 4 > $DCC_PATH/config
    echo 0x4201828 4 > $DCC_PATH/config
    echo 0x420183C 4 > $DCC_PATH/config
    echo 0x4201850 4 > $DCC_PATH/config
    echo 0x4201864 4 > $DCC_PATH/config
    echo 0x4201878 4 > $DCC_PATH/config
    echo 0x420188C 4 > $DCC_PATH/config
    echo 0x42018A0 4 > $DCC_PATH/config
    echo 0x42018B4 4 > $DCC_PATH/config
    echo 0x42018C8 4 > $DCC_PATH/config
    echo 0x4201A50 4 > $DCC_PATH/config
    echo 0x4201A64 4 > $DCC_PATH/config
    echo 0x4201A78 4 > $DCC_PATH/config
    echo 0x4201A8C 4 > $DCC_PATH/config
    echo 0x4201AA0 4 > $DCC_PATH/config
    echo 0x4201AB4 4 > $DCC_PATH/config
    echo 0x4201AC8 4 > $DCC_PATH/config
    echo 0x4201ADC 4 > $DCC_PATH/config
    echo 0x4201AF0 4 > $DCC_PATH/config
    echo 0x4201B04 4 > $DCC_PATH/config
    echo 0x4201B18 4 > $DCC_PATH/config
    echo 0x4201B2C 4 > $DCC_PATH/config
    echo 0x4201B40 4 > $DCC_PATH/config
    echo 0x4201B54 4 > $DCC_PATH/config
    echo 0x4201B68 4 > $DCC_PATH/config
    echo 0x4201CF0 4 > $DCC_PATH/config
    echo 0x4201D04 4 > $DCC_PATH/config
    echo 0x4201D18 4 > $DCC_PATH/config
    echo 0x4201D2C 4 > $DCC_PATH/config
    echo 0x4201D40 4 > $DCC_PATH/config
    echo 0x4201D54 4 > $DCC_PATH/config
    echo 0x4201D68 4 > $DCC_PATH/config
    echo 0x4201D7C 4 > $DCC_PATH/config
    echo 0x4201D90 4 > $DCC_PATH/config
    echo 0x4201DA4 4 > $DCC_PATH/config
    echo 0x4201DB8 4 > $DCC_PATH/config
    echo 0x4201DCC 4 > $DCC_PATH/config
    echo 0x4201DE0 4 > $DCC_PATH/config
    echo 0x4201DF4 4 > $DCC_PATH/config
    echo 0x4201E08 4 > $DCC_PATH/config
    echo 0x4210D00 2 > $DCC_PATH/config
    echo 0x4210D10 4 > $DCC_PATH/config
    echo 0x4210D30 4 > $DCC_PATH/config
    echo 0x4210D44 4 > $DCC_PATH/config
    echo 0x4210D58 4 > $DCC_PATH/config
    echo 0x4210D6C 4 > $DCC_PATH/config
    echo 0x4210D80 4 > $DCC_PATH/config
    echo 0x4210D94 4 > $DCC_PATH/config
    echo 0x4210DA8 4 > $DCC_PATH/config
    echo 0x4210DBC 4 > $DCC_PATH/config
    echo 0x4210DD0 4 > $DCC_PATH/config
    echo 0x4210DE4 4 > $DCC_PATH/config
    echo 0x4210DF8 4 > $DCC_PATH/config
    echo 0x4210E0C 4 > $DCC_PATH/config
    echo 0x4210E20 4 > $DCC_PATH/config
    echo 0x4210E34 4 > $DCC_PATH/config
    echo 0x4210E48 4 > $DCC_PATH/config
    echo 0x4210FD0 4 > $DCC_PATH/config
    echo 0x4210FE4 4 > $DCC_PATH/config
    echo 0x4210FF8 4 > $DCC_PATH/config
    echo 0x421100C 4 > $DCC_PATH/config
    echo 0x4211020 4 > $DCC_PATH/config
    echo 0x4211034 4 > $DCC_PATH/config
    echo 0x4211048 4 > $DCC_PATH/config
    echo 0x421105C 4 > $DCC_PATH/config
    echo 0x4211070 4 > $DCC_PATH/config
    echo 0x4211084 4 > $DCC_PATH/config
    echo 0x4211098 4 > $DCC_PATH/config
    echo 0x42110AC 4 > $DCC_PATH/config
    echo 0x42110C0 4 > $DCC_PATH/config
    echo 0x42110D4 4 > $DCC_PATH/config
    echo 0x42110E8 4 > $DCC_PATH/config
    echo 0x4211270 4 > $DCC_PATH/config
    echo 0x4211284 4 > $DCC_PATH/config
    echo 0x4211298 4 > $DCC_PATH/config
    echo 0x42112AC 4 > $DCC_PATH/config
    echo 0x42112C0 4 > $DCC_PATH/config
    echo 0x42112D4 4 > $DCC_PATH/config
    echo 0x42112E8 4 > $DCC_PATH/config
    echo 0x42112FC 4 > $DCC_PATH/config
    echo 0x4211310 4 > $DCC_PATH/config
    echo 0x4211324 4 > $DCC_PATH/config
    echo 0x4211338 4 > $DCC_PATH/config
    echo 0x421134C 4 > $DCC_PATH/config
    echo 0x4211360 4 > $DCC_PATH/config
    echo 0x4211374 4 > $DCC_PATH/config
    echo 0x4211388 4 > $DCC_PATH/config
    echo 0x4211510 4 > $DCC_PATH/config
    echo 0x4211524 4 > $DCC_PATH/config
    echo 0x4211538 4 > $DCC_PATH/config
    echo 0x421154C 4 > $DCC_PATH/config
    echo 0x4211560 4 > $DCC_PATH/config
    echo 0x4211574 4 > $DCC_PATH/config
    echo 0x4211588 4 > $DCC_PATH/config
    echo 0x421159C 4 > $DCC_PATH/config
    echo 0x42115B0 4 > $DCC_PATH/config
    echo 0x42115C4 4 > $DCC_PATH/config
    echo 0x42115D8 4 > $DCC_PATH/config
    echo 0x42115EC 4 > $DCC_PATH/config
    echo 0x4211600 4 > $DCC_PATH/config
    echo 0x4211614 4 > $DCC_PATH/config
    echo 0x4211628 4 > $DCC_PATH/config
    echo 0x42117B0 4 > $DCC_PATH/config
    echo 0x42117C4 4 > $DCC_PATH/config
    echo 0x42117D8 4 > $DCC_PATH/config
    echo 0x42117EC 4 > $DCC_PATH/config
    echo 0x4211800 4 > $DCC_PATH/config
    echo 0x4211814 4 > $DCC_PATH/config
    echo 0x4211828 4 > $DCC_PATH/config
    echo 0x421183C 4 > $DCC_PATH/config
    echo 0x4211850 4 > $DCC_PATH/config
    echo 0x4211864 4 > $DCC_PATH/config
    echo 0x4211878 4 > $DCC_PATH/config
    echo 0x421188C 4 > $DCC_PATH/config
    echo 0x42118A0 4 > $DCC_PATH/config
    echo 0x42118B4 4 > $DCC_PATH/config
    echo 0x42118C8 4 > $DCC_PATH/config
    echo 0x4211A50 4 > $DCC_PATH/config
    echo 0x4211A64 4 > $DCC_PATH/config
    echo 0x4211A78 4 > $DCC_PATH/config
    echo 0x4211A8C 4 > $DCC_PATH/config
    echo 0x4211AA0 4 > $DCC_PATH/config
    echo 0x4211AB4 4 > $DCC_PATH/config
    echo 0x4211AC8 4 > $DCC_PATH/config
    echo 0x4211ADC 4 > $DCC_PATH/config
    echo 0x4211AF0 4 > $DCC_PATH/config
    echo 0x4211B04 4 > $DCC_PATH/config
    echo 0x4211B18 4 > $DCC_PATH/config
    echo 0x4211B2C 4 > $DCC_PATH/config
    echo 0x4211B40 4 > $DCC_PATH/config
    echo 0x4211B54 4 > $DCC_PATH/config
    echo 0x4211B68 4 > $DCC_PATH/config
    echo 0x4211CF0 4 > $DCC_PATH/config
    echo 0x4211D04 4 > $DCC_PATH/config
    echo 0x4211D18 4 > $DCC_PATH/config
    echo 0x4211D2C 4 > $DCC_PATH/config
    echo 0x4211D40 4 > $DCC_PATH/config
    echo 0x4211D54 4 > $DCC_PATH/config
    echo 0x4211D68 4 > $DCC_PATH/config
    echo 0x4211D7C 4 > $DCC_PATH/config
    echo 0x4211D90 4 > $DCC_PATH/config
    echo 0x4211DA4 4 > $DCC_PATH/config
    echo 0x4211DB8 4 > $DCC_PATH/config
    echo 0x4211DCC 4 > $DCC_PATH/config
    echo 0x4211DE0 4 > $DCC_PATH/config
    echo 0x4211DF4 4 > $DCC_PATH/config
    echo 0x4211E08 4 > $DCC_PATH/config
    echo 0x4130404 2 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

enable_msmnile_dcc_config_modem
