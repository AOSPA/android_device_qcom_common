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

enable_kona_tracing_events()
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
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_frequency/enable
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

    #memory pressure events/oom
    echo 1 > /sys/kernel/debug/tracing/events/psi/psi_event/enable
    echo 1 > /sys/kernel/debug/tracing/events/psi/psi_window_vmstat/enable

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_kona_ftrace_event_tracing()
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

    enable_kona_tracing_events
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events_kona()
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
    enable_kona_tracing_events
}

config_kona_dcc_ddr()
{
    #DDR -DCC starts here.
    #Start Link list #6
    #DDRSS
    echo 0x9050078 1 > $DCC_PATH/config
    echo 0x9050110 8 > $DCC_PATH/config
    echo 0x9080058 2 > $DCC_PATH/config
    echo 0x90800C8 1 > $DCC_PATH/config
    echo 0x90800D4 1 > $DCC_PATH/config
    echo 0x90800E0 1 > $DCC_PATH/config
    echo 0x90800EC 1 > $DCC_PATH/config
    echo 0x90800F8 1 > $DCC_PATH/config
    echo 0x908401C 1 > $DCC_PATH/config
    echo 0x908403C 1 > $DCC_PATH/config
    echo 0x908404C 2 > $DCC_PATH/config
    echo 0x90840D4 1 > $DCC_PATH/config
    echo 0x9084204 1 > $DCC_PATH/config
    echo 0x908420C 1 > $DCC_PATH/config
    echo 0x9084250 2 > $DCC_PATH/config
    echo 0x9084260 3 > $DCC_PATH/config
    echo 0x9084280 1 > $DCC_PATH/config
    echo 0x90BA280 1 > $DCC_PATH/config
    echo 0x90BA288 7 > $DCC_PATH/config
    echo 0x9258610 4 > $DCC_PATH/config
    echo 0x92D8610 4 > $DCC_PATH/config
    echo 0x9358610 4 > $DCC_PATH/config
    echo 0x93D8610 4 > $DCC_PATH/config

    # LLCC
    echo 0x9220344 8 > $DCC_PATH/config
    echo 0x9220370 6 > $DCC_PATH/config
    echo 0x9220480 1 > $DCC_PATH/config
    echo 0x9222400 1 > $DCC_PATH/config
    echo 0x922240C 1 > $DCC_PATH/config
    echo 0x9223214 2 > $DCC_PATH/config
    echo 0x9223220 3 > $DCC_PATH/config
    echo 0x9223308 1 > $DCC_PATH/config
    echo 0x9223318 1 > $DCC_PATH/config
    echo 0x9232100 1 > $DCC_PATH/config
    echo 0x9236040 6 > $DCC_PATH/config
    echo 0x92360B0 1 > $DCC_PATH/config
    echo 0x923E030 2 > $DCC_PATH/config
    echo 0x9241000 1 > $DCC_PATH/config
    echo 0x9242028 1 > $DCC_PATH/config
    echo 0x9242044 3 > $DCC_PATH/config
    echo 0x9242070 1 > $DCC_PATH/config
    echo 0x9248030 1 > $DCC_PATH/config
    echo 0x9248048 8 > $DCC_PATH/config
    echo 0x92A0344 8 > $DCC_PATH/config
    echo 0x92A0370 6 > $DCC_PATH/config
    echo 0x92A0480 1 > $DCC_PATH/config
    echo 0x92A2400 1 > $DCC_PATH/config
    echo 0x92A240C 1 > $DCC_PATH/config
    echo 0x92A3214 2 > $DCC_PATH/config
    echo 0x92A3220 3 > $DCC_PATH/config
    echo 0x92A3308 1 > $DCC_PATH/config
    echo 0x92A3318 1 > $DCC_PATH/config
    echo 0x92B2100 1 > $DCC_PATH/config
    echo 0x92B6040 6 > $DCC_PATH/config
    echo 0x92B60B0 1 > $DCC_PATH/config
    echo 0x92BE030 2 > $DCC_PATH/config
    echo 0x92C1000 1 > $DCC_PATH/config
    echo 0x92C2028 1 > $DCC_PATH/config
    echo 0x92C2044 3 > $DCC_PATH/config
    echo 0x92C2070 1 > $DCC_PATH/config
    echo 0x92C8030 1 > $DCC_PATH/config
    echo 0x92C8048 8 > $DCC_PATH/config
    echo 0x9320344 8 > $DCC_PATH/config
    echo 0x9320370 6 > $DCC_PATH/config
    echo 0x9320480 1 > $DCC_PATH/config
    echo 0x9322400 1 > $DCC_PATH/config
    echo 0x932240C 1 > $DCC_PATH/config
    echo 0x9323214 2 > $DCC_PATH/config
    echo 0x9323220 3 > $DCC_PATH/config
    echo 0x9323308 1 > $DCC_PATH/config
    echo 0x9323318 1 > $DCC_PATH/config
    echo 0x9332100 1 > $DCC_PATH/config
    echo 0x9336040 6 > $DCC_PATH/config
    echo 0x93360B0 1 > $DCC_PATH/config
    echo 0x933E030 2 > $DCC_PATH/config
    echo 0x9341000 1 > $DCC_PATH/config
    echo 0x9342028 1 > $DCC_PATH/config
    echo 0x9342044 3 > $DCC_PATH/config
    echo 0x9342070 1 > $DCC_PATH/config
    echo 0x9348030 1 > $DCC_PATH/config
    echo 0x9348048 8 > $DCC_PATH/config
    echo 0x93A0344 8 > $DCC_PATH/config
    echo 0x93A0370 6 > $DCC_PATH/config
    echo 0x93A0480 1 > $DCC_PATH/config
    echo 0x93A2400 1 > $DCC_PATH/config
    echo 0x93A240C 1 > $DCC_PATH/config
    echo 0x93A3214 2 > $DCC_PATH/config
    echo 0x93A3220 3 > $DCC_PATH/config
    echo 0x93A3308 1 > $DCC_PATH/config
    echo 0x93A3318 1 > $DCC_PATH/config
    echo 0x93B2100 1 > $DCC_PATH/config
    echo 0x93B6040 6 > $DCC_PATH/config
    echo 0x93B60B0 1 > $DCC_PATH/config
    echo 0x93BE030 2 > $DCC_PATH/config
    echo 0x93C1000 1 > $DCC_PATH/config
    echo 0x93C2028 1 > $DCC_PATH/config
    echo 0x93C2044 3 > $DCC_PATH/config
    echo 0x93C2070 1 > $DCC_PATH/config
    echo 0x93C8030 1 > $DCC_PATH/config
    echo 0x93C8048 8 > $DCC_PATH/config

    # MC5
    echo 0x9270080 1 > $DCC_PATH/config
    echo 0x9270400 1 > $DCC_PATH/config
    echo 0x9270410 6 > $DCC_PATH/config
    echo 0x9270430 1 > $DCC_PATH/config
    echo 0x9270440 1 > $DCC_PATH/config
    echo 0x9270448 1 > $DCC_PATH/config
    echo 0x92704A0 1 > $DCC_PATH/config
    echo 0x92704B0 1 > $DCC_PATH/config
    echo 0x92704B8 2 > $DCC_PATH/config
    echo 0x92704D0 1 > $DCC_PATH/config
    echo 0x9271400 1 > $DCC_PATH/config
    echo 0x92753B0 1 > $DCC_PATH/config
    echo 0x9275C1C 1 > $DCC_PATH/config
    echo 0x9275C2C 1 > $DCC_PATH/config
    echo 0x9275C38 1 > $DCC_PATH/config
    echo 0x9276418 2 > $DCC_PATH/config
    echo 0x92F0080 1 > $DCC_PATH/config
    echo 0x92F0400 1 > $DCC_PATH/config
    echo 0x92F0410 6 > $DCC_PATH/config
    echo 0x92F0430 1 > $DCC_PATH/config
    echo 0x92F0440 1 > $DCC_PATH/config
    echo 0x92F0448 1 > $DCC_PATH/config
    echo 0x92F04A0 1 > $DCC_PATH/config
    echo 0x92F04B0 1 > $DCC_PATH/config
    echo 0x92F04B8 2 > $DCC_PATH/config
    echo 0x92F04D0 1 > $DCC_PATH/config
    echo 0x92F1400 1 > $DCC_PATH/config
    echo 0x92F53B0 1 > $DCC_PATH/config
    echo 0x92F5C1C 1 > $DCC_PATH/config
    echo 0x92F5C2C 1 > $DCC_PATH/config
    echo 0x92F5C38 1 > $DCC_PATH/config
    echo 0x92F6418 2 > $DCC_PATH/config
    echo 0x9370080 1 > $DCC_PATH/config
    echo 0x9370400 1 > $DCC_PATH/config
    echo 0x9370410 6 > $DCC_PATH/config
    echo 0x9370430 1 > $DCC_PATH/config
    echo 0x9370440 1 > $DCC_PATH/config
    echo 0x9370448 1 > $DCC_PATH/config
    echo 0x93704A0 1 > $DCC_PATH/config
    echo 0x93704B0 1 > $DCC_PATH/config
    echo 0x93704B8 2 > $DCC_PATH/config
    echo 0x93704D0 1 > $DCC_PATH/config
    echo 0x9371400 1 > $DCC_PATH/config
    echo 0x93753B0 1 > $DCC_PATH/config
    echo 0x9375C1C 1 > $DCC_PATH/config
    echo 0x9375C2C 1 > $DCC_PATH/config
    echo 0x9375C38 1 > $DCC_PATH/config
    echo 0x9376418 2 > $DCC_PATH/config
    echo 0x93F0080 1 > $DCC_PATH/config
    echo 0x93F0400 1 > $DCC_PATH/config
    echo 0x93F0410 6 > $DCC_PATH/config
    echo 0x93F0430 1 > $DCC_PATH/config
    echo 0x93F0440 1 > $DCC_PATH/config
    echo 0x93F0448 1 > $DCC_PATH/config
    echo 0x93F04A0 1 > $DCC_PATH/config
    echo 0x93F04B0 1 > $DCC_PATH/config
    echo 0x93F04B8 2 > $DCC_PATH/config
    echo 0x93F04D0 1 > $DCC_PATH/config
    echo 0x93F1400 1 > $DCC_PATH/config
    echo 0x93F53B0 1 > $DCC_PATH/config
    echo 0x93F5C1C 1 > $DCC_PATH/config
    echo 0x93F5C2C 1 > $DCC_PATH/config
    echo 0x93F5C38 1 > $DCC_PATH/config
    echo 0x93F6418 2 > $DCC_PATH/config

    # MC4
    echo 0x9260080 1 > $DCC_PATH/config
    echo 0x9260400 1 > $DCC_PATH/config
    echo 0x9260410 3 > $DCC_PATH/config
    echo 0x9260420 2 > $DCC_PATH/config
    echo 0x9260430 1 > $DCC_PATH/config
    echo 0x9260440 1 > $DCC_PATH/config
    echo 0x9260448 1 > $DCC_PATH/config
    echo 0x92604A0 1 > $DCC_PATH/config
    echo 0x92604B0 1 > $DCC_PATH/config
    echo 0x92604B8 2 > $DCC_PATH/config
    echo 0x92604D0 2 > $DCC_PATH/config
    echo 0x9261400 1 > $DCC_PATH/config
    echo 0x9263410 1 > $DCC_PATH/config
    echo 0x92653B0 1 > $DCC_PATH/config
    echo 0x9265804 1 > $DCC_PATH/config
    echo 0x9265B1C 1 > $DCC_PATH/config
    echo 0x9265B2C 1 > $DCC_PATH/config
    echo 0x9265B38 1 > $DCC_PATH/config
    echo 0x9269100 1 > $DCC_PATH/config
    echo 0x9269110 1 > $DCC_PATH/config
    echo 0x9269120 1 > $DCC_PATH/config
    echo 0x92E0080 1 > $DCC_PATH/config
    echo 0x92E0400 1 > $DCC_PATH/config
    echo 0x92E0410 3 > $DCC_PATH/config
    echo 0x92E0420 2 > $DCC_PATH/config
    echo 0x92E0430 1 > $DCC_PATH/config
    echo 0x92E0440 1 > $DCC_PATH/config
    echo 0x92E0448 1 > $DCC_PATH/config
    echo 0x92E04A0 1 > $DCC_PATH/config
    echo 0x92E04B0 1 > $DCC_PATH/config
    echo 0x92E04B8 2 > $DCC_PATH/config
    echo 0x92E04D0 2 > $DCC_PATH/config
    echo 0x92E1400 1 > $DCC_PATH/config
    echo 0x92E3410 1 > $DCC_PATH/config
    echo 0x92E53B0 1 > $DCC_PATH/config
    echo 0x92E5804 1 > $DCC_PATH/config
    echo 0x92E5B1C 1 > $DCC_PATH/config
    echo 0x92E5B2C 1 > $DCC_PATH/config
    echo 0x92E5B38 1 > $DCC_PATH/config
    echo 0x92E9100 1 > $DCC_PATH/config
    echo 0x92E9110 1 > $DCC_PATH/config
    echo 0x92E9120 1 > $DCC_PATH/config
    echo 0x9360080 1 > $DCC_PATH/config
    echo 0x9360400 1 > $DCC_PATH/config
    echo 0x9360410 3 > $DCC_PATH/config
    echo 0x9360420 2 > $DCC_PATH/config
    echo 0x9360430 1 > $DCC_PATH/config
    echo 0x9360440 1 > $DCC_PATH/config
    echo 0x9360448 1 > $DCC_PATH/config
    echo 0x93604A0 1 > $DCC_PATH/config
    echo 0x93604B0 1 > $DCC_PATH/config
    echo 0x93604B8 2 > $DCC_PATH/config
    echo 0x93604D0 2 > $DCC_PATH/config
    echo 0x9361400 1 > $DCC_PATH/config
    echo 0x9363410 1 > $DCC_PATH/config
    echo 0x93653B0 1 > $DCC_PATH/config
    echo 0x9365804 1 > $DCC_PATH/config
    echo 0x9365B1C 1 > $DCC_PATH/config
    echo 0x9365B2C 1 > $DCC_PATH/config
    echo 0x9365B38 1 > $DCC_PATH/config
    echo 0x9369100 1 > $DCC_PATH/config
    echo 0x9369110 1 > $DCC_PATH/config
    echo 0x9369120 1 > $DCC_PATH/config
    echo 0x93E0080 1 > $DCC_PATH/config
    echo 0x93E0400 1 > $DCC_PATH/config
    echo 0x93E0410 3 > $DCC_PATH/config
    echo 0x93E0420 2 > $DCC_PATH/config
    echo 0x93E0430 1 > $DCC_PATH/config
    echo 0x93E0440 1 > $DCC_PATH/config
    echo 0x93E0448 1 > $DCC_PATH/config
    echo 0x93E04A0 1 > $DCC_PATH/config
    echo 0x93E04B0 1 > $DCC_PATH/config
    echo 0x93E04B8 2 > $DCC_PATH/config
    echo 0x93E04D0 2 > $DCC_PATH/config
    echo 0x93E1400 1 > $DCC_PATH/config
    echo 0x93E3410 1 > $DCC_PATH/config
    echo 0x93E53B0 1 > $DCC_PATH/config
    echo 0x93E5804 1 > $DCC_PATH/config
    echo 0x93E5B1C 1 > $DCC_PATH/config
    echo 0x93E5B2C 1 > $DCC_PATH/config
    echo 0x93E5B38 1 > $DCC_PATH/config
    echo 0x93E9100 1 > $DCC_PATH/config
    echo 0x93E9110 1 > $DCC_PATH/config
    echo 0x93E9120 1 > $DCC_PATH/config

    # DDRPHY
    echo 0x96B0868 1 > $DCC_PATH/config
    echo 0x96B0870 1 > $DCC_PATH/config
    echo 0x96B1004 1 > $DCC_PATH/config
    echo 0x96B100C 1 > $DCC_PATH/config
    echo 0x96B1014 1 > $DCC_PATH/config
    echo 0x96B1204 1 > $DCC_PATH/config
    echo 0x96B120C 1 > $DCC_PATH/config
    echo 0x96B1214 1 > $DCC_PATH/config
    echo 0x96B1504 1 > $DCC_PATH/config
    echo 0x96B150C 1 > $DCC_PATH/config
    echo 0x96B1514 1 > $DCC_PATH/config
    echo 0x96B1604 1 > $DCC_PATH/config
    echo 0x96B8100 1 > $DCC_PATH/config
    echo 0x96B813C 1 > $DCC_PATH/config
    echo 0x96B8500 1 > $DCC_PATH/config
    echo 0x96B853C 1 > $DCC_PATH/config
    echo 0x96B8A04 1 > $DCC_PATH/config
    echo 0x96B8A18 1 > $DCC_PATH/config
    echo 0x96B8EA8 1 > $DCC_PATH/config
    echo 0x96B9044 1 > $DCC_PATH/config
    echo 0x96B904C 1 > $DCC_PATH/config
    echo 0x96B9054 1 > $DCC_PATH/config
    echo 0x96B905C 1 > $DCC_PATH/config
    echo 0x96B910C 2 > $DCC_PATH/config
    echo 0x96B9204 1 > $DCC_PATH/config
    echo 0x96B920C 1 > $DCC_PATH/config
    echo 0x96B9238 1 > $DCC_PATH/config
    echo 0x96B9240 1 > $DCC_PATH/config
    echo 0x96B926C 1 > $DCC_PATH/config
    echo 0x96B9394 1 > $DCC_PATH/config
    echo 0x96B939C 1 > $DCC_PATH/config
    echo 0x96B9704 1 > $DCC_PATH/config
    echo 0x96B970C 1 > $DCC_PATH/config
    echo 0x96F0868 1 > $DCC_PATH/config
    echo 0x96F0870 1 > $DCC_PATH/config
    echo 0x96F1004 1 > $DCC_PATH/config
    echo 0x96F100C 1 > $DCC_PATH/config
    echo 0x96F1014 1 > $DCC_PATH/config
    echo 0x96F1204 1 > $DCC_PATH/config
    echo 0x96F120C 1 > $DCC_PATH/config
    echo 0x96F1214 1 > $DCC_PATH/config
    echo 0x96F1504 1 > $DCC_PATH/config
    echo 0x96F150C 1 > $DCC_PATH/config
    echo 0x96F1514 1 > $DCC_PATH/config
    echo 0x96F1604 1 > $DCC_PATH/config
    echo 0x96F8100 1 > $DCC_PATH/config
    echo 0x96F813C 1 > $DCC_PATH/config
    echo 0x96F8500 1 > $DCC_PATH/config
    echo 0x96F853C 1 > $DCC_PATH/config
    echo 0x96F8A04 1 > $DCC_PATH/config
    echo 0x96F8A18 1 > $DCC_PATH/config
    echo 0x96F8EA8 1 > $DCC_PATH/config
    echo 0x96F9044 1 > $DCC_PATH/config
    echo 0x96F904C 1 > $DCC_PATH/config
    echo 0x96F9054 1 > $DCC_PATH/config
    echo 0x96F905C 1 > $DCC_PATH/config
    echo 0x96F910C 2 > $DCC_PATH/config
    echo 0x96F9204 1 > $DCC_PATH/config
    echo 0x96F920C 1 > $DCC_PATH/config
    echo 0x96F9238 1 > $DCC_PATH/config
    echo 0x96F9240 1 > $DCC_PATH/config
    echo 0x96F926C 1 > $DCC_PATH/config
    echo 0x96F9394 1 > $DCC_PATH/config
    echo 0x96F939C 1 > $DCC_PATH/config
    echo 0x96F9704 1 > $DCC_PATH/config
    echo 0x96F970C 1 > $DCC_PATH/config
    echo 0x9730868 1 > $DCC_PATH/config
    echo 0x9730870 1 > $DCC_PATH/config
    echo 0x9731004 1 > $DCC_PATH/config
    echo 0x973100C 1 > $DCC_PATH/config
    echo 0x9731014 1 > $DCC_PATH/config
    echo 0x9731204 1 > $DCC_PATH/config
    echo 0x973120C 1 > $DCC_PATH/config
    echo 0x9731214 1 > $DCC_PATH/config
    echo 0x9731504 1 > $DCC_PATH/config
    echo 0x973150C 1 > $DCC_PATH/config
    echo 0x9731514 1 > $DCC_PATH/config
    echo 0x9731604 1 > $DCC_PATH/config
    echo 0x9738100 1 > $DCC_PATH/config
    echo 0x973813C 1 > $DCC_PATH/config
    echo 0x9738500 1 > $DCC_PATH/config
    echo 0x973853C 1 > $DCC_PATH/config
    echo 0x9738A04 1 > $DCC_PATH/config
    echo 0x9738A18 1 > $DCC_PATH/config
    echo 0x9738EA8 1 > $DCC_PATH/config
    echo 0x9739044 1 > $DCC_PATH/config
    echo 0x973904C 1 > $DCC_PATH/config
    echo 0x9739054 1 > $DCC_PATH/config
    echo 0x973905C 1 > $DCC_PATH/config
    echo 0x973910C 2 > $DCC_PATH/config
    echo 0x9739204 1 > $DCC_PATH/config
    echo 0x973920C 1 > $DCC_PATH/config
    echo 0x9739238 1 > $DCC_PATH/config
    echo 0x9739240 1 > $DCC_PATH/config
    echo 0x973926C 1 > $DCC_PATH/config
    echo 0x9739394 1 > $DCC_PATH/config
    echo 0x973939C 1 > $DCC_PATH/config
    echo 0x9739704 1 > $DCC_PATH/config
    echo 0x973970C 1 > $DCC_PATH/config
    echo 0x9770868 1 > $DCC_PATH/config
    echo 0x9770870 1 > $DCC_PATH/config
    echo 0x9771004 1 > $DCC_PATH/config
    echo 0x977100C 1 > $DCC_PATH/config
    echo 0x9771014 1 > $DCC_PATH/config
    echo 0x9771204 1 > $DCC_PATH/config
    echo 0x977120C 1 > $DCC_PATH/config
    echo 0x9771214 1 > $DCC_PATH/config
    echo 0x9771504 1 > $DCC_PATH/config
    echo 0x977150C 1 > $DCC_PATH/config
    echo 0x9771514 1 > $DCC_PATH/config
    echo 0x9771604 1 > $DCC_PATH/config
    echo 0x9778100 1 > $DCC_PATH/config
    echo 0x977813C 1 > $DCC_PATH/config
    echo 0x9778500 1 > $DCC_PATH/config
    echo 0x977853C 1 > $DCC_PATH/config
    echo 0x9778A04 1 > $DCC_PATH/config
    echo 0x9778A18 1 > $DCC_PATH/config
    echo 0x9778EA8 1 > $DCC_PATH/config
    echo 0x9779044 1 > $DCC_PATH/config
    echo 0x977904C 1 > $DCC_PATH/config
    echo 0x9779054 1 > $DCC_PATH/config
    echo 0x977905C 1 > $DCC_PATH/config
    echo 0x977910C 2 > $DCC_PATH/config
    echo 0x9779204 1 > $DCC_PATH/config
    echo 0x977920C 1 > $DCC_PATH/config
    echo 0x9779238 1 > $DCC_PATH/config
    echo 0x9779240 1 > $DCC_PATH/config
    echo 0x977926C 1 > $DCC_PATH/config
    echo 0x9779394 1 > $DCC_PATH/config
    echo 0x977939C 1 > $DCC_PATH/config
    echo 0x9779704 1 > $DCC_PATH/config
    echo 0x977970C 1 > $DCC_PATH/config

    # GEMNOC
    echo 0x910D100 3 > $DCC_PATH/config
    echo 0x914D100 3 > $DCC_PATH/config
    echo 0x918D100 4 > $DCC_PATH/config
    echo 0x91A5100 1 > $DCC_PATH/config
    echo 0x91AD100 1 > $DCC_PATH/config
    #End Link list #6
}
config_kona_dcc_gemnoc()
{
    #GemNOC for KONA start
    echo 0x091A9020 1 > $DCC_PATH/config
    echo 0x5 0x1 > $DCC_PATH/rd_mod_wr
    echo 0x09102008 1 > $DCC_PATH/config
    echo 0x2 0x2 > $DCC_PATH/rd_mod_wr
    echo 0x09142008 1 > $DCC_PATH/config
    echo 0x2 0x2 > $DCC_PATH/rd_mod_wr
    echo 0x09102408 1 > $DCC_PATH/config
    echo 0x2 0x2 > $DCC_PATH/rd_mod_wr
    echo 0x09142408 1 > $DCC_PATH/config
    echo 0x2 0x2 > $DCC_PATH/rd_mod_wr

    #Dump Coherent even debug chain
    echo 0x09103808 1 > $DCC_PATH/config
    echo 3 > $DCC_PATH/loop
    echo 0x09103810 1 > $DCC_PATH/config
    echo 0x09103814 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #Dump Non-Coherent Even Chain debug
    echo 0x09103888 1 > $DCC_PATH/config
    echo 2 > $DCC_PATH/loop
    echo 0x09103890 1 > $DCC_PATH/config
    echo 0x09103894 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    # Dump Coherent Odd Chain debug
    echo 0x09143808 1 > $DCC_PATH/config
    echo 3 > $DCC_PATH/loop
    echo 0x09143810 1 > $DCC_PATH/config
    echo 0x09143814 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; Dump Non-Coherent Odd Chain debug
    echo 0x09143888 1 > $DCC_PATH/config
    echo 2 > $DCC_PATH/loop
    echo 0x09143890 1 > $DCC_PATH/config
    echo 0x09143894 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; Dump Coherent Sys Chain debug
    echo 0x09182808 1 > $DCC_PATH/config
    echo 2 > $DCC_PATH/loop
    echo 0x09182810 1 > $DCC_PATH/config
    echo 0x09182814 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; Dump Non-Coherent Sys Chain debug
    echo 0x09182888 1 > $DCC_PATH/config
    echo 3 > $DCC_PATH/loop
    echo 0x09182890 1 > $DCC_PATH/config
    echo 0x09182894 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; llcc0 pos debug Info dump
    echo 0x09103008 1 > $DCC_PATH/config
    echo 0x0910300C 1 > $DCC_PATH/config
    #; llcc0 pos Context Table Info dump - Retrieve context information
    echo 0x09103028 0x00000001 1 > $DCC_PATH/config_write
    echo 41 > $DCC_PATH/loop
    echo 0x09103010 1 > $DCC_PATH/config
    echo 0x09103014 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; llcc2 pos debug info dump
    echo 0x09103408 1 > $DCC_PATH/config
    echo 0x0910340C 1 > $DCC_PATH/config
    #; llcc2 pos Context Table Info dump - Retrieve context information
    echo 0x09103428 0x00000001 1 > $DCC_PATH/config_write
    echo 41 > $DCC_PATH/loop
    echo 0x09103410 1 > $DCC_PATH/config
    echo 0x09103414 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; llcc1 pos debug info dump
    echo 0x09143008 1 > $DCC_PATH/config
    echo 0x0914300C 1 > $DCC_PATH/config
    #; llcc1 pos Context Table Info dump - Retrieve context information
    echo 0x09143028 0x00000001 1 > $DCC_PATH/config_write
    echo 41 > $DCC_PATH/loop
    echo 0x09143010 1 > $DCC_PATH/config
    echo 0x09143014 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; llcc3 pos debug info dump
    echo 0x09143408 1 > $DCC_PATH/config
    echo 0x0914340C 1 > $DCC_PATH/config
    #; llcc3 pos Context Table Info dump - Retrieve context information
    echo 0x09143428 0x00000001 1 > $DCC_PATH/config_write
    echo 41 > $DCC_PATH/loop
    echo 0x09143410 1 > $DCC_PATH/config
    echo 0x09143414 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; PCIe pos debug info dump
    echo 0x09182008 1 > $DCC_PATH/config
    echo 0x0918200C 1 > $DCC_PATH/config
    #; PCIe pos Context Table Info dump - Retrieve context information
    echo 0x09182028 0x00000001 1 > $DCC_PATH/config_write
    echo 11 > $DCC_PATH/loop
    echo 0x09182010 1 > $DCC_PATH/config
    echo 0x09182014 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #; SNoC pos debug info dump
    echo 0x09182408 1 > $DCC_PATH/config
    echo 0x0918240C 1 > $DCC_PATH/config
    #; SNoC pos Context Table Info dump - Retrieve context information
    echo 0x09182428 0x00000001 1 > $DCC_PATH/config_write
    echo 11 > $DCC_PATH/loop
    echo 0x09182410 1 > $DCC_PATH/config
    echo 0x09182414 1 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    #GemNOC for KONA end
}
config_kona_dcc_lpm_pcu()
{
    #PCU -DCC for LPM path
    echo 0x18000024 1 > $DCC_PATH/config
    echo 0x18000040 4 > $DCC_PATH/config
    echo 0x18010024 1 > $DCC_PATH/config
    echo 0x18010040 4 > $DCC_PATH/config
    echo 0x18020024 1 > $DCC_PATH/config
    echo 0x18020040 4 > $DCC_PATH/config
    echo 0x18030024 1 > $DCC_PATH/config
    echo 0x18030040 4 > $DCC_PATH/config
    echo 0x18040024 1 > $DCC_PATH/config
    echo 0x18040040 4 > $DCC_PATH/config
    echo 0x18050024 1 > $DCC_PATH/config
    echo 0x18050040 4 > $DCC_PATH/config
    echo 0x18060024 1 > $DCC_PATH/config
    echo 0x18060040 4 > $DCC_PATH/config
    echo 0x18070024 1 > $DCC_PATH/config
    echo 0x18070040 4 > $DCC_PATH/config
    echo 0x18080024 1 > $DCC_PATH/config
    echo 0x18080040 3 > $DCC_PATH/config
    echo 0x180800F8 1 > $DCC_PATH/config
    echo 0x18080104 1 > $DCC_PATH/config
    echo 0x1808011C 1 > $DCC_PATH/config
    echo 0x18080128 1 > $DCC_PATH/config
}
config_kona_dcc_lpm()
{
    #RSC -DCC for LPM path
    echo 0x18200400 1 > $DCC_PATH/config
    echo 0x18200404 1 > $DCC_PATH/config
    echo 0x18200408 1 > $DCC_PATH/config
    echo 0x18200038 1 > $DCC_PATH/config
    echo 0x18200040 1 > $DCC_PATH/config
    echo 0x18200048 1 > $DCC_PATH/config
    echo 0x18220038 1 > $DCC_PATH/config
    echo 0x18220040 1 > $DCC_PATH/config
    echo 0x182200D0 1 > $DCC_PATH/config
    echo 0x18200030 1 > $DCC_PATH/config
    echo 0x18200010 1 > $DCC_PATH/config

    #RSC -TCS for LPM path
    echo 0x1822000c 1 > $DCC_PATH/config
    echo 0x18220d14 1 > $DCC_PATH/config
    echo 0x18220fb4 1 > $DCC_PATH/config
    echo 0x18221254 1 > $DCC_PATH/config
    echo 0x182214f4 1 > $DCC_PATH/config
    echo 0x18221794 1 > $DCC_PATH/config
    echo 0x18221a34 1 > $DCC_PATH/config
    echo 0x18221cd4 1 > $DCC_PATH/config
    echo 0x18221f74 1 > $DCC_PATH/config
    echo 0x18220d18 1 > $DCC_PATH/config
    echo 0x18220fb8 1 > $DCC_PATH/config
    echo 0x18221258 1 > $DCC_PATH/config
    echo 0x182214f8 1 > $DCC_PATH/config
    echo 0x18221798 1 > $DCC_PATH/config
    echo 0x18221a38 1 > $DCC_PATH/config
    echo 0x18221cd8 1 > $DCC_PATH/config
    echo 0x18221f78 1 > $DCC_PATH/config
    echo 0x18220d00 1 > $DCC_PATH/config
    echo 0x18220d04 1 > $DCC_PATH/config
    echo 0x18220d1c 1 > $DCC_PATH/config
    echo 0x18220fbc 1 > $DCC_PATH/config
    echo 0x1822125c 1 > $DCC_PATH/config
    echo 0x182214fc 1 > $DCC_PATH/config
    echo 0x1822179c 1 > $DCC_PATH/config
    echo 0x18221a3c 1 > $DCC_PATH/config
    echo 0x18221cdc 1 > $DCC_PATH/config
    echo 0x18221f7c 1 > $DCC_PATH/config
    echo 0x18221274 1 > $DCC_PATH/config
    echo 0x18221288 1 > $DCC_PATH/config
    echo 0x1822129c 1 > $DCC_PATH/config
    echo 0x182212b0 1 > $DCC_PATH/config
    echo 0x182212c4 1 > $DCC_PATH/config
    echo 0x182212d8 1 > $DCC_PATH/config
    echo 0x182212ec 1 > $DCC_PATH/config
    echo 0x18221300 1 > $DCC_PATH/config
    echo 0x18221314 1 > $DCC_PATH/config
    echo 0x18221328 1 > $DCC_PATH/config
    echo 0x1822133c 1 > $DCC_PATH/config
    echo 0x18221350 1 > $DCC_PATH/config
    echo 0x18221364 1 > $DCC_PATH/config
    echo 0x18221378 1 > $DCC_PATH/config
    echo 0x1822138c 1 > $DCC_PATH/config
    echo 0x182213a0 1 > $DCC_PATH/config
    echo 0x18221514 1 > $DCC_PATH/config
    echo 0x18221528 1 > $DCC_PATH/config
    echo 0x1822153c 1 > $DCC_PATH/config
    echo 0x18221550 1 > $DCC_PATH/config
    echo 0x18221564 1 > $DCC_PATH/config
    echo 0x18221578 1 > $DCC_PATH/config
    echo 0x1822158c 1 > $DCC_PATH/config
    echo 0x182215a0 1 > $DCC_PATH/config
    echo 0x182215b4 1 > $DCC_PATH/config
    echo 0x182215c8 1 > $DCC_PATH/config
    echo 0x182215dc 1 > $DCC_PATH/config
    echo 0x182215f0 1 > $DCC_PATH/config
    echo 0x18221604 1 > $DCC_PATH/config
    echo 0x18221618 1 > $DCC_PATH/config
    echo 0x1822162c 1 > $DCC_PATH/config
    echo 0x18221640 1 > $DCC_PATH/config
    echo 0x182217b4 1 > $DCC_PATH/config
    echo 0x182217c8 1 > $DCC_PATH/config
    echo 0x182217dc 1 > $DCC_PATH/config
    echo 0x182217f0 1 > $DCC_PATH/config
    echo 0x18221804 1 > $DCC_PATH/config
    echo 0x18221818 1 > $DCC_PATH/config
    echo 0x1822182c 1 > $DCC_PATH/config
    echo 0x18221840 1 > $DCC_PATH/config
    echo 0x18221854 1 > $DCC_PATH/config
    echo 0x18221868 1 > $DCC_PATH/config
    echo 0x1822187c 1 > $DCC_PATH/config
    echo 0x18221890 1 > $DCC_PATH/config
    echo 0x182218a4 1 > $DCC_PATH/config
    echo 0x182218b8 1 > $DCC_PATH/config
    echo 0x182218cc 1 > $DCC_PATH/config
    echo 0x182218e0 1 > $DCC_PATH/config
    echo 0x18221a54 1 > $DCC_PATH/config
    echo 0x18221a68 1 > $DCC_PATH/config
    echo 0x18221a7c 1 > $DCC_PATH/config
    echo 0x18221a90 1 > $DCC_PATH/config
    echo 0x18221aa4 1 > $DCC_PATH/config
    echo 0x18221ab8 1 > $DCC_PATH/config
    echo 0x18221acc 1 > $DCC_PATH/config
    echo 0x18221ae0 1 > $DCC_PATH/config
    echo 0x18221af4 1 > $DCC_PATH/config
    echo 0x18221b08 1 > $DCC_PATH/config
    echo 0x18221b1c 1 > $DCC_PATH/config
    echo 0x18221b30 1 > $DCC_PATH/config
    echo 0x18221b44 1 > $DCC_PATH/config
    echo 0x18221b58 1 > $DCC_PATH/config
    echo 0x18221b6c 1 > $DCC_PATH/config
    echo 0x18221b80 1 > $DCC_PATH/config
    echo 0x18221cf4 1 > $DCC_PATH/config
    echo 0x18221d08 1 > $DCC_PATH/config
    echo 0x18221d1c 1 > $DCC_PATH/config
    echo 0x18221d30 1 > $DCC_PATH/config
    echo 0x18221d44 1 > $DCC_PATH/config
    echo 0x18221d58 1 > $DCC_PATH/config
    echo 0x18221d6c 1 > $DCC_PATH/config
    echo 0x18221d80 1 > $DCC_PATH/config
    echo 0x18221d94 1 > $DCC_PATH/config
    echo 0x18221da8 1 > $DCC_PATH/config
    echo 0x18221dbc 1 > $DCC_PATH/config
    echo 0x18221dd0 1 > $DCC_PATH/config
    echo 0x18221de4 1 > $DCC_PATH/config
    echo 0x18221df8 1 > $DCC_PATH/config
    echo 0x18221e0c 1 > $DCC_PATH/config
    echo 0x18221e20 1 > $DCC_PATH/config
    echo 0x18221f94 1 > $DCC_PATH/config
    echo 0x18221fa8 1 > $DCC_PATH/config
    echo 0x18221fbc 1 > $DCC_PATH/config
    echo 0x18221fd0 1 > $DCC_PATH/config
    echo 0x18221fe4 1 > $DCC_PATH/config
    echo 0x18221ff8 1 > $DCC_PATH/config
    echo 0x1822200c 1 > $DCC_PATH/config
    echo 0x18222020 1 > $DCC_PATH/config
    echo 0x18222034 1 > $DCC_PATH/config
    echo 0x18222048 1 > $DCC_PATH/config
    echo 0x1822205c 1 > $DCC_PATH/config
    echo 0x18222070 1 > $DCC_PATH/config
    echo 0x18222084 1 > $DCC_PATH/config
    echo 0x18222098 1 > $DCC_PATH/config
    echo 0x182220ac 1 > $DCC_PATH/config
    echo 0x182220c0 1 > $DCC_PATH/config
    echo 0x18221278 1 > $DCC_PATH/config
    echo 0x1822128c 1 > $DCC_PATH/config
    echo 0x182212a0 1 > $DCC_PATH/config
    echo 0x182212b4 1 > $DCC_PATH/config
    echo 0x182212c8 1 > $DCC_PATH/config
    echo 0x182212dc 1 > $DCC_PATH/config
    echo 0x182212f0 1 > $DCC_PATH/config
    echo 0x18221304 1 > $DCC_PATH/config
    echo 0x18221318 1 > $DCC_PATH/config
    echo 0x1822132c 1 > $DCC_PATH/config
    echo 0x18221340 1 > $DCC_PATH/config
    echo 0x18221354 1 > $DCC_PATH/config
    echo 0x18221368 1 > $DCC_PATH/config
    echo 0x1822137c 1 > $DCC_PATH/config
    echo 0x18221390 1 > $DCC_PATH/config
    echo 0x182213a4 1 > $DCC_PATH/config
    echo 0x18221518 1 > $DCC_PATH/config
    echo 0x1822152c 1 > $DCC_PATH/config
    echo 0x18221540 1 > $DCC_PATH/config
    echo 0x18221554 1 > $DCC_PATH/config
    echo 0x18221568 1 > $DCC_PATH/config
    echo 0x1822157c 1 > $DCC_PATH/config
    echo 0x18221590 1 > $DCC_PATH/config
    echo 0x182215a4 1 > $DCC_PATH/config
    echo 0x182215b8 1 > $DCC_PATH/config
    echo 0x182215cc 1 > $DCC_PATH/config
    echo 0x182215e0 1 > $DCC_PATH/config
    echo 0x182215f4 1 > $DCC_PATH/config
    echo 0x18221608 1 > $DCC_PATH/config
    echo 0x1822161c 1 > $DCC_PATH/config
    echo 0x18221630 1 > $DCC_PATH/config
    echo 0x18221644 1 > $DCC_PATH/config
    echo 0x182217b8 1 > $DCC_PATH/config
    echo 0x182217cc 1 > $DCC_PATH/config
    echo 0x182217e0 1 > $DCC_PATH/config
    echo 0x182217f4 1 > $DCC_PATH/config
    echo 0x18221808 1 > $DCC_PATH/config
    echo 0x1822181c 1 > $DCC_PATH/config
    echo 0x18221830 1 > $DCC_PATH/config
    echo 0x18221844 1 > $DCC_PATH/config
    echo 0x18221858 1 > $DCC_PATH/config
    echo 0x1822186c 1 > $DCC_PATH/config
    echo 0x18221880 1 > $DCC_PATH/config
    echo 0x18221894 1 > $DCC_PATH/config
    echo 0x182218a8 1 > $DCC_PATH/config
    echo 0x182218bc 1 > $DCC_PATH/config
    echo 0x182218d0 1 > $DCC_PATH/config
    echo 0x182218e4 1 > $DCC_PATH/config
    echo 0x18221a58 1 > $DCC_PATH/config
    echo 0x18221a6c 1 > $DCC_PATH/config
    echo 0x18221a80 1 > $DCC_PATH/config
    echo 0x18221a94 1 > $DCC_PATH/config
    echo 0x18221aa8 1 > $DCC_PATH/config
    echo 0x18221abc 1 > $DCC_PATH/config
    echo 0x18221ad0 1 > $DCC_PATH/config
    echo 0x18221ae4 1 > $DCC_PATH/config
    echo 0x18221af8 1 > $DCC_PATH/config
    echo 0x18221b0c 1 > $DCC_PATH/config
    echo 0x18221b20 1 > $DCC_PATH/config
    echo 0x18221b34 1 > $DCC_PATH/config
    echo 0x18221b48 1 > $DCC_PATH/config
    echo 0x18221b5c 1 > $DCC_PATH/config
    echo 0x18221b70 1 > $DCC_PATH/config
    echo 0x18221b84 1 > $DCC_PATH/config
    echo 0x18221cf8 1 > $DCC_PATH/config
    echo 0x18221d0c 1 > $DCC_PATH/config
    echo 0x18221d20 1 > $DCC_PATH/config
    echo 0x18221d34 1 > $DCC_PATH/config
    echo 0x18221d48 1 > $DCC_PATH/config
    echo 0x18221d5c 1 > $DCC_PATH/config
    echo 0x18221d70 1 > $DCC_PATH/config
    echo 0x18221d84 1 > $DCC_PATH/config
    echo 0x18221d98 1 > $DCC_PATH/config
    echo 0x18221dac 1 > $DCC_PATH/config
    echo 0x18221dc0 1 > $DCC_PATH/config
    echo 0x18221dd4 1 > $DCC_PATH/config
    echo 0x18221de8 1 > $DCC_PATH/config
    echo 0x18221dfc 1 > $DCC_PATH/config
    echo 0x18221e10 1 > $DCC_PATH/config
    echo 0x18221e24 1 > $DCC_PATH/config
    echo 0x18221f98 1 > $DCC_PATH/config
    echo 0x18221fac 1 > $DCC_PATH/config
    echo 0x18221fc0 1 > $DCC_PATH/config
    echo 0x18221fd4 1 > $DCC_PATH/config
    echo 0x18221fe8 1 > $DCC_PATH/config
    echo 0x18221ffc 1 > $DCC_PATH/config
    echo 0x18222010 1 > $DCC_PATH/config
    echo 0x18222024 1 > $DCC_PATH/config
    echo 0x18222038 1 > $DCC_PATH/config
    echo 0x1822204c 1 > $DCC_PATH/config
    echo 0x18222060 1 > $DCC_PATH/config
    echo 0x18222074 1 > $DCC_PATH/config
    echo 0x18222088 1 > $DCC_PATH/config
    echo 0x1822209c 1 > $DCC_PATH/config
    echo 0x182220b0 1 > $DCC_PATH/config
    echo 0x182220c4 1 > $DCC_PATH/config

}

