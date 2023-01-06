COMMON_SEPOLICY_PATH := device/qcom/common/sepolicy

ifeq ($(TARGET_SEPOLICY_DIR),)
    TARGET_SEPOLICY_DIR := $(TARGET_BOARD_PLATFORM)
endif

ifeq (,$(filter sdm845 sdm710 sdm660 msm8937 msm8953 msm8996, $(TARGET_BOARD_PLATFORM)))
    SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
        $(COMMON_SEPOLICY_PATH)/generic/private/common
    BOARD_VENDOR_SEPOLICY_DIRS += \
        $(COMMON_SEPOLICY_PATH)/generic/vendor/common \
        $(COMMON_SEPOLICY_PATH)/qva/vendor/common \
        $(COMMON_SEPOLICY_PATH)/generic/vendor/$(TARGET_SEPOLICY_DIR) \
        $(COMMON_SEPOLICY_PATH)/qva/vendor/$(TARGET_SEPOLICY_DIR)
else # Legacy
    BOARD_VENDOR_SEPOLICY_DIRS += \
        $(COMMON_SEPOLICY_PATH)/legacy/vendor/ssg \
        $(COMMON_SEPOLICY_PATH)/legacy/vendor/common \
        $(COMMON_SEPOLICY_PATH)/legacy/vendor/$(TARGET_SEPOLICY_DIR)

    ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
        BOARD_VENDOR_SEPOLICY_DIRS += \
            $(COMMON_SEPOLICY_PATH)/legacy/vendor/test \
            $(COMMON_SEPOLICY_PATH)/legacy/vendor/test/sysmonapp
    endif

endif
