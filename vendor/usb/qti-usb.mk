#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/usb

# Inherit from the USB product definition.
$(call inherit-product, vendor/qcom/opensource/usb/vendor_product.mk)

TARGET_HAS_DIAG_ROUTER := true

PRODUCT_PACKAGES += android.hardware.usb@1.0-service

PRODUCT_HAS_GADGET_HAL := true

ifeq ($(PRODUCT_HAS_GADGET_HAL),true)
PRODUCT_PACKAGES += \
    NcmTetheringOverlay \
    NcmTetheringOverlayMainline
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_PACKAGES += \
    init.aospa.usb.rc
