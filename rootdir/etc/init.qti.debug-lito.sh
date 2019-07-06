#!/vendor/bin/sh

#Copyright (c) 2019, The Linux Foundation. All rights reserved.
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

enable_tracing_events_lito()
{
    # timer
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_cancel/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_exit/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_init/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_start/enable
    #enble FTRACE for softirq events
    echo 1 > /sys/kernel/debug/tracing/events/irq/enable
    #enble FTRACE for Workqueue events
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/enable
    # schedular
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_cpu_hotplug/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_migrate_task/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_pi_setprio/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_isolate/enable
    # video
    echo 1 > /sys/kernel/debug/tracing/events/msm_vidc_events/enable
    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_enable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_disable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_frequency/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable
    # power
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/enable
    #scm
    echo 1 > /sys/kernel/debug/tracing/events/scm/enable
    #rmph_send_msg
    echo 1 > /sys/kernel/debug/tracing/events/rpmh/rpmh_send_msg/enable

    #enable aop with timestamps
    # echo 33 0x680000 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    # echo 48 0xC0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    # echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/mcmb_lanes_select
    # echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_mode
    # echo 1 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_trig_ts
    # echo 1 >  /sys/bus/coresight/devices/coresight-tpdm-swao-0/enable_source
    # echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigin
    # echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigout

    #memory pressure events/oom
    echo 1 > /sys/kernel/debug/tracing/events/psi/psi_event/enable
    echo 1 > /sys/kernel/debug/tracing/events/psi/psi_window_vmstat/enable

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_ftrace_event_tracing_lito()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    enable_tracing_events_lito
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events_lito()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/buffer_size
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable_tracing_events_lito
}

config_lito_dcc_ddr()
{
    #DDR -DCC starts here.
    #Start Link list #6
    #LLCC
    echo 0x9220480 1 > $DCC_PATH/config
    echo 0x9232100 1 > $DCC_PATH/config
    echo 0x92360b0 1 > $DCC_PATH/config
    echo 0x9236044 4 > $DCC_PATH/config
    echo 0x923e030 1 > $DCC_PATH/config
    echo 0x9241000 1 > $DCC_PATH/config
    echo 0x9248048 4 > $DCC_PATH/config
    echo 0x9248058 4 > $DCC_PATH/config

    #CABO
    echo 0x9260400 > $DCC_PATH/config
    echo 0x9260410 > $DCC_PATH/config
    echo 0x9260414 > $DCC_PATH/config
    echo 0x9260418 > $DCC_PATH/config
    echo 0x9260420 > $DCC_PATH/config
    echo 0x9260424 > $DCC_PATH/config
    echo 0x9260430 > $DCC_PATH/config
    echo 0x9260440 > $DCC_PATH/config
    echo 0x9260448 > $DCC_PATH/config
    echo 0x92604a0 > $DCC_PATH/config
    echo 0x92604B8 > $DCC_PATH/config
    echo 0x9265804 > $DCC_PATH/config
    echo 0x9266418 > $DCC_PATH/config
    echo 0x92E0400 > $DCC_PATH/config
    echo 0x92e0410 > $DCC_PATH/config
    echo 0x92e0414 > $DCC_PATH/config
    echo 0x92e0418 > $DCC_PATH/config
    echo 0x92e0420 > $DCC_PATH/config
    echo 0x92e0424 > $DCC_PATH/config
    echo 0x92e0430 > $DCC_PATH/config
    echo 0x92e0440 > $DCC_PATH/config
    echo 0x92e0448 > $DCC_PATH/config
    echo 0x92e04a0 > $DCC_PATH/config
    echo 0x92E04B8 > $DCC_PATH/config
    echo 0x92E5804 > $DCC_PATH/config
    echo 0x92E6418 > $DCC_PATH/config

    #LLCC Broadcast
    echo 0x9600000 > $DCC_PATH/config
    echo 0x9600004 > $DCC_PATH/config
    echo 0x9601000 > $DCC_PATH/config
    echo 0x9601004 > $DCC_PATH/config
    echo 0x9602000 > $DCC_PATH/config
    echo 0x9602004 > $DCC_PATH/config
    echo 0x9603000 > $DCC_PATH/config
    echo 0x9603004 > $DCC_PATH/config
    echo 0x9604000 > $DCC_PATH/config
    echo 0x9604004 > $DCC_PATH/config
    echo 0x9605000 > $DCC_PATH/config
    echo 0x9605004 > $DCC_PATH/config
    echo 0x9606000 > $DCC_PATH/config
    echo 0x9606004 > $DCC_PATH/config
    echo 0x9607000 > $DCC_PATH/config
    echo 0x9607004 > $DCC_PATH/config
    echo 0x9608000 > $DCC_PATH/config
    echo 0x9608004 > $DCC_PATH/config
    echo 0x9609000 > $DCC_PATH/config
    echo 0x9609004 > $DCC_PATH/config
    echo 0x960a000 > $DCC_PATH/config
    echo 0x960a004 > $DCC_PATH/config
    echo 0x960b000 > $DCC_PATH/config
    echo 0x960b004 > $DCC_PATH/config
    echo 0x960c000 > $DCC_PATH/config
    echo 0x960c004 > $DCC_PATH/config
    echo 0x960d000 > $DCC_PATH/config
    echo 0x960d004 > $DCC_PATH/config
    echo 0x960e000 > $DCC_PATH/config
    echo 0x960e004 > $DCC_PATH/config
    echo 0x960f000 > $DCC_PATH/config
    echo 0x960f004 > $DCC_PATH/config
    echo 0x9610000 > $DCC_PATH/config
    echo 0x9610004 > $DCC_PATH/config
    echo 0x9611000 > $DCC_PATH/config
    echo 0x9611004 > $DCC_PATH/config
    echo 0x9612000 > $DCC_PATH/config
    echo 0x9612004 > $DCC_PATH/config
    echo 0x9613000 > $DCC_PATH/config
    echo 0x9613004 > $DCC_PATH/config
    echo 0x9614000 > $DCC_PATH/config
    echo 0x9614004 > $DCC_PATH/config
    echo 0x9615000 > $DCC_PATH/config
    echo 0x9615004 > $DCC_PATH/config
    echo 0x9616000 > $DCC_PATH/config
    echo 0x9616004 > $DCC_PATH/config
    echo 0x9617000 > $DCC_PATH/config
    echo 0x9617004 > $DCC_PATH/config
    echo 0x9618000 > $DCC_PATH/config
    echo 0x9618004 > $DCC_PATH/config
    echo 0x9619000 > $DCC_PATH/config
    echo 0x9619004 > $DCC_PATH/config
    echo 0x961a000 > $DCC_PATH/config
    echo 0x961a004 > $DCC_PATH/config
    echo 0x961b000 > $DCC_PATH/config
    echo 0x961b004 > $DCC_PATH/config
    echo 0x961c000 > $DCC_PATH/config
    echo 0x961c004 > $DCC_PATH/config
    echo 0x961d000 > $DCC_PATH/config
    echo 0x961d004 > $DCC_PATH/config
    echo 0x961e000 > $DCC_PATH/config
    echo 0x961e004 > $DCC_PATH/config
    echo 0x961f000 > $DCC_PATH/config
    echo 0x961f004 > $DCC_PATH/config

    #SHRM / MCCC
    echo 0x9050008 > $DCC_PATH/config
    echo 0x9050068 > $DCC_PATH/config
    echo 0x9050078 > $DCC_PATH/config
    echo 0x90b0280 > $DCC_PATH/config
    echo 0x90b0288 > $DCC_PATH/config
    echo 0x90b028c > $DCC_PATH/config
    echo 0x90b0290 > $DCC_PATH/config
    echo 0x90b0294 > $DCC_PATH/config
    echo 0x90b0298 > $DCC_PATH/config
    echo 0x90b029c > $DCC_PATH/config
    echo 0x90b02a0 > $DCC_PATH/config

    #LLCC1
    echo 0x92a0480 > $DCC_PATH/config
    echo 0x92b2100 > $DCC_PATH/config
    echo 0x92b6044 > $DCC_PATH/config
    echo 0x92b6048 > $DCC_PATH/config
    echo 0x92b604c > $DCC_PATH/config
    echo 0x92b6050 > $DCC_PATH/config
    echo 0x92b60b0 > $DCC_PATH/config
    echo 0x92be030 > $DCC_PATH/config
    echo 0x92c1000 > $DCC_PATH/config
    echo 0x92C8048 4 > $DCC_PATH/config
    echo 0x92c8058 > $DCC_PATH/config
    echo 0x92c805c > $DCC_PATH/config
    echo 0x92c8060 > $DCC_PATH/config
    echo 0x92c8064 > $DCC_PATH/config
   #End Link list #6
}
config_lito_dcc_gemnoc()
{
    #GemNOC for lito start
    echo 0x9680000 > $DCC_PATH/config
    echo 0x9680004 > $DCC_PATH/config
    echo 8 > $DCC_PATH/loop
    echo 0x9681000 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 0x9681004 13> $DCC_PATH/config
    echo 0x968103C > $DCC_PATH/config
    echo 0x9698100 > $DCC_PATH/config
    echo 0x9698104 > $DCC_PATH/config
    echo 0x9698108 > $DCC_PATH/config
    echo 0x9698110 > $DCC_PATH/config
    echo 0x9698120 > $DCC_PATH/config
    echo 0x9698124 > $DCC_PATH/config
    echo 0x9698128 > $DCC_PATH/config
    echo 0x969812c > $DCC_PATH/config
    echo 0x9698130 > $DCC_PATH/config
    echo 0x9698134 > $DCC_PATH/config
    echo 0x9698138 > $DCC_PATH/config
    echo 0x969813c > $DCC_PATH/config
    #GemNOC for lito end
}
config_lito_dcc_lpm()
{
    #PCU Register
    echo 0x18000024 > $DCC_PATH/config
    echo 0x18000040 > $DCC_PATH/config
    echo 0x18010024 > $DCC_PATH/config
    echo 0x18010040 > $DCC_PATH/config
    echo 0x18020024 > $DCC_PATH/config
    echo 0x18020040 > $DCC_PATH/config
    echo 0x18030024 > $DCC_PATH/config
    echo 0x18030040 > $DCC_PATH/config
    echo 0x18040024 > $DCC_PATH/config
    echo 0x18040040 > $DCC_PATH/config
    echo 0x18050024 > $DCC_PATH/config
    echo 0x18050040 > $DCC_PATH/config
    echo 0x18060024 > $DCC_PATH/config
    echo 0x18060040 > $DCC_PATH/config
    echo 0x18070024 > $DCC_PATH/config
    echo 0x18070040 > $DCC_PATH/config
    echo 0x18080024 > $DCC_PATH/config
    echo 0x18080040 > $DCC_PATH/config
    echo 0x18080044 > $DCC_PATH/config
    echo 0x18080048 > $DCC_PATH/config
    echo 0x1808004c > $DCC_PATH/config
    echo 0x18080054 > $DCC_PATH/config
    echo 0x1808006c > $DCC_PATH/config
    echo 0x18080070 > $DCC_PATH/config
    echo 0x18080074 > $DCC_PATH/config
    echo 0x18080078 > $DCC_PATH/config
    echo 0x1808007c > $DCC_PATH/config
    echo 0x180800f4 > $DCC_PATH/config
    echo 0x180800f8 > $DCC_PATH/config
    echo 0x18080104 > $DCC_PATH/config
    echo 0x18080118 > $DCC_PATH/config
    echo 0x1808011c > $DCC_PATH/config
    echo 0x18080128 > $DCC_PATH/config
    echo 0x1808012c > $DCC_PATH/config
    echo 0x18080130 > $DCC_PATH/config
    echo 0x18080134 > $DCC_PATH/config
    echo 0x18080138 > $DCC_PATH/config
    echo 0x18080158 > $DCC_PATH/config
    echo 0x1808015c > $DCC_PATH/config
    echo 0x18080168 > $DCC_PATH/config
    echo 0x18080170 > $DCC_PATH/config
    echo 0x18080174 > $DCC_PATH/config
    echo 0x18080188 > $DCC_PATH/config
    echo 0x1808018c > $DCC_PATH/config
    echo 0x18080198 > $DCC_PATH/config
    echo 0x180801ac > $DCC_PATH/config
    echo 0x180801b0 > $DCC_PATH/config
    echo 0x180801b4 > $DCC_PATH/config
    echo 0x180801b8 > $DCC_PATH/config
    echo 0x180801bc > $DCC_PATH/config
    echo 0x180801f0 > $DCC_PATH/config
    echo 0x18280000 > $DCC_PATH/config
    echo 0x18282000 > $DCC_PATH/config
    echo 0x18284000 > $DCC_PATH/config
    echo 0x18286000 > $DCC_PATH/config
}

config_lito_dcc_osm()
{
    #APSS_OSM_RAIN0/RAIL1
    echo 0x1832102c > $DCC_PATH/config
    echo 0x18321044 > $DCC_PATH/config
    echo 0x18321700 > $DCC_PATH/config
    echo 0x18321710 > $DCC_PATH/config
    echo 0x1832176c > $DCC_PATH/config
    echo 0x18321818 > $DCC_PATH/config
    echo 0x18321920 > $DCC_PATH/config
    echo 0x18322c18 > $DCC_PATH/config
    echo 0x1832302c > $DCC_PATH/config
    echo 0x18323044 > $DCC_PATH/config
    echo 0x18323700 > $DCC_PATH/config
    echo 0x18323710 > $DCC_PATH/config
    echo 0x1832376c > $DCC_PATH/config
    echo 0x18323818 > $DCC_PATH/config
    echo 0x18323920 > $DCC_PATH/config
    echo 0x18324c18 > $DCC_PATH/config
    echo 0x1832582c > $DCC_PATH/config
    echo 0x18325844 > $DCC_PATH/config
    echo 0x18325f00 > $DCC_PATH/config
    echo 0x18325f10 > $DCC_PATH/config
    echo 0x18325f6c > $DCC_PATH/config
    echo 0x18326018 > $DCC_PATH/config
    echo 0x18326120 > $DCC_PATH/config
    echo 0x18327418 > $DCC_PATH/config
    echo 0x1832782c > $DCC_PATH/config
    echo 0x18327844 > $DCC_PATH/config
    echo 0x18327f00 > $DCC_PATH/config
    echo 0x18327f10 > $DCC_PATH/config
    echo 0x18327f6c > $DCC_PATH/config
    echo 0x18328018 > $DCC_PATH/config
    echo 0x18328120 > $DCC_PATH/config
    echo 0x18329418 > $DCC_PATH/config
}

