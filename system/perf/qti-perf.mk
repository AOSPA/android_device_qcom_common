#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Boot Jars
PRODUCT_BOOT_JARS += \
    QPerformance \
    UxPerformance

# Sysconfig
PRODUCT_COPY_FILES += \
    device/qcom/common/system/perf/aospa_qti_whitelist_system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/aospa_qti_whitelist_system_ext.xml

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/system/perf/perf-vendor.mk)
