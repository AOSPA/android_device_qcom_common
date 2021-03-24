# Copyright (C) 2021 Paranoid Android
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

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/perf

ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
# Boot Jars
PRODUCT_BOOT_JARS += \
    QPerformance \
    UxPerformance
else
PRODUCT_PACKAGES += \
    DisableCafBoost
endif

# Configs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/perf/configs/common/perf/commonresourceconfigs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/perf/commonresourceconfigs.xml \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/lm/*),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/lm/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/perf/*),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/pwr/*),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/pwr/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/msm_irqbalance.conf),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/$(notdir $(file)))

# Disable IOP HAL for select platforms.
ifeq ($(call is-board-platform-in-list, msm8937 msm8953 msm8998 qcs605 sdm660 sdm710),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/perf/vendor.qti.hardware.iop@2.0-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.iop@2.0-service-disable.rc
endif

# Packages
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0 \
    init.aospa.perf.rc \
    libpsi.vendor \
    libtflite \
    vendor.qti.hardware.servicetracker@1.2.vendor

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    vendor.power.pasr.enabled=true

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/perf/perf-vendor.mk)
