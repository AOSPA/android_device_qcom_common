#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

# Include display HAL makefiles.
-include hardware/qcom/display/config/display-board.mk
-include hardware/qcom/display/config/display-product.mk

# Include QTI AIDL Lights HAL
-include vendor/qcom/opensource/lights/lights-vendor-product.mk

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# Properties for <6.1 targets
# These are already set on 6.1+.
ifneq (,$(filter 4.14 4.19 5.4 5.10 5.15, $(TARGET_KERNEL_VERSION)))
PRODUCT_ODM_PROPERTIES += \
    debug.sf.auto_latch_unsignaled=1 \
    debug.sf.disable_client_composition_cache=0
endif

# Properties for <5.15 targets
# These are already set on 5.15+.
ifneq (,$(filter 4.14 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.graphics.game_default_frame_rate.disabled=1
endif

# Properties for <5.10 targets
# These are already set on 5.10+.
ifneq (,$(filter 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.predict_hwc_composition_strategy=0 \
    debug.sf.treat_170m_as_sRGB=1

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.game_default_frame_rate_override=60
else
# Properties for 5.10+ targets
PRODUCT_ODM_PROPERTIES += \
    ro.surface_flinger.clear_slots_with_set_layer_buffer=true
endif

# Properties for <4.19 targets
# These are already set on 4.19+.
ifneq (,$(filter 4.14, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    debug.sf.latch_unsignaled=1
endif

# Copy feature_enabler rc only for lahaina on 5.4
ifeq ($(call is-board-platform-in-list, lahaina),true)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/display/5.4/feature_enabler_client.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/feature_enabler_client.rc
endif

# Disable custom content metadata region on <5.15 targets
ifneq (,$(filter 4.14 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
$(call soong_config_set, qtidisplaycommonsys, gralloc_handle_has_no_custom_content_md_reserved_size, true)
endif

# Disable UBWC-P on <6.1 targets
ifneq (,$(filter 4.14 4.19 5.4 5.10 5.15, $(TARGET_KERNEL_VERSION)))
$(call soong_config_set, qtidisplaycommonsys, gralloc_handle_has_no_ubwcp, true)
endif

# Use TARGET_KERNEL_VERSION for TARGET_DISP_DIR unless otherwise specified
ifeq ($(TARGET_KERNEL_VERSION)_$(TARGET_BOARD_PLATFORM),5.15_bengal)
    TARGET_DISP_DIR := 5.15_bengal
else
    TARGET_DISP_DIR := $(TARGET_KERNEL_VERSION)
endif

# Copy Advanced SF Offsets Config if present
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,advanced_sf_offsets.xml,device/qcom/common/vendor/display/$(TARGET_DISP_DIR),$(TARGET_COPY_OUT_VENDOR)/etc/display)

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/display/$(TARGET_DISP_DIR)/display-vendor.mk)
$(call inherit-product, vendor/qcom/common/vendor/display/display-vendor.mk)
