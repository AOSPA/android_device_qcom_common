#
# Copyright (C) 2021-2022 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_USES_NQ_NFC ?= true

ifeq ($(TARGET_USES_NQ_NFC), true)

# Inherit from NQ NFC.
$(call inherit-product, device/qcom/common/vendor/nfc/nq/qti-nfc.mk)

else

PRODUCT_PACKAGES += \
    NfcNci \
    android.hardware.nfc@1.2-service \
    android.hardware.nfc@1.2.vendor \
    android.hardware.secure_element@1.2-service \
    libchrome.vendor

endif
