# Copyright (C) 2021 Paranoid Android
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

ifeq ($(TARGET_KERNEL_VERSION),4.14)
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-sscrpc-service.rc:vendor/etc/init/vendor.qti.adsprpc-sscrpc-service.rc
else
ifneq ($(TARGET_BOARD_PLATFORM),sdm660)
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-guestos-service.rc:vendor/etc/init/vendor.qti.adsprpc-guestos-service.rc
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.sensors.sscrpcd.rc:vendor/etc/init/vendor.sensors.sscrpcd.rc
else
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-guestos-noaudiopd-service.rc:vendor/etc/init/vendor.qti.adsprpc-guestos-noaudiopd-service.rc
endif
endif

# Get non-open-source specific aspects.
$(call inherit-product, vendor/qcom/common/vendor/dsprpcd/dsprpcd-vendor.mk)