config_lito_dcc_core()
{
    # core hang
    echo 0x1800005C 1 > $DCC_PATH/config
    echo 0x1801005C 1 > $DCC_PATH/config
    echo 0x1802005C 1 > $DCC_PATH/config
    echo 0x1803005C 1 > $DCC_PATH/config
    echo 0x1804005C 1 > $DCC_PATH/config
    echo 0x1805005C 1 > $DCC_PATH/config
    echo 0x1806005C 1 > $DCC_PATH/config
    echo 0x1807005C 1 > $DCC_PATH/config
    #CPRh
    echo 0x18101908 1 > $DCC_PATH/config
    echo 0x18101C18 1 > $DCC_PATH/config
    echo 0x18390810 1 > $DCC_PATH/config
    echo 0x18390C50 1 > $DCC_PATH/config
    echo 0x18390814 1 > $DCC_PATH/config
    echo 0x18390C54 1 > $DCC_PATH/config
    echo 0x18390818 1 > $DCC_PATH/config
    echo 0x18390C58 1 > $DCC_PATH/config
    echo 0x18393A84 2 > $DCC_PATH/config
    echo 0x18100908 1 > $DCC_PATH/config
    echo 0x18100C18 1 > $DCC_PATH/config
    echo 0x183A0810 1 > $DCC_PATH/config
    echo 0x183A0C50 1 > $DCC_PATH/config
    echo 0x183A0814 1 > $DCC_PATH/config
    echo 0x183A0C54 1 > $DCC_PATH/config
    echo 0x183A0818 1 > $DCC_PATH/config
    echo 0x183A0C58 1 > $DCC_PATH/config
    echo 0x183A3A84 2 > $DCC_PATH/config
    echo 0x18393500 1 > $DCC_PATH/config
    echo 0x18393580 1 > $DCC_PATH/config
    echo 0x183A3500 1 > $DCC_PATH/config
    echo 0x183A3580 1 > $DCC_PATH/config

    #Silver / L3 / Gold+ PLL
    echo 0x18280000 4 > $DCC_PATH/config
    echo 0x18284000 4 > $DCC_PATH/config
    echo 0x18286000 4 > $DCC_PATH/config

    #Gold PLL
    echo 0x18282000 4 > $DCC_PATH/config
    echo 0x18282028 1 > $DCC_PATH/config
    echo 0x18282038 1 > $DCC_PATH/config
    echo 0x18282080 5 > $DCC_PATH/config
    echo 0x18286000 4 > $DCC_PATH/config
    echo 0x18286028 1 > $DCC_PATH/config
    echo 0x18286038 1 > $DCC_PATH/config
    echo 0x18286080 5 > $DCC_PATH/config
    #rpmh
    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config
    echo 0x18300000 1 > $DCC_PATH/config

    #GOLD
    echo 0x1829208C 1 > $DCC_PATH/config
    echo 0x1829209C 0x78 > $DCC_PATH/config_write
    echo 0x1829209C 0x0  > $DCC_PATH/config_write
    echo 0x18292048 0x1  > $DCC_PATH/config_write
    echo 0x18292090 0x0  > $DCC_PATH/config_write
    echo 0x18292090 0x25 > $DCC_PATH/config_write
    echo 0x18292098 1 > $DCC_PATH/config
    echo 0x18292048 0x1D > $DCC_PATH/config_write
    echo 0x18292090 0x0  > $DCC_PATH/config_write
    echo 0x18292090 0x25 > $DCC_PATH/config_write
    echo 0x18292098 1 > $DCC_PATH/config

    #GOLD+
    echo 0x1829608C 1 > $DCC_PATH/config
    echo 0x1829609C 0x78 > $DCC_PATH/config_write
    echo 0x1829609C 0x0  > $DCC_PATH/config_write
    echo 0x18296048 0x1  > $DCC_PATH/config_write
    echo 0x18296090 0x0  > $DCC_PATH/config_write
    echo 0x18296090 0x25 > $DCC_PATH/config_write
    echo 0x18296098 1 > $DCC_PATH/config
    echo 0x18296048 0x1D > $DCC_PATH/config_write
    echo 0x18296090 0x0  > $DCC_PATH/config_write
    echo 0x18296090 0x25 > $DCC_PATH/config_write
}
config_lito_dcc_rsc_tcs()
{
    #APPS RSC TCS
    echo 0x18200d1c > $DCC_PATH/config
    echo 0x18200d34 > $DCC_PATH/config
    echo 0x18200d38 > $DCC_PATH/config
    echo 0x18200d3c > $DCC_PATH/config
    echo 0x18200d48 > $DCC_PATH/config
    echo 0x18200d4c > $DCC_PATH/config
    echo 0x18200d50 > $DCC_PATH/config
    echo 0x18200d5c > $DCC_PATH/config
    echo 0x18200d60 > $DCC_PATH/config
    echo 0x18200d64 > $DCC_PATH/config
    echo 0x18200d70 > $DCC_PATH/config
    echo 0x18200d74 > $DCC_PATH/config
    echo 0x18200d78 > $DCC_PATH/config
    echo 0x18200fbc > $DCC_PATH/config
    echo 0x1820125c > $DCC_PATH/config
    echo 0x182014fc > $DCC_PATH/config
    echo 0x1822000c > $DCC_PATH/config
    echo 0x18220d00 > $DCC_PATH/config
    echo 0x18220d04 > $DCC_PATH/config
    echo 0x18220d14 > $DCC_PATH/config
    echo 0x18220d18 > $DCC_PATH/config
    echo 0x18220d1c > $DCC_PATH/config
    echo 0x18220fb4 > $DCC_PATH/config
    echo 0x18220fb8 > $DCC_PATH/config
    echo 0x18220fbc > $DCC_PATH/config
    echo 0x18221254 > $DCC_PATH/config
    echo 0x18221258 > $DCC_PATH/config
    echo 0x1822125c > $DCC_PATH/config
    echo 0x18221274 > $DCC_PATH/config
    echo 0x18221278 > $DCC_PATH/config
    echo 0x18221288 > $DCC_PATH/config
    echo 0x1822128c > $DCC_PATH/config
    echo 0x1822129c > $DCC_PATH/config
    echo 0x182212a0 > $DCC_PATH/config
    echo 0x182212b0 > $DCC_PATH/config
    echo 0x182212b4 > $DCC_PATH/config
    echo 0x182212c4 > $DCC_PATH/config
    echo 0x182212c8 > $DCC_PATH/config
    echo 0x182212d8 > $DCC_PATH/config
    echo 0x182212dc > $DCC_PATH/config
    echo 0x182212ec > $DCC_PATH/config
    echo 0x182212f0 > $DCC_PATH/config
    echo 0x18221300 > $DCC_PATH/config
    echo 0x18221304 > $DCC_PATH/config
    echo 0x18221314 > $DCC_PATH/config
    echo 0x18221318 > $DCC_PATH/config
    echo 0x18221328 > $DCC_PATH/config
    echo 0x1822132c > $DCC_PATH/config
    echo 0x1822133c > $DCC_PATH/config
    echo 0x18221340 > $DCC_PATH/config
    echo 0x18221350 > $DCC_PATH/config
    echo 0x18221354 > $DCC_PATH/config
    echo 0x18221364 > $DCC_PATH/config
    echo 0x18221368 > $DCC_PATH/config
    echo 0x18221378 > $DCC_PATH/config
    echo 0x1822137c > $DCC_PATH/config
    echo 0x1822138c > $DCC_PATH/config
    echo 0x18221390 > $DCC_PATH/config
    echo 0x182213a0 > $DCC_PATH/config
    echo 0x182213a4 > $DCC_PATH/config
    echo 0x182214f4 > $DCC_PATH/config
    echo 0x182214f8 > $DCC_PATH/config
    echo 0x182214fc > $DCC_PATH/config
    echo 0x18221514 > $DCC_PATH/config
    echo 0x18221518 > $DCC_PATH/config
    echo 0x18221528 > $DCC_PATH/config
    echo 0x1822152c > $DCC_PATH/config
    echo 0x1822153c > $DCC_PATH/config
    echo 0x18221540 > $DCC_PATH/config
    echo 0x18221550 > $DCC_PATH/config
    echo 0x18221554 > $DCC_PATH/config
    echo 0x18221564 > $DCC_PATH/config
    echo 0x18221568 > $DCC_PATH/config
    echo 0x18221578 > $DCC_PATH/config
    echo 0x1822157c > $DCC_PATH/config
    echo 0x1822158c > $DCC_PATH/config
    echo 0x18221590 > $DCC_PATH/config
    echo 0x182215a0 > $DCC_PATH/config
    echo 0x182215a4 > $DCC_PATH/config
    echo 0x182215b4 > $DCC_PATH/config
    echo 0x182215b8 > $DCC_PATH/config
    echo 0x182215c8 > $DCC_PATH/config
    echo 0x182215cc > $DCC_PATH/config
    echo 0x182215dc > $DCC_PATH/config
    echo 0x182215e0 > $DCC_PATH/config
    echo 0x182215f0 > $DCC_PATH/config
    echo 0x182215f4 > $DCC_PATH/config
    echo 0x18221604 > $DCC_PATH/config
    echo 0x18221608 > $DCC_PATH/config
    echo 0x18221618 > $DCC_PATH/config
    echo 0x1822161c > $DCC_PATH/config
    echo 0x1822162c > $DCC_PATH/config
    echo 0x18221630 > $DCC_PATH/config
    echo 0x18221640 > $DCC_PATH/config
    echo 0x18221644 > $DCC_PATH/config
    echo 0x18221794 > $DCC_PATH/config
    echo 0x18221798 > $DCC_PATH/config
    echo 0x1822179c > $DCC_PATH/config
    echo 0x182217b4 > $DCC_PATH/config
    echo 0x182217b8 > $DCC_PATH/config
    echo 0x182217c8 > $DCC_PATH/config
    echo 0x182217cc > $DCC_PATH/config
    echo 0x182217dc > $DCC_PATH/config
    echo 0x182217e0 > $DCC_PATH/config
    echo 0x182217f0 > $DCC_PATH/config
    echo 0x182217f4 > $DCC_PATH/config
    echo 0x18221804 > $DCC_PATH/config
    echo 0x18221808 > $DCC_PATH/config
    echo 0x18221818 > $DCC_PATH/config
    echo 0x1822181c > $DCC_PATH/config
    echo 0x1822182c > $DCC_PATH/config
    echo 0x18221830 > $DCC_PATH/config
    echo 0x18221840 > $DCC_PATH/config
    echo 0x18221844 > $DCC_PATH/config
    echo 0x18221854 > $DCC_PATH/config
    echo 0x18221858 > $DCC_PATH/config
    echo 0x18221868 > $DCC_PATH/config
    echo 0x1822186c > $DCC_PATH/config
    echo 0x1822187c > $DCC_PATH/config
    echo 0x18221880 > $DCC_PATH/config
    echo 0x18221890 > $DCC_PATH/config
    echo 0x18221894 > $DCC_PATH/config
    echo 0x182218a4 > $DCC_PATH/config
    echo 0x182218a8 > $DCC_PATH/config
    echo 0x182218b8 > $DCC_PATH/config
    echo 0x182218bc > $DCC_PATH/config
    echo 0x182218cc > $DCC_PATH/config
    echo 0x182218d0 > $DCC_PATH/config
    echo 0x182218e0 > $DCC_PATH/config
    echo 0x182218e4 > $DCC_PATH/config
    echo 0x18221a34 > $DCC_PATH/config
    echo 0x18221a38 > $DCC_PATH/config
    echo 0x18221a3c > $DCC_PATH/config
    echo 0x18221a54 > $DCC_PATH/config
    echo 0x18221a58 > $DCC_PATH/config
    echo 0x18221a68 > $DCC_PATH/config
    echo 0x18221a6c > $DCC_PATH/config
    echo 0x18221a7c > $DCC_PATH/config
    echo 0x18221a80 > $DCC_PATH/config
    echo 0x18221a90 > $DCC_PATH/config
    echo 0x18221a94 > $DCC_PATH/config
    echo 0x18221aa4 > $DCC_PATH/config
    echo 0x18221aa8 > $DCC_PATH/config
    echo 0x18221ab8 > $DCC_PATH/config
    echo 0x18221abc > $DCC_PATH/config
    echo 0x18221acc > $DCC_PATH/config
    echo 0x18221ad0 > $DCC_PATH/config
    echo 0x18221ae0 > $DCC_PATH/config
    echo 0x18221ae4 > $DCC_PATH/config
    echo 0x18221af4 > $DCC_PATH/config
    echo 0x18221af8 > $DCC_PATH/config
    echo 0x18221b08 > $DCC_PATH/config
    echo 0x18221b0c > $DCC_PATH/config
    echo 0x18221b1c > $DCC_PATH/config
    echo 0x18221b20 > $DCC_PATH/config
    echo 0x18221b30 > $DCC_PATH/config
    echo 0x18221b34 > $DCC_PATH/config
    echo 0x18221b44 > $DCC_PATH/config
    echo 0x18221b48 > $DCC_PATH/config
    echo 0x18221b58 > $DCC_PATH/config
    echo 0x18221b5c > $DCC_PATH/config
    echo 0x18221b6c > $DCC_PATH/config
    echo 0x18221b70 > $DCC_PATH/config
    echo 0x18221b80 > $DCC_PATH/config
    echo 0x18221b84 > $DCC_PATH/config
    echo 0x18221cd4 > $DCC_PATH/config
    echo 0x18221cd8 > $DCC_PATH/config
    echo 0x18221cdc > $DCC_PATH/config
    echo 0x18221cf4 > $DCC_PATH/config
    echo 0x18221cf8 > $DCC_PATH/config
    echo 0x18221d08 > $DCC_PATH/config
    echo 0x18221d0c > $DCC_PATH/config
    echo 0x18221d1c > $DCC_PATH/config
    echo 0x18221d20 > $DCC_PATH/config
    echo 0x18221d30 > $DCC_PATH/config
    echo 0x18221d34 > $DCC_PATH/config
    echo 0x18221d44 > $DCC_PATH/config
    echo 0x18221d48 > $DCC_PATH/config
    echo 0x18221d58 > $DCC_PATH/config
    echo 0x18221d5c > $DCC_PATH/config
    echo 0x18221d6c > $DCC_PATH/config
    echo 0x18221d70 > $DCC_PATH/config
    echo 0x18221d80 > $DCC_PATH/config
    echo 0x18221d84 > $DCC_PATH/config
    echo 0x18221d94 > $DCC_PATH/config
    echo 0x18221d98 > $DCC_PATH/config
    echo 0x18221da8 > $DCC_PATH/config
    echo 0x18221dac > $DCC_PATH/config
    echo 0x18221dbc > $DCC_PATH/config
    echo 0x18221dc0 > $DCC_PATH/config
    echo 0x18221dd0 > $DCC_PATH/config
    echo 0x18221dd4 > $DCC_PATH/config
    echo 0x18221de4 > $DCC_PATH/config
    echo 0x18221de8 > $DCC_PATH/config
    echo 0x18221df8 > $DCC_PATH/config
    echo 0x18221dfc > $DCC_PATH/config
    echo 0x18221e0c > $DCC_PATH/config
    echo 0x18221e10 > $DCC_PATH/config
    echo 0x18221e20 > $DCC_PATH/config
    echo 0x18221e24 > $DCC_PATH/config
    echo 0x18221f74 > $DCC_PATH/config
    echo 0x18221f78 > $DCC_PATH/config
    echo 0x18221f7c > $DCC_PATH/config
    echo 0x18221f94 > $DCC_PATH/config
    echo 0x18221f98 > $DCC_PATH/config
    echo 0x18221fa8 > $DCC_PATH/config
    echo 0x18221fac > $DCC_PATH/config
    echo 0x18221fbc > $DCC_PATH/config
    echo 0x18221fc0 > $DCC_PATH/config
    echo 0x18221fd0 > $DCC_PATH/config
    echo 0x18221fd4 > $DCC_PATH/config
    echo 0x18221fe4 > $DCC_PATH/config
    echo 0x18221fe8 > $DCC_PATH/config
    echo 0x18221ff8 > $DCC_PATH/config
    echo 0x18221ffc > $DCC_PATH/config
    echo 0x1822200c > $DCC_PATH/config
    echo 0x18222010 > $DCC_PATH/config
    echo 0x18222020 > $DCC_PATH/config
    echo 0x18222024 > $DCC_PATH/config
    echo 0x18222034 > $DCC_PATH/config
    echo 0x18222038 > $DCC_PATH/config
    echo 0x18222048 > $DCC_PATH/config
    echo 0x1822204c > $DCC_PATH/config
    echo 0x1822205c > $DCC_PATH/config
    echo 0x18222060 > $DCC_PATH/config
    echo 0x18222070 > $DCC_PATH/config
    echo 0x18222074 > $DCC_PATH/config
    echo 0x18222084 > $DCC_PATH/config
    echo 0x18222088 > $DCC_PATH/config
    echo 0x18222098 > $DCC_PATH/config
    echo 0x1822209c > $DCC_PATH/config
    echo 0x182220ac > $DCC_PATH/config
    echo 0x182220b0 > $DCC_PATH/config
    echo 0x182220c0 > $DCC_PATH/config
    echo 0x182220c4 > $DCC_PATH/config

    #APPS RSC
    echo 0x18200010 > $DCC_PATH/config
    echo 0x18200030 > $DCC_PATH/config
    echo 0x18200038 > $DCC_PATH/config
    echo 0x18200040 > $DCC_PATH/config
    echo 0x18200048 > $DCC_PATH/config
    echo 0x18200400 > $DCC_PATH/config
    echo 0x18200404 > $DCC_PATH/config
    echo 0x18200408 > $DCC_PATH/config
    echo 0x18220038 > $DCC_PATH/config
    echo 0x18220040 > $DCC_PATH/config
    echo 0x182200d0 > $DCC_PATH/config
    echo 0x18230408 > $DCC_PATH/config

    #RPMH PDC
    echo 0xb201020 > $DCC_PATH/config
    echo 0xb201024 > $DCC_PATH/config
    echo 0xb20103c > $DCC_PATH/config
    echo 0xb204510 > $DCC_PATH/config
    echo 0xb204514 > $DCC_PATH/config
    echo 0xb204520 > $DCC_PATH/config
    echo 0xb231020 > $DCC_PATH/config
    echo 0xb231024 > $DCC_PATH/config

    #NPU RSC
    # echo 0x98b0010 > $DCC_PATH/config
    # echo 0x98b0014 > $DCC_PATH/config
    # echo 0x98b0018 > $DCC_PATH/config
    # echo 0x98b0208 > $DCC_PATH/config
    # echo 0x98b020c > $DCC_PATH/config
    # echo 0x98b0210 > $DCC_PATH/config
    # echo 0x98b0228 > $DCC_PATH/config
    # echo 0x98b022c > $DCC_PATH/config
    # echo 0x98b0230 > $DCC_PATH/config
    # echo 0x98b0248 > $DCC_PATH/config
    # echo 0x98b024c > $DCC_PATH/config
    # echo 0x98b0250 > $DCC_PATH/config
    # echo 0x98b0268 > $DCC_PATH/config
    # echo 0x98b026c > $DCC_PATH/config
    # echo 0x98b0270 > $DCC_PATH/config
    # echo 0x98b0288 > $DCC_PATH/config
    # echo 0x98b028c > $DCC_PATH/config
    # echo 0x98b0290 > $DCC_PATH/config
    # echo 0x98b02a8 > $DCC_PATH/config
    # echo 0x98b02ac > $DCC_PATH/config
    # echo 0x98b02b0 > $DCC_PATH/config
    # echo 0x98b0400 > $DCC_PATH/config
    # echo 0x98b0404 > $DCC_PATH/config
    # echo 0x98b0408 > $DCC_PATH/config

    # echo 0x9800044 > $DCC_PATH/config
    # echo 0x9800468 > $DCC_PATH/config
    # echo 0x9802028 > $DCC_PATH/config
    # echo 0x9890380 32 > $DCC_PATH/config

    #CDSP RSCp
    echo 0x80a4010 > $DCC_PATH/config
    echo 0x80a4014 > $DCC_PATH/config
    echo 0x80a4018 > $DCC_PATH/config
    echo 0x80a4030 > $DCC_PATH/config
    echo 0x80a4038 > $DCC_PATH/config
    echo 0x80a4040 > $DCC_PATH/config
    echo 0x80a4048 > $DCC_PATH/config
    echo 0x80a40d0 > $DCC_PATH/config
    echo 0x80a4208 > $DCC_PATH/config
    echo 0x80a420c > $DCC_PATH/config
    echo 0x80a4210 > $DCC_PATH/config
    echo 0x80a4228 > $DCC_PATH/config
    echo 0x80a422c > $DCC_PATH/config
    echo 0x80a4230 > $DCC_PATH/config
    echo 0x80a4248 > $DCC_PATH/config
    echo 0x80a424c > $DCC_PATH/config
    echo 0x80a4250 > $DCC_PATH/config
    echo 0x80a4268 > $DCC_PATH/config
    echo 0x80a426c > $DCC_PATH/config
    echo 0x80a4270 > $DCC_PATH/config
    echo 0x80a4288 > $DCC_PATH/config
    echo 0x80a428c > $DCC_PATH/config
    echo 0x80a4290 > $DCC_PATH/config
    echo 0x80a42a8 > $DCC_PATH/config
    echo 0x80a42ac > $DCC_PATH/config
    echo 0x80a42b0 > $DCC_PATH/config
    echo 0x80a4400 > $DCC_PATH/config
    echo 0x80a4404 > $DCC_PATH/config
    echo 0x80a4408 > $DCC_PATH/config
    echo 0x80a4d04 > $DCC_PATH/config

    #QDSP6 RSC
    echo 0x83b0010 > $DCC_PATH/config
    echo 0x83b0014 > $DCC_PATH/config
    echo 0x83b0018 > $DCC_PATH/config
    echo 0x83b0208 > $DCC_PATH/config
    echo 0x83b020c > $DCC_PATH/config
    echo 0x83b0210 > $DCC_PATH/config
    echo 0x83b0228 > $DCC_PATH/config
    echo 0x83b022c > $DCC_PATH/config
    echo 0x83b0230 > $DCC_PATH/config
    echo 0x83b0248 > $DCC_PATH/config
    echo 0x83b024c > $DCC_PATH/config
    echo 0x83b0250 > $DCC_PATH/config
    echo 0x83b0268 > $DCC_PATH/config
    echo 0x83b026c > $DCC_PATH/config
    echo 0x83b0270 > $DCC_PATH/config
    echo 0x83b0288 > $DCC_PATH/config
    echo 0x83b028c > $DCC_PATH/config
    echo 0x83b0290 > $DCC_PATH/config
    echo 0x83b02a8 > $DCC_PATH/config
    echo 0x83b02ac > $DCC_PATH/config
    echo 0x83b02b0 > $DCC_PATH/config
    echo 0x83b0400 > $DCC_PATH/config
    echo 0x83b0404 > $DCC_PATH/config
    echo 0x83b0408 > $DCC_PATH/config

    #CDSP PDC
    echo 0xb2b0010 > $DCC_PATH/config
    # echo 0xb2b0014 > $DCC_PATH/config
    echo 0xb2b0900 > $DCC_PATH/config
    # echo 0xb2b0904 > $DCC_PATH/config
    echo 0xb2b1020 > $DCC_PATH/config
    echo 0xb2b1024 > $DCC_PATH/config
    echo 0xb2b1030 > $DCC_PATH/config
    echo 0xb2b103c > $DCC_PATH/config
    echo 0xb2b1200 > $DCC_PATH/config
    echo 0xb2b1204 > $DCC_PATH/config
    echo 0xb2b1208 > $DCC_PATH/config
    echo 0xb2b1214 > $DCC_PATH/config
    echo 0xb2b1218 > $DCC_PATH/config
    echo 0xb2b121c > $DCC_PATH/config
    echo 0xb2b1228 > $DCC_PATH/config
    echo 0xb2b122c > $DCC_PATH/config
    echo 0xb2b1230 > $DCC_PATH/config
    echo 0xb2b123c > $DCC_PATH/config
    echo 0xb2b1240 > $DCC_PATH/config
    echo 0xb2b1244 > $DCC_PATH/config
    echo 0xb2b1250 > $DCC_PATH/config
    echo 0xb2b1254 > $DCC_PATH/config
    echo 0xb2b1258 > $DCC_PATH/config
    echo 0xb2b4510 > $DCC_PATH/config
    echo 0xb2b4514 > $DCC_PATH/config
    echo 0xb2b4520 > $DCC_PATH/config

    #QDSP6 General
    echo 0x8300044 > $DCC_PATH/config
    echo 0x8300468 > $DCC_PATH/config
    echo 0x8302000 > $DCC_PATH/config
    echo 0x8302028 > $DCC_PATH/config
    echo 0x8390380 32 > $DCC_PATH/config
}

