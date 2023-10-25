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
    device/qcom/common/vendor/telephony

# Data Services
SOONG_CONFIG_NAMESPACES += rmnetctl
SOONG_CONFIG_rmnetctl += \
    old_rmnet_data
SOONG_CONFIG_rmnetctl_old_rmnet_data ?= false
ifeq (,$(filter 5.15, $(TARGET_KERNEL_VERSION)))
SOONG_CONFIG_rmnetctl_old_rmnet_data := true
endif
$(call inherit-product, vendor/qcom/opensource/dataservices/dataservices_vendor_product.mk)

# IPACM
ifneq (,$(filter 5.10 5.15, $(TARGET_KERNEL_VERSION)))
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)
else
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr-legacy
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr-legacy/ipacm_vendor_product.mk)
endif

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

PRODUCT_PACKAGES += \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config@1.3.vendor \
    android.hardware.radio.deprecated@1.0.vendor \
    android.hardware.secure_element@1.2.vendor \
    android.hardware.wifi.hostapd@1.0.vendor \
    android.system.net.netd@1.1.vendor \
    vendor.qti.hardware.systemhelperaidl-V1-ndk.vendor

PRODUCT_PACKAGES += \
    android.hardware.radio.config-V1-ndk.vendor \
    android.hardware.radio.data-V1-ndk.vendor \
    android.hardware.radio.messaging-V1-ndk.vendor \
    android.hardware.radio.modem-V1-ndk.vendor \
    android.hardware.radio.network-V1-ndk.vendor \
    android.hardware.radio.sim-V1-ndk.vendor \
    android.hardware.radio.voice-V1-ndk.vendor \
    android.hardware.radio-V1-ndk.vendor

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.radio.rat_on=combine
endif

PRODUCT_VENDOR_PROPERTIES += \
    persist.radio.multisim.config=dsds \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.procedure_bytes=SKIP \
    persist.vendor.radio.sib16_support=1

ifeq ($(call is-board-platform-in-list, $(3_18_FAMILY) $(4_4_FAMILY) $(4_9_FAMILY)),true)
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.radio.enableadvancedscan=false
else
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.radio.enableadvancedscan=true
endif

ifeq ($(call is-board-platform-in-list, bengal holi),true)
# Vendor property to enable fetching of QoS parameters via IQtiRadio HAL
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.fetchqos=true
endif

ifneq (,$(filter 4.14 4.19 5.4 5.10 5.15, $(TARGET_KERNEL_VERSION)))
# Property to enable single ims registration
PRODUCT_PROPERTY_OVERRIDES += \
     persist.vendor.rcs.singlereg.feature=1
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml
