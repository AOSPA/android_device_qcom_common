#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Allowlist
PRODUCT_COPY_FILES += \
    device/qcom/common/system/perf/qti-perf-allowlist.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/qti-perf-allowlist.xml

# Boot Jars
PRODUCT_BOOT_JARS += \
    QPerformance \
    UxPerformance

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/system/perf/perf-vendor.mk)
