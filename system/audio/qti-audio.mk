# Inherit from QSSI audio makefiles.
-include $(TOPDIR)vendor/qcom/opensource/commonsys/audio/configs/qssi/qssi.mk
-include $(TOPDIR)vendor/qcom/opensource/commonsys/audio/configs/qssi/audio_system_product.mk

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/system/audio/audio-vendor.mk)
