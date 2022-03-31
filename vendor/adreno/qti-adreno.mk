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

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.opengles.version=196610

# Get non-open-source specific aspects.
$(call inherit-product, vendor/qcom/common/vendor/adreno/adreno-vendor.mk)

# Use qtimapper-shim for sdm845
ifeq ($(call is-board-platform-in-list,sdm845),true)
ifneq (,$(filter 4.9, $(TARGET_KERNEL_VERSION)))
# Guard for qtimapper-shim usage
TARGET_USES_QTIMAPPER_SHIM ?= true

ifeq ($(TARGET_USES_QTIMAPPER_SHIM), true)
# Qtimapper shim
PRODUCT_PACKAGES += \
    android.hardware.graphics.mappershim \
    vendor.qti.hardware.display.mappershim \
    vendor.qti.hardware.display.mapperextensionsshim

# Use patched adreno blobs with qtimapper-shim
PRODUCT_PACKAGES += \
    libCB-qtimapper-shim \
    eglSubDriverAndroid-qtimapper-shim \
    vulkan.adreno-qtimapper-shim
endif
endif
endif
