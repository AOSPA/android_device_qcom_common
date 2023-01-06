# Copyright (C) 2023 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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