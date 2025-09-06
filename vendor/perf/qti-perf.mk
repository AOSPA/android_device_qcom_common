#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/perf

TARGET_PERF_COMPONENT_VARIANT := perf

# Configs
# Use the configs for TARGET_BOARD_PLATFORM unless otherwise specified
ifeq ($(TARGET_BOARD_PLATFORM)$(TARGET_BOARD_SUFFIX),bengal_515)
    TARGET_PERF_DIR := bengal_515
else
    TARGET_PERF_DIR := $(TARGET_BOARD_PLATFORM)
endif

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(QCOM_COMMON_PATH)/vendor/perf/configs/common,$(TARGET_COPY_OUT_VENDOR)/etc) \
    $(call find-copy-subdir-files,*,$(QCOM_COMMON_PATH)/vendor/perf/configs/$(TARGET_PERF_DIR),$(TARGET_COPY_OUT_VENDOR)/etc)

# Only copy task_profiles.json for 5.4 targets.
ifeq ($(TARGET_KERNEL_VERSION),5.4)
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json
endif

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.perf-hal.ver=3.0 \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.vendor.perf.scroll_opt=true \
    ro.vendor.qspm.enable=true \
    vendor.perf.framepacing.enable=1

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.beluga.p=0x3 \
    ro.vendor.beluga.c=0x4800 \
    ro.vendor.beluga.s=0x900 \
    ro.vendor.beluga.t=0x240

# Disable excessive logging
PRODUCT_VENDOR_PROPERTIES += \
    log.tag.vendor.qti.hardware.servicetrackeraidl-service=E

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/vendor/perf/perf-vendor.mk)
