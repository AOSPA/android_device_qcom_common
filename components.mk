# Copyright 2021 Paranoid Android
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

ifeq ($(TARGET_COMMON_QTI_COMPONENTS), all)
TARGET_COMMON_QTI_COMPONENTS := \
    audio \
    av \
    bt \
    display \
    gps \
    init \
    nq-nfc \
    overlay \
    perf \
    telephony \
    usb \
    vibrator \
    wfd \
    wlan

ifeq ($(call is-board-platform-in-list,$(5_4_FAMILY)),true)
TARGET_COMMON_QTI_COMPONENTS += media
else
TARGET_COMMON_QTI_COMPONENTS += media-legacy
endif

ifneq (,$(filter true, $(call is-board-platform-in-list,$(3_18_FAMILY) $(4_4_FAMILY))))
TARGET_COMMON_QTI_COMPONENTS += adreno-legacy
else
TARGET_COMMON_QTI_COMPONENTS += adreno
endif
endif

# QTI Common Components
ifneq (,$(filter av, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/av/qti-av.mk
endif

ifneq (,$(filter bt, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/bt/qti-bt.mk
endif

ifneq (,$(filter gps, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/gps/qti-gps.mk
endif

ifneq (,$(filter init, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/init/qti-init.mk
endif

ifneq (,$(filter overlay, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/overlay/qti-overlay.mk
endif

ifneq (,$(filter perf, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/perf/qti-perf.mk
include $(QCOM_COMMON_PATH)/vendor/perf/qti-perf.mk
endif

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/telephony/qti-telephony.mk
endif

ifneq (,$(filter usb, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/usb/qti-usb.mk
endif

ifneq (,$(filter vibrator, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/vibrator/qti-vibrator.mk
endif

# >= SM8350
ifneq (,$(filter media, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/media/qti-media.mk
endif

# <= SM8250
ifneq (,$(filter media-legacy, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/media-legacy/qti-media-legacy.mk
endif

# >= SDM845
ifneq (,$(filter adreno, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/adreno/qti-adreno.mk
endif

ifneq (,$(filter audio, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/audio/qti-audio.mk
endif

ifneq (,$(filter display, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/display/qti-display.mk
endif

ifneq (,$(filter nq-nfc, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/nq-nfc/qti-nq-nfc.mk
endif

ifneq (,$(filter wfd, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/wfd/qti-wfd.mk
endif

ifneq (,$(filter wlan, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/wlan/qti-wlan.mk
include $(QCOM_COMMON_PATH)/vendor/wlan/qti-wlan.mk
endif

# <= MSM8998
ifneq (,$(filter wfd-legacy, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/system/wfd-legacy/qti-wfd-legacy.mk
endif

ifneq (,$(filter adreno-legacy, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(QCOM_COMMON_PATH)/vendor/adreno-legacy/qti-adreno-legacy.mk
endif
