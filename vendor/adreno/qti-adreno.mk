#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

ifeq ($(call is-board-platform-in-list,$(6_1_FAMILY)),true)
  TARGET_ADRENO_DIR ?= u
else ifeq ($(call is-board-platform-in-list,$(5_15_FAMILY)),true)
  TARGET_ADRENO_DIR ?= t
else ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
  TARGET_ADRENO_DIR ?= s
else ifeq ($(call is-board-platform-in-list,$(4_14_FAMILY) $(4_19_FAMILY) $(5_4_FAMILY)),true)
  TARGET_ADRENO_DIR ?= r
else ifeq ($(call is-board-platform-in-list,$(4_19_LEGACY_FAMILY)),true)
  # Adreno 5xx: r (V@0530) finds no EGLConfig with the sdm660 display/gralloc stack (SurfaceFlinger aborts)
  TARGET_ADRENO_DIR ?= 5xx
else
  $(error "Adreno component is enabled, but there is not a directory available for your platform.")
endif

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-$(if $(filter $(TARGET_BOARD_PLATFORM),$(4_19_LEGACY_FAMILY)),0,1).xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-$(if $(filter $(TARGET_BOARD_PLATFORM),$(4_19_LEGACY_FAMILY)),0,1).xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.opengles.version=196610

ifeq ($(TARGET_ADRENO_DIR),r)
PRODUCT_VENDOR_PROPERTIES += \
    graphics.gpu.profiler.support=true
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, device/qcom/common/vendor/adreno/$(TARGET_ADRENO_DIR)/qti-adreno.mk)
$(call inherit-product-if-exists, vendor/qcom/common/vendor/adreno/$(TARGET_ADRENO_DIR)/adreno-vendor.mk)
