TARGET_WFD_COMPONENT_VARIANT := wfd-legacy

DEVICE_MANIFEST_FILE += device/qcom/common/vendor/wfd-legacy/configs/vintf/wfd-legacy-manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += device/qcom/common/vendor/wfd-legacy/configs/vintf/miracast_framework_compatibility_matrix.xml

PRODUCT_PACKAGES += \
    libwfdaac_vendor

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/wfd-legacy/wfd-legacy-vendor.mk)
