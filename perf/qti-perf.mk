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

# Boot Jars
PRODUCT_BOOT_JARS += \
    QPerformance \
    UxPerformance

# Configs
PRODUCT_COPY_FILES += \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/lm/*.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/lm/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/*.conf),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/app*.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/msm_irqbalance.conf),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/perfboosts*.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/power*.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/perfmap*.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/target*.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/targetresourceconfigs.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/$(TARGET_BOARD_PLATFORM)/perfconfigstore.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file))) \
    $(foreach file,$(wildcard $(LOCAL_PATH)/perf/configs/common/commonresourceconfigs.xml),$(file):$(TARGET_COPY_OUT_VENDOR)/etc/perf/$(notdir $(file)))

# Packages
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0 \
    init.aospa.perf.rc \
    libtflite \
    vendor.qti.hardware.servicetracker@1.2.vendor

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    vendor.power.pasr.enabled=true

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/perf/perf-vendor.mk)
