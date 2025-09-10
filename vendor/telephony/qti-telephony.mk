#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/telephony

# Data Services
SOONG_CONFIG_NAMESPACES += rmnetctl
SOONG_CONFIG_rmnetctl += \
    old_rmnet_data
SOONG_CONFIG_rmnetctl_old_rmnet_data ?= false
ifneq (,$(filter 4.14 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
SOONG_CONFIG_rmnetctl_old_rmnet_data := true
endif
$(call inherit-product, vendor/qcom/opensource/dataservices/dataservices_vendor_product.mk)

# IPACM
ifeq (,$(filter 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)
else
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr-legacy
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr-legacy/ipacm_vendor_product.mk)
endif

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

PRODUCT_VENDOR_PROPERTIES += \
    persist.radio.multisim.config=dsds \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.procedure_bytes=SKIP \
    persist.vendor.radio.sib16_support=1 \
    persist.vendor.ssr.restart_level=ALL_ENABLE

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.radio.enableadvancedscan=true

ifeq ($(call is-board-platform-in-list, bengal holi),true)
# Vendor property to enable fetching of QoS parameters via IQtiRadio HAL
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.radio.fetchqos=true
endif

# Property to enable single ims registration
PRODUCT_PROPERTY_OVERRIDES += \
     persist.vendor.rcs.singlereg.feature=1

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

ifeq (,$(filter 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml
endif
