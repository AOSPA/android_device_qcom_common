#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Boot Jars
PRODUCT_BOOT_JARS += \
    QPerformance \
    UxPerformance

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/system/perf/perf-vendor.mk)
