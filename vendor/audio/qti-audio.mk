# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(call is-board-platform-in-list,sm6150),true)
-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/msmsteppe/msmsteppe.mk
else
-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/$(TARGET_BOARD_PLATFORM)/$(TARGET_BOARD_PLATFORM).mk
endif

# Build Qualcomm common audio overlay
TARGET_USES_RRO := true

# Override proprietary definitions from SoC audio HAL Makefiles.
AUDIO_FEATURE_ENABLED_DYNAMIC_LOG := false
BOARD_SUPPORTS_OPENSOURCE_STHAL := false

# OMX Packages
PRODUCT_PACKAGES += \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxEvrcEnc \
    libOmxG711Enc \
    libOmxQcelp13Enc

# Audio Packages
PRODUCT_PACKAGES += \
    audio.primary.$(TARGET_BOARD_PLATFORM) \
    audio.r_submix.default \
    audio.usb.default \
    liba2dpoffload \
    libaudioroute \
    libbatterylistener \
    libcirrusspkrprot \
    libcomprcapture \
    libexthwplugin \
    libhdmiedid \
    libhfp \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libsndmonitor \
    libspkrprot \
    libssrec \
    libtinycompress \
    libvolumelistener \
    sound_trigger.primary.$(TARGET_BOARD_PLATFORM) \
    vendor.qti.hardware.pal@1.0.vendor

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/audio/audio-vendor.mk)
