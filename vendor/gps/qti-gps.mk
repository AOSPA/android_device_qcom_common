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

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/gps

# Flags
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default

# Inherit the GPS HAL.
$(call inherit-product-if-exists, hardware/qcom/gps/gps_vendor_product.mk)

ifneq (,$(filter 5.10, $(TARGET_KERNEL_VERSION)))
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/location
$(call inherit-product, vendor/qcom/opensource/location/gps_vendor_product.mk)
else
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/location-legacy
$(call inherit-product, vendor/qcom/opensource/location-legacy/gps_vendor_product.mk)
endif

# Overlays
PRODUCT_PACKAGES += \
    QCOMGPSFrameworksOverlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/gps/gps-vendor.mk)
