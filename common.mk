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


# Power
# Define all modules and they will be filtered out
# by the build flags in Android.mk
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
PRODUCT_PACKAGES += \
    android.hardware.power@1.2-service \
    power.qcom
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

ifneq (,$(filter perf, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/perf/qti-perf.mk
endif

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/telephony/qti-telephony.mk
endif

# 845 series and newer
ifneq (,$(filter audio, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/audio/qti-audio.mk
endif

ifneq (,$(filter display, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/display/qti-display.mk
endif

ifneq (,$(filter wfd, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/wfd/qti-wfd.mk
endif

# 8998 series and older
ifneq (,$(filter wfd-legacy, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(DEVICE_PATH)/wfd-legacy/qti-wfd-legacy.mk
endif