config_lito_dcc_lpass_rsc(){
    #LPASS RSC
    echo 0x3500010 > $DCC_PATH/config
    echo 0x3500014 > $DCC_PATH/config
    echo 0x3500018 > $DCC_PATH/config
    echo 0x3500030 > $DCC_PATH/config
    echo 0x3500038 > $DCC_PATH/config
    echo 0x3500040 > $DCC_PATH/config
    echo 0x3500048 > $DCC_PATH/config
    echo 0x35000d0 > $DCC_PATH/config
    echo 0x3500208 > $DCC_PATH/config
    echo 0x350020c > $DCC_PATH/config
    echo 0x3500210 > $DCC_PATH/config
    echo 0x3500228 > $DCC_PATH/config
    echo 0x350022c > $DCC_PATH/config
    echo 0x3500230 > $DCC_PATH/config
    echo 0x3500248 > $DCC_PATH/config
    echo 0x350024c > $DCC_PATH/config
    echo 0x3500250 > $DCC_PATH/config
    echo 0x3500268 > $DCC_PATH/config
    echo 0x350026c > $DCC_PATH/config
    echo 0x3500270 > $DCC_PATH/config
    echo 0x3500288 > $DCC_PATH/config
    echo 0x350028c > $DCC_PATH/config
    echo 0x3500290 > $DCC_PATH/config
    echo 0x35002a8 > $DCC_PATH/config
    echo 0x35002ac > $DCC_PATH/config
    echo 0x35002b0 > $DCC_PATH/config
    echo 0x3500400 > $DCC_PATH/config
    echo 0x3500404 > $DCC_PATH/config
    echo 0x3500408 > $DCC_PATH/config
    echo 0x3500d04 > $DCC_PATH/config

    #LPASS RSCc
    echo 0x30b0010 > $DCC_PATH/config
    echo 0x30b0014 > $DCC_PATH/config
    echo 0x30b0018 > $DCC_PATH/config
    echo 0x30b0208 > $DCC_PATH/config
    echo 0x30b020c > $DCC_PATH/config
    echo 0x30b0210 > $DCC_PATH/config
    echo 0x30b0228 > $DCC_PATH/config
    echo 0x30b022c > $DCC_PATH/config
    echo 0x30b0230 > $DCC_PATH/config
    echo 0x30b0248 > $DCC_PATH/config
    echo 0x30b024c > $DCC_PATH/config
    echo 0x30b0250 > $DCC_PATH/config
    echo 0x30b0268 > $DCC_PATH/config
    echo 0x30b026c > $DCC_PATH/config
    echo 0x30b0270 > $DCC_PATH/config
    echo 0x30b0288 > $DCC_PATH/config
    echo 0x30b028c > $DCC_PATH/config
    echo 0x30b0290 > $DCC_PATH/config
    echo 0x30b02a8 > $DCC_PATH/config
    echo 0x30b02ac > $DCC_PATH/config
    echo 0x30b02b0 > $DCC_PATH/config
    echo 0x30b0400 > $DCC_PATH/config
    echo 0x30b0404 > $DCC_PATH/config
    echo 0x30b0408 > $DCC_PATH/config

    #Audio PDC
    echo 0xb250010 > $DCC_PATH/config
    echo 0xb250014 > $DCC_PATH/config
    echo 0xb250900 > $DCC_PATH/config
    echo 0xb250904 > $DCC_PATH/config
    echo 0xb251020 > $DCC_PATH/config
    echo 0xb251024 > $DCC_PATH/config
    echo 0xb251030 > $DCC_PATH/config
    echo 0xb25103c > $DCC_PATH/config
    echo 0xb251200 > $DCC_PATH/config
    echo 0xb251204 > $DCC_PATH/config
    echo 0xb251208 > $DCC_PATH/config
    echo 0xb251214 > $DCC_PATH/config
    echo 0xb251218 > $DCC_PATH/config
    echo 0xb25121c > $DCC_PATH/config
    echo 0xb251228 > $DCC_PATH/config
    echo 0xb25122c > $DCC_PATH/config
    echo 0xb251230 > $DCC_PATH/config
    echo 0xb25123c > $DCC_PATH/config
    echo 0xb251240 > $DCC_PATH/config
    echo 0xb251244 > $DCC_PATH/config
    echo 0xb251250 > $DCC_PATH/config
    echo 0xb251254 > $DCC_PATH/config
    echo 0xb251258 > $DCC_PATH/config
    echo 0xb254510 > $DCC_PATH/config
    echo 0xb254514 > $DCC_PATH/config
    echo 0xb254520 > $DCC_PATH/config

    #LPASS General
    echo 0x3000044 > $DCC_PATH/config
    echo 0x3000468 > $DCC_PATH/config
    echo 0x3002000 > $DCC_PATH/config
    echo 0x3002004 > $DCC_PATH/config
    echo 0x3002028 > $DCC_PATH/config
    echo 0x3090380 32 > $DCC_PATH/config
}

