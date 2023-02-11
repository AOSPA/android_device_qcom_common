TARGET_WFD_COMPONENT_VARIANT := wfd-legacy

DEVICE_FRAMEWORK_MANIFEST_FILE += device/qcom/common/system/wfd-legacy/configs/vintf/framework_manifest.xml

PRODUCT_PACKAGES += \
    libnl

PRODUCT_BOOT_JARS += \
    WfdCommon

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Display
PRODUCT_PACKAGES += \
    libdisplayconfig \
    libqdMetaData \
    libqdMetaData.system

# Media
PRODUCT_PACKAGES += \
    libaacwrapper

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/wfd-legacy/wfd-legacy-vendor.mk)
