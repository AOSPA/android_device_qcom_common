#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# AV
BOARD_USES_ADRENO := true
TARGET_USES_AOSP_FOR_AUDIO ?= false
TARGET_USES_QCOM_MM_AUDIO := true
TARGET_USES_ION := true

# Default mount point symlinks to false
# since they are not used on 8998 and up
TARGET_MOUNT_POINTS_SYMLINKS ?= false

# SEPolicy
ifneq ($(TARGET_EXCLUDE_QCOM_SEPOLICY),true)
include device/qcom/sepolicy_vndr/SEPolicy.mk
include device/qcom/common/sepolicy/SEPolicy.mk
endif # Exclude QCOM SEPolicy
