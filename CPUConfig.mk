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

# All 64-bit targets
TARGET_ARCH := arm64
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=

# Enable 32-bit libraries for 5.15 and lower by default
ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4 5.10 5.15, $(TARGET_KERNEL_VERSION)))
TARGET_2ND_ARCH := arm
endif

# All 32-bit targets
ifeq ($(TARGET_2ND_ARCH),arm)
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
endif

# Set Armv9 for 5.10+
ifeq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
TARGET_ARCH_VARIANT := armv9-a
# Set Armv8.2 Dotprod for 4.14+
else ifneq (,$(filter 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_2ND_ARCH_VARIANT := armv8-2a
# Set Armv8.2 for 4.9
else ifneq (,$(filter 4.9, $(TARGET_KERNEL_VERSION)))
TARGET_ARCH_VARIANT := armv8-2a
TARGET_2ND_ARCH_VARIANT := armv8-2a
# Set Armv8 for the rest
else
TARGET_ARCH_VARIANT := armv8-a
TARGET_2ND_ARCH_VARIANT := armv8-a
endif

# Set Cortex-A510 on 5.10 and 5.15
ifeq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
TARGET_CPU_VARIANT := cortex-a510
else ifneq (,$(filter 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
TARGET_CPU_VARIANT := cortex-a76
TARGET_2ND_CPU_VARIANT := cortex-a76
else ifneq (,$(filter 4.9, $(TARGET_KERNEL_VERSION)))
TARGET_CPU_VARIANT := kryo385
else
TARGET_CPU_VARIANT := generic
endif
