# Include QTI Bluetooth makefiles.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
$(call inherit-product, vendor/qcom/opensource/commonsys-intf/bluetooth/bt-system-opensource-product.mk)
endif

# Properties
ifneq ($(TARGET_USE_QTI_BT_STACK),false)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.bt.a2dp.aac_whitelist=false \
    ro.bluetooth.library_name=libbluetooth_qti.so
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/bt/bt-vendor.mk)
