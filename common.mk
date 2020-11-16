#
# Copyright 2020 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/qcom/common

# List of QCOM targets.
MSMSTEPPE := sm6150
TRINKET := trinket

QCOM_BOARD_PLATFORMS += \
    $(MSMSTEPPE) \
    $(TRINKET) \
    apq8084 \
    apq8098_latv \
    atoll \
    bengal \
    kona \
    lito \
    mpq8092 \
    msm8226 \
    msm8610 \
    msm8909 \
    msm8909_512 \
    msm8916 \
    msm8916_32 \
    msm8916_32_512 \
    msm8916_64 \
    msm8937 \
    msm8952 \
    msm8953 \
    msm8974 \
    msm8992 \
    msm8994 \
    msm8996 \
    msm8998 \
    msmnile \
    msmnile_au \
    msm_bronze \
    qcs605 \
    sdm660 \
    sdm710 \
    sdm845

# List of targets that use video hardware.
MSM_VIDC_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    apq8084 \
    apq8098_latv \
    atoll \
    kona \
    lito \
    msm8226 \
    msm8610 \
    msm8909 \
    msm8916 \
    msm8937 \
    msm8952 \
    msm8953 \
    msm8974 \
    msm8992 \
    msm8994 \
    msm8996 \
    msm8998 \
    msmnile \
    qcs605 \
    sdm660 \
    sdm710 \
    sdm845

# List of targets that use master side content protection.
MASTER_SIDE_CP_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    apq8098_latv \
    atoll \
    bengal \
    holi \
    kona \
    lito \
    msm8996 \
    msm8998 \
    msmnile \
    qcs605 \
    sdm660 \
    sdm710 \
    sdm845

# Include QCOM board utilities.
include $(DEVICE_PATH)/utils.mk

# Kernel Families
5_4_FAMILY := \
    holi

4_19_FAMILY := \
    bengal \
    kona \
    lito

4_14_FAMILY := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    msmnile \
    msmnile_au

4_9_FAMILY := \
    qcs605 \
    sdm710 \
    sdm845

4_4_FAMILY := \
    msm8998 \
    sdm660

3_18_FAMILY := \
    msm8937 \
    msm8953 \
    msm8996

ifeq ($(call is-board-platform-in-list,$(5_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.4
else ifeq ($(call is-board-platform-in-list,$(4_19_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.19
else ifeq ($(call is-board-platform-in-list,$(4_14_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.14
else ifeq ($(call is-board-platform-in-list,$(4_9_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.9
else ifeq ($(call is-board-platform-in-list,$(4_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.4
else ifeq ($(call is-board-platform-in-list,$(3_18_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 3.18
endif

# Power
# Define all modules and they will be filtered out
# by the build flags in Android.mk
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
PRODUCT_PACKAGES += \
    android.hardware.power-service
endif

ifeq ($(TARGET_COMMON_QTI_COMPONENTS), all)
TARGET_COMMON_QTI_COMPONENTS := \
    audio \
    av \
    bt \
    display \
    gps \
    init \
    media \
    nq-nfc \
    overlay \
    perf \
    telephony \
    usb \
    wfd \
    wlan
endif

# QTI common components
ifneq (,$(filter av, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/av/qti-av.mk
endif

ifneq (,$(filter bt, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/bt/qti-bt.mk
endif

ifneq (,$(filter gps, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/gps/qti-gps.mk
endif

ifneq (,$(filter init, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/init/qti-init.mk
endif

ifneq (,$(filter media, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/media/qti-media.mk
endif

ifneq (,$(filter overlay, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/overlay/qti-overlay.mk
endif

ifneq (,$(filter perf, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/perf/qti-perf.mk
endif

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/telephony/qti-telephony.mk
endif

ifneq (,$(filter usb, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/usb/qti-usb.mk
endif

# 845 series and newer
ifneq (,$(filter audio, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/audio/qti-audio.mk
endif

ifneq (,$(filter display, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/display/qti-display.mk
endif

ifneq (,$(filter nq-nfc, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/nq-nfc/qti-nq-nfc.mk
endif

ifneq (,$(filter wfd, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/wfd/qti-wfd.mk
endif

ifneq (,$(filter wlan, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/wlan/qti-wlan.mk
endif

# 8998 series and older
ifneq (,$(filter wfd-legacy, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/wfd-legacy/qti-wfd-legacy.mk
endif
