# Copyright (C) 2016 ParanoidAndroid Project
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

SDCLANG ?= false
SDCLANG_FORCED ?= false

SDCLANG_PATH := vendor/qcom/sdclang-3.8/linux-x86/bin

SDCLANG_LTO_DEFS := device/qcom/common/sdclang/sdllvm-lto-defs.mk

SDCLANG_COMMON_FLAGS := -O3
