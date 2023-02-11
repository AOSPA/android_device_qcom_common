# Boot Jars
PRODUCT_BOOT_JARS += \
    QPerformance \
    UxPerformance

# Packages
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0 \
    libavservices_minijail

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/system/perf/perf-vendor.mk)
