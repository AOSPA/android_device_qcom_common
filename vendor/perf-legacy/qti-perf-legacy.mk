TARGET_PERF_COMPONENT_VARIANT := perf-legacy

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/perf-legacy

# Configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(QCOM_COMMON_PATH)/vendor/perf-legacy/configs/common,$(TARGET_COPY_OUT_VENDOR)/etc) \
    $(call find-copy-subdir-files,*,$(QCOM_COMMON_PATH)/vendor/perf-legacy/configs/$(TARGET_BOARD_PLATFORM),$(TARGET_COPY_OUT_VENDOR)/etc)

# Disable IOP HAL for select platforms.
ifeq ($(call is-board-platform-in-list, msm8937 msm8953 msm8998 qcs605 sdm660 sdm710),true)
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/perf-legacy/vendor.qti.hardware.iop@2.0-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.qti.hardware.iop@2.0-service-disable.rc
endif

# Disable the poweropt service for <5.4 platforms.
ifeq (,$(filter 5.4 5.10, $(TARGET_KERNEL_VERSION)))
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/vendor/perf-legacy/poweropt-service-disable.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/poweropt-service-disable.rc
endif

# Packages
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0.vendor \
    init.aospa.perf.rc \
    libavservices_minijail.vendor \
    libpsi.vendor \
    libtflite \
    vendor.qti.hardware.servicetracker@1.2.vendor

# Only copy task_profiles.json for 5.4 targets.
ifeq ($(TARGET_KERNEL_VERSION),5.4)
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json
endif

# Properties
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.perf-hal.ver=2.2 \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.vendor.perf.scroll_opt=true \
    ro.vendor.qspm.enable=true \
    vendor.power.pasr.enabled=true

ifeq ($(call is-board-platform-in-list, kona lahaina),true)
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.beluga.p=0x3 \
    ro.vendor.beluga.c=0x4800 \
    ro.vendor.beluga.s=0x900 \
    ro.vendor.beluga.t=0x240
endif

ifneq (,$(filter 4.14 4.19 5.4 5.10, $(TARGET_KERNEL_VERSION)))
ifeq ($(TARGET_BOARD_PLATFORM), holi)
PRODUCT_VENDOR_PROPERTIES += vendor.pasr.activemode.enabled=false
else
PRODUCT_VENDOR_PROPERTIES += vendor.pasr.activemode.enabled=true
endif
endif

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/qcom/common/vendor/perf-legacy/perf-legacy-vendor.mk)
