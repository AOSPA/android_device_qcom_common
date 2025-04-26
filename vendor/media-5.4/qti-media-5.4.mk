#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/media-5.4

TARGET_MEDIA_COMPONENT_VARIANT := media-5.4

# Inherit configuration from the HAL.
$(call inherit-product-if-exists, hardware/qcom/media/product.mk)

# Enable 64-bit mediaserver
PRODUCT_VENDOR_PROPERTIES += \
    ro.mediaserver.64b.enable=true

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    media.stagefright.thumbnail.prefer_hw_codecs=true \
    ro.media.recorder-max-base-layer-fps=60

# Media Init
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media-5.4/init.qti.media.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.media.sh

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media-5.4/media-5.4-vendor.mk)
