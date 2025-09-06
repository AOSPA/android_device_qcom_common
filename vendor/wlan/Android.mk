#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_WLAN_COMPONENT_VARIANT),wlan)

include $(CLEAR_VARS)

-include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/AndroidBoardWlan.mk

endif
