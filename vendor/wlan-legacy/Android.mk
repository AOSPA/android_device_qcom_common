#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_WLAN_COMPONENT_VARIANT),wlan-legacy)

include $(CLEAR_VARS)

ifeq ($(call is-board-platform-in-list,sm6150),true)
-include device/qcom/wlan/talos/AndroidBoardWlan.mk
else
-include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/AndroidBoardWlan.mk
endif

endif
