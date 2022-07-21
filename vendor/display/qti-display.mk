# Copyright (C) 2022 Paranoid Android
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

# Include display HAL makefiles.
-include hardware/qcom/display/config/display-board.mk
-include hardware/qcom/display/config/display-product.mk

# Lights AIDL Soong Configs
SOONG_CONFIG_NAMESPACES += lights
SOONG_CONFIG_lights += lighttargets
SOONG_CONFIG_lights_lighttargets := lightaidlV1target

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Packages
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V1-ndk_platform.vendor \
    android.hardware.lights-service.qti \
    libqdutils \
    libqservice \
    lights.qcom

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/display/display-vendor.mk)
