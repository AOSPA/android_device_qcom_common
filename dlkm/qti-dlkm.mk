#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

include $(QCOM_COMMON_PATH)/dlkm/kernel-platform.mk

$(foreach vbdefs, $(sort $(wildcard vendor/qcom/defs/board-defs/vendor/*.mk)), \
    $(call inherit-product, $(vbdefs)))
$(foreach vpdefs, $(sort $(wildcard vendor/qcom/defs/product-defs/vendor/*.mk)), \
    $(call inherit-product, $(vpdefs)))
