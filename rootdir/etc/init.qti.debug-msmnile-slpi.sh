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
enable_msmnile_dcc_config_slpi()
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

    echo 0x2B90404 2 > $DCC_PATH/config
    echo 0x2B91C00 2 > $DCC_PATH/config
    echo 0x2B91C10 4 > $DCC_PATH/config
    echo 0x2B91EB0 4 > $DCC_PATH/config
    echo 0x2B92150 4 > $DCC_PATH/config
    echo 0x2B923F0 4 > $DCC_PATH/config
    echo 0x2B92690 4 > $DCC_PATH/config
    echo 0x2B92930 4 > $DCC_PATH/config
    echo 0x2B91C30 4 > $DCC_PATH/config
    echo 0x2B91C44 4 > $DCC_PATH/config
    echo 0x2B91C58 4 > $DCC_PATH/config
    echo 0x2B91C6C 4 > $DCC_PATH/config
    echo 0x2B91C80 4 > $DCC_PATH/config
    echo 0x2B91C94 4 > $DCC_PATH/config
    echo 0x2B91CA8 4 > $DCC_PATH/config
    echo 0x2B91CBC 4 > $DCC_PATH/config
    echo 0x2B91CD0 4 > $DCC_PATH/config
    echo 0x2B91CE4 4 > $DCC_PATH/config
    echo 0x2B91CF8 4 > $DCC_PATH/config
    echo 0x2B91D0C 4 > $DCC_PATH/config
    echo 0x2B91D20 4 > $DCC_PATH/config
    echo 0x2B91D34 4 > $DCC_PATH/config
    echo 0x2B91D48 4 > $DCC_PATH/config
    echo 0x2B91D5C 4 > $DCC_PATH/config
    echo 0x2B91ED0 4 > $DCC_PATH/config
    echo 0x2B91EE4 4 > $DCC_PATH/config
    echo 0x2B91EF8 4 > $DCC_PATH/config
    echo 0x2B91F0C 4 > $DCC_PATH/config
    echo 0x2B91F20 4 > $DCC_PATH/config
    echo 0x2B91F34 4 > $DCC_PATH/config
    echo 0x2B91F48 4 > $DCC_PATH/config
    echo 0x2B91F5C 4 > $DCC_PATH/config
    echo 0x2B91F70 4 > $DCC_PATH/config
    echo 0x2B91F84 4 > $DCC_PATH/config
    echo 0x2B91F98 4 > $DCC_PATH/config
    echo 0x2B91FAC 4 > $DCC_PATH/config
    echo 0x2B91FC0 4 > $DCC_PATH/config
    echo 0x2B91FD4 4 > $DCC_PATH/config
    echo 0x2B91FE8 4 > $DCC_PATH/config
    echo 0x2B91FFC 4 > $DCC_PATH/config
    echo 0x2B92170 4 > $DCC_PATH/config
    echo 0x2B92184 4 > $DCC_PATH/config
    echo 0x2B92198 4 > $DCC_PATH/config
    echo 0x2B921AC 4 > $DCC_PATH/config
    echo 0x2B921C0 4 > $DCC_PATH/config
    echo 0x2B921D4 4 > $DCC_PATH/config
    echo 0x2B921E8 4 > $DCC_PATH/config
    echo 0x2B921FC 4 > $DCC_PATH/config
    echo 0x2B92210 4 > $DCC_PATH/config
    echo 0x2B92224 4 > $DCC_PATH/config
    echo 0x2B92238 4 > $DCC_PATH/config
    echo 0x2B9224C 4 > $DCC_PATH/config
    echo 0x2B92260 4 > $DCC_PATH/config
    echo 0x2B92274 4 > $DCC_PATH/config
    echo 0x2B92288 4 > $DCC_PATH/config
    echo 0x2B9229C 4 > $DCC_PATH/config
    echo 0x2B92410 4 > $DCC_PATH/config
    echo 0x2B92424 4 > $DCC_PATH/config
    echo 0x2B92438 4 > $DCC_PATH/config
    echo 0x2B9244C 4 > $DCC_PATH/config
    echo 0x2B92460 4 > $DCC_PATH/config
    echo 0x2B92474 4 > $DCC_PATH/config
    echo 0x2B92488 4 > $DCC_PATH/config
    echo 0x2B9249C 4 > $DCC_PATH/config
    echo 0x2B924B0 4 > $DCC_PATH/config
    echo 0x2B924C4 4 > $DCC_PATH/config
    echo 0x2B924D8 4 > $DCC_PATH/config
    echo 0x2B924EC 4 > $DCC_PATH/config
    echo 0x2B92500 4 > $DCC_PATH/config
    echo 0x2B92514 4 > $DCC_PATH/config
    echo 0x2B92528 4 > $DCC_PATH/config
    echo 0x2B9253C 4 > $DCC_PATH/config
    echo 0x2B926B0 4 > $DCC_PATH/config
    echo 0x2B926C4 4 > $DCC_PATH/config
    echo 0x2B926D8 4 > $DCC_PATH/config
    echo 0x2B926EC 4 > $DCC_PATH/config
    echo 0x2B92700 4 > $DCC_PATH/config
    echo 0x2B92714 4 > $DCC_PATH/config
    echo 0x2B92728 4 > $DCC_PATH/config
    echo 0x2B9273C 4 > $DCC_PATH/config
    echo 0x2B92750 4 > $DCC_PATH/config
    echo 0x2B92764 4 > $DCC_PATH/config
    echo 0x2B92778 4 > $DCC_PATH/config
    echo 0x2B9278C 4 > $DCC_PATH/config
    echo 0x2B927A0 4 > $DCC_PATH/config
    echo 0x2B927B4 4 > $DCC_PATH/config
    echo 0x2B927C8 4 > $DCC_PATH/config
    echo 0x2B927DC 4 > $DCC_PATH/config
    echo 0x2B92950 4 > $DCC_PATH/config
    echo 0x2B92964 4 > $DCC_PATH/config
    echo 0x2B92978 4 > $DCC_PATH/config
    echo 0x2B9298C 4 > $DCC_PATH/config
    echo 0x2B929A0 4 > $DCC_PATH/config
    echo 0x2B929B4 4 > $DCC_PATH/config
    echo 0x2B929C8 4 > $DCC_PATH/config
    echo 0x2B929DC 4 > $DCC_PATH/config
    echo 0x2B929F0 4 > $DCC_PATH/config
    echo 0x2B92A04 4 > $DCC_PATH/config
    echo 0x2B92A18 4 > $DCC_PATH/config
    echo 0x2B92A2C 4 > $DCC_PATH/config
    echo 0x2B92A40 4 > $DCC_PATH/config
    echo 0x2B92A54 4 > $DCC_PATH/config
    echo 0x2B92A68 4 > $DCC_PATH/config
    echo 0x2B92A7C 4 > $DCC_PATH/config
    echo 0x24B0404 2 > $DCC_PATH/config
    echo  1 > $DCC_PATH/enable
}

enable_msmnile_dcc_config_slpi
