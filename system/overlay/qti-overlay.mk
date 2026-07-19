#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/system/overlay

# Overlays
PRODUCT_PACKAGES += \
    CarrierConfigResCommon_Sys \
    FrameworksResCommon_Sys \
    FrameworksResNonModem_Sys \
    NfcResCommon_Sys \
    SettingsResCommon_Sys \
    SystemUIResCommon_Sys \
    TelecommResCommon_Sys \
    TelephonyResCommon_Sys \
    UwbResCommon_Sys \
    UwbResCommonMainline_Sys \
    WifiResCommon_Sys \
    WifiResCommonMainline_Sys

PRODUCT_COPY_FILES += \
    device/qcom/common/system/overlay/partition_order.xml:$(TARGET_COPY_OUT_PRODUCT)/overlay/partition_order.xml
