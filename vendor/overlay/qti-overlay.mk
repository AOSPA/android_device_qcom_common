# Copyright (C) 2024 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/overlay

ifneq ($(TARGET_BOARD_SUFFIX),_515)
# Overlays
PRODUCT_PACKAGES += \
    BluetoothResTarget_$(TARGET_BOARD_PLATFORM) \
    FrameworksResTarget_$(TARGET_BOARD_PLATFORM) \
    SecureElementResTarget_$(TARGET_BOARD_PLATFORM) \
    WifiResTarget_$(TARGET_BOARD_PLATFORM) \
    WifiResTarget_spf_$(TARGET_BOARD_PLATFORM) \
    WifiResTargetMainline_$(TARGET_BOARD_PLATFORM) \
    WifiResTargetMainline_spf_$(TARGET_BOARD_PLATFORM)
endif

ifeq ($(TARGET_BOARD_PLATFORM),lahaina)
PRODUCT_PACKAGES += \
    WifiResTarget_yupik_iot \
    WifiResTargetMainline_yupik_iot
endif

ifeq ($(TARGET_BOARD_PLATFORM),taro)
PRODUCT_PACKAGES += \
    WifiResTarget_cape \
    WifiResTargetMainline_cape
endif
