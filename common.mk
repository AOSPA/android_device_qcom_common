# include additional build utilities
include device/qcom/common/utils.mk

# Audio
TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_MM_AUDIO := true
# Inherit QSSI Audio HAL Definitions
-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/qssi/qssi.mk
# Override Proprietary Definitions From QSSI Audio HAL Makefile
AUDIO_FEATURE_ENABLED_3D_AUDIO := false
AUDIO_FEATURE_ENABLED_AHAL_EXT := false

# Bluetooth
ifeq ($(TARGET_USE_QTI_BT_STACK),true)
# Legacy Platform
ifeq ($(call is-board-platform-in-list, msm8937 msm8953 msm8996 msm8998 sdm660),true)
-include $(TOPDIR)vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-legacy-board.mk
else
# Recent Platform
-include $(TOPDIR)vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-board.mk
endif
# If BLUETOOTH_QCOM and !QTI_BT_STACK
elseif ($(BOARD_HAVE_BLUETOOTH_QCOM),true)
-include $(TOPDIR)vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-legacy-aosp-board.mk
endif
# For all devices with QCOM BT
ifeq ($(BOARD_HAVE_BLUETOOTH_QCOM),true)
$(call inherit-product-if-exists, vendor/qcom/opensource/commonsys-intf/bluetooth/bt-system-opensource-product.mk)
endif

# Display
BOARD_USES_ADRENO := true
TARGET_USES_ION := true
TARGET_USES_QCOM_BSP ?= false
-include $(TOPDIR)hardware/qcom/display/config/display-board.mk
$(call inherit-product-if-exists, hardware/qcom/display/config/display-product.mk)
$(call inherit-product-if-exists, vendor/qcom/opensource/commonsys-intf/display/config/display-interfaces-product.mk)
$(call inherit-product-if-exists, vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk)

# Kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

# Media
TARGET_ENABLE_MEDIADRM_64 := true
$(call inherit-product-if-exists, hardware/qcom/media/product.mk)

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
-include $(TOPDIR)vendor/qcom/opensource/power/power-vendor-board.mk
$(call inherit-product-if-exists, vendor/qcom/opensource/power/power-vendor-product.mk)
endif

# SECCOMP Extension
BOARD_SECCOMP_POLICY += device/qcom/common/seccomp

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/common/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/common/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy
