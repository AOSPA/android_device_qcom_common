# Copyright (C) 2021 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/media-legacy

TARGET_MEDIA_COMPONENT_VARIANT := media-legacy

ifneq ($(call is-board-platform-in-list, sm6150 msmnile kona),true)
TARGET_DISABLE_C2_CODEC ?= true
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

ifneq ($(TARGET_DISABLE_C2_CODEC),true)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media-legacy/C2/media-legacy-vendor.mk)
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media-legacy/media-legacy-vendor.mk)
