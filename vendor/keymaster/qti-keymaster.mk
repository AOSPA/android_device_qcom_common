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

# Packages
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.keymaster@4.0.vendor \
    android.hardware.keymaster@4.1.vendor

DEVICE_MANIFEST_FILE += \
    $(QCOM_COMMON_PATH)/vendor/keymaster/gatekeeper-manifest.xml \
    $(QCOM_COMMON_PATH)/vendor/keymaster/keymaster-manifest.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/keymaster/keymaster-vendor.mk)
