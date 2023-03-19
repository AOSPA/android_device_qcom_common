# Copyright (C) 2023 Paranoid Android
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

ifneq ($(TARGET_USE_QTI_AIDL_HEALTH),true)
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl-qti \
    android.hardware.health@2.1-service

PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/charging/init.charging_sevice.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.charging_sevice.rc
else
$(call inherit-product, vendor/qcom/opensource/healthd-ext/health-vendor-product.mk)
endif

PRODUCT_PACKAGES += \
    libsuspend

PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/charging/vendor.qti.hardware.charger_monitor@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.charger_monitor@1.0-service.rc

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/charging/charging-vendor.mk)
