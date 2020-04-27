# Copyright (C) 2020 Paranoid Android
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

# From vendor/qcom/opensource/commonsys-intf/bluetooth/bt-commonsys-intf-board.mk

#ANT
BOARD_ANT_WIRELESS_DEVICE := "qualcomm-hidl"

#BT
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
TARGET_USE_QTI_BT_STACK := true

#FM - needs libqcomfm_jni
#BOARD_HAVE_QCOM_FM := true

TARGET_USE_QTI_BT_CONFIGSTORE := true
TARGET_USE_QTI_BT_SAR := true
TARGET_USE_QTI_VND_FWK_DETECT := true

$(call inherit-product, vendor/qcom/opensource/commonsys-intf/bluetooth/bt-system-opensource-product.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/bt/bt-vendor.mk)
