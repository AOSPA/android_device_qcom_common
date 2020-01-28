TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_HAS_QC_KERNEL_SOURCE := true
TARGET_USES_QCOM_MM_AUDIO := true

BOARD_USES_ADRENO := true

BOARD_USES_QCNE := true

TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_BSP ?= false

# SECCOMP Extension
BOARD_SECCOMP_POLICY += device/qcom/common/seccomp

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/common/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/common/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy
