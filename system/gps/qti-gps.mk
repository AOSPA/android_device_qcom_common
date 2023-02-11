# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.backup.ntpServer="0.pool.ntp.org"

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/gps/gps-vendor.mk)