config_lito_dcc_mss_rsc(){
    #MSS RSCp
    echo 0x4200010 > $DCC_PATH/config
    echo 0x4200014 > $DCC_PATH/config
    echo 0x4200018 > $DCC_PATH/config
    echo 0x4200030 > $DCC_PATH/config
    echo 0x4200034 > $DCC_PATH/config
    echo 0x4200038 > $DCC_PATH/config
    echo 0x420003c > $DCC_PATH/config
    echo 0x4200040 > $DCC_PATH/config
    echo 0x4200044 > $DCC_PATH/config
    echo 0x4200048 > $DCC_PATH/config
    echo 0x42000d0 > $DCC_PATH/config
    echo 0x42000d8 > $DCC_PATH/config
    echo 0x4200100 > $DCC_PATH/config
    echo 0x4200208 > $DCC_PATH/config
    echo 0x420020c > $DCC_PATH/config
    echo 0x4200210 > $DCC_PATH/config
    echo 0x4200228 > $DCC_PATH/config
    echo 0x420022c > $DCC_PATH/config
    echo 0x4200230 > $DCC_PATH/config
    echo 0x4200248 > $DCC_PATH/config
    echo 0x420024c > $DCC_PATH/config
    echo 0x4200250 > $DCC_PATH/config
    echo 0x4200268 > $DCC_PATH/config
    echo 0x420026c > $DCC_PATH/config
    echo 0x4200270 > $DCC_PATH/config
    echo 0x4200288 > $DCC_PATH/config
    echo 0x420028c > $DCC_PATH/config
    echo 0x4200290 > $DCC_PATH/config
    echo 0x42002a8 > $DCC_PATH/config
    echo 0x42002ac > $DCC_PATH/config
    echo 0x42002b0 > $DCC_PATH/config
    echo 0x4200400 > $DCC_PATH/config
    echo 0x4200404 > $DCC_PATH/config
    echo 0x4200408 > $DCC_PATH/config
    echo 0x4200d00 > $DCC_PATH/config
    echo 0x4200d04 > $DCC_PATH/config

    #MSS RSCc
    echo 0x4130010 > $DCC_PATH/config
    echo 0x4130014 > $DCC_PATH/config
    echo 0x4130018 > $DCC_PATH/config
    echo 0x41300d0 > $DCC_PATH/config
    echo 0x41300d8 > $DCC_PATH/config
    echo 0x4130100 > $DCC_PATH/config
    echo 0x4130104 > $DCC_PATH/config
    echo 0x4130208 > $DCC_PATH/config
    echo 0x413020c > $DCC_PATH/config
    echo 0x4130210 > $DCC_PATH/config
    echo 0x4130228 > $DCC_PATH/config
    echo 0x413022c > $DCC_PATH/config
    echo 0x4130230 > $DCC_PATH/config
    echo 0x4130248 > $DCC_PATH/config
    echo 0x413024c > $DCC_PATH/config
    echo 0x4130250 > $DCC_PATH/config
    echo 0x4130268 > $DCC_PATH/config
    echo 0x413026c > $DCC_PATH/config
    echo 0x4130270 > $DCC_PATH/config
    echo 0x4130288 > $DCC_PATH/config
    echo 0x413028c > $DCC_PATH/config
    echo 0x4130290 > $DCC_PATH/config
    echo 0x41302a8 > $DCC_PATH/config
    echo 0x41302ac > $DCC_PATH/config
    echo 0x41302b0 > $DCC_PATH/config
    echo 0x4130400 > $DCC_PATH/config
    echo 0x4130404 > $DCC_PATH/config
    echo 0x4130408 > $DCC_PATH/config

    #MSS PDC
    echo 0xb2c0010 > $DCC_PATH/config
    echo 0xb2c0014 > $DCC_PATH/config
    echo 0xb2c0900 > $DCC_PATH/config
    echo 0xb2c0904 > $DCC_PATH/config
    echo 0xb2c1020 > $DCC_PATH/config
    echo 0xb2c1024 > $DCC_PATH/config
    echo 0xb2c1030 > $DCC_PATH/config
    echo 0xb2c1200 > $DCC_PATH/config
    echo 0xb2c1204 > $DCC_PATH/config
    echo 0xb2c1208 > $DCC_PATH/config
    echo 0xb2c1214 > $DCC_PATH/config
    echo 0xb2c1218 > $DCC_PATH/config
    echo 0xb2c121c > $DCC_PATH/config
    echo 0xb2c1228 > $DCC_PATH/config
    echo 0xb2c122c > $DCC_PATH/config
    echo 0xb2c1230 > $DCC_PATH/config
    echo 0xb2c123c > $DCC_PATH/config
    echo 0xb2c1240 > $DCC_PATH/config
    echo 0xb2c1244 > $DCC_PATH/config
    echo 0xb2c1250 > $DCC_PATH/config
    echo 0xb2c1254 > $DCC_PATH/config
    echo 0xb2c1258 > $DCC_PATH/config
    echo 0xb2c4510 > $DCC_PATH/config
    echo 0xb2c4514 > $DCC_PATH/config
    echo 0xb2c4520 > $DCC_PATH/config

    #MSS RSCC TCS
    echo 0x4201000 > $DCC_PATH/config
    echo 0x4202000 > $DCC_PATH/config
    echo 0x4201004 > $DCC_PATH/config
    echo 0x4202ac8 > $DCC_PATH/config
    echo 0x4201808 > $DCC_PATH/config
    echo 0x4201aac > $DCC_PATH/config
    echo 0x420000c > $DCC_PATH/config
    echo 0x4200ffc > $DCC_PATH/config
    echo 0x420203c > $DCC_PATH/config
    echo 0x4201010 > $DCC_PATH/config
    echo 0x4202d58 > $DCC_PATH/config
    echo 0x4200fb8 > $DCC_PATH/config
    echo 0x4201014 > $DCC_PATH/config
    echo 0x4201ff8 > $DCC_PATH/config
    echo 0x4201018 > $DCC_PATH/config
    echo 0x4201804 > $DCC_PATH/config
    echo 0x420181c > $DCC_PATH/config
    echo 0x4201820 > $DCC_PATH/config
    echo 0x42012b0 > $DCC_PATH/config
    echo 0x4201024 > $DCC_PATH/config
    echo 0x4201028 > $DCC_PATH/config
    echo 0x4201d5c > $DCC_PATH/config
    echo 0x420102c > $DCC_PATH/config
    echo 0x4201830 > $DCC_PATH/config
    echo 0x4202808 > $DCC_PATH/config
    echo 0x4201834 > $DCC_PATH/config
    echo 0x4203038 > $DCC_PATH/config
    echo 0x4202ab4 > $DCC_PATH/config
    echo 0x420103c > $DCC_PATH/config
    echo 0x4201840 > $DCC_PATH/config
    echo 0x4202560 > $DCC_PATH/config
    echo 0x4200d98 > $DCC_PATH/config
    echo 0x4201844 > $DCC_PATH/config
    echo 0x4201848 > $DCC_PATH/config
    echo 0x420180c > $DCC_PATH/config
    echo 0x4202880 > $DCC_PATH/config
    echo 0x420104c > $DCC_PATH/config
    echo 0x4201050 > $DCC_PATH/config
    echo 0x42012b8 > $DCC_PATH/config
    echo 0x42017b8 > $DCC_PATH/config
    echo 0x4201854 > $DCC_PATH/config
    echo 0x4201858 > $DCC_PATH/config
    echo 0x4201564 > $DCC_PATH/config
    echo 0x420185c > $DCC_PATH/config
    echo 0x4201060 > $DCC_PATH/config
    echo 0x4202010 > $DCC_PATH/config
    echo 0x4201064 > $DCC_PATH/config
    echo 0x4201068 > $DCC_PATH/config
    echo 0x4201abc > $DCC_PATH/config
    echo 0x420186c > $DCC_PATH/config
    echo 0x4201870 > $DCC_PATH/config
    echo 0x4202d68 > $DCC_PATH/config
    echo 0x4201074 > $DCC_PATH/config
    echo 0x4201620 > $DCC_PATH/config
    echo 0x4201078 > $DCC_PATH/config
    echo 0x4202014 > $DCC_PATH/config
    echo 0x420107c > $DCC_PATH/config
    echo 0x4201b30 > $DCC_PATH/config
    echo 0x4201880 > $DCC_PATH/config
    echo 0x4201ac0 > $DCC_PATH/config
    echo 0x4202084 > $DCC_PATH/config
    echo 0x4201884 > $DCC_PATH/config
    echo 0x4201088 > $DCC_PATH/config
    echo 0x420156c > $DCC_PATH/config
    echo 0x4200fbc > $DCC_PATH/config
    echo 0x420108c > $DCC_PATH/config
    echo 0x4201090 > $DCC_PATH/config
    echo 0x4201818 > $DCC_PATH/config
    echo 0x4201894 > $DCC_PATH/config
    echo 0x4201898 > $DCC_PATH/config
    echo 0x42012c4 > $DCC_PATH/config
    echo 0x420109c > $DCC_PATH/config
    echo 0x42010a0 > $DCC_PATH/config
    echo 0x4202d70 > $DCC_PATH/config
    echo 0x42018a4 > $DCC_PATH/config
    echo 0x42018a8 > $DCC_PATH/config
    echo 0x420281c > $DCC_PATH/config
    echo 0x42018ac > $DCC_PATH/config
    echo 0x42010b0 > $DCC_PATH/config
    echo 0x42012c8 > $DCC_PATH/config
    echo 0x42010b4 > $DCC_PATH/config
    echo 0x42018b8 > $DCC_PATH/config
    echo 0x4201d74 > $DCC_PATH/config
    echo 0x42018bc > $DCC_PATH/config
    echo 0x42012f0 > $DCC_PATH/config
    echo 0x42018c0 > $DCC_PATH/config
    echo 0x4202020 > $DCC_PATH/config
    echo 0x42010c4 > $DCC_PATH/config
    echo 0x4200d14 > $DCC_PATH/config
    echo 0x42010c8 > $DCC_PATH/config
    echo 0x4202acc > $DCC_PATH/config
    echo 0x42017bc > $DCC_PATH/config
    echo 0x42010cc > $DCC_PATH/config
    echo 0x42018d0 > $DCC_PATH/config
    echo 0x4202578 > $DCC_PATH/config
    echo 0x42018d4 > $DCC_PATH/config
    echo 0x42010d8 > $DCC_PATH/config
    echo 0x4202024 > $DCC_PATH/config
    echo 0x42010dc > $DCC_PATH/config
    echo 0x42010e0 > $DCC_PATH/config
    echo 0x4201ad0 > $DCC_PATH/config
    echo 0x42018e4 > $DCC_PATH/config
    echo 0x42018e8 > $DCC_PATH/config
    echo 0x420157c > $DCC_PATH/config
    echo 0x42010ec > $DCC_PATH/config
    echo 0x42010f0 > $DCC_PATH/config
    echo 0x4202028 > $DCC_PATH/config
    echo 0x42010f4 > $DCC_PATH/config
    echo 0x42015e0 > $DCC_PATH/config
    echo 0x4201ad4 > $DCC_PATH/config
    echo 0x4201100 > $DCC_PATH/config
    echo 0x4201580 > $DCC_PATH/config
    echo 0x4201104 > $DCC_PATH/config
    echo 0x4201108 > $DCC_PATH/config
    echo 0x420182c > $DCC_PATH/config
    echo 0x42012d8 > $DCC_PATH/config
    echo 0x4201d84 > $DCC_PATH/config
    echo 0x4202830 > $DCC_PATH/config
    echo 0x42012dc > $DCC_PATH/config
    echo 0x4201d88 > $DCC_PATH/config
    echo 0x4202034 > $DCC_PATH/config
    echo 0x4201d9c > $DCC_PATH/config
    echo 0x4200d18 > $DCC_PATH/config
    echo 0x4202844 > $DCC_PATH/config
    echo 0x4201ae0 > $DCC_PATH/config
    echo 0x4202800 > $DCC_PATH/config
    echo 0x420158c > $DCC_PATH/config
    echo 0x4201038 > $DCC_PATH/config
    echo 0x4201ae4 > $DCC_PATH/config
    echo 0x4202590 > $DCC_PATH/config
    echo 0x420283c > $DCC_PATH/config
    echo 0x42015e4 > $DCC_PATH/config
    echo 0x4201ae8 > $DCC_PATH/config
    echo 0x420208c > $DCC_PATH/config
    echo 0x42015a0 > $DCC_PATH/config
    echo 0x4201af4 > $DCC_PATH/config
    echo 0x4201594 > $DCC_PATH/config
    echo 0x4201d94 > $DCC_PATH/config
    echo 0x4201518 > $DCC_PATH/config
    echo 0x4201040 > $DCC_PATH/config
    echo 0x4202754 > $DCC_PATH/config
    echo 0x42012ec > $DCC_PATH/config
    echo 0x4201d98 > $DCC_PATH/config
    echo 0x4203044 > $DCC_PATH/config
    echo 0x42022f0 > $DCC_PATH/config
    echo 0x4200de8 > $DCC_PATH/config
    echo 0x4200d9c > $DCC_PATH/config
    echo 0x4201890 > $DCC_PATH/config
    echo 0x4202048 > $DCC_PATH/config
    echo 0x42012b4 > $DCC_PATH/config
    echo 0x4200d1c > $DCC_PATH/config
    echo 0x4202af4 > $DCC_PATH/config
    echo 0x4202804 > $DCC_PATH/config
    echo 0x42025a0 > $DCC_PATH/config
    echo 0x420204c > $DCC_PATH/config
    echo 0x4201af8 > $DCC_PATH/config
    echo 0x4202da4 > $DCC_PATH/config
    echo 0x4202050 > $DCC_PATH/config
    echo 0x4201afc > $DCC_PATH/config
    echo 0x42015a4 > $DCC_PATH/config
    echo 0x4202da8 > $DCC_PATH/config
    echo 0x42029f4 > $DCC_PATH/config
    echo 0x4203048 > $DCC_PATH/config
    echo 0x4201054 > $DCC_PATH/config
    echo 0x4202b40 > $DCC_PATH/config
    echo 0x42029fc > $DCC_PATH/config
    echo 0x4201300 > $DCC_PATH/config
    echo 0x4201fc4 > $DCC_PATH/config
    echo 0x4202dac > $DCC_PATH/config
    echo 0x4202858 > $DCC_PATH/config
    echo 0x4202214 > $DCC_PATH/config
    echo 0x4202a18 > $DCC_PATH/config
    echo 0x4201304 > $DCC_PATH/config
    echo 0x420221c > $DCC_PATH/config
    echo 0x4200dec > $DCC_PATH/config
    echo 0x42025b0 > $DCC_PATH/config
    echo 0x4202a28 > $DCC_PATH/config
    echo 0x420205c > $DCC_PATH/config
    echo 0x4202a2c > $DCC_PATH/config
    echo 0x4202a30 > $DCC_PATH/config
    echo 0x4201308 > $DCC_PATH/config
    echo 0x4201a34 > $DCC_PATH/config
    echo 0x4201d1c > $DCC_PATH/config
    echo 0x4201a38 > $DCC_PATH/config
    echo 0x42025b4 > $DCC_PATH/config
    echo 0x4201a3c > $DCC_PATH/config
    echo 0x4202a40 > $DCC_PATH/config
    echo 0x4202060 > $DCC_PATH/config
    echo 0x4202a44 > $DCC_PATH/config
    echo 0x4202248 > $DCC_PATH/config
    echo 0x4201b0c > $DCC_PATH/config
    echo 0x420224c > $DCC_PATH/config
    echo 0x4202250 > $DCC_PATH/config
    echo 0x4202db8 > $DCC_PATH/config
    echo 0x4201254 > $DCC_PATH/config
    echo 0x4201258 > $DCC_PATH/config
    echo 0x4202864 > $DCC_PATH/config
    echo 0x4201a5c > $DCC_PATH/config
    echo 0x4202260 > $DCC_PATH/config
    echo 0x4201b10 > $DCC_PATH/config
    echo 0x4202264 > $DCC_PATH/config
    echo 0x4201a68 > $DCC_PATH/config
    echo 0x4202dbc > $DCC_PATH/config
    echo 0x4201a6c > $DCC_PATH/config
    echo 0x420200c > $DCC_PATH/config
    echo 0x4201a70 > $DCC_PATH/config
    echo 0x4201868 > $DCC_PATH/config
    echo 0x42015dc > $DCC_PATH/config
    echo 0x4201274 > $DCC_PATH/config
    echo 0x4203008 > $DCC_PATH/config
    echo 0x4202a78 > $DCC_PATH/config
    echo 0x4201314 > $DCC_PATH/config
    echo 0x4201a7c > $DCC_PATH/config
    echo 0x4201a80 > $DCC_PATH/config
    echo 0x4200dc0 > $DCC_PATH/config
    echo 0x4201a84 > $DCC_PATH/config
    echo 0x4201288 > $DCC_PATH/config
    echo 0x420286c > $DCC_PATH/config
    echo 0x420128c > $DCC_PATH/config
    echo 0x4201290 > $DCC_PATH/config
    echo 0x4201318 > $DCC_PATH/config
    echo 0x4201a94 > $DCC_PATH/config
    echo 0x4201a98 > $DCC_PATH/config
    echo 0x4200dc4 > $DCC_PATH/config
    echo 0x420129c > $DCC_PATH/config
    echo 0x4202aa0 > $DCC_PATH/config
    echo 0x4203070 > $DCC_PATH/config
    echo 0x4201da8 > $DCC_PATH/config
    echo 0x4202aa4 > $DCC_PATH/config
    echo 0x4201aa8 > $DCC_PATH/config
    echo 0x4201b1c > $DCC_PATH/config
    echo 0x42022ac > $DCC_PATH/config
    echo 0x42022b0 > $DCC_PATH/config
    echo 0x42015c8 > $DCC_PATH/config
    echo 0x42022b4 > $DCC_PATH/config
    echo 0x4201ab8 > $DCC_PATH/config
    echo 0x4202074 > $DCC_PATH/config
    echo 0x4202abc > $DCC_PATH/config
    echo 0x42022c0 > $DCC_PATH/config
    echo 0x4201b20 > $DCC_PATH/config
    echo 0x42022c4 > $DCC_PATH/config
    echo 0x42022c8 > $DCC_PATH/config
    echo 0x4202dcc > $DCC_PATH/config
    echo 0x4201acc > $DCC_PATH/config
    echo 0x4202ad0 > $DCC_PATH/config
    echo 0x4202078 > $DCC_PATH/config
    echo 0x42022d4 > $DCC_PATH/config
    echo 0x42015f0 > $DCC_PATH/config
    echo 0x42022d8 > $DCC_PATH/config
    echo 0x4201b24 > $DCC_PATH/config
    echo 0x42022dc > $DCC_PATH/config
    echo 0x42012e0 > $DCC_PATH/config
    echo 0x4201dd0 > $DCC_PATH/config
    echo 0x4202ae4 > $DCC_PATH/config
    echo 0x42022e8 > $DCC_PATH/config
    echo 0x420187c > $DCC_PATH/config
    echo 0x4202ab8 > $DCC_PATH/config
    echo 0x42022ec > $DCC_PATH/config
    echo 0x420300c > $DCC_PATH/config
    echo 0x4202af0 > $DCC_PATH/config
    echo 0x4201328 > $DCC_PATH/config
    echo 0x42012f4 > $DCC_PATH/config
    echo 0x4202af8 > $DCC_PATH/config
    echo 0x4201dd4 > $DCC_PATH/config
    echo 0x42022fc > $DCC_PATH/config
    echo 0x4201d60 > $DCC_PATH/config
    echo 0x4202300 > $DCC_PATH/config
    echo 0x4203080 > $DCC_PATH/config
    echo 0x4202304 > $DCC_PATH/config
    echo 0x4201b08 > $DCC_PATH/config
    echo 0x420232c > $DCC_PATH/config
    echo 0x4202b0c > $DCC_PATH/config
    echo 0x4202310 > $DCC_PATH/config
    echo 0x4201dd8 > $DCC_PATH/config
    echo 0x4202314 > $DCC_PATH/config
    echo 0x4202318 > $DCC_PATH/config
    echo 0x4203084 > $DCC_PATH/config
    echo 0x4201dac > $DCC_PATH/config
    echo 0x420131c > $DCC_PATH/config
    echo 0x4202b20 > $DCC_PATH/config
    echo 0x4201330 > $DCC_PATH/config
    echo 0x4202324 > $DCC_PATH/config
    echo 0x4202328 > $DCC_PATH/config
    echo 0x4200ddc > $DCC_PATH/config
    echo 0x4202b2c > $DCC_PATH/config
    echo 0x4202b30 > $DCC_PATH/config
    echo 0x4202088 > $DCC_PATH/config
    echo 0x4201b34 > $DCC_PATH/config
    echo 0x4201b38 > $DCC_PATH/config
    echo 0x4202b34 > $DCC_PATH/config
    echo 0x420133c > $DCC_PATH/config
    echo 0x4201340 > $DCC_PATH/config
    echo 0x42025e0 > $DCC_PATH/config
    echo 0x4202b44 > $DCC_PATH/config
    echo 0x4201b48 > $DCC_PATH/config
    echo 0x420288c > $DCC_PATH/config
    echo 0x4201b4c > $DCC_PATH/config
    echo 0x4201350 > $DCC_PATH/config
    echo 0x4202338 > $DCC_PATH/config
    echo 0x4201354 > $DCC_PATH/config
    echo 0x4201358 > $DCC_PATH/config
    echo 0x4201de4 > $DCC_PATH/config
    echo 0x4201b5c > $DCC_PATH/config
    echo 0x4201b60 > $DCC_PATH/config
    echo 0x4202890 > $DCC_PATH/config
    echo 0x4201364 > $DCC_PATH/config
    echo 0x4203010 > $DCC_PATH/config
    echo 0x4201368 > $DCC_PATH/config
    echo 0x420233c > $DCC_PATH/config
    echo 0x4201b6c > $DCC_PATH/config
    echo 0x4201b70 > $DCC_PATH/config
    echo 0x4201de8 > $DCC_PATH/config
    echo 0x4201b74 > $DCC_PATH/config
    echo 0x4201378 > $DCC_PATH/config
    echo 0x4202894 > $DCC_PATH/config
    echo 0x420137c > $DCC_PATH/config
    echo 0x4201380 > $DCC_PATH/config
    echo 0x4202340 > $DCC_PATH/config
    echo 0x4201b84 > $DCC_PATH/config
    echo 0x4201b88 > $DCC_PATH/config
    echo 0x4201dec > $DCC_PATH/config
    echo 0x4200db4 > $DCC_PATH/config
    echo 0x420138c > $DCC_PATH/config
    echo 0x4201390 > $DCC_PATH/config
    echo 0x4202098 > $DCC_PATH/config
    echo 0x4201db0 > $DCC_PATH/config
    echo 0x4201394 > $DCC_PATH/config
    echo 0x4201b44 > $DCC_PATH/config
    echo 0x4202814 > $DCC_PATH/config
    echo 0x42013a0 > $DCC_PATH/config
    echo 0x4200df0 > $DCC_PATH/config
    echo 0x42013a4 > $DCC_PATH/config
    echo 0x4200d50 > $DCC_PATH/config
    echo 0x42013a8 > $DCC_PATH/config
    echo 0x420209c > $DCC_PATH/config
    echo 0x4202b48 > $DCC_PATH/config
    echo 0x42015f4 > $DCC_PATH/config
    echo 0x42020a0 > $DCC_PATH/config
    echo 0x42015f8 > $DCC_PATH/config
    echo 0x420234c > $DCC_PATH/config
    echo 0x42029f8 > $DCC_PATH/config
    echo 0x4200fd8 > $DCC_PATH/config
    echo 0x4202b04 > $DCC_PATH/config
    echo 0x4203058 > $DCC_PATH/config
    echo 0x42010a4 > $DCC_PATH/config
    echo 0x4202758 > $DCC_PATH/config
    echo 0x4202350 > $DCC_PATH/config
    echo 0x4200dfc > $DCC_PATH/config
    echo 0x42028a8 > $DCC_PATH/config
    echo 0x4202840 > $DCC_PATH/config
    echo 0x4202354 > $DCC_PATH/config
    echo 0x4202600 > $DCC_PATH/config
    echo 0x42020ac > $DCC_PATH/config
    echo 0x42028a0 > $DCC_PATH/config
    echo 0x4201b58 > $DCC_PATH/config
    echo 0x4202818 > $DCC_PATH/config
    echo 0x4202604 > $DCC_PATH/config
    echo 0x4201794 > $DCC_PATH/config
    echo 0x420223c > $DCC_PATH/config
    echo 0x42020b0 > $DCC_PATH/config
    echo 0x420275c > $DCC_PATH/config
    echo 0x4201608 > $DCC_PATH/config
    echo 0x42020b4 > $DCC_PATH/config
    echo 0x420304c > $DCC_PATH/config
    echo 0x4202360 > $DCC_PATH/config
    echo 0x42015b8 > $DCC_PATH/config
    echo 0x420160c > $DCC_PATH/config
    echo 0x4202b08 > $DCC_PATH/config
    echo 0x4201530 > $DCC_PATH/config
    echo 0x420305c > $DCC_PATH/config
    echo 0x42010b8 > $DCC_PATH/config
    echo 0x420252c > $DCC_PATH/config
    echo 0x4202364 > $DCC_PATH/config
    echo 0x4201d70 > $DCC_PATH/config
    echo 0x4200e10 > $DCC_PATH/config
    echo 0x42024bc > $DCC_PATH/config
    echo 0x4202368 > $DCC_PATH/config
    echo 0x4200e00 > $DCC_PATH/config
    echo 0x4200e14 > $DCC_PATH/config
    echo 0x42020c0 > $DCC_PATH/config
    echo 0x42028a4 > $DCC_PATH/config
    echo 0x42012cc > $DCC_PATH/config
    echo 0x4200d34 > $DCC_PATH/config
    echo 0x420136c > $DCC_PATH/config
    echo 0x42017dc > $DCC_PATH/config
    echo 0x4201d30 > $DCC_PATH/config
    echo 0x4202218 > $DCC_PATH/config
    echo 0x4201798 > $DCC_PATH/config
    echo 0x4202c94 > $DCC_PATH/config
    echo 0x4202c98 > $DCC_PATH/config
    echo 0x42020c4 > $DCC_PATH/config
    echo 0x4202c9c > $DCC_PATH/config
    echo 0x4202a1c > $DCC_PATH/config
    echo 0x42020c8 > $DCC_PATH/config
    echo 0x42024b4 > $DCC_PATH/config
    echo 0x42024b8 > $DCC_PATH/config
    echo 0x4201f74 > $DCC_PATH/config
    echo 0x42015bc > $DCC_PATH/config
    echo 0x4202cbc > $DCC_PATH/config
    echo 0x4202064 > $DCC_PATH/config
    echo 0x4202cc8 > $DCC_PATH/config
    echo 0x42018cc > $DCC_PATH/config
    echo 0x4202ccc > $DCC_PATH/config
    echo 0x420301c > $DCC_PATH/config
    echo 0x4202cd0 > $DCC_PATH/config
    echo 0x4201f78 > $DCC_PATH/config
    echo 0x4201cd4 > $DCC_PATH/config
    echo 0x4201cd8 > $DCC_PATH/config
    echo 0x4200e24 > $DCC_PATH/config
    echo 0x4201cdc > $DCC_PATH/config
    echo 0x4202ce0 > $DCC_PATH/config
    echo 0x4202ce4 > $DCC_PATH/config
    echo 0x42024e8 > $DCC_PATH/config
    echo 0x420277c > $DCC_PATH/config
    echo 0x42024ec > $DCC_PATH/config
    echo 0x4200e04 > $DCC_PATH/config
    echo 0x42024f0 > $DCC_PATH/config
    echo 0x4200e28 > $DCC_PATH/config
    echo 0x4201cf4 > $DCC_PATH/config
    echo 0x4201cf8 > $DCC_PATH/config
    echo 0x42024d4 > $DCC_PATH/config
    echo 0x4201cfc > $DCC_PATH/config
    echo 0x4201344 > $DCC_PATH/config
    echo 0x4202500 > $DCC_PATH/config
    echo 0x4201b80 > $DCC_PATH/config
    echo 0x4202504 > $DCC_PATH/config
    echo 0x42017e0 > $DCC_PATH/config
    echo 0x4201558 > $DCC_PATH/config
    echo 0x4201d08 > $DCC_PATH/config
    echo 0x4200e2c > $DCC_PATH/config
    echo 0x420179c > $DCC_PATH/config
    echo 0x4201d0c > $DCC_PATH/config
    echo 0x4201d10 > $DCC_PATH/config
    echo 0x42024d8 > $DCC_PATH/config
    echo 0x4202514 > $DCC_PATH/config
    echo 0x4202518 > $DCC_PATH/config
    echo 0x420151c > $DCC_PATH/config
    echo 0x4201d20 > $DCC_PATH/config
    echo 0x4201d24 > $DCC_PATH/config
    echo 0x4201528 > $DCC_PATH/config
    echo 0x42024dc > $DCC_PATH/config
    echo 0x4202d2c > $DCC_PATH/config
    echo 0x4202d30 > $DCC_PATH/config
    echo 0x4202554 > $DCC_PATH/config
    echo 0x4201d34 > $DCC_PATH/config
    echo 0x4200d38 > $DCC_PATH/config
    echo 0x4202234 > $DCC_PATH/config
    echo 0x4200fd4 > $DCC_PATH/config
    echo 0x4200d3c > $DCC_PATH/config
    echo 0x4201540 > $DCC_PATH/config
    echo 0x42018e0 > $DCC_PATH/config
    echo 0x4201544 > $DCC_PATH/config
    echo 0x4203020 > $DCC_PATH/config
    echo 0x4201d48 > $DCC_PATH/config
    echo 0x420254c > $DCC_PATH/config
    echo 0x4202550 > $DCC_PATH/config
    echo 0x4202238 > $DCC_PATH/config
    echo 0x4202850 > $DCC_PATH/config
    echo 0x4202d54 > $DCC_PATH/config
    echo 0x4201d58 > $DCC_PATH/config
    echo 0x4200d5c > $DCC_PATH/config
    echo 0x4200d60 > $DCC_PATH/config
    echo 0x4202790 > $DCC_PATH/config
    echo 0x42017cc > $DCC_PATH/config
    echo 0x4200d64 > $DCC_PATH/config
    echo 0x4202568 > $DCC_PATH/config
    echo 0x4202a3c > $DCC_PATH/config
    echo 0x4201d6c > $DCC_PATH/config
    echo 0x4200d70 > $DCC_PATH/config
    echo 0x4200d74 > $DCC_PATH/config
    echo 0x4200d78 > $DCC_PATH/config
    echo 0x4201f94 > $DCC_PATH/config
    echo 0x420257c > $DCC_PATH/config
    echo 0x42017e4 > $DCC_PATH/config
    echo 0x4201d38 > $DCC_PATH/config
    echo 0x4201d80 > $DCC_PATH/config
    echo 0x4200e40 > $DCC_PATH/config
    echo 0x420228c > $DCC_PATH/config
    echo 0x4200d84 > $DCC_PATH/config
    echo 0x42027e0 > $DCC_PATH/config
    echo 0x4200d88 > $DCC_PATH/config
    echo 0x4200d8c > $DCC_PATH/config
    echo 0x4202d90 > $DCC_PATH/config
    echo 0x4201f98 > $DCC_PATH/config
    echo 0x4202d94 > $DCC_PATH/config
    echo 0x4202d98 > $DCC_PATH/config
    echo 0x420259c > $DCC_PATH/config
    echo 0x4200da0 > $DCC_PATH/config
    echo 0x4202cf0 > $DCC_PATH/config
    echo 0x42025a4 > $DCC_PATH/config
    echo 0x42015a8 > $DCC_PATH/config
    echo 0x4201f9c > $DCC_PATH/config
    echo 0x4200dac > $DCC_PATH/config
    echo 0x4200db0 > $DCC_PATH/config
    echo 0x42015b4 > $DCC_PATH/config
    echo 0x4200fe8 > $DCC_PATH/config
    echo 0x420153c > $DCC_PATH/config
    echo 0x42025b8 > $DCC_PATH/config
    echo 0x42014f4 > $DCC_PATH/config
    echo 0x4201a90 > $DCC_PATH/config
    echo 0x4201dbc > $DCC_PATH/config
    echo 0x4201fe4 > $DCC_PATH/config
    echo 0x4203024 > $DCC_PATH/config
    echo 0x4201dc0 > $DCC_PATH/config
    echo 0x4201dc4 > $DCC_PATH/config
    echo 0x4200dc8 > $DCC_PATH/config
    echo 0x42025cc > $DCC_PATH/config
    echo 0x4202dd0 > $DCC_PATH/config
    echo 0x42014f8 > $DCC_PATH/config
    echo 0x4202dd4 > $DCC_PATH/config
    echo 0x42025d8 > $DCC_PATH/config
    echo 0x42027a4 > $DCC_PATH/config
    echo 0x42025dc > $DCC_PATH/config
    echo 0x4202de0 > $DCC_PATH/config
    echo 0x4202a50 > $DCC_PATH/config
    echo 0x4202de4 > $DCC_PATH/config
    echo 0x4202de8 > $DCC_PATH/config
    echo 0x42014fc > $DCC_PATH/config
    echo 0x42025ec > $DCC_PATH/config
    echo 0x42025f0 > $DCC_PATH/config
    echo 0x4201fa8 > $DCC_PATH/config
    echo 0x42025f4 > $DCC_PATH/config
    echo 0x4202828 > $DCC_PATH/config
    echo 0x4201df8 > $DCC_PATH/config
    echo 0x4202d7c > $DCC_PATH/config
    echo 0x4201dfc > $DCC_PATH/config
    echo 0x4201e00 > $DCC_PATH/config
    echo 0x4201604 > $DCC_PATH/config
    echo 0x4202cf4 > $DCC_PATH/config
    echo 0x4202608 > $DCC_PATH/config
    echo 0x4201fac > $DCC_PATH/config
    echo 0x4201e0c > $DCC_PATH/config
    echo 0x4201e10 > $DCC_PATH/config
    echo 0x4201a58 > $DCC_PATH/config
    echo 0x4201e14 > $DCC_PATH/config
    echo 0x4201618 > $DCC_PATH/config
    echo 0x4202d04 > $DCC_PATH/config
    echo 0x420161c > $DCC_PATH/config
    echo 0x4201e20 > $DCC_PATH/config
    echo 0x4201fb0 > $DCC_PATH/config
    echo 0x4201e24 > $DCC_PATH/config
    echo 0x4201e28 > $DCC_PATH/config
    echo 0x4202070 > $DCC_PATH/config
    echo 0x420162c > $DCC_PATH/config
    echo 0x4200fec > $DCC_PATH/config
    echo 0x4202b18 > $DCC_PATH/config
    echo 0x4201630 > $DCC_PATH/config
    echo 0x4202d08 > $DCC_PATH/config
    echo 0x4201634 > $DCC_PATH/config
    echo 0x4200e38 > $DCC_PATH/config
    echo 0x42017b4 > $DCC_PATH/config
    echo 0x4202dc0 > $DCC_PATH/config
    echo 0x4200e3c > $DCC_PATH/config
    echo 0x4201640 > $DCC_PATH/config
    echo 0x4201644 > $DCC_PATH/config
    echo 0x4201648 > $DCC_PATH/config
    echo 0x4202d0c > $DCC_PATH/config
    echo 0x4200e4c > $DCC_PATH/config
    echo 0x4200e50 > $DCC_PATH/config
    echo 0x4202fb8 > $DCC_PATH/config
    echo 0x4202a58 > $DCC_PATH/config
    echo 0x4200e54 > $DCC_PATH/config
    echo 0x4202a64 > $DCC_PATH/config
    echo 0x4200e60 > $DCC_PATH/config
    echo 0x4202510 > $DCC_PATH/config
    echo 0x4200e64 > $DCC_PATH/config
    echo 0x4200e68 > $DCC_PATH/config
    echo 0x4202fbc > $DCC_PATH/config
    echo 0x4201568 > $DCC_PATH/config
    echo 0x420282c > $DCC_PATH/config
    echo 0x4202a68 > $DCC_PATH/config
    echo 0x4202d80 > $DCC_PATH/config
    echo 0x4201514 > $DCC_PATH/config
    echo 0x4202cf8 > $DCC_PATH/config
    echo 0x4201fc0 > $DCC_PATH/config
    echo 0x4202cb4 > $DCC_PATH/config
    echo 0x4202a6c > $DCC_PATH/config
    echo 0x4202d18 > $DCC_PATH/config
    echo 0x4202564 > $DCC_PATH/config
    echo 0x42027c4 > $DCC_PATH/config
    echo 0x42015cc > $DCC_PATH/config
    echo 0x4202270 > $DCC_PATH/config
    echo 0x42025c8 > $DCC_PATH/config
    echo 0x4202b1c > $DCC_PATH/config
    echo 0x4202d1c > $DCC_PATH/config
    echo 0x4201a54 > $DCC_PATH/config
    echo 0x42017c8 > $DCC_PATH/config
    echo 0x42024fc > $DCC_PATH/config
    echo 0x4202274 > $DCC_PATH/config
    echo 0x4202d20 > $DCC_PATH/config
    echo 0x4201d4c > $DCC_PATH/config
    echo 0x42027cc > $DCC_PATH/config
    echo 0x4201278 > $DCC_PATH/config
    echo 0x4202524 > $DCC_PATH/config
    echo 0x4200d48 > $DCC_PATH/config
    echo 0x4201fd0 > $DCC_PATH/config
    echo 0x42017f0 > $DCC_PATH/config
    echo 0x42025c4 > $DCC_PATH/config
    echo 0x4201d44 > $DCC_PATH/config
    echo 0x4202a7c > $DCC_PATH/config
    echo 0x4202d84 > $DCC_PATH/config
    echo 0x4202d6c > $DCC_PATH/config
    echo 0x4202528 > $DCC_PATH/config
    echo 0x4201fd4 > $DCC_PATH/config
    echo 0x4202cb8 > $DCC_PATH/config
    echo 0x4202a80 > $DCC_PATH/config
    echo 0x420306c > $DCC_PATH/config
    echo 0x420152c > $DCC_PATH/config
    echo 0x4201fd8 > $DCC_PATH/config
    echo 0x42015d0 > $DCC_PATH/config
    echo 0x4202284 > $DCC_PATH/config
    echo 0x4203074 > $DCC_PATH/config
    echo 0x4202588 > $DCC_PATH/config
    echo 0x4202adc > $DCC_PATH/config
    echo 0x4203030 > $DCC_PATH/config
    echo 0x4200fdc > $DCC_PATH/config
    echo 0x4202a54 > $DCC_PATH/config
    echo 0x4202288 > $DCC_PATH/config
    echo 0x4202f34 > $DCC_PATH/config
    echo 0x4202f38 > $DCC_PATH/config
    echo 0x4202d34 > $DCC_PATH/config
    echo 0x4202f3c > $DCC_PATH/config
    echo 0x4202868 > $DCC_PATH/config
    echo 0x4202fe0 > $DCC_PATH/config
    echo 0x4200e18 > $DCC_PATH/config
    echo 0x4202a8c > $DCC_PATH/config
    echo 0x4200dd4 > $DCC_PATH/config
    echo 0x4202538 > $DCC_PATH/config
    echo 0x4202f54 > $DCC_PATH/config
    echo 0x4202f58 > $DCC_PATH/config
    echo 0x4202878 > $DCC_PATH/config
    echo 0x4202f5c > $DCC_PATH/config
    echo 0x42017f4 > $DCC_PATH/config
    echo 0x420125c > $DCC_PATH/config
    echo 0x4202a90 > $DCC_PATH/config
    echo 0x4202f68 > $DCC_PATH/config
    echo 0x420253c > $DCC_PATH/config
    echo 0x4202f6c > $DCC_PATH/config
    echo 0x4203088 > $DCC_PATH/config
    echo 0x4202f70 > $DCC_PATH/config
    echo 0x4201fe8 > $DCC_PATH/config
    echo 0x4202774 > $DCC_PATH/config
    echo 0x4202778 > $DCC_PATH/config
    echo 0x4202a94 > $DCC_PATH/config
    echo 0x4202cdc > $DCC_PATH/config
    echo 0x4202f7c > $DCC_PATH/config
    echo 0x4202f80 > $DCC_PATH/config
    echo 0x4202d40 > $DCC_PATH/config
    echo 0x4202f84 > $DCC_PATH/config
    echo 0x4202788 > $DCC_PATH/config
    echo 0x4201fec > $DCC_PATH/config
    echo 0x420278c > $DCC_PATH/config
    echo 0x4202f90 > $DCC_PATH/config
    echo 0x4202298 > $DCC_PATH/config
    echo 0x4201590 > $DCC_PATH/config
    echo 0x4202f94 > $DCC_PATH/config
    echo 0x4202038 > $DCC_PATH/config
    echo 0x4202f98 > $DCC_PATH/config
    echo 0x4202d44 > $DCC_PATH/config
    echo 0x420258c > $DCC_PATH/config
    echo 0x4200fb4 > $DCC_PATH/config
    echo 0x420279c > $DCC_PATH/config
    echo 0x4202ae0 > $DCC_PATH/config
    echo 0x4203034 > $DCC_PATH/config
    echo 0x42027a0 > $DCC_PATH/config
    echo 0x4200ff0 > $DCC_PATH/config
    echo 0x4202540 > $DCC_PATH/config
    echo 0x4202fa4 > $DCC_PATH/config
    echo 0x4202fa8 > $DCC_PATH/config
    echo 0x420229c > $DCC_PATH/config
    echo 0x420127c > $DCC_PATH/config
    echo 0x4202854 > $DCC_PATH/config
    echo 0x4202fac > $DCC_PATH/config
    echo 0x4202a14 > $DCC_PATH/config
    echo 0x42027b0 > $DCC_PATH/config
    echo 0x4202d48 > $DCC_PATH/config
    echo 0x42027b4 > $DCC_PATH/config
    echo 0x4201f7c > $DCC_PATH/config
    echo 0x42027b8 > $DCC_PATH/config
    echo 0x42027f4 > $DCC_PATH/config
    echo 0x42017d0 > $DCC_PATH/config
    echo 0x4201fbc > $DCC_PATH/config
    echo 0x4202fc0 > $DCC_PATH/config
    echo 0x42012a0 > $DCC_PATH/config
    echo 0x4200dd8 > $DCC_PATH/config
    echo 0x420132c > $DCC_PATH/config
    echo 0x42027c8 > $DCC_PATH/config
    echo 0x4200d4c > $DCC_PATH/config
    echo 0x4201578 > $DCC_PATH/config
    echo 0x4202fcc > $DCC_PATH/config
    echo 0x4202fd0 > $DCC_PATH/config
    echo 0x420287c > $DCC_PATH/config
    echo 0x42012a4 > $DCC_PATH/config
    echo 0x4202fd4 > $DCC_PATH/config
    echo 0x42017f8 > $DCC_PATH/config
    echo 0x4202278 > $DCC_PATH/config
    echo 0x42027d8 > $DCC_PATH/config
    echo 0x4201aa4 > $DCC_PATH/config
    echo 0x42022a0 > $DCC_PATH/config
    echo 0x42027dc > $DCC_PATH/config
    echo 0x420225c > $DCC_PATH/config
    echo 0x4201550 > $DCC_PATH/config
    echo 0x4202fe4 > $DCC_PATH/config
    echo 0x4202fe8 > $DCC_PATH/config
    echo 0x4201ffc > $DCC_PATH/config
    echo 0x42027ec > $DCC_PATH/config
    echo 0x42027f0 > $DCC_PATH/config
    echo 0x4202aa8 > $DCC_PATH/config
    echo 0x4202ff4 > $DCC_PATH/config
    echo 0x4202d5c > $DCC_PATH/config
    echo 0x4202574 > $DCC_PATH/config
    echo 0x4202ff8 > $DCC_PATH/config
    echo 0x4201554 > $DCC_PATH/config
    echo 0x4203060 > $DCC_PATH/config
    echo 0x4202ffc > $DCC_PATH/config

    #MSS General
    echo 0x18a004 > $DCC_PATH/config
    echo 0x4080044 > $DCC_PATH/config
    echo 0x40800b0 > $DCC_PATH/config
    echo 0x4080304 > $DCC_PATH/config
    echo 0x4080438 > $DCC_PATH/config
    echo 0x4080448 > $DCC_PATH/config
    echo 0x4080468 > $DCC_PATH/config
    echo 0x4082000 > $DCC_PATH/config
    echo 0x4082004 > $DCC_PATH/config
    echo 0x4082028 > $DCC_PATH/config
    echo 0x4110380 32 > $DCC_PATH/config
    echo 0x41a802c > $DCC_PATH/config
    echo 0x4402028 > $DCC_PATH/config
}

