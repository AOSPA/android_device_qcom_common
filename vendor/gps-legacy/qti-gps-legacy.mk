#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

TARGET_GPS_COMPONENT_VARIANT := gps-legacy

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/gps-legacy

# Flags
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default
LOC_HIDL_VERSION := 4.3

# Inherit the GPS HAL.
$(call inherit-product-if-exists, hardware/qcom/gps/gps_vendor_product.mk)

# Manifest
DEVICE_MANIFEST_FILE += \
    $(QCOM_COMMON_PATH)/vendor/gps-legacy/qcc-manifest.xml

# Overlays (they make com.qualcomm.location the network location provider; it comes from
# system/gps, which the 4.19 legacy family doesn't take)
ifneq ($(call is-board-platform-in-list,$(4_19_LEGACY_FAMILY)),true)
PRODUCT_PACKAGES += \
    QCOMGPSFrameworksOverlay
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/gps-legacy/gps-legacy-vendor.mk)
