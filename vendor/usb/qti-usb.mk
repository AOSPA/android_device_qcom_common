PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/usb

# Inherit from the USB product definition.
$(call inherit-product, vendor/qcom/opensource/usb/vendor_product.mk)

ifneq (,$(filter 5.4 5.10, $(TARGET_KERNEL_VERSION)))
TARGET_HAS_DIAG_ROUTER := true
endif

ifeq (,$(filter 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
PRODUCT_PACKAGES += android.hardware.usb@1.0-service
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_PACKAGES += \
    init.aospa.usb.rc
