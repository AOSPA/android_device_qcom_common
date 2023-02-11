LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_WLAN_COMPONENT_VARIANT),wlan)

include $(CLEAR_VARS)

ifeq ($(call is-board-platform-in-list,msm8998 sdm660),true)
-include device/qcom/wlan/sdm660_64/AndroidBoardWlan.mk
else ifeq ($(call is-board-platform-in-list,sm6150),true)
-include device/qcom/wlan/talos/AndroidBoardWlan.mk
else
-include device/qcom/wlan/$(TARGET_BOARD_PLATFORM)/AndroidBoardWlan.mk
endif

endif
