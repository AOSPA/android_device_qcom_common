#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-guestos-noaudiopd-service.rc:vendor/etc/init/vendor.qti.adsprpc-guestos-noaudiopd-service.rc

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/dsprpcd/dsprpcd-vendor.mk)
