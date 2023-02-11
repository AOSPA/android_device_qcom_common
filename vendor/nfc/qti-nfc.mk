TARGET_USES_NQ_NFC ?= true

ifeq ($(TARGET_USES_NQ_NFC), true)

# Inherit from NQ NFC.
$(call inherit-product, vendor/nxp/opensource/commonsys/packages/apps/Nfc/nfc_system_product.mk)
$(call inherit-product, vendor/nxp/opensource/halimpl/nfc_vendor_product.mk)

# Packages
PRODUCT_PACKAGES += \
    se_nq_extn_client \
    ls_nq_client \
    jcos_nq_client

# Permissions
ifneq ($(TARGET_NFC_SKU),)
NFC_PERMISSIONS_DIR := $(TARGET_COPY_OUT_ODM)/etc/permissions/sku_$(TARGET_NFC_SKU)
else
NFC_PERMISSIONS_DIR := $(TARGET_COPY_OUT_VENDOR)/etc/permissions
endif

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(NFC_PERMISSIONS_DIR)/android.hardware.se.omapi.ese.xml \
    frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(NFC_PERMISSIONS_DIR)/android.hardware.se.omapi.uicc.xml

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/nfc/nq-nfc-vendor.mk)

else

PRODUCT_PACKAGES += \
    NfcNci \
    android.hardware.nfc@1.2-service \
    android.hardware.nfc@1.2.vendor \
    android.hardware.secure_element@1.2-service \
    libchrome.vendor

endif
