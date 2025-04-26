#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/media-legacy

TARGET_MEDIA_COMPONENT_VARIANT := media-legacy

ifneq ($(call is-board-platform-in-list, sm6150 msmnile kona),true)
TARGET_DISABLE_C2_CODEC ?= true
endif

ifeq ($(TARGET_DISABLE_C2_CODEC),true)
PRODUCT_ODM_PROPERTIES += \
    debug.stagefright.ccodec=0
endif

# Inherit configuration from the HAL.
$(call inherit-product-if-exists, hardware/qcom/media/product.mk)

# Manifest
ifneq ($(TARGET_USES_CUSTOM_C2_MANIFEST), true)
DEVICE_MANIFEST_FILE += \
    $(QCOM_COMMON_PATH)/vendor/media-legacy/c2_manifest_vendor.xml
endif

# Media Profiles
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml

# Packages
PRODUCT_PACKAGES += \
    libavservices_minijail.vendor \
    libcodec2_hidl@1.0.vendor \
    libcodec2_vndk.vendor \
    libgui_vendor \
    libstagefright_softomx.vendor

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    media.stagefright.thumbnail.prefer_hw_codecs=true \
    ro.media.recorder-max-base-layer-fps=60

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media-legacy/media-legacy-vendor.mk)
