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

enable_tracing_events()
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
    # sound
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_read/enable
    echo 1 > /sys/kernel/debug/tracing/events/asoc/snd_soc_reg_write/enable
    # mdp
    echo 1 > /sys/kernel/debug/tracing/events/mdss/mdp_video_underrun_done/enable
    # video
    echo 1 > /sys/kernel/debug/tracing/events/msm_vidc/enable
    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_enable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_disable/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable
    # power
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_offline/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_core_online/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_pre_frequency_mit/enable
    echo 1 > /sys/kernel/debug/tracing/events/thermal/thermal_post_frequency_mit/enable

    #rmph_send_msg
    echo 1 > /sys/kernel/debug/tracing/events/rpmh/rpmh_send_msg/enable

    #enable aop with timestamps
    echo 33 0x680000 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    echo 48 0xC0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/mcmb_lanes_select
    echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_mode
    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_trig_ts
    echo 1 >  /sys/bus/coresight/devices/coresight-tpdm-swao-0/enable_source
    echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigin
    echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigout

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_ftrace_event_tracing()
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

    enable_tracing_events
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events_msmnile()
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

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/mem_size
    echo sg > /sys/bus/coresight/devices/coresight-tmc-etr/mem_type
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable_tracing_events
}

# Function msmnile DCC configuration
enable_msmnile_dcc_config()
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


    #TCS
    echo 0x18220D14 3 > $DCC_PATH/config
    echo 0x18220D30 4 > $DCC_PATH/config
    echo 0x18220D44 4 > $DCC_PATH/config
    echo 0x18220D58 4 > $DCC_PATH/config
    echo 0x18220FB4 3 > $DCC_PATH/config
    echo 0x18220FD0 4 > $DCC_PATH/config
    echo 0x18220FE4 4 > $DCC_PATH/config
    echo 0x18220FF8 4 > $DCC_PATH/config
    echo 0x18220D04 1 > $DCC_PATH/config
    echo 0x18220D00 1 > $DCC_PATH/config

    #RSC_PDC_PCU
    echo 0x18000024 1 > $DCC_PATH/config
    echo 0x18000040 3 > $DCC_PATH/config
    echo 0x18010024 1 > $DCC_PATH/config
    echo 0x18010040 3 > $DCC_PATH/config
    echo 0x18020024 1 > $DCC_PATH/config
    echo 0x18020040 3 > $DCC_PATH/config
    echo 0x18030024 1 > $DCC_PATH/config
    echo 0x18030040 3 > $DCC_PATH/config
    echo 0x18040024 1 > $DCC_PATH/config
    echo 0x18040040 3 > $DCC_PATH/config
    echo 0x18050024 1 > $DCC_PATH/config
    echo 0x18050040 3 > $DCC_PATH/config
    echo 0x18060024 1 > $DCC_PATH/config
    echo 0x18060040 3 > $DCC_PATH/config
    echo 0x18070024 1 > $DCC_PATH/config
    echo 0x18070040 3 > $DCC_PATH/config
    echo 0x18080104 1 > $DCC_PATH/config
    echo 0x18080168 1 > $DCC_PATH/config
    echo 0x18080198 1 > $DCC_PATH/config
    echo 0x18080128 1 > $DCC_PATH/config
    echo 0x18080024 1 > $DCC_PATH/config
    echo 0x18080040 3 > $DCC_PATH/config
    echo 0x18200400 3 > $DCC_PATH/config
    echo 0x0B201020 2 > $DCC_PATH/config

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
    echo 0x18393500 80 > $DCC_PATH/config
    echo 0x183A3500 80 > $DCC_PATH/config

    #APSS_OSM
    echo 0x18321700 13 > $DCC_PATH/config
    echo 0x18321744    > $DCC_PATH/config
    echo 0x18321780    > $DCC_PATH/config
    echo 0x18321804 16 > $DCC_PATH/config
    echo 0x18321920    > $DCC_PATH/config
    echo 0x18322c14 2  > $DCC_PATH/config
    echo 0x18322d70    > $DCC_PATH/config
    echo 0x18322d88    > $DCC_PATH/config
    echo 0x18323700 13 > $DCC_PATH/config
    echo 0x18323744    > $DCC_PATH/config
    echo 0x18323780    > $DCC_PATH/config
    echo 0x18323804 16 > $DCC_PATH/config
    echo 0x18323920    > $DCC_PATH/config
    echo 0x18324c14 2  > $DCC_PATH/config
    echo 0x18324d70    > $DCC_PATH/config
    echo 0x18324d88    > $DCC_PATH/config
    echo 0x18325f00 13 > $DCC_PATH/config
    echo 0x18325f44    > $DCC_PATH/config
    echo 0x18325f80    > $DCC_PATH/config
    echo 0x18326004 16 > $DCC_PATH/config
    echo 0x18326120    > $DCC_PATH/config
    echo 0x18327414 2  > $DCC_PATH/config
    echo 0x18327570    > $DCC_PATH/config
    echo 0x18327588    > $DCC_PATH/config
    echo 0x18327f00 13 > $DCC_PATH/config
    echo 0x18327f44    > $DCC_PATH/config
    echo 0x18327f80    > $DCC_PATH/config
    echo 0x18328004 16 > $DCC_PATH/config
    echo 0x18328120    > $DCC_PATH/config
    echo 0x18329414 2  > $DCC_PATH/config
    echo 0x18329570    > $DCC_PATH/config
    echo 0x18329588    > $DCC_PATH/config

    #DDRSS
    #SHRM CSR
    echo 0x09050008 1 > $DCC_PATH/config
    echo 0x09050078 1 > $DCC_PATH/config

    #LLCC/CABO
    echo 0x09601000 2 > $DCC_PATH/config
    echo 0x09232100 1 > $DCC_PATH/config
    echo 0x092360B0 1 > $DCC_PATH/config
    echo 0x09236044 4 > $DCC_PATH/config
    echo 0x09241000 1 > $DCC_PATH/config
    echo 0x09242028 1 > $DCC_PATH/config
    echo 0x09260410 3 > $DCC_PATH/config
    echo 0x09260420 2 > $DCC_PATH/config
    echo 0x09260430 1 > $DCC_PATH/config
    echo 0x09260440 1 > $DCC_PATH/config
    echo 0x09260448 1 > $DCC_PATH/config
    echo 0x092604A0 1 > $DCC_PATH/config
    echo 0x092B2100 1 > $DCC_PATH/config
    echo 0x092B60B0 1 > $DCC_PATH/config
    echo 0x092B6044 4 > $DCC_PATH/config
    echo 0x092C1000 1 > $DCC_PATH/config
    echo 0x092C2028 1 > $DCC_PATH/config
    echo 0x092E0410 3 > $DCC_PATH/config
    echo 0x092E0420 2 > $DCC_PATH/config
    echo 0x092E0430 1 > $DCC_PATH/config
    echo 0x092E0440 1 > $DCC_PATH/config
    echo 0x092E0448 1 > $DCC_PATH/config
    echo 0x092E04A0 1 > $DCC_PATH/config
    echo 0x09332100 1 > $DCC_PATH/config
    echo 0x093360B0 1 > $DCC_PATH/config
    echo 0x09336044 4 > $DCC_PATH/config
    echo 0x09341000 1 > $DCC_PATH/config
    echo 0x09342028 1 > $DCC_PATH/config
    echo 0x09360410 3 > $DCC_PATH/config
    echo 0x09360420 2 > $DCC_PATH/config
    echo 0x09360430 1 > $DCC_PATH/config
    echo 0x09360440 2 > $DCC_PATH/config
    echo 0x09360448 1 > $DCC_PATH/config
    echo 0x093604A0 1 > $DCC_PATH/config
    echo 0x093B2100 1 > $DCC_PATH/config
    echo 0x093B60B0 1 > $DCC_PATH/config
    echo 0x093B6044 4 > $DCC_PATH/config
    echo 0x093C1000 1 > $DCC_PATH/config
    echo 0x093C2028 1 > $DCC_PATH/config
    echo 0x093E0410 3 > $DCC_PATH/config
    echo 0x093E0420 2 > $DCC_PATH/config
    echo 0x093E0430 1 > $DCC_PATH/config
    echo 0x093E0440 1 > $DCC_PATH/config
    echo 0x093E0448 1 > $DCC_PATH/config
    echo 0x093E04A0 1 > $DCC_PATH/config
    echo 0x09601000 1 > $DCC_PATH/config
    echo 0x09601004 1 > $DCC_PATH/config
    echo 0x09602000 1 > $DCC_PATH/config
    echo 0x09602004 1 > $DCC_PATH/config
    echo 0x09603000 1 > $DCC_PATH/config
    echo 0x09603004 1 > $DCC_PATH/config
    echo 0x09604000 1 > $DCC_PATH/config
    echo 0x09604004 1 > $DCC_PATH/config
    echo 0x09605000 1 > $DCC_PATH/config
    echo 0x09605004 1 > $DCC_PATH/config
    echo 0x09606000 1 > $DCC_PATH/config
    echo 0x09606004 1 > $DCC_PATH/config
    echo 0x09607000 1 > $DCC_PATH/config
    echo 0x09607004 1 > $DCC_PATH/config
    echo 0x09608000 1 > $DCC_PATH/config
    echo 0x09608004 1 > $DCC_PATH/config
    echo 0x09609000 1 > $DCC_PATH/config
    echo 0x09609004 1 > $DCC_PATH/config
    echo 0x0960a000 1 > $DCC_PATH/config
    echo 0x0960a004 1 > $DCC_PATH/config
    echo 0x0960b000 1 > $DCC_PATH/config
    echo 0x0960b004 1 > $DCC_PATH/config
    echo 0x0960c000 1 > $DCC_PATH/config
    echo 0x0960c004 1 > $DCC_PATH/config
    echo 0x0960d000 1 > $DCC_PATH/config
    echo 0x0960d004 1 > $DCC_PATH/config
    echo 0x0960e000 1 > $DCC_PATH/config
    echo 0x0960e004 1 > $DCC_PATH/config
    echo 0x0960f000 1 > $DCC_PATH/config
    echo 0x0960f004 1 > $DCC_PATH/config
    echo 0x09610000 1 > $DCC_PATH/config
    echo 0x09610004 1 > $DCC_PATH/config
    echo 0x09611000 1 > $DCC_PATH/config
    echo 0x09611004 1 > $DCC_PATH/config
    echo 0x09612000 1 > $DCC_PATH/config
    echo 0x09612004 1 > $DCC_PATH/config
    echo 0x09613000 1 > $DCC_PATH/config
    echo 0x09613004 1 > $DCC_PATH/config
    echo 0x09614000 1 > $DCC_PATH/config
    echo 0x09614004 1 > $DCC_PATH/config
    echo 0x09615000 1 > $DCC_PATH/config
    echo 0x09615004 1 > $DCC_PATH/config
    echo 0x09616000 1 > $DCC_PATH/config
    echo 0x09616004 1 > $DCC_PATH/config
    echo 0x09617000 1 > $DCC_PATH/config
    echo 0x09617004 1 > $DCC_PATH/config
    echo 0x09618000 1 > $DCC_PATH/config
    echo 0x09618004 1 > $DCC_PATH/config
    echo 0x09619000 1 > $DCC_PATH/config
    echo 0x09619004 1 > $DCC_PATH/config
    echo 0x0961a000 1 > $DCC_PATH/config
    echo 0x0961a004 1 > $DCC_PATH/config
    echo 0x0961b000 1 > $DCC_PATH/config
    echo 0x0961b004 1 > $DCC_PATH/config
    echo 0x0961c000 1 > $DCC_PATH/config
    echo 0x0961c004 1 > $DCC_PATH/config
    echo 0x0961d000 1 > $DCC_PATH/config
    echo 0x0961d004 1 > $DCC_PATH/config
    echo 0x0961e000 1 > $DCC_PATH/config
    echo 0x0961e004 1 > $DCC_PATH/config
    echo 0x0961f000 1 > $DCC_PATH/config
    echo 0x0961f004 1 > $DCC_PATH/config

    #SHRM
    echo 0x06A0E00C 0x00600007 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x00136800 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136810 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136820 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136830 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136840 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136850 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136860 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x00136870 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003e9a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003c0a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003d1a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003d2a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003d5a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003d6a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003e8a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003eea0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003b1a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003b2a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003b5a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003b6a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003c2a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003c5a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E01C 0x0003c6a0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06A0E014 1 1 > $DCC_PATH/config
    echo 0x06A0E014 0x00020B38 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x000368B0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x00000BA8 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x0013B6A0 1 > $DCC_PATH/config_write
    echo 0x06A0E01C 0x00F1E000 1 > $DCC_PATH/config_write
    echo 0x06A0E008 0x00000007 1 > $DCC_PATH/config_write
    echo 0x906E7E00 124 > $DCC_PATH/config

    echo  1 > $DCC_PATH/enable
}

enable_msmnile_stm_hw_events()
{
   #TODO: Add HW events
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
enable_msmnile_debug()
{
    echo "msmnile debug"
    srcenable="enable_source"
    sinkenable="enable_sink"
    echo "Enabling STM events on msmnile."
    enable_stm_events_msmnile
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing
    fi
    enable_msmnile_dcc_config
    enable_msmnile_stm_hw_events
}
