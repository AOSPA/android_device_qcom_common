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
    echo 0x9270310 1 > $DCC_PATH/config
    echo 0x9270400 1 > $DCC_PATH/config
    echo 0x9270410 6 > $DCC_PATH/config
    echo 0x9270430 1 > $DCC_PATH/config
    echo 0x9270440 1 > $DCC_PATH/config
    echo 0x9270448 1 > $DCC_PATH/config
    echo 0x92704A0 1 > $DCC_PATH/config
    echo 0x92704B0 1 > $DCC_PATH/config
    echo 0x92704B8 2 > $DCC_PATH/config
    echo 0x92704D0 2 > $DCC_PATH/config
    echo 0x9271400 1 > $DCC_PATH/config
    echo 0x9273410 1 > $DCC_PATH/config
    echo 0x92753B0 1 > $DCC_PATH/config
    echo 0x9275804 1 > $DCC_PATH/config
    echo 0x9275C1C 1 > $DCC_PATH/config
    echo 0x9275C2C 1 > $DCC_PATH/config
    echo 0x9275C38 1 > $DCC_PATH/config
    echo 0x9276418 2 > $DCC_PATH/config
    echo 0x9279100 1 > $DCC_PATH/config
    echo 0x9279110 1 > $DCC_PATH/config
    echo 0x9279120 1 > $DCC_PATH/config
    echo 0x9279180 2 > $DCC_PATH/config
    echo 0x92F0080 1 > $DCC_PATH/config
    echo 0x92F0310 1 > $DCC_PATH/config
    echo 0x92F0400 1 > $DCC_PATH/config
    echo 0x92F0410 6 > $DCC_PATH/config
    echo 0x92F0430 1 > $DCC_PATH/config
    echo 0x92F0440 1 > $DCC_PATH/config
    echo 0x92F0448 1 > $DCC_PATH/config
    echo 0x92F04A0 1 > $DCC_PATH/config
    echo 0x92F04B0 1 > $DCC_PATH/config
    echo 0x92F04B8 2 > $DCC_PATH/config
    echo 0x92F04D0 2 > $DCC_PATH/config
    echo 0x92F1400 1 > $DCC_PATH/config
    echo 0x92F3410 1 > $DCC_PATH/config
    echo 0x92F53B0 1 > $DCC_PATH/config
    echo 0x92F5804 1 > $DCC_PATH/config
    echo 0x92F5C1C 1 > $DCC_PATH/config
    echo 0x92F5C2C 1 > $DCC_PATH/config
    echo 0x92F5C38 1 > $DCC_PATH/config
    echo 0x92F6418 2 > $DCC_PATH/config
    echo 0x92F9100 1 > $DCC_PATH/config
    echo 0x92F9110 1 > $DCC_PATH/config
    echo 0x92F9120 1 > $DCC_PATH/config
    echo 0x92F9180 2 > $DCC_PATH/config
    echo 0x9370080 1 > $DCC_PATH/config
    echo 0x9370310 1 > $DCC_PATH/config
    echo 0x9370400 1 > $DCC_PATH/config
    echo 0x9370410 6 > $DCC_PATH/config
    echo 0x9370430 1 > $DCC_PATH/config
    echo 0x9370440 1 > $DCC_PATH/config
    echo 0x9370448 1 > $DCC_PATH/config
    echo 0x93704A0 1 > $DCC_PATH/config
    echo 0x93704B0 1 > $DCC_PATH/config
    echo 0x93704B8 2 > $DCC_PATH/config
    echo 0x93704D0 2 > $DCC_PATH/config
    echo 0x9371400 1 > $DCC_PATH/config
    echo 0x9373410 1 > $DCC_PATH/config
    echo 0x93753B0 1 > $DCC_PATH/config
    echo 0x9375804 1 > $DCC_PATH/config
    echo 0x9375C1C 1 > $DCC_PATH/config
    echo 0x9375C2C 1 > $DCC_PATH/config
    echo 0x9375C38 1 > $DCC_PATH/config
    echo 0x9376418 2 > $DCC_PATH/config
    echo 0x9379100 1 > $DCC_PATH/config
    echo 0x9379110 1 > $DCC_PATH/config
    echo 0x9379120 1 > $DCC_PATH/config
    echo 0x9379180 2 > $DCC_PATH/config
    echo 0x93F0080 1 > $DCC_PATH/config
    echo 0x93F0310 1 > $DCC_PATH/config
    echo 0x93F0400 1 > $DCC_PATH/config
    echo 0x93F0410 6 > $DCC_PATH/config
    echo 0x93F0430 1 > $DCC_PATH/config
    echo 0x93F0440 1 > $DCC_PATH/config
    echo 0x93F0448 1 > $DCC_PATH/config
    echo 0x93F04A0 1 > $DCC_PATH/config
    echo 0x93F04B0 1 > $DCC_PATH/config
    echo 0x93F04B8 2 > $DCC_PATH/config
    echo 0x93F04D0 2 > $DCC_PATH/config
    echo 0x93F1400 1 > $DCC_PATH/config
    echo 0x93F3410 1 > $DCC_PATH/config
    echo 0x93F53B0 1 > $DCC_PATH/config
    echo 0x93F5804 1 > $DCC_PATH/config
    echo 0x93F5C1C 1 > $DCC_PATH/config
    echo 0x93F5C2C 1 > $DCC_PATH/config
    echo 0x93F5C38 1 > $DCC_PATH/config
    echo 0x93F6418 2 > $DCC_PATH/config
    echo 0x93F9100 1 > $DCC_PATH/config
    echo 0x93F9110 1 > $DCC_PATH/config
    echo 0x93F9120 1 > $DCC_PATH/config
    echo 0x93F9180 2 > $DCC_PATH/config

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

    echo 0x610110 5 > $DCC_PATH/config

    # SHRM
    echo 0x06E0A00C 0x00600007 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x00136800 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136810 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136820 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136830 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136840 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136850 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136860 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x00136870 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003e9a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003c0a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003d1a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003d2a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003d5a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003d6a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003e8a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003eea0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003b1a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003b2a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003b5a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003b6a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003c2a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003c5a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A01C 0x0003c6a0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x001368a0 1 > $DCC_PATH/config_write
    echo 0x06E0A014 1 1 > $DCC_PATH/config
    echo 0x06E0A014 0x0002000c 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x000368b0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x00000ba8 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x0013B6A0 1 > $DCC_PATH/config_write
    echo 0x06E0A01C 0x00F1E000 1 > $DCC_PATH/config_write
    echo 0x06E0A008 0x00000007 1 > $DCC_PATH/config_write
    echo 0x09067E00 124 > $DCC_PATH/config
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

