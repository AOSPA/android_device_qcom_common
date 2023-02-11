# AV
BOARD_USES_ADRENO := true
TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_MM_AUDIO := true
TARGET_USES_ION := true

# Enable Media Extensions for HAL1 on Legacy Devices
ifeq ($(call is-board-platform-in-list, msm8937 msm8953 msm8996 msm8998 sdm660),true)
  TARGET_USES_MEDIA_EXTENSIONS := true
endif

# Default mount point symlinks to false
# since they are not used on 8998 and up
TARGET_MOUNT_POINTS_SYMLINKS ?= false

# SEPolicy
ifneq ($(TARGET_EXCLUDE_QCOM_SEPOLICY),true)
ifneq ($(call is-board-platform-in-list, msm8937 msm8953 msm8998 sdm660),true)
include device/qcom/sepolicy_vndr/SEPolicy.mk
else # if (8937 || 8953 || 8998 || 660)
include device/qcom/sepolicy/SEPolicy.mk
endif # !(8937 || 8953 || 8998 || 660)
include device/qcom/common/sepolicy/SEPolicy.mk
endif # Exclude QCOM SEPolicy
