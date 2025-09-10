#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/media

# Use TARGET_KERNEL_VERSION for TARGET_MEDIA_DIR except for <5.4
ifneq (,$(filter 4.14 4.19, $(TARGET_KERNEL_VERSION)))
    TARGET_MEDIA_DIR := legacy
else
    TARGET_MEDIA_DIR := $(TARGET_KERNEL_VERSION)
endif

# Inherit configuration from the HAL.
$(call inherit-product-if-exists, hardware/qcom/media/product.mk)

# Enable 64-bit mediaserver
PRODUCT_VENDOR_PROPERTIES += \
    ro.mediaserver.64b.enable=true

# Packages
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.2.vendor \
    libavservices_minijail.vendor

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    media.stagefright.thumbnail.prefer_hw_codecs=true \
    ro.media.recorder-max-base-layer-fps=60

# Configure media stack for <5.4 targets
ifneq (,$(filter 4.14 4.19, $(TARGET_KERNEL_VERSION)))
    PRODUCT_COPY_FILES += \
        device/qcom/common/vendor/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml

    ifneq ($(call is-board-platform-in-list, sm6150 msmnile kona),true)
        PRODUCT_ODM_PROPERTIES += \
            debug.stagefright.ccodec=0
    endif
endif

# Configure media stack for >=5.4 targets
ifeq (,$(filter 4.14 4.19, $(TARGET_KERNEL_VERSION)))
    PRODUCT_COPY_FILES += \
        device/qcom/common/vendor/media/$(TARGET_MEDIA_DIR)/init.qti.media.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.media.sh
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media/$(TARGET_MEDIA_DIR)/media-vendor.mk)
