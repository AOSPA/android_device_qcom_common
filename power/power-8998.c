/*
 * Copyright (c) 2016-2017, The Linux Foundation. All rights reserved.
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

#define LOG_TAG "QTI PowerHAL"
#include <utils/Log.h>
#include <hardware/hardware.h>
#include <hardware/power.h>

#include "utils.h"
#include "metadata-defs.h"
#include "hint-data.h"
#include "performance.h"
#include "power-common.h"
#include "powerhintparser.h"

static int sustained_mode_handle = 0;
static int vr_mode_handle = 0;
int sustained_performance_mode = 0;
int vr_mode = 0;
static pthread_mutex_t s_interaction_lock = PTHREAD_MUTEX_INITIALIZER;
#define CHECK_HANDLE(x) (((x)>0) && ((x)!=-1))

static int process_sustained_perf_hint(void *data)
{
    int duration = 0;

    pthread_mutex_lock(&s_interaction_lock);
    if (data && sustained_performance_mode == 0) {
        if (vr_mode == 0) { // Sustained mode only.
            sustained_mode_handle = perf_hint_enable(
                SUSTAINED_PERF_HINT, duration);
            if (!CHECK_HANDLE(sustained_mode_handle)) {
                ALOGE("Failed interaction_with_handle for sustained_mode_handle");
                pthread_mutex_unlock(&s_interaction_lock);
                return HINT_NONE;
            }
        } else if (vr_mode == 1) { // Sustained + VR mode.
            release_request(vr_mode_handle);
            sustained_mode_handle = perf_hint_enable(
                VR_MODE_SUSTAINED_PERF_HINT, duration);
            if (!CHECK_HANDLE(sustained_mode_handle)) {
                ALOGE("Failed interaction_with_handle for sustained_mode_handle");
                pthread_mutex_unlock(&s_interaction_lock);
                return HINT_NONE;
            }
        }
        sustained_performance_mode = 1;
    } else if (sustained_performance_mode == 1) {
        release_request(sustained_mode_handle);
        if (vr_mode == 1) { // Switch back to VR Mode.
            vr_mode_handle = perf_hint_enable(
                VR_MODE_HINT, duration);
            if (!CHECK_HANDLE(vr_mode_handle)) {
                ALOGE("Failed interaction_with_handle for vr_mode_handle");
                pthread_mutex_unlock(&s_interaction_lock);
                return HINT_NONE;
            }
        }
        sustained_performance_mode = 0;
    }
    pthread_mutex_unlock(&s_interaction_lock);
    return HINT_HANDLED;
}

static int process_vr_mode_hint(void *data)
{
    int duration = 0;

    pthread_mutex_lock(&s_interaction_lock);
    if (data && vr_mode == 0) {
        if (sustained_performance_mode == 0) { // VR mode only.
            vr_mode_handle = perf_hint_enable(
                VR_MODE_HINT, duration);
            if (!CHECK_HANDLE(vr_mode_handle)) {
                ALOGE("Failed interaction_with_handle for vr_mode_handle");
                pthread_mutex_unlock(&s_interaction_lock);
                return HINT_NONE;
            }
        } else if (sustained_performance_mode == 1) { // Sustained + VR mode.
            release_request(sustained_mode_handle);
            vr_mode_handle = perf_hint_enable(
                VR_MODE_SUSTAINED_PERF_HINT, duration);
            if (!CHECK_HANDLE(vr_mode_handle)) {
                ALOGE("Failed interaction_with_handle for vr_mode_handle");
                pthread_mutex_unlock(&s_interaction_lock);
                return HINT_NONE;
            }
        }
        vr_mode = 1;
    } else if (vr_mode == 1) {
        release_request(vr_mode_handle);
        if (sustained_performance_mode == 1) { // Switch back to sustained Mode.
            sustained_mode_handle = perf_hint_enable(
                SUSTAINED_PERF_HINT, duration);
            if (!CHECK_HANDLE(sustained_mode_handle)) {
                ALOGE("Failed interaction_with_handle for sustained_mode_handle");
                pthread_mutex_unlock(&s_interaction_lock);
                return HINT_NONE;
            }
        }
        vr_mode = 0;
    }
    pthread_mutex_unlock(&s_interaction_lock);

    return HINT_HANDLED;
}

static int process_video_encode_hint(void *metadata)
{
    char governor[80];
    struct video_encode_metadata_t video_encode_metadata;
    static int video_encode_handle = 0;

    if(!metadata)
       return HINT_NONE;

    if (get_scaling_governor(governor, sizeof(governor)) == -1) {
        ALOGE("Can't obtain scaling governor.");

        return HINT_NONE;
    }

    /* Initialize encode metadata struct fields */
    memset(&video_encode_metadata, 0, sizeof(struct video_encode_metadata_t));
    video_encode_metadata.state = -1;

    if (parse_video_encode_metadata((char *)metadata, &video_encode_metadata) ==
            -1) {
       ALOGE("Error occurred while parsing metadata.");
       return HINT_NONE;
    }

    if (video_encode_metadata.state == 1) {
          if (is_interactive_governor(governor)) {
              video_encode_handle = perf_hint_enable(
                       VIDEO_ENCODE_HINT, 0);
              return HINT_HANDLED;
        }
    } else if (video_encode_metadata.state == 0) {
          if (is_interactive_governor(governor)) {
            release_request(video_encode_handle);
            ALOGI("Video Encode hint stop");
            return HINT_HANDLED;
        }
    }
    return HINT_NONE;
}

int power_hint_override(struct power_module *module, power_hint_t hint, void *data)
{
    int ret_val = HINT_NONE;
    switch(hint) {
        case POWER_HINT_VIDEO_ENCODE:
            ret_val = process_video_encode_hint(data);
            break;
        case POWER_HINT_SUSTAINED_PERFORMANCE:
            ret_val = process_sustained_perf_hint(data);
            break;
        case POWER_HINT_VR_MODE:
            ret_val = process_vr_mode_hint(data);
            break;
        case POWER_HINT_INTERACTION:
            pthread_mutex_lock(&s_interaction_lock);
            if (sustained_performance_mode || vr_mode) {
                ret_val = HINT_HANDLED;
            }
            pthread_mutex_unlock(&s_interaction_lock);
            break;
        default:
            break;
    }
    return ret_val;
}

int set_interactive_override(struct power_module *module, int on)
{
    return HINT_HANDLED; /* Don't excecute this code path, not in use */
}
