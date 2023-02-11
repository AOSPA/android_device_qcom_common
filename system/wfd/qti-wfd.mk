TARGET_WFD_COMPONENT_VARIANT := wfd

PRODUCT_PACKAGES += \
    libavservices_minijail \
    libnl

PRODUCT_BOOT_JARS += \
    WfdCommon

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.enable_hwc_vds=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Inherit QCOM display dependencies.
$(call inherit-product-if-exists, vendor/qcom/opensource/commonsys-intf/display/config/display-product-system.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/system/wfd/wfd-vendor.mk)
