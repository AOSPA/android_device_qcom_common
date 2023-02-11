PRODUCT_PACKAGES += \
    libsuspend

PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/charging/vendor.qti.hardware.charger_monitor@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.charger_monitor@1.0-service.rc

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/charging/charging-vendor.mk)
