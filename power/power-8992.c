/*
 * Copyright (c) 2015, The Linux Foundation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 * *    * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#define LOG_NIDEBUG 0

#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <stdlib.h>
#include <pthread.h>
#include <stdbool.h>

#define LOG_TAG "QCOMPowerHAL"
#include <utils/Log.h>
#include <hardware/hardware.h>
#include <hardware/power.h>

#include "utils.h"
#include "metadata-defs.h"
#include "hint-data.h"
#include "performance.h"
#include "power-common.h"

pthread_mutex_t video_encode_lock = PTHREAD_MUTEX_INITIALIZER;
uintptr_t video_encode_hint_counter = 0;
bool video_encode_hint_should_enable = false;
bool video_encode_hint_is_enabled = false;

static int new_hint_id = DEFAULT_VIDEO_ENCODE_HINT_ID;
static int cur_hint_id = DEFAULT_VIDEO_ENCODE_HINT_ID;

static const time_t VIDEO_ENCODE_DELAY_SECONDS = 2;
static const time_t VIDEO_ENCODE_DELAY_NSECONDS = 0;

static void* video_encode_hint_function(void* arg) {
    struct timespec tv = {0};
    tv.tv_sec = VIDEO_ENCODE_DELAY_SECONDS;
    tv.tv_nsec = VIDEO_ENCODE_DELAY_NSECONDS;
    int nanosleep_ret = 0;
    uintptr_t expected_counter = (uintptr_t)arg;

    // delay the hint for two seconds
    // the hint hotplugs the large CPUs, so this prevents the large CPUs from
    // going offline until the camera has had time to startup
    TEMP_FAILURE_RETRY(nanosleep(&tv, &tv));
    pthread_mutex_lock(&video_encode_lock);

    // check to ensure we should still turn on hint from this particular thread
    // if should_enable is true but counter is different, another thread owns hint
    // if should_enable is false, we've already quit the camera
    if (video_encode_hint_should_enable == true && video_encode_hint_counter == expected_counter) {
        /* sched and cpufreq params
           A53: 4 cores online at 1.2GHz max, 960 min
           A57: 4 cores online at 384 max, 384 min
        */
        int resource_values[] = {0x150C, 0x1F03, 0x2303};
        perform_hint_action(new_hint_id,
                            resource_values, sizeof(resource_values)/sizeof(resource_values[0]));
        cur_hint_id = new_hint_id;
        video_encode_hint_is_enabled = true;
        video_encode_hint_should_enable = false;
    }

    pthread_mutex_unlock(&video_encode_lock);
    return NULL;
}

static int display_hint_sent;

static int process_video_encode_hint(void *metadata)
{
    char governor[80];
    struct video_encode_metadata_t video_encode_metadata;

    if (get_scaling_governor(governor, sizeof(governor)) == -1) {
        ALOGE("Can't obtain scaling governor.");

        return HINT_NONE;
    }

    /* Initialize encode metadata struct fields */
    memset(&video_encode_metadata, 0, sizeof(struct video_encode_metadata_t));
    video_encode_metadata.state = -1;
    video_encode_metadata.hint_id = DEFAULT_VIDEO_ENCODE_HINT_ID;

    if (metadata) {
        if (parse_video_encode_metadata((char *)metadata, &video_encode_metadata) ==
            -1) {
            ALOGE("Error occurred while parsing metadata.");
            return HINT_NONE;
        }
    } else {
        return HINT_NONE;
    }

    if (video_encode_metadata.state == 1) {
        if ((strncmp(governor, INTERACTIVE_GOVERNOR, strlen(INTERACTIVE_GOVERNOR)) == 0) &&
                (strlen(governor) == strlen(INTERACTIVE_GOVERNOR))) {
            pthread_t video_encode_hint_thread;
            pthread_mutex_lock(&video_encode_lock);
            new_hint_id = video_encode_metadata.hint_id;
            if (video_encode_hint_counter < 65535) {
                video_encode_hint_counter++;
            } else {
                video_encode_hint_counter = 0;
            }
            // start new thread to launch hint
            video_encode_hint_should_enable = true;
            if (pthread_create(&video_encode_hint_thread, NULL, video_encode_hint_function, (void*)video_encode_hint_counter) != 0) {
                ALOGE("Error constructing hint thread");
                video_encode_hint_should_enable = false;
                pthread_mutex_unlock(&video_encode_lock);
                return HINT_NONE;
            }
            pthread_detach(video_encode_hint_thread);
            pthread_mutex_unlock(&video_encode_lock);

            return HINT_HANDLED;
        }
    } else if (video_encode_metadata.state == 0) {
        if ((strncmp(governor, INTERACTIVE_GOVERNOR, strlen(INTERACTIVE_GOVERNOR)) == 0) &&
                (strlen(governor) == strlen(INTERACTIVE_GOVERNOR))) {
            pthread_mutex_lock(&video_encode_lock);
            video_encode_hint_should_enable = false;
            if (video_encode_hint_is_enabled == true) {
                undo_hint_action(cur_hint_id);
                video_encode_hint_is_enabled = false;
            }
            pthread_mutex_unlock(&video_encode_lock);
            return HINT_HANDLED;
        }
    }
    return HINT_NONE;
}

