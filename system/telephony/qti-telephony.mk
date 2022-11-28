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

# HIDL
SYSTEM_EXT_MANIFEST_FILES += $(QCOM_COMMON_PATH)/system/telephony/atcmdfwd-saidl.xml

# Packages
PRODUCT_PACKAGES += \
    android.hardware.radio@1.6 \
    android.hardware.radio.config@1.3 \
    android.hardware.radio.deprecated@1.0 \
    android.system.net.netd@1.1 \
    libjson

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    DEVICE_PROVISIONED=1 \
    net.tethering.noprovisioning=true \
    persist.sys.fflag.override.settings_network_and_internet_v2=true \
    persist.vendor.cne.feature=1 \
    persist.vendor.data.mode=concurrent \
    persist.vendor.dpm.feature=11 \
    persist.vendor.dpm.idletimer.mode=default \
    ril.subscription.types=NV,RUIM \
    ro.telephony.default_network=33,33 \
    ro.telephony.sim_slots.count=2 \
    ro.vendor.use_data_netmgrd=true \
    telephony.active_modems.max_count=2 \
    telephony.lteOnCdmaDevice=1

ifeq ($(TARGET_BOARD_PLATFORM), holi)
# System prop to enable fetching of QoS parameters via IQtiRadio HAL
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.radio.fetchqos=true
endif

# Force voLTE/voWIFI/viLTE
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.wfc_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.ims.disableADBLogs=1 \
    persist.vendor.ims.disableDebugLogs=1 \
    persist.vendor.ims.disableIMSLogs=1 \
    persist.vendor.ims.disableQXDMLogs=1
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/telephony/telephony-vendor.mk)
