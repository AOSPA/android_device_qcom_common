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

# Error if TARGET_BOARD_PLATFORM is not set because otherwise the modules with the board in the name cannot be built.
ifeq ($(TARGET_BOARD_PLATFORM),)
$(error, TARGET_BOARD_PLATFORM is not defined yet. Please define in your device Makefile if you wish to use this component)
endif

# Include Display HAL Makefiles
include hardware/qcom/display/config/display-product.mk
include vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/display/display-vendor.mk)