config_lito_dcc_noc(){
    #A1NOC
    echo 0x16e0000 > $DCC_PATH/config
    echo 0x16e0004 > $DCC_PATH/config
    echo 0x16e0288 > $DCC_PATH/config
    echo 0x16e0290 > $DCC_PATH/config
    echo 0x16e0300 > $DCC_PATH/config
    echo 0x16e0408 > $DCC_PATH/config
    echo 0x16e0410 > $DCC_PATH/config
    echo 0x16e0420 > $DCC_PATH/config
    echo 0x16e0424 > $DCC_PATH/config
    echo 0x16e0428 > $DCC_PATH/config
    echo 0x16e042c > $DCC_PATH/config
    echo 0x16e0430 > $DCC_PATH/config
    echo 0x16e0434 > $DCC_PATH/config
    echo 0x16e0438 > $DCC_PATH/config
    echo 0x16e043c > $DCC_PATH/config
    echo 0x16e0688 > $DCC_PATH/config
    echo 0x16e0690 > $DCC_PATH/config
    echo 0x16e0700 > $DCC_PATH/config
    echo 0x16e0888 > $DCC_PATH/config
    echo 0x16e0890 > $DCC_PATH/config
    echo 0x16e0900 > $DCC_PATH/config
    echo 0x16e0904 > $DCC_PATH/config
    echo 0x16e0a40 > $DCC_PATH/config
    echo 0x16e0a48 > $DCC_PATH/config
    echo 0x16e0a88 > $DCC_PATH/config
    echo 0x16e0a90 > $DCC_PATH/config
    echo 0x16e0b00 > $DCC_PATH/config

    #A2NOC
    echo 0x1700204 > $DCC_PATH/config
    echo 0x1700240 > $DCC_PATH/config
    echo 0x1700248 > $DCC_PATH/config
    echo 0x1700288 > $DCC_PATH/config
    echo 0x1700290 > $DCC_PATH/config
    echo 0x1700300 > $DCC_PATH/config
    echo 0x1700304 > $DCC_PATH/config
    echo 0x1700308 > $DCC_PATH/config
    echo 0x170030c > $DCC_PATH/config
    echo 0x1700310 > $DCC_PATH/config
    echo 0x1700400 > $DCC_PATH/config
    echo 0x1700404 > $DCC_PATH/config
    echo 0x1700488 > $DCC_PATH/config
    echo 0x1700490 > $DCC_PATH/config
    echo 0x1700500 > $DCC_PATH/config
    echo 0x1700504 > $DCC_PATH/config
    echo 0x1700508 > $DCC_PATH/config
    echo 0x170050c > $DCC_PATH/config
    echo 0x1700c00 > $DCC_PATH/config
    echo 0x1700c04 > $DCC_PATH/config
    echo 0x1700c08 > $DCC_PATH/config
    echo 0x1700c10 > $DCC_PATH/config
    echo 0x1700c20 > $DCC_PATH/config
    echo 0x1700c24 > $DCC_PATH/config
    echo 0x1700c28 > $DCC_PATH/config
    echo 0x1700c2c > $DCC_PATH/config
    echo 0x1700c30 > $DCC_PATH/config
    echo 0x1700c34 > $DCC_PATH/config
    echo 0x1700c38 > $DCC_PATH/config
    echo 0x1700c3c > $DCC_PATH/config

    #SNOC
    echo 0x1620000 > $DCC_PATH/config
    echo 0x1620004 > $DCC_PATH/config
    echo 0x1620008 > $DCC_PATH/config
    echo 0x1620010 > $DCC_PATH/config
    echo 0x1620020 > $DCC_PATH/config
    echo 0x1620024 > $DCC_PATH/config
    echo 0x1620028 > $DCC_PATH/config
    echo 0x162002c > $DCC_PATH/config
    echo 0x1620030 > $DCC_PATH/config
    echo 0x1620034 > $DCC_PATH/config
    echo 0x1620038 > $DCC_PATH/config
    echo 0x162003c > $DCC_PATH/config
    echo 0x1620100 > $DCC_PATH/config
    echo 0x1620104 > $DCC_PATH/config
    echo 0x1620108 > $DCC_PATH/config
    echo 0x1620110 > $DCC_PATH/config
    echo 0x1620200 > $DCC_PATH/config
    echo 0x1620204 > $DCC_PATH/config
    echo 0x1620240 > $DCC_PATH/config
    echo 0x1620248 > $DCC_PATH/config
    echo 0x1620288 > $DCC_PATH/config
    echo 0x162028c > $DCC_PATH/config
    echo 0x1620290 > $DCC_PATH/config
    echo 0x1620294 > $DCC_PATH/config
    echo 0x16202a8 > $DCC_PATH/config
    echo 0x16202ac > $DCC_PATH/config
    echo 0x16202b0 > $DCC_PATH/config
    echo 0x16202b4 > $DCC_PATH/config
    echo 0x1620300 > $DCC_PATH/config
    echo 0x1620400 > $DCC_PATH/config
    echo 0x1620404 > $DCC_PATH/config
    echo 0x1620488 > $DCC_PATH/config
    echo 0x1620490 > $DCC_PATH/config
    echo 0x1620500 > $DCC_PATH/config
    echo 0x1620504 > $DCC_PATH/config
    echo 0x1620508 > $DCC_PATH/config
    echo 0x162050c > $DCC_PATH/config
    echo 0x1620510 > $DCC_PATH/config
    echo 0x1620600 > $DCC_PATH/config
    echo 0x1620604 > $DCC_PATH/config
    echo 0x1620688 > $DCC_PATH/config
    echo 0x1620690 > $DCC_PATH/config
    echo 0x1620700 > $DCC_PATH/config
    echo 0x1620704 > $DCC_PATH/config
    echo 0x1620708 > $DCC_PATH/config
    echo 0x162070c > $DCC_PATH/config
    echo 0x1620710 > $DCC_PATH/config
    echo 0x1620800 > $DCC_PATH/config
    echo 0x1620804 > $DCC_PATH/config
    echo 0x1620900 > $DCC_PATH/config
    echo 0x1620a00 > $DCC_PATH/config
    echo 0x1620a04 > $DCC_PATH/config
    echo 0x1620b00 > $DCC_PATH/config
    echo 0x1620b04 > $DCC_PATH/config
    echo 0x1620e00 > $DCC_PATH/config
    echo 0x1620e04 > $DCC_PATH/config
    echo 0x1620e88 > $DCC_PATH/config
    echo 0x1620e90 > $DCC_PATH/config
    echo 0x1620f00 > $DCC_PATH/config
    echo 0x1639000 > $DCC_PATH/config
    echo 0x1639004 > $DCC_PATH/config
    echo 0x1639088 > $DCC_PATH/config
    echo 0x1639090 > $DCC_PATH/config
    echo 0x1639100 > $DCC_PATH/config

    #LPASS AGNOC
    echo 0x3c41800 > $DCC_PATH/config
    echo 0x3c41804 > $DCC_PATH/config
    echo 0x3c41880 > $DCC_PATH/config
    echo 0x3c41888 > $DCC_PATH/config
    echo 0x3c41890 > $DCC_PATH/config
    echo 0x3c41900 > $DCC_PATH/config
    echo 0x3c41a00 > $DCC_PATH/config
    echo 0x3c41a04 > $DCC_PATH/config
    echo 0x3c41a40 > $DCC_PATH/config
    echo 0x3c41a48 > $DCC_PATH/config
    echo 0x3c41c00 > $DCC_PATH/config
    echo 0x3c41c04 > $DCC_PATH/config
    echo 0x3c41d00 > $DCC_PATH/config
    echo 0x3c42680 > $DCC_PATH/config
    echo 0x3c42684 > $DCC_PATH/config
    echo 0x3c42688 > $DCC_PATH/config
    echo 0x3c42690 > $DCC_PATH/config
    echo 0x3c42698 > $DCC_PATH/config
    echo 0x3c426a0 > $DCC_PATH/config
    echo 0x3c426a4 > $DCC_PATH/config
    echo 0x3c426a8 > $DCC_PATH/config
    echo 0x3c426ac > $DCC_PATH/config
    echo 0x3c426b0 > $DCC_PATH/config
    echo 0x3c426b4 > $DCC_PATH/config
    echo 0x3c426b8 > $DCC_PATH/config
    echo 0x3c426bc > $DCC_PATH/config

    #MMSS NOC
    echo 0x1740000 > $DCC_PATH/config
    echo 0x1740004 > $DCC_PATH/config
    echo 0x1740008 > $DCC_PATH/config
    echo 0x1740010 > $DCC_PATH/config
    echo 0x1740018 > $DCC_PATH/config
    echo 0x1740020 > $DCC_PATH/config
    echo 0x1740024 > $DCC_PATH/config
    echo 0x1740028 > $DCC_PATH/config
    echo 0x174002c > $DCC_PATH/config
    echo 0x1740030 > $DCC_PATH/config
    echo 0x1740034 > $DCC_PATH/config
    echo 0x1740038 > $DCC_PATH/config
    echo 0x174003c > $DCC_PATH/config
    echo 0x1740240 > $DCC_PATH/config
    echo 0x1740248 > $DCC_PATH/config
    echo 0x1740280 > $DCC_PATH/config
    echo 0x1740288 > $DCC_PATH/config
    echo 0x1740290 > $DCC_PATH/config
    echo 0x1740300 > $DCC_PATH/config
    echo 0x1740304 > $DCC_PATH/config
    echo 0x1740308 > $DCC_PATH/config
    echo 0x174030c > $DCC_PATH/config
    echo 0x1740310 > $DCC_PATH/config
    echo 0x1740314 > $DCC_PATH/config
    echo 0x1740318 > $DCC_PATH/config

    #GEMNOC
    echo 0x9681010 > $DCC_PATH/config
    echo 0x9681014 > $DCC_PATH/config
    echo 0x9681018 > $DCC_PATH/config
    echo 0x968101c > $DCC_PATH/config
    echo 0x9681020 > $DCC_PATH/config
    echo 0x9681024 > $DCC_PATH/config
    echo 0x9681028 > $DCC_PATH/config
    echo 0x968102c > $DCC_PATH/config
    echo 0x9681030 > $DCC_PATH/config
    echo 0x9681034 > $DCC_PATH/config
    echo 0x968103c > $DCC_PATH/config
    echo 0x9692000 > $DCC_PATH/config
    echo 0x9692004 > $DCC_PATH/config
    echo 0x9692008 > $DCC_PATH/config
    echo 0x9692040 > $DCC_PATH/config
    echo 0x9692048 > $DCC_PATH/config
    echo 0x9695000 > $DCC_PATH/config
    echo 0x9695004 > $DCC_PATH/config
    echo 0x9695080 > $DCC_PATH/config
    echo 0x9695084 > $DCC_PATH/config
    echo 0x9695088 > $DCC_PATH/config
    echo 0x969508c > $DCC_PATH/config
    echo 0x9695090 > $DCC_PATH/config
    echo 0x9695094 > $DCC_PATH/config
    echo 0x96950a0 > $DCC_PATH/config
    echo 0x96950a8 > $DCC_PATH/config
    echo 0x96950b0 > $DCC_PATH/config
    echo 0x9695100 > $DCC_PATH/config
    echo 0x9695104 > $DCC_PATH/config
    echo 0x9695108 > $DCC_PATH/config
    echo 0x969510c > $DCC_PATH/config
    echo 0x9695110 > $DCC_PATH/config
    echo 0x9695114 > $DCC_PATH/config
    echo 0x9695118 > $DCC_PATH/config
    echo 0x969511c > $DCC_PATH/config
    echo 0x9696000 > $DCC_PATH/config
    echo 0x9696004 > $DCC_PATH/config
    echo 0x9696080 > $DCC_PATH/config
    echo 0x9696088 > $DCC_PATH/config
    echo 0x9696090 > $DCC_PATH/config
    echo 0x9696100 > $DCC_PATH/config
    echo 0x9696104 > $DCC_PATH/config
    echo 0x9696108 > $DCC_PATH/config
    echo 0x969610c > $DCC_PATH/config
    echo 0x9696114 > $DCC_PATH/config
    echo 0x9696118 > $DCC_PATH/config
    echo 0x969611c > $DCC_PATH/config
    echo 0x9698000 > $DCC_PATH/config
    echo 0x9698004 > $DCC_PATH/config
    echo 0x9698008 > $DCC_PATH/config
    echo 0x9698010 > $DCC_PATH/config
    echo 0x9698100 > $DCC_PATH/config
    echo 0x9698104 > $DCC_PATH/config
    echo 0x9698108 > $DCC_PATH/config
    echo 0x9698110 > $DCC_PATH/config
    echo 0x9698118 > $DCC_PATH/config
    echo 0x9698120 > $DCC_PATH/config
    echo 0x9698124 > $DCC_PATH/config
    echo 0x9698128 > $DCC_PATH/config
    echo 0x969812c > $DCC_PATH/config
    echo 0x9698130 > $DCC_PATH/config
    echo 0x9698134 > $DCC_PATH/config
    echo 0x9698138 > $DCC_PATH/config
    echo 0x969813c > $DCC_PATH/config
    echo 0x9698200 > $DCC_PATH/config
    echo 0x9698204 > $DCC_PATH/config
    echo 0x9698240 > $DCC_PATH/config
    echo 0x9698244 > $DCC_PATH/config
    echo 0x9698248 > $DCC_PATH/config
    echo 0x969824c > $DCC_PATH/config
}