enable_kona_cpu_register()
{
    echo 1 > /sys/bus/platform/devices/soc:cpuss_dump/register_reset
    echo 0x17800000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17800008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17800054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x178000f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17808000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00020 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00084 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00104 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00184 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00204 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00284 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00304 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00384 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00420 0x3a0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00c08 0xe8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00d04 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a00e08 0xe8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06110 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06118 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06128 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06130 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06138 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06148 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06150 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06158 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06160 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06168 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06170 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06178 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06188 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06198 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a061f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06208 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06210 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06218 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06220 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06228 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06230 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06238 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06240 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06248 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06250 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06258 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06260 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06268 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06270 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06278 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06288 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06290 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06298 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a062f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06308 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06310 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06318 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06328 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06330 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06338 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06340 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06348 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06350 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06358 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06360 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06368 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06370 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06378 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06388 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06390 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06398 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a063f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06400 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06408 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06410 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06418 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06420 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06428 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06430 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06438 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06440 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06448 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06450 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06458 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06460 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06468 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06470 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06478 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06480 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06488 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06490 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06498 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a064f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06500 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06508 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06510 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06518 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06520 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06528 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06530 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06538 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06540 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06548 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06550 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06558 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06560 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06568 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06570 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06578 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06580 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06588 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06590 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06598 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a065f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06600 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06608 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06610 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06618 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06620 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06628 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06630 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06638 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06640 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06648 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06650 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06658 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06660 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06668 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06670 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06678 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06680 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06688 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06690 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06698 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a066f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06700 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06708 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06710 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06718 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06720 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06728 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06730 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06738 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06740 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06748 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06750 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06758 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06760 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06768 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06770 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06778 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06780 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06788 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06790 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06798 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a067f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06800 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06808 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06810 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06818 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06820 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06828 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06830 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06838 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06840 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06848 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06850 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06858 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06860 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06868 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06870 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06878 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06880 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06888 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06890 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06898 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a068f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06900 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06908 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06910 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06918 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06920 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06928 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06930 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06938 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06940 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06948 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06950 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06958 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06960 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06968 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06970 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06978 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06980 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06988 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06990 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06998 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a069f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06a98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06aa0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06aa8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ab0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ab8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ac0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ac8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ad0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ad8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ae0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ae8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06af0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06af8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06b98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ba0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ba8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06be0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06be8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06bf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06c98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ca0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ca8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ce0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ce8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06cf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06d98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06da0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06da8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06db0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06db8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06dc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06dc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06dd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06dd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06de0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06de8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06df0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06df8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06e98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ea0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ea8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06eb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06eb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ec0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ec8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ed0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ed8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ee0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ee8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ef0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ef8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06f98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fa0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fa8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fe0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06fe8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ff0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a06ff8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07018 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07020 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07028 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07030 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07038 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07048 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07050 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07058 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07060 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07068 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07088 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07090 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07098 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a070f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07110 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07118 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07128 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07130 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07138 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07148 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07150 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07158 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07160 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07168 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07170 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07178 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07188 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07198 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a071f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07208 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07210 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07218 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07220 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07228 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07230 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07238 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07240 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07248 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07250 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07258 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07260 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07268 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07270 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07278 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07288 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07290 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07298 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a072f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07308 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07310 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07318 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07328 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07330 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07338 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07340 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07348 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07350 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07358 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07360 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07368 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07370 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07378 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07388 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07390 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07398 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a073f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07400 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07408 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07410 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07418 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07420 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07428 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07430 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07438 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07440 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07448 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07450 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07458 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07460 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07468 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07470 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07478 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07480 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07488 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07490 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07498 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a074f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07500 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07508 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07510 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07518 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07520 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07528 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07530 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07538 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07540 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07548 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07550 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07558 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07560 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07568 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07570 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07578 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07580 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07588 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07590 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07598 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a075f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07600 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07608 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07610 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07618 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07620 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07628 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07630 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07638 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07640 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07648 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07650 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07658 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07660 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07668 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07670 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07678 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07680 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07688 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07690 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07698 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a076f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07700 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07708 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07710 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07718 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07720 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07728 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07730 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07738 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07740 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07748 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07750 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07758 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07760 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07768 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07770 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07778 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07780 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07788 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07790 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07798 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a077f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07800 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07808 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07810 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07818 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07820 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07828 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07830 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07838 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07840 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07848 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07850 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07858 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07860 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07868 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07870 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07878 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07880 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07888 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07890 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07898 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a078f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07900 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07908 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07910 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07918 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07920 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07928 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07930 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07938 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07940 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07948 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07950 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07958 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07960 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07968 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07970 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07978 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07980 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07988 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07990 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07998 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a079f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07a98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07aa0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07aa8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ab0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ab8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ac0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ac8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ad0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ad8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ae0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ae8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07af0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07af8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07b98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ba0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ba8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07be0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07be8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07bf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07c98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ca0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ca8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ce0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07ce8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07cf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07d98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07da0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07da8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07db0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07db8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07dc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07dc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07dd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07dd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07de0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07de8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07df0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a07df8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a0e008 0xe8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a0e104 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a0f000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a0ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20018 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20020 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20028 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20048 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20050 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20060 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20068 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20088 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20090 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a200e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20110 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20128 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20148 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20150 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20160 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20168 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20188 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a201e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20208 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20210 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20220 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20228 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20240 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20248 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20250 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20260 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20268 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20288 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20290 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a202e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20308 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20310 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20328 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20340 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20348 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20350 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20360 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a20368 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a2e000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a2e800 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a2e808 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a2ffbc 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a2ffc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a2ffd0 0x44 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30400 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30600 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30a00 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30c00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30c20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30c40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30c60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30c80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30cc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30e00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30e50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30fb8 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a30fcc 0x34 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40020 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40028 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40030 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40088 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40090 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a40108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a4f000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a4ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a60000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a60014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a60020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a60070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a60078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a6ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a70e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a7c000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a7c008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a7c010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a7f000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a80000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a80014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a80020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a80070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a80078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a8ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a90e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a9c000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a9c008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a9c010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17a9f000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aa0000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aa0014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aa0020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aa0070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aa0078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aaffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ab0e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17abc000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17abc008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17abc010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17abf000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ac0000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ac0014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ac0020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ac0070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ac0078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17acffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ad0e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17adc000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17adc008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17adc010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17adf000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ae0000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ae0014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ae0020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ae0070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17ae0078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aeffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17af0e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17afc000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17afc008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17afc010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17aff000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b00000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b00014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b00020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b00070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b00078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b0ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b10e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b1c000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b1c008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b1c010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b1f000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b20000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b20014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b20020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b20070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b20078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b2ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b30e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b3c000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b3c008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b3c010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b3f000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b40000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b40014 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b40020 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b40070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b40078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b4ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50400 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b50e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b5c000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b5c008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b5c010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b5f000 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60020 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60084 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60104 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60184 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60204 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60284 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60304 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60384 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60420 0x3a0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60c08 0xe8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60d04 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b60e08 0xe8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66110 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66118 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66128 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66130 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66138 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66148 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66150 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66158 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66160 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66168 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66170 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66178 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66188 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66198 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b661f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66208 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66210 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66218 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66220 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66228 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66230 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66238 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66240 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66248 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66250 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66258 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66260 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66268 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66270 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66278 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66288 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66290 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66298 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b662f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66308 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66310 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66318 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66328 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66330 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66338 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66340 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66348 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66350 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66358 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66360 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66368 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66370 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66378 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66388 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66390 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66398 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b663f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66400 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66408 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66410 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66418 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66420 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66428 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66430 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66438 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66440 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66448 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66450 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66458 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66460 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66468 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66470 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66478 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66480 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66488 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66490 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66498 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b664f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66500 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66508 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66510 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66518 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66520 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66528 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66530 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66538 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66540 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66548 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66550 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66558 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66560 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66568 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66570 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66578 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66580 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66588 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66590 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66598 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b665f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66600 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66608 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66610 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66618 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66620 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66628 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66630 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66638 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66640 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66648 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66650 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66658 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66660 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66668 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66670 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66678 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66680 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66688 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66690 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66698 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b666f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66700 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66708 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66710 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66718 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66720 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66728 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66730 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66738 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66740 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66748 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66750 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66758 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66760 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66768 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66770 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66778 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66780 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66788 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66790 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66798 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b667f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66800 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66808 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66810 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66818 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66820 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66828 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66830 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66838 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66840 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66848 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66850 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66858 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66860 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66868 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66870 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66878 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66880 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66888 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66890 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66898 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b668f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66900 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66908 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66910 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66918 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66920 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66928 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66930 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66938 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66940 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66948 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66950 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66958 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66960 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66968 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66970 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66978 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66980 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66988 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66990 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66998 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b669f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66a98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66aa0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66aa8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ab0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ab8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ac0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ac8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ad0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ad8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ae0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ae8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66af0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66af8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66b98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ba0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ba8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66be0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66be8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66bf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66c98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ca0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ca8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ce0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ce8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66cf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66d98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66da0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66da8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66db0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66db8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66dc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66dc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66dd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66dd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66de0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66de8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66df0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66df8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66e98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ea0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ea8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66eb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66eb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ec0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ec8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ed0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ed8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ee0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ee8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ef0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ef8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66f98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fa0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fa8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fe0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66fe8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ff0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b66ff8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67018 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67020 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67028 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67030 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67038 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67048 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67050 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67058 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67060 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67068 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67088 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67090 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67098 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b670f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67110 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67118 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67128 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67130 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67138 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67148 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67150 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67158 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67160 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67168 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67170 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67178 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67180 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67188 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67198 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b671f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67200 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67208 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67210 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67218 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67220 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67228 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67230 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67238 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67240 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67248 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67250 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67258 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67260 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67268 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67270 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67278 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67288 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67290 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67298 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b672f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67300 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67308 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67310 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67318 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67328 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67330 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67338 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67340 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67348 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67350 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67358 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67360 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67368 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67370 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67378 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67388 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67390 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67398 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b673f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67400 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67408 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67410 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67418 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67420 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67428 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67430 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67438 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67440 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67448 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67450 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67458 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67460 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67468 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67470 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67478 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67480 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67488 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67490 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67498 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b674f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67500 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67508 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67510 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67518 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67520 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67528 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67530 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67538 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67540 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67548 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67550 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67558 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67560 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67568 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67570 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67578 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67580 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67588 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67590 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67598 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b675f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67600 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67608 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67610 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67618 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67620 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67628 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67630 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67638 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67640 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67648 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67650 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67658 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67660 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67668 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67670 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67678 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67680 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67688 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67690 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67698 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b676f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67700 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67708 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67710 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67718 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67720 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67728 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67730 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67738 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67740 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67748 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67750 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67758 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67760 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67768 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67770 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67778 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67780 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67788 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67790 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67798 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b677f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67800 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67808 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67810 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67818 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67820 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67828 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67830 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67838 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67840 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67848 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67850 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67858 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67860 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67868 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67870 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67878 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67880 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67888 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67890 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67898 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b678f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67900 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67908 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67910 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67918 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67920 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67928 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67930 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67938 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67940 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67948 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67950 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67958 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67960 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67968 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67970 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67978 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67980 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67988 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67990 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67998 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b679f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67a98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67aa0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67aa8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ab0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ab8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ac0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ac8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ad0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ad8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ae0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ae8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67af0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67af8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67b98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ba0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ba8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67be0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67be8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67bf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67c98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ca0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ca8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cb0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cb8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ce0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67ce8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cf0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67cf8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d10 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d18 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d20 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d28 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d38 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d40 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d48 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d50 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d60 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d70 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d78 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d88 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67d98 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67da0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67da8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67db0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67db8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67dc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67dc8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67dd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67dd8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67de0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67de8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67df0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b67df8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b6e008 0xe8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b6e104 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b6f000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17b6ffd0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c00004 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c00038 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c00044 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c000f0 0x74 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c00200 0x64 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c00438 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c00444 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c10000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c1000c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c10020 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20040 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20080 0x38 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20fc0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20fe0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c20ff0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c21000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c21fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c22000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c22020 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c22fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c23000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c23fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c25000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c25fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c26000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c26020 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c26fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c27000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c27fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c29000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c29fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c2b000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c2bfd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c2d000 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17c2dfd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00004 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00010 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00034 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00040 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00050 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00160 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00204 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00210 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00220 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00230 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00240 0x7c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00404 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e0041c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00434 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e0043c 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x17e00448 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18000000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18000008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18000054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180000f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18010000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18010008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18010054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180100f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18020000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18020008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18020054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180200f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18030000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18030008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18030054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180300f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18040000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18040008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18040054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180400f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18048000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18050000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18050008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18050054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180500f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18058000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18060000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18060008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18060054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180600f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18068000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18070000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18070008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18070054 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180700f0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18078000 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18080000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18080008 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18080054 0x34 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18080090 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180800a0 0x9c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18080140 0x8c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180801f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c0000 0x248 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8010 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8018 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8020 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8028 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8030 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8038 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8048 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8050 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8058 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8060 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8068 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8078 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8088 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8090 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8098 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80a0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80b8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80c8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80f0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c80f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8110 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180c8118 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180cc000 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180cc030 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180cc040 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x180cc090 0x88 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1810000c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100040 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100900 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100c0c 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100c40 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18100fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1810100c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101040 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101900 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101c0c 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101c40 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18101fd0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200000 0xd4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182000d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200100 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200200 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200224 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200244 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200264 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200284 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182002a4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182002c4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182002e4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200400 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200410 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200450 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200490 0x2c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200600 0x200 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d30 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d44 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d58 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d6c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d80 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200d94 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200da8 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200dbc 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200dd0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200de4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200df8 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200e0c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200e20 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200e34 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200e48 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200e5c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200fb0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200fd0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200fe4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18200ff8 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820100c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201020 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201034 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201048 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820105c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201070 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201084 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201098 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182010ac 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182010c0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182010d4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182010e8 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182010fc 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201250 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201270 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201284 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201298 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182012ac 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182012c0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182012d4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182012e8 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182012fc 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201310 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201324 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201338 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820134c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201360 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201374 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201388 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820139c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182014f0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201510 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201524 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201538 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820154c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201560 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201574 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201588 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820159c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182015b0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182015c4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182015d8 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182015ec 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201600 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201614 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18201628 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820163c 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202d40 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202d4c 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202d68 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202d7c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202d90 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202da4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202db8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202dcc 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202de0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202df4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202e08 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202e1c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202e30 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202e44 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202e58 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202e6c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202fe0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18202ff4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203008 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820301c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203030 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203044 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203058 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820306c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203094 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182030a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182030bc 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182030d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182030e4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182030f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820310c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203280 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203294 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182032a8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182032bc 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182032d0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182032e4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182032f8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820330c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203334 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203348 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820335c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203370 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203384 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203398 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182033ac 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203520 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203534 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203548 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820355c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203570 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203584 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203598 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182035ac 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182035c0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182035d4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182035e8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182035fc 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203610 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203624 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18203638 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1820364c 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210000 0x4c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210050 0x84 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182100d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210204 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210224 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210244 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210264 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210284 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182102a4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182102c4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182102e4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210400 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210410 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210450 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182104a0 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210600 0x200 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210d00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210d10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210d30 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210fb0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18210fd0 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18211250 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18211270 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182114f0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18211510 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18212d44 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18212d4c 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220000 0x4c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220050 0x84 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182200d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220204 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220224 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220244 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220264 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220284 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182202a4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182202c4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182202e4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220400 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220410 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220450 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182204a0 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220600 0x200 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220d00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220d10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220d30 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220fb0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18220fd0 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221250 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221270 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182214f0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221510 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221790 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182217b0 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221a30 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221a50 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221cd0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221cf0 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221f70 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18221f90 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18222d44 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18222d4c 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230000 0x4c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230050 0x84 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182300d8 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230108 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230204 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230224 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230244 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230264 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230284 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182302a4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182302c4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182302e4 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230400 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230410 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230450 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182304a0 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230600 0x200 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230d00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230d10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230d30 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230fb0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18230fd0 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18231250 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18231270 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18232d44 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18232d4c 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18280000 0x3c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18280040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18280080 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18282000 0x3c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18282040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18282080 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18284000 0x3c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18284040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18284080 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18286000 0x3c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18286040 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18286080 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18290000 0x5c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18290080 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18290100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18292000 0x5c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18292080 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18292100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18294000 0x5c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18294080 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18294100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18296000 0x5c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18296080 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18296100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182a0004 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182a0028 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x182a0054 0x70 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18300000 0x118 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370010 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370090 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370110 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183701a0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370220 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183702a0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370390 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370410 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370420 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183704a0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370520 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370580 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370600 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370610 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370690 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370710 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370790 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370810 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370890 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370910 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370990 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370a10 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370a90 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370b00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370b10 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370b90 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370c10 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370c90 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370d10 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370d80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370d90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370e10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370e90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370f10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18370f90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371010 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371090 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371110 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371190 0x200 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371990 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371a10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371a80 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371a90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371b10 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371ba0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371bb0 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371c30 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18371d00 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378010 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378090 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378110 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378190 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183781a0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378220 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183782a0 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378380 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378390 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378410 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378420 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183784a0 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378520 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378580 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378600 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378610 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378690 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378710 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378790 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378810 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378890 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378910 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378990 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378a10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378a90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378b00 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378b10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378b90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378c10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378c90 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378d10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378d80 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378d90 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378e10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378e90 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378f10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18378f90 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379010 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379080 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379090 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379110 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379190 0x100 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379990 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379a10 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379a80 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379a90 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379b10 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379ba0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379bb0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379c30 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18379d00 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390000 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390020 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390050 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390080 0x64 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390200 0x30 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390700 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390780 0x80 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390808 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390824 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390840 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390c48 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390c64 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18390c80 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18393500 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18393a80 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18393aa8 0xc8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18393c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0000 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0020 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0050 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0070 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0080 0x64 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0100 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0120 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0140 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0200 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0700 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0780 0x80 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0808 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0824 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0840 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0c48 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0c64 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a0c80 0x40 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a3500 0x140 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a3a80 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a3aa8 0xc8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x183a3c00 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400000 0x68 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400098 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184000bc 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400100 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400140 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400180 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400200 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400494 0x18 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184004b0 0x1c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184004f8 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400538 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400560 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400590 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400598 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184005a0 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184005b8 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184005e0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400600 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400640 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400680 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184006c0 0x20 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400700 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18400710 0x80 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18401068 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18401074 0x38 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18401480 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184014cc 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18401558 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18401594 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x184015b4 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18401600 0x48 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18420000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18421000 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18580000 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18580100 0x400 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18590000 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18590014 0x68 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185900b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185900b8 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185900d0 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18590100 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18590200 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18590300 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18590320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1859034c 0x7c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18591000 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18591014 0x68 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185910b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185910b8 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185910d0 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18591100 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18591200 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18591300 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18591320 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1859134c 0x8c > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18592000 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18592014 0x68 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185920b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185920b8 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185920d0 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18592100 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18592200 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18592300 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18592320 0xc > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1859234c 0x88 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18593000 0x10 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18593014 0x68 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185930b0 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185930b8 0x8 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x185930d0 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18593100 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18593200 0xa0 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18593300 0x14 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18593320 0x4 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x1859334c 0x80 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18598000 0x24 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
    echo 0x18500000 0x10000 > /sys/bus/platform/devices/soc:cpuss_dump/register_config
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
    enable_kona_cpu_register
}
