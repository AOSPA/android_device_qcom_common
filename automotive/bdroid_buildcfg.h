/*
 *
 *  Copyright (c) 2013, The Linux Foundation. All rights reserved.
 *  Not a Contribution, Apache license notifications and license are retained
 *  for attribution purposes only.
 *
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H
#define BTM_DEF_LOCAL_NAME   "QTI-BTD"
// Disables read remote device feature
#define MAX_ACL_CONNECTIONS   16
#define MAX_L2CAP_CHANNELS    16
#define BLE_VND_INCLUDED   TRUE
// skips conn update at conn completion
#define BT_CLEAN_TURN_ON_DISABLED 1

/* Increasing SEPs to 12 from 6 to support SHO/MCast i.e. two streams per codec */
#define AVDT_NUM_SEPS 12

/* Enable A2DP(SNK) */
#define BTA_AV_SINK_INCLUDED TRUE

/* Enable delay-report for A2DP(SNK) */
#define A2DP_SINK_DELAY_REPORT TRUE

/* Write 128bit UUID to EIR when a service based on RFCOMM channel is created. */
#define BTA_EIR_SUPPORT_128BIT_UUID TRUE

/*
* Change CoD for Auto car-kit
* {SERVICE_CLASS, MAJOR_CLASS, MINOR_CLASS}
*
* SERVICE_CLASS:0x26 (Bit17 - Networking, Bit18 - Rendering, Bit21 - Audio)
* MAJOR_CLASS:0x04 - Audio/Video
* MINOR_CLASS:0X08 - Hands-free Device
*
* Detailed information can be found in below link
* https://www.bluetooth.com/specifications/assigned-numbers/baseband
*/
#define BTA_DM_COD \
  { 0x26, 0x04, 0x08 }
#endif