config_lito_dcc_gcc(){
    #GCC
    echo 0x100000 13 > $DCC_PATH/config
    echo 0x100040 > $DCC_PATH/config
    echo 0x100100 4 > $DCC_PATH/config
    echo 0x101000 13 > $DCC_PATH/config
    echo 0x10103c > $DCC_PATH/config
    echo 0x101040 > $DCC_PATH/config
    echo 0x102000 13 > $DCC_PATH/config
    echo 0x10203c > $DCC_PATH/config
    echo 0x102040 > $DCC_PATH/config
    echo 0x103000 13 > $DCC_PATH/config
    echo 0x10303c > $DCC_PATH/config
    echo 0x103040 > $DCC_PATH/config
    echo 0x10401c > $DCC_PATH/config
    echo 0x105008 > $DCC_PATH/config
    echo 0x10504c > $DCC_PATH/config
    echo 0x105064 > $DCC_PATH/config
    echo 0x106100 > $DCC_PATH/config
    echo 0x109004 > $DCC_PATH/config
    echo 0x109008 > $DCC_PATH/config
    echo 0x10900c > $DCC_PATH/config
    echo 0x109010 > $DCC_PATH/config
    echo 0x109014 > $DCC_PATH/config
    echo 0x109018 > $DCC_PATH/config
    echo 0x10901c > $DCC_PATH/config
    echo 0x109020 > $DCC_PATH/config
    echo 0x109024 > $DCC_PATH/config
    echo 0x10904c > $DCC_PATH/config
    echo 0x10915c > $DCC_PATH/config
    echo 0x109160 > $DCC_PATH/config
    echo 0x109464 > $DCC_PATH/config
    echo 0x109468 > $DCC_PATH/config
    echo 0x10946c > $DCC_PATH/config
    echo 0x109470 > $DCC_PATH/config
    echo 0x109478 > $DCC_PATH/config
    echo 0x113000 > $DCC_PATH/config
    echo 0x113004 > $DCC_PATH/config
    echo 0x113008 > $DCC_PATH/config
    echo 0x11300c > $DCC_PATH/config
    echo 0x113010 > $DCC_PATH/config
    echo 0x113014 > $DCC_PATH/config
    echo 0x113018 > $DCC_PATH/config
    echo 0x11301c > $DCC_PATH/config
    echo 0x113020 > $DCC_PATH/config
    echo 0x113024 > $DCC_PATH/config
    echo 0x113028 > $DCC_PATH/config
    echo 0x11302c > $DCC_PATH/config
    echo 0x113030 > $DCC_PATH/config
    echo 0x11303c > $DCC_PATH/config
    echo 0x113040 > $DCC_PATH/config
    echo 0x117024 > $DCC_PATH/config
    echo 0x117154 > $DCC_PATH/config
    echo 0x117284 > $DCC_PATH/config
    echo 0x1173b4 > $DCC_PATH/config
    echo 0x1174e4 > $DCC_PATH/config
    echo 0x117614 > $DCC_PATH/config
    echo 0x118024 > $DCC_PATH/config
    echo 0x118154 > $DCC_PATH/config
    echo 0x118284 > $DCC_PATH/config
    echo 0x1183b4 > $DCC_PATH/config
    echo 0x1184e4 > $DCC_PATH/config
    echo 0x118614 > $DCC_PATH/config
    echo 0x11a000 > $DCC_PATH/config
    echo 0x11a004 > $DCC_PATH/config
    echo 0x11a008 > $DCC_PATH/config
    echo 0x11a00c > $DCC_PATH/config
    echo 0x11a010 > $DCC_PATH/config
    echo 0x11a014 > $DCC_PATH/config
    echo 0x11a018 > $DCC_PATH/config
    echo 0x11a01c > $DCC_PATH/config
    echo 0x11a020 > $DCC_PATH/config
    echo 0x11a024 > $DCC_PATH/config
    echo 0x11a028 > $DCC_PATH/config
    echo 0x11a02c > $DCC_PATH/config
    echo 0x11a030 > $DCC_PATH/config
    echo 0x11a03c > $DCC_PATH/config
    echo 0x11a040 > $DCC_PATH/config
    echo 0x11b000 > $DCC_PATH/config
    echo 0x11b004 > $DCC_PATH/config
    echo 0x11b008 > $DCC_PATH/config
    echo 0x11b00c > $DCC_PATH/config
    echo 0x11b010 > $DCC_PATH/config
    echo 0x11b014 > $DCC_PATH/config
    echo 0x11b018 > $DCC_PATH/config
    echo 0x11b01c > $DCC_PATH/config
    echo 0x11b020 > $DCC_PATH/config
    echo 0x11b024 > $DCC_PATH/config
    echo 0x11b028 > $DCC_PATH/config
    echo 0x11b02c > $DCC_PATH/config
    echo 0x11b030 > $DCC_PATH/config
    echo 0x11b03c > $DCC_PATH/config
    echo 0x11b040 > $DCC_PATH/config
    echo 0x11c000 > $DCC_PATH/config
    echo 0x11c004 > $DCC_PATH/config
    echo 0x11c008 > $DCC_PATH/config
    echo 0x11c00c > $DCC_PATH/config
    echo 0x11c010 > $DCC_PATH/config
    echo 0x11c014 > $DCC_PATH/config
    echo 0x11c018 > $DCC_PATH/config
    echo 0x11c01c > $DCC_PATH/config
    echo 0x11c020 > $DCC_PATH/config
    echo 0x11c024 > $DCC_PATH/config
    echo 0x11c028 > $DCC_PATH/config
    echo 0x11c02c > $DCC_PATH/config
    echo 0x11c030 > $DCC_PATH/config
    echo 0x11c03c > $DCC_PATH/config
    echo 0x11c040 > $DCC_PATH/config
    echo 0x11d000 > $DCC_PATH/config
    echo 0x11d004 > $DCC_PATH/config
    echo 0x11d008 > $DCC_PATH/config
    echo 0x11d00c > $DCC_PATH/config
    echo 0x11d010 > $DCC_PATH/config
    echo 0x11d014 > $DCC_PATH/config
    echo 0x11d018 > $DCC_PATH/config
    echo 0x11d01c > $DCC_PATH/config
    echo 0x11d020 > $DCC_PATH/config
    echo 0x11d024 > $DCC_PATH/config
    echo 0x11d028 > $DCC_PATH/config
    echo 0x11d02c > $DCC_PATH/config
    echo 0x11d030 > $DCC_PATH/config
    echo 0x11d03c > $DCC_PATH/config
    echo 0x11d040 > $DCC_PATH/config
    echo 0x120004 > $DCC_PATH/config
    echo 0x123020 > $DCC_PATH/config
    echo 0x127004 > $DCC_PATH/config
    echo 0x135000 > $DCC_PATH/config
    echo 0x13500c > $DCC_PATH/config
    echo 0x135010 > $DCC_PATH/config
    echo 0x141024 > $DCC_PATH/config
    echo 0x14401c > $DCC_PATH/config
    echo 0x144164 > $DCC_PATH/config
    echo 0x144284 > $DCC_PATH/config
    echo 0x1442a0 > $DCC_PATH/config
    echo 0x1443d0 > $DCC_PATH/config
    echo 0x145000 > $DCC_PATH/config
    echo 0x145004 > $DCC_PATH/config
    echo 0x145008 > $DCC_PATH/config
    echo 0x145010 > $DCC_PATH/config
    echo 0x145018 > $DCC_PATH/config
    echo 0x145044 > $DCC_PATH/config
    echo 0x145378 > $DCC_PATH/config
    echo 0x14537c > $DCC_PATH/config
    echo 0x145380 > $DCC_PATH/config
    echo 0x145384 > $DCC_PATH/config
    echo 0x145398 > $DCC_PATH/config
    echo 0x147000 > $DCC_PATH/config
    echo 0x14700c > $DCC_PATH/config
    echo 0x147014 > $DCC_PATH/config
    echo 0x17100c > $DCC_PATH/config
    echo 0x171010 > $DCC_PATH/config
    echo 0x171018 > $DCC_PATH/config
    echo 0x171250 > $DCC_PATH/config
    echo 0x174000 > $DCC_PATH/config
    echo 0x174004 > $DCC_PATH/config
    echo 0x174008 > $DCC_PATH/config
    echo 0x17400c > $DCC_PATH/config
    echo 0x174010 > $DCC_PATH/config
    echo 0x174014 > $DCC_PATH/config
    echo 0x174018 > $DCC_PATH/config
    echo 0x17401c > $DCC_PATH/config
    echo 0x174020 > $DCC_PATH/config
    echo 0x174024 > $DCC_PATH/config
    echo 0x174028 > $DCC_PATH/config
    echo 0x17402c > $DCC_PATH/config
    echo 0x174030 > $DCC_PATH/config
    echo 0x17403c > $DCC_PATH/config
    echo 0x174040 > $DCC_PATH/config
    echo 0x176000 > $DCC_PATH/config
    echo 0x176004 > $DCC_PATH/config
    echo 0x176008 > $DCC_PATH/config
    echo 0x17600c > $DCC_PATH/config
    echo 0x176010 > $DCC_PATH/config
    echo 0x176014 > $DCC_PATH/config
    echo 0x176018 > $DCC_PATH/config
    echo 0x17601c > $DCC_PATH/config
    echo 0x176020 > $DCC_PATH/config
    echo 0x176024 > $DCC_PATH/config
    echo 0x176028 > $DCC_PATH/config
    echo 0x17602c > $DCC_PATH/config
    echo 0x176030 > $DCC_PATH/config
    echo 0x17603c > $DCC_PATH/config
    echo 0x176040 > $DCC_PATH/config
    echo 0x178040 > $DCC_PATH/config
    echo 0x182010 > $DCC_PATH/config
    echo 0x182884 > $DCC_PATH/config
    echo 0x182888 > $DCC_PATH/config
    echo 0x18288c > $DCC_PATH/config
    echo 0x182894 > $DCC_PATH/config
    echo 0x182898 > $DCC_PATH/config
    echo 0x18289c > $DCC_PATH/config
    echo 0x183004 > $DCC_PATH/config
    echo 0x183008 > $DCC_PATH/config
    echo 0x18300c > $DCC_PATH/config
    echo 0x183024 > $DCC_PATH/config
    echo 0x183140 > $DCC_PATH/config
    echo 0x18323c > $DCC_PATH/config
    echo 0x189004 > $DCC_PATH/config
    echo 0x189008 > $DCC_PATH/config
    echo 0x18900c > $DCC_PATH/config
    echo 0x189010 > $DCC_PATH/config
    echo 0x189014 > $DCC_PATH/config
    echo 0x189018 > $DCC_PATH/config
    echo 0x18901c > $DCC_PATH/config
    echo 0x189024 > $DCC_PATH/config
    echo 0x189044 > $DCC_PATH/config
    echo 0x189164 > $DCC_PATH/config
    echo 0x190004 > $DCC_PATH/config
    echo 0x190008 > $DCC_PATH/config
    echo 0x19000c > $DCC_PATH/config
    echo 0x190010 > $DCC_PATH/config
    echo 0x190014 > $DCC_PATH/config
    echo 0x190018 > $DCC_PATH/config
    echo 0x191100 > $DCC_PATH/config
    echo 0x192100 > $DCC_PATH/config
    echo 0x193100 > $DCC_PATH/config
    echo 0x194100 > $DCC_PATH/config
    echo 0x195100 > $DCC_PATH/config
    echo 0x196100 > $DCC_PATH/config
    echo 0x197100 > $DCC_PATH/config
    echo 0x19b100 > $DCC_PATH/config
    echo 0x19c100 > $DCC_PATH/config
    echo 0x3D91078 > $DCC_PATH/config
    echo 0x3D95000 > $DCC_PATH/config
}