config_kona_dcc_core()
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
    echo 0x18296098 1 > $DCC_PATH/config
}

config_kona_dcc_edu()
{
    echo 0x088E1014 1 > $DCC_PATH/config
    echo 0x088E2000 1 > $DCC_PATH/config
}
#config_kona_dcc_tcs()
#{
    #TCS
    #echo 0x18220D14 3 > $DCC_PATH/config
    #echo 0x18220D30 4 > $DCC_PATH/config
    #echo 0x18220D44 4 > $DCC_PATH/config
    #echo 0x18220D58 4 > $DCC_PATH/config
    #echo 0x18220FB4 3 > $DCC_PATH/config
    #echo 0x18220FD0 4 > $DCC_PATH/config
    #echo 0x18220FE4 4 > $DCC_PATH/config
    #echo 0x18220FF8 4 > $DCC_PATH/config
    #echo 0x18220D04 1 > $DCC_PATH/config
    #echo 0x18220D00 1 > $DCC_PATH/config
#}
config_kona_dcc_sys_agnoc_error()
{
    #Agnoc Error syndrome start
    echo 0x16E0010 1 > $DCC_PATH/config
    echo 0x16E0020 1 > $DCC_PATH/config
    echo 0x16E0024 1 > $DCC_PATH/config
    echo 0x16E0028 1 > $DCC_PATH/config
    echo 0x16E002C 1 > $DCC_PATH/config
    echo 0x16E0030 1 > $DCC_PATH/config
    echo 0x16E0034 1 > $DCC_PATH/config
    echo 0x16E0038 1 > $DCC_PATH/config
    echo 0x16E003C 1 > $DCC_PATH/config
    echo 0x16E0248 1 > $DCC_PATH/config
    echo 0x1700010 1 > $DCC_PATH/config
    echo 0x1700020 1 > $DCC_PATH/config
    echo 0x1700024 1 > $DCC_PATH/config
    echo 0x1700028 1 > $DCC_PATH/config
    echo 0x170002C 1 > $DCC_PATH/config
    echo 0x1700030 1 > $DCC_PATH/config
    echo 0x1700034 1 > $DCC_PATH/config
    echo 0x1700038 1 > $DCC_PATH/config
    echo 0x170003C 1 > $DCC_PATH/config
    echo 0x1700448 1 > $DCC_PATH/config
    #Agnoc Error syndrome end

    #DCNOC Error Start
    echo 0x90C0010 1 > $DCC_PATH/config
    echo 0x90C0020 1 > $DCC_PATH/config
    echo 0x90C0024 1 > $DCC_PATH/config
    echo 0x90C0028 1 > $DCC_PATH/config
    echo 0x90C002C 1 > $DCC_PATH/config
    echo 0x90C0030 1 > $DCC_PATH/config
    echo 0x90C0034 1 > $DCC_PATH/config
    echo 0x90C0038 1 > $DCC_PATH/config
    echo 0x90C003C 1 > $DCC_PATH/config
    echo 0x90C0248 1 > $DCC_PATH/config
    #DCNOC Error End

    #MNOC Error Start
    echo 0x1740010 1 > $DCC_PATH/config
    echo 0x1740020 1 > $DCC_PATH/config
    echo 0x1740024 1 > $DCC_PATH/config
    echo 0x1740028 1 > $DCC_PATH/config
    echo 0x174002C 1 > $DCC_PATH/config
    echo 0x1740030 1 > $DCC_PATH/config
    echo 0x1740034 1 > $DCC_PATH/config
    echo 0x1740038 1 > $DCC_PATH/config
    echo 0x174003C 1 > $DCC_PATH/config
    echo 0x1740248 1 > $DCC_PATH/config
    #MNOC Error End

    #CNOC Error Start
    echo 0x1500010 1 > $DCC_PATH/config
    echo 0x1500020 1 > $DCC_PATH/config
    echo 0x1500024 1 > $DCC_PATH/config
    echo 0x1500028 1 > $DCC_PATH/config
    echo 0x150002C 1 > $DCC_PATH/config
    echo 0x1500030 1 > $DCC_PATH/config
    echo 0x1500034 1 > $DCC_PATH/config
    echo 0x1500038 1 > $DCC_PATH/config
    echo 0x150003C 1 > $DCC_PATH/config
    echo 0x1500248 1 > $DCC_PATH/config
    echo 0x150024C 1 > $DCC_PATH/config
    echo 0x1500448 1 > $DCC_PATH/config
    #CNOC Error End

    #sysNOC Error Start
    echo 0x1620010 1 > $DCC_PATH/config
    echo 0x1620018 1 > $DCC_PATH/config
    echo 0x1620020 1 > $DCC_PATH/config
    echo 0x1620024 1 > $DCC_PATH/config
    echo 0x1620028 1 > $DCC_PATH/config
    echo 0x162002C 1 > $DCC_PATH/config
    echo 0x1620030 1 > $DCC_PATH/config
    echo 0x1620034 1 > $DCC_PATH/config
    echo 0x1620038 1 > $DCC_PATH/config
    echo 0x162003C 1 > $DCC_PATH/config
    echo 0x1620248 1 > $DCC_PATH/config
    #sysNOC Error End
}

