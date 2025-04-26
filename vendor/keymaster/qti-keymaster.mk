#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_MANIFEST_FILE += \
    $(QCOM_COMMON_PATH)/vendor/keymaster/gatekeeper-manifest.xml \
    $(QCOM_COMMON_PATH)/vendor/keymaster/keymaster-manifest.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/keymaster/keymaster-vendor.mk)