config_lito_dcc_l3_rsc(){
    echo 0x182300d0 > $DCC_PATH/config
    echo 0x182300d8 > $DCC_PATH/config
    echo 0x18230100 > $DCC_PATH/config
    echo 0x18230400 > $DCC_PATH/config
    echo 0x18230404 > $DCC_PATH/config
    echo 0x18230408 > $DCC_PATH/config
    echo 0x18230460 > $DCC_PATH/config
    echo 0x18230464 > $DCC_PATH/config
    echo 0x18230d00 > $DCC_PATH/config
    echo 0x18230d04 > $DCC_PATH/config
    echo 0x18230d10 > $DCC_PATH/config
    echo 0x18230d14 > $DCC_PATH/config
    echo 0x18230d18 > $DCC_PATH/config
    echo 0x18230d1c > $DCC_PATH/config
    echo 0x18230d34 > $DCC_PATH/config
    echo 0x18230d38 > $DCC_PATH/config
    echo 0x18230d3c > $DCC_PATH/config
    echo 0x18230d48 > $DCC_PATH/config
    echo 0x18230d4c > $DCC_PATH/config
    echo 0x18230d50 > $DCC_PATH/config
    echo 0x18230d5c > $DCC_PATH/config
    echo 0x18230d60 > $DCC_PATH/config
    echo 0x18230d64 > $DCC_PATH/config
    echo 0x18230d70 > $DCC_PATH/config
    echo 0x18230d74 > $DCC_PATH/config
    echo 0x18230d78 > $DCC_PATH/config
    echo 0x18230d84 > $DCC_PATH/config
    echo 0x18230d88 > $DCC_PATH/config
    echo 0x18230d8c > $DCC_PATH/config
    echo 0x18230d98 > $DCC_PATH/config
    echo 0x18230d9c > $DCC_PATH/config
    echo 0x18230da0 > $DCC_PATH/config
    echo 0x18230dac > $DCC_PATH/config
    echo 0x18230db0 > $DCC_PATH/config
    echo 0x18230db4 > $DCC_PATH/config
    echo 0x18230dc0 > $DCC_PATH/config
    echo 0x18230dc4 > $DCC_PATH/config
    echo 0x18230dc8 > $DCC_PATH/config
    echo 0x18230dd4 > $DCC_PATH/config
    echo 0x18230dd8 > $DCC_PATH/config
    echo 0x18230ddc > $DCC_PATH/config
    echo 0x18230de8 > $DCC_PATH/config
    echo 0x18230dec > $DCC_PATH/config
    echo 0x18230df0 > $DCC_PATH/config
    echo 0x18230dfc > $DCC_PATH/config
    echo 0x18230e00 > $DCC_PATH/config
    echo 0x18230e04 > $DCC_PATH/config
    echo 0x18230e10 > $DCC_PATH/config
    echo 0x18230e14 > $DCC_PATH/config
    echo 0x18230e18 > $DCC_PATH/config
    echo 0x18230e24 > $DCC_PATH/config
    echo 0x18230e28 > $DCC_PATH/config
    echo 0x18230e2c > $DCC_PATH/config
    echo 0x18230e38 > $DCC_PATH/config
    echo 0x18230e3c > $DCC_PATH/config
    echo 0x18230e40 > $DCC_PATH/config
    echo 0x18230e4c > $DCC_PATH/config
    echo 0x18230e50 > $DCC_PATH/config
    echo 0x18230e54 > $DCC_PATH/config
    echo 0x18230e60 > $DCC_PATH/config
    echo 0x18230e64 > $DCC_PATH/config
    echo 0x18230e68 > $DCC_PATH/config
    echo 0x18230fb0 > $DCC_PATH/config
    echo 0x18230fb4 > $DCC_PATH/config
    echo 0x18230fb8 > $DCC_PATH/config
    echo 0x18230fbc > $DCC_PATH/config
    echo 0x18230fd4 > $DCC_PATH/config
    echo 0x18230fd8 > $DCC_PATH/config
    echo 0x18230fdc > $DCC_PATH/config
    echo 0x18230fe8 > $DCC_PATH/config
    echo 0x18230fec > $DCC_PATH/config
    echo 0x18230ff0 > $DCC_PATH/config
    echo 0x18230ffc > $DCC_PATH/config
    echo 0x18231000 > $DCC_PATH/config
    echo 0x18231004 > $DCC_PATH/config
    echo 0x18231010 > $DCC_PATH/config
    echo 0x18231014 > $DCC_PATH/config
    echo 0x18231018 > $DCC_PATH/config
    echo 0x18231024 > $DCC_PATH/config
    echo 0x18231028 > $DCC_PATH/config
    echo 0x1823102c > $DCC_PATH/config
    echo 0x18231038 > $DCC_PATH/config
    echo 0x1823103c > $DCC_PATH/config
    echo 0x18231040 > $DCC_PATH/config
    echo 0x1823104c > $DCC_PATH/config
    echo 0x18231050 > $DCC_PATH/config
    echo 0x18231054 > $DCC_PATH/config
    echo 0x18231060 > $DCC_PATH/config
    echo 0x18231064 > $DCC_PATH/config
    echo 0x18231068 > $DCC_PATH/config
    echo 0x18231074 > $DCC_PATH/config
    echo 0x18231078 > $DCC_PATH/config
    echo 0x1823107c > $DCC_PATH/config
    echo 0x18231088 > $DCC_PATH/config
    echo 0x1823108c > $DCC_PATH/config
    echo 0x18231090 > $DCC_PATH/config
    echo 0x1823109c > $DCC_PATH/config
    echo 0x182310a0 > $DCC_PATH/config
    echo 0x182310a4 > $DCC_PATH/config
    echo 0x182310b0 > $DCC_PATH/config
    echo 0x182310b4 > $DCC_PATH/config
    echo 0x182310b8 > $DCC_PATH/config
    echo 0x182310c4 > $DCC_PATH/config
    echo 0x182310c8 > $DCC_PATH/config
    echo 0x182310cc > $DCC_PATH/config
    echo 0x182310d8 > $DCC_PATH/config
    echo 0x182310dc > $DCC_PATH/config
    echo 0x182310e0 > $DCC_PATH/config
    echo 0x182310ec > $DCC_PATH/config
    echo 0x182310f0 > $DCC_PATH/config
    echo 0x182310f4 > $DCC_PATH/config
    echo 0x18231100 > $DCC_PATH/config
    echo 0x18231104 > $DCC_PATH/config
    echo 0x18231108 > $DCC_PATH/config
    echo 0x18231250 > $DCC_PATH/config
    echo 0x18231254 > $DCC_PATH/config
    echo 0x18231258 > $DCC_PATH/config
    echo 0x1823125c > $DCC_PATH/config
    echo 0x18231274 > $DCC_PATH/config
    echo 0x18231278 > $DCC_PATH/config
    echo 0x1823127c > $DCC_PATH/config
    echo 0x18231288 > $DCC_PATH/config
    echo 0x1823128c > $DCC_PATH/config
    echo 0x18231290 > $DCC_PATH/config
    echo 0x1823129c > $DCC_PATH/config
    echo 0x182312a0 > $DCC_PATH/config
    echo 0x182312a4 > $DCC_PATH/config
    echo 0x182312b0 > $DCC_PATH/config
    echo 0x182312b4 > $DCC_PATH/config
    echo 0x182312b8 > $DCC_PATH/config
    echo 0x182312c4 > $DCC_PATH/config
    echo 0x182312c8 > $DCC_PATH/config
    echo 0x182312cc > $DCC_PATH/config
    echo 0x182312d8 > $DCC_PATH/config
    echo 0x182312dc > $DCC_PATH/config
    echo 0x182312e0 > $DCC_PATH/config
    echo 0x182312ec > $DCC_PATH/config
    echo 0x182312f0 > $DCC_PATH/config
    echo 0x182312f4 > $DCC_PATH/config
    echo 0x18231300 > $DCC_PATH/config
    echo 0x18231304 > $DCC_PATH/config
    echo 0x18231308 > $DCC_PATH/config
    echo 0x18231314 > $DCC_PATH/config
    echo 0x18231318 > $DCC_PATH/config
    echo 0x1823131c > $DCC_PATH/config
    echo 0x18231328 > $DCC_PATH/config
    echo 0x1823132c > $DCC_PATH/config
    echo 0x18231330 > $DCC_PATH/config
    echo 0x1823133c > $DCC_PATH/config
    echo 0x18231340 > $DCC_PATH/config
    echo 0x18231344 > $DCC_PATH/config
    echo 0x18231350 > $DCC_PATH/config
    echo 0x18231354 > $DCC_PATH/config
    echo 0x18231358 > $DCC_PATH/config
    echo 0x18231364 > $DCC_PATH/config
    echo 0x18231368 > $DCC_PATH/config
    echo 0x1823136c > $DCC_PATH/config
    echo 0x18231378 > $DCC_PATH/config
    echo 0x1823137c > $DCC_PATH/config
    echo 0x18231380 > $DCC_PATH/config
    echo 0x1823138c > $DCC_PATH/config
    echo 0x18231390 > $DCC_PATH/config
    echo 0x18231394 > $DCC_PATH/config
    echo 0x182313a0 > $DCC_PATH/config
    echo 0x182313a4 > $DCC_PATH/config
    echo 0x182313a8 > $DCC_PATH/config
}