config_kona_dcc_sys_agnoc()
{
    #SYSNOC start
    echo 0x162C100 1 > $DCC_PATH/config
    echo 0x162C104 1 > $DCC_PATH/config
    echo 0x162C108 1 > $DCC_PATH/config
    echo 0x162C10C 1 > $DCC_PATH/config
    echo 0x162C300 1 > $DCC_PATH/config
    echo 0x162C304 1 > $DCC_PATH/config
    echo 0x162C308 1 > $DCC_PATH/config
    echo 0x162C30C 1 > $DCC_PATH/config
    echo 0x162C500 1 > $DCC_PATH/config
    echo 0x162C504 1 > $DCC_PATH/config
    echo 0x162C700 1 > $DCC_PATH/config
    echo 0x162C900 1 > $DCC_PATH/config
    #SYSNOC End

    #AGNOC start
    echo 0x16E0300 1 > $DCC_PATH/config
    echo 0x16E0304 1 > $DCC_PATH/config
    echo 0x16E0308 1 > $DCC_PATH/config
    echo 0x16E030C 1 > $DCC_PATH/config
    echo 0x16E0310 1 > $DCC_PATH/config
    echo 0x16E0700 1 > $DCC_PATH/config
    echo 0x1700500 1 > $DCC_PATH/config
    echo 0x1700504 1 > $DCC_PATH/config
    echo 0x1700508 1 > $DCC_PATH/config
    echo 0x170050C 1 > $DCC_PATH/config
    echo 0x1700900 1 > $DCC_PATH/config
    echo 0x1700904 1 > $DCC_PATH/config
    echo 0x1700908 1 > $DCC_PATH/config
    echo 0x1700B00 1 > $DCC_PATH/config
    echo 0x1700B04 1 > $DCC_PATH/config
    #AGNOC End

    #cdspnoc start
    echo 0x1700D00 1 > $DCC_PATH/config
    echo 0x1700D04 1 > $DCC_PATH/config
    echo 0x1700D08 1 > $DCC_PATH/config
    echo 0x1700D0C 1 > $DCC_PATH/config
    #End

    #DCNOC Start
    echo 0x90C4100 1 > $DCC_PATH/config
    echo 0x90C4104 1 > $DCC_PATH/config
    echo 0x90C4108 1 > $DCC_PATH/config
    echo 0x90C410C 1 > $DCC_PATH/config
    echo 0x90C4110 1 > $DCC_PATH/config
    echo 0x90C4114 1 > $DCC_PATH/config
    #DCNOC End

    #MNOC Start
    echo 0x1740300 1 > $DCC_PATH/config
    echo 0x1740304 1 > $DCC_PATH/config
    echo 0x1740308 1 > $DCC_PATH/config
    echo 0x174030C 1 > $DCC_PATH/config
    echo 0x1740310 1 > $DCC_PATH/config
    echo 0x1740314 1 > $DCC_PATH/config
    echo 0x1740318 1 > $DCC_PATH/config
    echo 0x174031C 1 > $DCC_PATH/config
    #MNOC End

    #CNOC Start
    echo 0x1501100 1 > $DCC_PATH/config
    echo 0x1501104 1 > $DCC_PATH/config
    echo 0x1501108 1 > $DCC_PATH/config
    echo 0x1501300 1 > $DCC_PATH/config
    echo 0x1501500 1 > $DCC_PATH/config
    echo 0x1501700 1 > $DCC_PATH/config
    echo 0x1501704 1 > $DCC_PATH/config
    echo 0x1501708 1 > $DCC_PATH/config
    echo 0x1501900 1 > $DCC_PATH/config
    echo 0x1501904 1 > $DCC_PATH/config
    echo 0x1501908 1 > $DCC_PATH/config
    echo 0x1501D00 1 > $DCC_PATH/config
    echo 0x1501D04 1 > $DCC_PATH/config
    echo 0x1501F00 1 > $DCC_PATH/config
    echo 0x1501F04 1 > $DCC_PATH/config
    #CNOC End

}
# Function to send ASYNC package in TPDA
kona_dcc_async_package()
{
    echo 0x06004FB0 0xc5acce55 > $DCC_PATH/config_write
    echo 0x0600408c 0xff > $DCC_PATH/config_write
    echo 0x06004FB0 0x0 > $DCC_PATH/config_write
}

