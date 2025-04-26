#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/charging

# Health
ifneq ($(TARGET_USE_HIDL_QTI_HEALTH),true)
$(call inherit-product, vendor/qcom/opensource/healthd-ext/health-vendor-product.mk)

PRODUCT_PACKAGES += \
    android.hardware.health@1.0.vendor \
    android.hardware.health@2.1.vendor
else
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl-qti \
    android.hardware.health@2.1-service

PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/init/init.charger_service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.charger_service.rc

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.charger.enable_suspend=1
endif

# Init
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/charging/vendor.qti.hardware.charger_monitor@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.charger_monitor@1.0-service.rc

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/charging/charging-vendor.mk)