config_lito_dcc_pimem()
{
    echo 0x610100 11 > $DCC_PATH/config
}

# Function to send ASYNC package in TPDA
lito_dcc_async_package()
{
    echo 0x06004FB0 0xc5acce55 > $DCC_PATH/config_write
    echo 0x0600408c 0xff > $DCC_PATH/config_write
    echo 0x06004FB0 0x0 > $DCC_PATH/config_write
}

# Function lito DCC configuration
enable_lito_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/1022000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    #DCC will trigger in following order LL6 -> LL4 -> LL3
    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 6 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_lito_dcc_lpm
    config_lito_dcc_core
    config_lito_dcc_osm
    config_lito_dcc_gemnoc
    config_lito_dcc_noc
    config_lito_dcc_gcc
    config_lito_dcc_pimem
    config_lito_dcc_ddr

    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_lito_dcc_ddr

    # echo 6 > $DCC_PATH/curr_list
    # echo cap > $DCC_PATH/func_type
    # echo sram > $DCC_PATH/data_sink
    # config_lito_dcc_ddr

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-dcc/enable_source
    echo 3 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo atb > $DCC_PATH/data_sink
    lito_dcc_async_package
    config_lito_dcc_rsc_tcs
    config_lito_dcc_lpass_rsc
    config_lito_dcc_mss_rsc
    config_lito_dcc_l3_rsc

    echo  1 > $DCC_PATH/enable
}

enable_lito_stm_hw_events()
{
   #TODO: Add HW events
}

enable_lito_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to max
    echo 0xffffffff > $CORE_PATH_SILVER/threshold
    echo 0xffffffff > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    echo 0x1 > $CORE_PATH_SILVER/enable
    echo 0x1 > $CORE_PATH_GOLD/enable
}

enable_lito_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to max
    echo 0xffffffff > $CORE_PATH_SILVER/threshold
    echo 0xffffffff > $CORE_PATH_GOLD/threshold

    #To the enable core hang detection
    echo 0x1 > $CORE_PATH_SILVER/enable
    echo 0x1 > $CORE_PATH_GOLD/enable
}


ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
enable_lito_debug()
{
    echo "lito debug"
    srcenable="enable_source"
    sinkenable="enable_sink"
    echo "Enabling STM events on lito."
    enable_stm_events_lito
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing_lito
    fi
    enable_lito_dcc_config
    enable_lito_core_hang_config
    enable_lito_stm_hw_events
}
