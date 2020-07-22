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

DEVICE_FRAMEWORK_MANIFEST_FILE += device/qcom/common/telephony/framework_manifest.xml

# Radio
$(call inherit-product-if-exists, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)

PRODUCT_PACKAGES += \
    android.hardware.radio@1.4 \
    android.hardware.radio.config@1.2 \
    android.hardware.radio.deprecated@1.0 \
    librmnetctl

# Dual SIM - allow setting calling account to 'Ask every time'
# rather than resetting to sub 1 every boot
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.vendor.radio.aosp_usr_pref_sel=true

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/telephony/telephony-vendor.mk)
