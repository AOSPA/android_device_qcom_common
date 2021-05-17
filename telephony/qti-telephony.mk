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
    device/qcom/common/telephony

# Data Services
$(call inherit-product, vendor/qcom/opensource/dataservices/dataservices_vendor_product.mk)

# HIDL
DEVICE_FRAMEWORK_MANIFEST_FILE += device/qcom/common/telephony/framework_manifest.xml

# IPACM
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=dsds \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.enableadvancedscan=true \
    persist.vendor.radio.procedure_bytes=SKIP \
    persist.vendor.radio.rat_on=combine \
    persist.vendor.radio.sib16_support=1

# Packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    android.hardware.radio@1.5 \
    android.hardware.radio.config@1.2 \
    android.hardware.radio.deprecated@1.0 \
    libjson

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    DEVICE_PROVISIONED=1 \
    persist.vendor.cne.feature=1 \
    persist.vendor.data.mode=concurrent \
    persist.vendor.dpm.feature=11 \
    ril.subscription.types=NV,RUIM \
    ro.telephony.default_network=33,33 \
    ro.vendor.use_data_netmgrd=true \
    telephony.lteOnCdmaDevice=1

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.ims.disableADBLogs=1 \
    persist.vendor.ims.disableDebugLogs=1 \
    persist.vendor.ims.disableIMSLogs=1 \
    persist.vendor.ims.disableQXDMLogs=1 \
    persist.vendor.ims.loglevel=0 \
    persist.vendor.ims.rtp.enableqxdm=0 \
    persist.vendor.ims.vt.enableadb=0
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/telephony/telephony-vendor.mk)
