PRODUCT_PACKAGES += \
    libdrm.vendor

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/qseecomd/qseecomd-vendor.mk)
