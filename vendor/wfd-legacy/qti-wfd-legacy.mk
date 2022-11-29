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

TARGET_WFD_COMPONENT_VARIANT := wfd-legacy

DEVICE_MANIFEST_FILE += device/qcom/common/vendor/wfd-legacy/configs/vintf/wfd-legacy-manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/qcom/common/vendor/wfd-legacy/configs/vintf/miracast_framework_compatibility_matrix.xml

PRODUCT_PACKAGES += \
    libwfdaac_vendor

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/wfd-legacy/wfd-legacy-vendor.mk)
