#
# Copyright (C) 2022 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

include $(QCOM_COMMON_PATH)/dlkm/kernel-platform.mk

$(foreach vdefs, $(sort $(wildcard vendor/qcom/defs/board-defs/vendor/*.mk)), \
    $(call inherit-product, $(vdefs)))
$(foreach vdefs, $(sort $(wildcard vendor/qcom/defs/product-defs/vendor/*.mk)), \
    $(call inherit-product, $(vdefs)))
