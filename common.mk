# include additional build utilities
include device/qcom/common/utils.mk

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_USES_QCOM_MM_AUDIO := true

BOARD_USES_ADRENO := true

TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_BSP ?= false

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
