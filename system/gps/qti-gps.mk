#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Init
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/system/gps/vendor.qti.hardware.qccsyshal@1.2-service.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/vendor.qti.hardware.qccsyshal@1.2-service_override.rc

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.backup.ntpServer="0.pool.ntp.org"

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/gps/gps-vendor.mk)
