#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/wlan

TARGET_WLAN_COMPONENT_VARIANT := wlan

BOARD_HAS_QCOM_WLAN := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := //hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib:lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := //hardware/qcom/wlan/qcwcn/wpa_supplicant_8_lib:lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_BUILT := qca_cld3
WIFI_DRIVER_DEFAULT := qca_cld3
WIFI_DRIVER_INSTALL_TO_KERNEL_OUT := true
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

PRODUCT_PACKAGES += \
    android.hardware.wifi.supplicant-V1-ndk.vendor \
    vendor.qti.hardware.wifi.supplicant-V1-ndk.vendor

PRODUCT_SOONG_NAMESPACES += hardware/qcom/wlan/qcwcn

# For mk config
CONFIG_IEEE80211AC := true
CONFIG_IEEE80211AX := true
CONFIG_IEEE80211BE := true

# For bp config
WIFI_FEATURE_HOSTAPD_11AX := true
WIFI_FEATURE_HOSTAPD_11BE := true
WIFI_FEATURE_SUPPLICANT_11AX := true
WIFI_FEATURE_SUPPLICANT_11BE := true

# IPACM
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)

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
$(call inherit-product-if-exists, vendor/qcom/common/vendor/wlan/wlan-vendor.mk)
