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

# Include QTI Bluetooth makefiles.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
include vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-board.mk
endif

# Packages
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.1.vendor \
    android.hardware.bluetooth.audio@2.1-impl \
    audio.bluetooth.default \
    com.dsi.ant@1.0.vendor \
    com.qualcomm.qti.bluetooth_audio@1.0.vendor \
    libldacBT_enc \
    libldacBT_abr \
    vendor.qti.hardware.bluetooth_audio@2.1.vendor \
    vendor.qti.hardware.btconfigstore@1.0.vendor \
    vendor.qti.hardware.btconfigstore@2.0.vendor

# FM
PRODUCT_PACKAGES += \
    vendor.qti.hardware.fm@1.0.vendor

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml

#ANT/BT/FM/WIPOWER PROPERTIES

ifeq ($(TARGET_BOARD_PLATFORM), atoll msmnile) #
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=cherokee
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=true
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptive
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
#aac frame control support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=true
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=false
endif

ifeq ($(TARGET_BOARD_PLATFORM), bengal sm6150 sdm710 sdm845 trinket)
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=cherokee
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=true
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
#aac frame control support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=true
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=false
endif

ifeq ($(TARGET_BOARD_PLATFORM), kona)  # kona/sm8250 specific defines
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=hastings
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=true
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
#aac frame control support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true
#A2dp Multicast support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_mcast_test.enabled=false
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true
#AptX Adaptive R2.1 support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=false
#HearingAid support
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_bluetooth_hearing_aid=true
endif

ifeq ($(TARGET_BOARD_PLATFORM), lahaina) # lahaina specific defines
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2
#aac frame control support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#A2dp Multicast support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_mcast_test.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true
#AptX Adaptive R2.1 support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=true
#HearingAid support
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_bluetooth_hearing_aid=true
endif

ifeq ($(TARGET_BOARD_PLATFORM), lito) # lito specific defines
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=cherokee
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=true
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true
#AptX Adaptive R2.1 support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=false
#HearingAid support
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_bluetooth_hearing_aid=true
endif

ifeq ($(TARGET_BOARD_PLATFORM), holi) # holi specific defines
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=true
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=false
endif

ifeq ($(TARGET_BOARD_PLATFORM), msm8998 sdm660)
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=cherokee
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=true
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxhd-aac-ldac
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
endif

ifeq ($(TARGET_BOARD_PLATFORM), msm8996) # MSM8996 specific defines
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=rome
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=false
# Set this true as ROME which is programmed
# as embedded wipower mode by default
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
endif

ifeq ($(TARGET_BOARD_PLATFORM), msm8909 msm8937 msm8952 msm8953)
#Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.soc=pronto
#split a2dp support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.enable.splita2dp=false
#Embedded wipower mode
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.wipower=false
endif

ifeq ($(TARGET_BOARD_PLATFORM), parrot taro)
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2
#aac frame control support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#A2dp Multicast support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_mcast_test.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true
#AptX Adaptive R2.1 support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=true
#HearingAid support
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_bluetooth_hearing_aid=true
#QC CSIP enable
PRODUCT_PROPERTY_OVERRIDES += ro.vendor.bluetooth.csip_qti=true
endif

ifeq ($(TARGET_BOARD_PLATFORM), kalama) # kailua specific defines
#a2dp offload capability
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac-aptxadaptiver2
#aac frame control support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_frm_ctl.enabled=true
#TWS+ state support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.twsp_state.enabled=false
#A2dp Multicast support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.a2dp_mcast_test.enabled=false
#Scrambling support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.scram.enabled=false
#AAC VBR support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true
#AptX Adaptive R2.1 support
PRODUCT_PROPERTY_OVERRIDES += persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=true
#HearingAid support
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fflag.override.settings_bluetooth_hearing_aid=true
#Basic Audio Profile (BAP) broadcast assist role is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.bap.broadcast.assist.enabled=true
#Basic Audio Profile (BAP) broadcast source role is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.bap.broadcast.source.enabled=true
#Basic Audio Profile (BAP) unicast client role is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.bap.unicast.client.enabled=true
#Volume Control Profile (VCP) controller role is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.vcp.controller.enabled=true
#Coordinated Set Identification Profile (CSIP) is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.csip.set_coordinator.enabled=true
#Media Control Profile (MCP) is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.mcp.server.enabled=true
#Call Control Profile (CCP) is enabled
PRODUCT_PROPERTY_OVERRIDES += bluetooth.profile.ccp.server.enabled=true
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/bt/bt-vendor.mk)
