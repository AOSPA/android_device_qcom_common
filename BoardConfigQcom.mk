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
# 4.19 legacy UM (literal list: the family variable is product-scope). The device includes
# device/qcom/sepolicy-legacy-um; only AOSPA's system_ext app policy is shared.
ifneq (,$(filter sdm660,$(TARGET_BOARD_PLATFORM)))
ifneq ($(AOSPA_BUILD),)
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    device/qcom/common/sepolicy/aospa/private \
    device/qcom/common/sepolicy/pixel/private
endif
else
include device/qcom/sepolicy_vndr/SEPolicy.mk
include device/qcom/common/sepolicy/SEPolicy.mk
endif
endif # Exclude QCOM SEPolicy
