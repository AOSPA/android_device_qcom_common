# include additional build utilities
include device/qcom/common/utils.mk

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_HAS_QC_KERNEL_SOURCE := true
TARGET_USES_QCOM_MM_AUDIO := true

BOARD_USES_ADRENO := true

BOARD_USES_QCNE := true

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

ifneq ($(call is-board-platform-in-list, msm8996 sdm660), true)
TARGET_USES_AOSP ?= false
else
TARGET_USES_AOSP ?= true
endif

TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_BSP ?= false

#skip boot jars check
SKIP_BOOT_JARS_CHECK := true

# SECCOMP Extension
BOARD_SECCOMP_POLICY += device/qcom/common/seccomp

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/common/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/common/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy
