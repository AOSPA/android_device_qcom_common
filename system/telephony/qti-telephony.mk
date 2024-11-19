#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# AIDL / HIDL
SYSTEM_EXT_MANIFEST_FILES += $(QCOM_COMMON_PATH)/system/telephony/atcmdfwd-saidl.xml

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    net.tethering.noprovisioning=true \
    persist.sys.fflag.override.settings_network_and_internet_v2=true \
    persist.vendor.cne.feature=1 \
    persist.vendor.data.mode=concurrent \
    persist.vendor.dpm.feature=11 \
    persist.vendor.dpm.idletimer.mode=default \
    ril.subscription.types=NV,RUIM \
    ro.telephony.default_network=26,26 \
    ro.telephony.sim_slots.count=2 \
    ro.vendor.use_data_netmgrd=true \
    telephony.active_modems.max_count=2 \
    telephony.lteOnCdmaDevice=1

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.ims.disableADBLogs=1 \
    persist.vendor.ims.disableDebugLogs=1 \
    persist.vendor.ims.disableIMSLogs=1 \
    persist.vendor.ims.disableQXDMLogs=1
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/telephony/telephony-vendor.mk)