# Function kona DCC configuration
enable_kona_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/1023000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 6 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    #config_kona_dcc_tcs
    config_kona_dcc_core
    config_kona_dcc_gemnoc
    config_kona_dcc_sys_agnoc
    config_kona_dcc_edu
    config_kona_dcc_lpm_pcu
    config_kona_dcc_ddr

    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_kona_dcc_ddr

    #echo 7 > $DCC_PATH/curr_list
    #echo cap > $DCC_PATH/func_type
    #echo sram > $DCC_PATH/data_sink
    #config_kona_dcc_ddr

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-dcc/enable_source
    echo 3 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo atb > $DCC_PATH/data_sink
    kona_dcc_async_package
    config_kona_dcc_lpm
    config_kona_dcc_sys_agnoc_error

    echo  1 > $DCC_PATH/enable
}

enable_kona_stm_hw_events()
{
   #TODO: Add HW events
}

enable_kona_core_hang_config()
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

    #To the enable core hang detection.
    #It's a boolean variable. DO NOT USE HEX values to enable/disable.
    echo 1 > $CORE_PATH_SILVER/enable
    echo 1 > $CORE_PATH_GOLD/enable
}

ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
enable_kona_debug()
{
    echo "kona debug"
    srcenable="enable_source"
    sinkenable="enable_sink"
    echo "Enabling STM events on kona."
    enable_stm_events_kona
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_kona_ftrace_event_tracing
    fi
    enable_kona_dcc_config
    enable_kona_stm_hw_events
}
