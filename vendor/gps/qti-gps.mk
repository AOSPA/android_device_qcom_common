PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/gps

# Flags
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := default

# Inherit the GPS HAL.
$(call inherit-product-if-exists, hardware/qcom/gps/gps_vendor_product.mk)

# Overlays
PRODUCT_PACKAGES += \
    QCOMGPSFrameworksOverlay

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/gps/gps-vendor.mk)
