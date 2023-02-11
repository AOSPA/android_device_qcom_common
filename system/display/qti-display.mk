# Include display HAL makefiles.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
include vendor/qcom/opensource/commonsys-intf/display/config/display-interfaces-product.mk
include vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk
include vendor/qcom/opensource/commonsys/display/config/display-product-commonsys.mk
endif

# Packages
PRODUCT_PACKAGES += \
    android.hardware.graphics.common-V1-ndk_platform

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/display/display-vendor.mk)
