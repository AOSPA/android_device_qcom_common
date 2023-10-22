#
# Copyright (C) 2023 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/alarm

# Init script
PRODUCT_PACKAGES += \
    init.qcom.alarm.rc

# Manifest
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/alarm/alarm-manifest.xml:$(TARGET_COPY_OUT_VENDOR)/etc/vintf/manifest/vendor.qti.hardware.alarm@1.0.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/alarm/alarm-vendor.mk)
