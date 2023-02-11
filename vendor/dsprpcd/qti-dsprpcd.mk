ifeq ($(TARGET_KERNEL_VERSION),4.14)
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-sscrpc-service.rc:vendor/etc/init/vendor.qti.adsprpc-sscrpc-service.rc
else
ifneq ($(TARGET_BOARD_PLATFORM),sdm660)
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-guestos-service.rc:vendor/etc/init/vendor.qti.adsprpc-guestos-service.rc
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.sensors.sscrpcd.rc:vendor/etc/init/vendor.sensors.sscrpcd.rc
else
PRODUCT_COPY_FILES += $(QCOM_COMMON_PATH)/vendor/dsprpcd/vendor.qti.adsprpc-guestos-noaudiopd-service.rc:vendor/etc/init/vendor.qti.adsprpc-guestos-noaudiopd-service.rc
endif
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/dsprpcd/dsprpcd-vendor.mk)
