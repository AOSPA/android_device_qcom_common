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

# Comment out the following line because this device has separate Makefiles
# depending on if vendor is or isn't built. Unfortunately, we can't tell
# that from this product Makefile, so we need to wait until Android.mk.
# See setup-makefiles.sh for more information.
# Get non-open-source specific aspects
#$(call inherit-product-if-exists, vendor/qcom/common/adreno-6xx/adreno-6xx-vendor.mk)
