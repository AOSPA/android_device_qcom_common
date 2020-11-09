# Copyright (C) 2020 Paranoid Android
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

# HIDL
LOC_HIDL_VERSION ?= 4.0

# Include GPS HAL makefiles.
include hardware/qcom/gps/gps_vendor_board.mk
$(call inherit-product, hardware/qcom/gps/gps_vendor_product.mk)

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/gps/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

PRODUCT_PACKAGES += \
    libjson

# Overlays
PRODUCT_PACKAGES += \
    QCOMGPSFrameworksOverlay

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/gps/gps-vendor.mk)