/* Declare function before use */
int interaction(int duration, int num_args, int opt_list[]);
int interaction_with_handle(int lock_handle, int duration, int num_args, int opt_list[]);

static void power_hint_override(struct power_module *module, power_hint_t hint, void *data)
{
    int ret_val = HINT_NONE;
    switch(hint) {
        case POWER_HINT_VIDEO_ENCODE:
            ret_val = process_video_encode_hint(data);
            break;
        case POWER_HINT_INTERACTION:
        {
            int duration_hint = 0;
            static unsigned long long previous_boost_time = 0;

            // little core freq bump for 1.5s
            int resources[] = {0x20C};
            int duration = 1500;
            static int handle_little = 0;

            // big core freq bump for 500ms
            int resources_big[] = {0x2312, 0x1F08};
            int duration_big = 500;
            static int handle_big = 0;

            // sched_downmigrate lowered to 10 for 1s at most
            // should be half of upmigrate
            int resources_downmigrate[] = {0x4F00};
            int duration_downmigrate = 1000;
            static int handle_downmigrate = 0;

            // sched_upmigrate lowered to at most 20 for 500ms
            // set threshold based on elapsed time since last boost
            int resources_upmigrate[] = {0x4E00};
            int duration_upmigrate = 500;
            static int handle_upmigrate = 0;

            // set duration hint
            if (data) {
                duration_hint = *((int*)data);
            }

            struct timeval cur_boost_timeval = {0, 0};
            gettimeofday(&cur_boost_timeval, NULL);
            unsigned long long cur_boost_time = cur_boost_timeval.tv_sec * 1000000 + cur_boost_timeval.tv_usec;
            double elapsed_time = (double)(cur_boost_time - previous_boost_time);
            if (elapsed_time > 750000)
                elapsed_time = 750000;
            // don't hint if it's been less than 250ms since last boost
            // also detect if we're doing anything resembling a fling
            // support additional boosting in case of flings
            else if (elapsed_time < 250000 && duration_hint <= 750)
                return;

            // 95: default upmigrate for phone
            // 20: upmigrate for sporadic touch
            // 750ms: a completely arbitrary threshold for last touch
            int upmigrate_value = 95 - (int)(75. * ((elapsed_time*elapsed_time) / (750000.*750000.)));

            // keep sched_upmigrate high when flinging
            if (duration_hint >= 750)
                upmigrate_value = 20;

            previous_boost_time = cur_boost_time;
            resources_upmigrate[0] = resources_upmigrate[0] | upmigrate_value;
            resources_downmigrate[0] = resources_downmigrate[0] | (upmigrate_value / 2);

            // modify downmigrate duration based on interaction data hint
            // 1000 <= duration_downmigrate <= 5000
            // extend little core freq bump past downmigrate to soften downmigrates
            if (duration_hint > 1000) {
                if (duration_hint < 5000) {
                    duration_downmigrate = duration_hint;
                    duration = duration_hint + 750;
                } else {
                    duration_downmigrate = 5000;
                    duration = 5750;
                }
            }

            handle_little = interaction_with_handle(handle_little,duration, sizeof(resources)/sizeof(resources[0]), resources);
            handle_big = interaction_with_handle(handle_big, duration_big, sizeof(resources_big)/sizeof(resources_big[0]), resources_big);
            handle_downmigrate = interaction_with_handle(handle_downmigrate, duration_downmigrate, sizeof(resources_downmigrate)/sizeof(resources_downmigrate[0]), resources_downmigrate);
            handle_upmigrate = interaction_with_handle(handle_upmigrate, duration_upmigrate, sizeof(resources_upmigrate)/sizeof(resources_upmigrate[0]), resources_upmigrate);
            ret_val = HINT_HANDLED;
        }
            break;
        default:
            break;
    }
    return ret_val;
}

int set_interactive_override(struct power_module *module, int on)
{
    char governor[80];

    if (get_scaling_governor(governor, sizeof(governor)) == -1) {
        ALOGE("Can't obtain scaling governor.");

        return HINT_NONE;
    }

    if (!on) {
        /* Display off */
        if ((strncmp(governor, INTERACTIVE_GOVERNOR, strlen(INTERACTIVE_GOVERNOR)) == 0) &&
            (strlen(governor) == strlen(INTERACTIVE_GOVERNOR))) {
            // Offline all big cores
            int resource_values[] = {0x777};
            if (!display_hint_sent) {
                perform_hint_action(DISPLAY_STATE_HINT_ID,
                resource_values, sizeof(resource_values)/sizeof(resource_values[0]));
                display_hint_sent = 1;
                return HINT_HANDLED;
            }
        }
    } else {
        /* Display on */
        if ((strncmp(governor, INTERACTIVE_GOVERNOR, strlen(INTERACTIVE_GOVERNOR)) == 0) &&
            (strlen(governor) == strlen(INTERACTIVE_GOVERNOR))) {
            undo_hint_action(DISPLAY_STATE_HINT_ID);
            display_hint_sent = 0;
            return HINT_HANDLED;
        }
    }
    return HINT_NONE;
}
