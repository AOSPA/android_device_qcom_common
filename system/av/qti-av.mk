#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Enable QCT resampler
AUDIO_FEATURE_ENABLED_EXTN_RESAMPLER := true

# Media
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    vendor.mm.enable.qcom_parser=16777215

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/system/av/av-vendor.mk)
