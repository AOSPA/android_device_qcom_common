TARGET_USES_QCOM_BSP := true

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_USES_AOSP := false
TARGET_HAS_QC_KERNEL_SOURCE := true
TARGET_USES_QCOM_MM_AUDIO := true

# include additional build utilities
include device/qcom/common/utils.mk

ANDROID_COMPILE_WITH_JACK := false

# Advanced DPM
ifeq ($(TARGET_WANTS_EXTENDED_DPM_PLATFORM),true)
PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += tcmclient
PRODUCT_BOOT_JARS += com.qti.dpmframework
PRODUCT_BOOT_JARS += dpmapi
PRODUCT_BOOT_JARS += com.qti.location.sdk
endif

