#
# Copyright (C) 2022 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

include $(QCOM_COMMON_PATH)/dlkm/kernel-platform.mk

# Audio
-include vendor/qcom/opensource/audio-kernel/audio_kernel_product_board.mk
-include vendor/qcom/opensource/audio-kernel/audio_kernel_vendor_board.mk

# CVP
-include vendor/qcom/opensource/cvp-kernel/cvp_kernel_board.mk
-include vendor/qcom/opensource/cvp-kernel/cvp_kernel_product.mk

# Camera
-include vendor/qcom/opensource/camera-kernel/board.mk
-include vendor/qcom/opensource/camera-kernel/product.mk

# Dataipa
-include vendor/qcom/opensource/dataipa/dataipa_dlkm_vendor_board.mk
-include vendor/qcom/opensource/dataipa/dataipa_dlkm_vendor_product.mk

# Datarmnet
-include vendor/qcom/opensource/datarmnet/datarmnet_dlkm_vendor_board.mk
-include vendor/qcom/opensource/datarmnet/datarmnet_dlkm_vendor_product.mk
-include vendor/qcom/opensource/datarmnet-ext/datarmnet_ext_dlkm_vendor_board.mk
-include vendor/qcom/opensource/datarmnet-ext/datarmnet_ext_dlkm_vendor_product.mk

# Display
-include vendor/qcom/opensource/display-drivers/display_driver_board.mk
-include vendor/qcom/opensource/display-drivers/display_driver_product.mk

# EVA
-include vendor/qcom/opensource/eva-kernel/eva_kernel_board.mk
-include vendor/qcom/opensource/eva-kernel/eva_kernel_product.mk

# MMRM
-include vendor/qcom/opensource/mmrm-driver/mmrm_kernel_board.mk
-include vendor/qcom/opensource/mmrm-driver/mmrm_kernel_product.mk

# Video
-include vendor/qcom/opensource/video-driver/video_kernel_board.mk
-include vendor/qcom/opensource/video-driver/video_kernel_product.mk
