# Packages
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.keymaster@4.0.vendor \
    android.hardware.keymaster@4.1.vendor

DEVICE_MANIFEST_FILE += \
    $(QCOM_COMMON_PATH)/vendor/keymaster/gatekeeper-manifest.xml \
    $(QCOM_COMMON_PATH)/vendor/keymaster/keymaster-manifest.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/keymaster/keymaster-vendor.mk)
