COMMON_SEPOLICY_PATH := device/qcom/common/sepolicy

ifeq ($(TARGET_SEPOLICY_DIR),)
    TARGET_SEPOLICY_DIR := $(TARGET_BOARD_PLATFORM)
endif

BOARD_VENDOR_SEPOLICY_DIRS += \
    $(COMMON_SEPOLICY_PATH)/generic/vendor/common \
    $(COMMON_SEPOLICY_PATH)/qva/vendor/common \
    $(COMMON_SEPOLICY_PATH)/generic/vendor/$(TARGET_SEPOLICY_DIR) \
    $(COMMON_SEPOLICY_PATH)/qva/vendor/$(TARGET_SEPOLICY_DIR)

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
        $(COMMON_SEPOLICY_PATH)/qva/vendor/test
endif

# Common system policies
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    $(COMMON_SEPOLICY_PATH)/common/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += \
    $(COMMON_SEPOLICY_PATH)/common/public

# AOSPA-QCOM Specific Required SEPolicy
ifneq ($(AOSPA_BUILD),)
    SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
        $(COMMON_SEPOLICY_PATH)/aospa/private \
        $(COMMON_SEPOLICY_PATH)/pixel/private
endif
