#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/wlan-legacy

TARGET_WLAN_COMPONENT_VARIANT := wlan-legacy

BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := //hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib:lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := //hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib:lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    fstman \
    fstman.ini \
    hostapd \
    hostapd.accept \
    hostapd.deny \
    hostapd_cli \
    hostapd_default.conf \
    libqsap_sdk \
    libwifi-hal-qcom \
    sigma_dut \
    wpa_supplicant \
    wpa_supplicant.conf

ifeq ($(call is-board-platform-in-list, lahaina),true)
PRODUCT_PACKAGES += \
    init.vendor.wlan.rc
endif

PRODUCT_SOONG_NAMESPACES += hardware/qcom/wlan/qcwcn

# Enable IEEE 802.11ax support
ifeq ($(call is-board-platform-in-list, $(4_14_FAMILY) $(4_19_FAMILY) $(5_4_FAMILY)),true)
CONFIG_IEEE80211AX := true
WIFI_FEATURE_HOSTAPD_11AX := true
WIFI_FEATURE_SUPPLICANT_11AX := true
endif

# IPACM
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr-legacy
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr-legacy/ipacm_vendor_product.mk)

# Include QCOM WLAN makefiles.
ifeq ($(call is-board-platform-in-list,sdm845),true)
-include device/qcom/wlan/skunk/wlan.mk
else ifeq ($(call is-board-platform-in-list,msm8998 sdm660),true)
-include device/qcom/wlan/sdm660_64/wlan.mk
else ifeq ($(call is-board-platform-in-list,sm6150),true)
-include device/qcom/wlan/talos/wlan.mk
else
-include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/wlan.mk
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/wlan-legacy/wlan-legacy-vendor.mk)
