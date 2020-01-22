# include additional build utilities
include device/qcom/common/utils.mk

# Set TARGET_USES_AOSP per platform following Qualcomm.
ifneq ($(call is-board-platform-in-list, msm8996 sdm660), true)
TARGET_USES_AOSP ?= false
else
TARGET_USES_AOSP ?= true
endif

# Audio
TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_MM_AUDIO := true
-include $(TOPDIR)vendor/qcom/opensource/audio-hal/primary-hal/configs/qssi/qssi.mk

# Bluetooth
ifeq ($(TARGET_USE_QTI_BT_STACK),true)
ifneq ($(call is-board-platform-in-list, msm8937 msm8953 msm8996 msm8998 sdm660), true)
# Recent Platform
-include vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-board.mk
else
# Legacy Platform
-include vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-legacy-board.mk
endif
# If BLUETOOTH_QCOM and !QTI_BT_STACK
else if ($(BOARD_HAVE_BLUETOOTH_QCOM),true)
-include vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-legacy-aosp-board.mk
endif
# For all devices with QCOM BT
ifeq ($(BOARD_HAVE_BLUETOOTH_QCOM),true)
include vendor/qcom/opensource/commonsys-intf/bluetooth/bt-system-opensource-product.mk
endif


# Display
BOARD_USES_ADRENO := true
TARGET_USES_ION := true
TARGET_USES_QCOM_BSP ?= false
-include hardware/qcom/display/config/display-board.mk
$(call inherit-product-if-exists, hardware/qcom/display/display-product.mk)
$(call inherit-product-if-exists, vendor/qcom/opensource/commonsys-intf/display/display-interfaces-product.mk)
$(call inherit-product-if-exists, vendor/qcom/opensource/commonsys-intf/display/display-product-system.mk)

# Kernel
TARGET_COMPILE_WITH_MSM_KERNEL := true

# Media
TARGET_ENABLE_MEDIADRM_64 := true
$(call inherit-product-if-exists, hardware/qcom/media/product.mk)

# Power
ifneq ($(TARGET_PROVIDES_POWERHAL),true)
-include vendor/qcom/opensource/power/power-vendor-board.mk
$(call inherit-product-if-exists, vendor/qcom/opensource/power/power-vendor-product.mk)
endif

#skip boot jars check
SKIP_BOOT_JARS_CHECK := true

# Wifi
DISABLE_EAP_PROXY := true
