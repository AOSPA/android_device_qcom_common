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

# include additional build utilities
include $(DEVICE_PATH)/utils.mk

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_USES_QCOM_MM_AUDIO := true

BOARD_USES_ADRENO := true

TARGET_USES_AOSP_FOR_AUDIO ?= false

# Camera
# Enable Media Extensions for HAL1 on Legacy Devices
ifeq ($(call is-board-platform-in-list, apq8084 msm8226 msm8909 msm8916 msm8937 msm8952 msm8953 msm8960 msm8974 msm8976 msm8992 msm8994 msm8996 msm8998 sdm660),true)
  TARGET_USES_MEDIA_EXTENSIONS := true
endif

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
# Disable Binderized Power HAL by default for legacy targets.
# Devices can still opt in by setting TARGET_USES_NON_LEGACY_POWERHAL in BoardConfig.mk.
# Conversely, recent chips, such as sm8150 with an old vendor can opt out.
ifneq ($(call is-board-platform-in-list, msm8937 msm8952 msm8953 msm8996 msm8998 sdm660 sdm710 sdm845 sdm710 trinket),true)
TARGET_USES_NON_LEGACY_POWERHAL ?= true

PRODUCT_PACKAGES += \
    android.hardware.power@1.2-impl \
    android.hardware.power@1.2-service

LOCAL_VINTF_FRAGMENTS := android.hardware.power@1.2-service.xml
else
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    power.qcom \

LOCAL_VINTF_FRAGMENTS := android.hardware.power@1.0-service.xml
endif # Legacy PowerHAL
endif # TARGET_PROVIDES_POWERHAL

# QTI common components
ifneq (,$(filter av, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/av/qti-av.mk
endif

ifneq (,$(filter bt, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/bt/qti-bt.mk
endif

ifneq (,$(filter perf, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/perf/qti-perf.mk
endif

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/telephony/qti-telephony.mk
endif

ifneq (,$(filter wfd, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/wfd/qti-wfd.mk
endif
