LOCAL_PATH := $(call my-dir)

ifneq ($(TARGET_USES_DEVICE_SPECIFIC_POWERHAL), true)
ifeq ($(call is-vendor-board-platform,QCOM),true)

# HAL module implemenation stored in
# hw/<POWERS_HARDWARE_MODULE_ID>.<ro.hardware>.so
include $(CLEAR_VARS)

LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MULTILIB := both
LOCAL_SHARED_LIBRARIES := liblog libcutils libdl
LOCAL_SRC_FILES := power.c metadata-parser.c utils.c list.c hint-data.c

# Include target-specific files.
ifeq ($(call is-board-platform-in-list, msm8974), true)
LOCAL_SRC_FILES += power-8974.c
endif

ifeq ($(call is-board-platform-in-list, msm8226), true)
LOCAL_SRC_FILES += power-8226.c
endif

ifeq ($(call is-board-platform-in-list, msm8610), true)
LOCAL_SRC_FILES += power-8610.c
endif

ifeq ($(call is-board-platform-in-list, apq8084), true)
LOCAL_SRC_FILES += power-8084.c
endif

ifeq ($(call is-board-platform-in-list, msm8909), true)
LOCAL_SRC_FILES += power-8909.c
endif

ifeq ($(call is-board-platform-in-list,msm8916), true)
LOCAL_SRC_FILES += power-8916.c
endif

ifeq ($(call is-board-platform-in-list,msm8952), true)
LOCAL_SRC_FILES += power-8952.c
endif

ifeq ($(call is-board-platform-in-list, msm8994), true)
LOCAL_SRC_FILES += power-8994.c
endif

ifeq ($(call is-board-platform-in-list, msm8992), true)
LOCAL_SRC_FILES += power-8992.c
endif

ifeq ($(call is-board-platform-in-list, msm8996), true)
LOCAL_SRC_FILES += power-8996.c
endif

ifneq ($(TARGET_GESTURES_NODE),)
  LOCAL_CFLAGS += -DGESTURES_NODE=\"$(TARGET_GESTURES_NODE)\"
endif

ifneq ($(TARGET_TAP_TO_WAKE_NODE),)
  LOCAL_CFLAGS += -DTAP_TO_WAKE_NODE=\"$(TARGET_TAP_TO_WAKE_NODE)\"
endif

ifneq ($(TARGET_DRAW_V_NODE),)
  LOCAL_CFLAGS += -DDRAW_V_NODE=\"$(TARGET_DRAW_V_NODE)\"
endif

ifneq ($(TARGET_DRAW_INVERSE_V_NODE),)
  LOCAL_CFLAGS += -DDRAW_INVERSE_V_NODE=\"$(TARGET_DRAW_INVERSE_V_NODE)\"
endif

ifneq ($(TARGET_DRAW_O_NODE),)
  LOCAL_CFLAGS += -DDRAW_O_NODE=\"$(TARGET_DRAW_O_NODE)\"
endif

ifneq ($(TARGET_DRAW_M_NODE),)
  LOCAL_CFLAGS += -DDRAW_M_NODE=\"$(TARGET_DRAW_M_NODE)\"
endif

ifneq ($(TARGET_DRAW_W_NODE),)
  LOCAL_CFLAGS += -DDRAW_W_NODE=\"$(TARGET_DRAW_W_NODE)\"
endif

ifneq ($(TARGET_DRAW_ARROW_LEFT_NODE),)
  LOCAL_CFLAGS += -DDRAW_ARROW_LEFT_NODE=\"$(TARGET_DRAW_ARROW_LEFT_NODE)\"
endif

ifneq ($(TARGET_DRAW_ARROW_RIGHT_NODE),)
  LOCAL_CFLAGS += -DDRAW_ARROW_RIGHT_NODE=\"$(TARGET_DRAW_ARROW_RIGHT_NODE)\"
endif

ifneq ($(TARGET_ONE_FINGER_SWIPE_DOWN_NODE),)
  LOCAL_CFLAGS += -DONE_FINGER_SWIPE_DOWN_NODE=\"$(TARGET_ONE_FINGER_SWIPE_DOWN_NODE)\"
endif

ifneq ($(TARGET_ONE_FINGER_SWIPE_LEFT_NODE),)
  LOCAL_CFLAGS += -DONE_FINGER_SWIPE_LEFT_NODE=\"$(TARGET_ONE_FINGER_SWIPE_LEFT_NODE)\"
endif

ifneq ($(TARGET_TWO_FINGER_SWIPE_NODE),)
  LOCAL_CFLAGS += -DTWO_FINGER_SWIPE_NODE=\"$(TARGET_TWO_FINGER_SWIPE_NODE)\"
endif

ifeq ($(TARGET_POWER_SET_FEATURE_LIB),)
  ifeq ($(TARGET_POWER_GESTURE_FILE),)
    LOCAL_SRC_FILES += power-feature-default.c
  else
    LOCAL_SRC_FILES += ../../../../$(TARGET_POWER_GESTURE_FILE)
  endif
else
  LOCAL_STATIC_LIBRARIES += $(TARGET_POWER_SET_FEATURE_LIB)
endif

ifeq ($(call is-board-platform-in-list,msm8953), true)
LOCAL_SRC_FILES += power-8953.c
endif

ifeq ($(call is-board-platform-in-list,msm8998), true)
LOCAL_SRC_FILES += power-8998.c
endif

ifeq ($(call is-board-platform-in-list,sdm660), true)
LOCAL_SRC_FILES += power-660.c
endif

ifeq ($(call is-board-platform-in-list,sdm845), true)
LOCAL_SRC_FILES += power-845.c
endif

ifeq ($(TARGET_USES_INTERACTION_BOOST),true)
    LOCAL_CFLAGS += -DINTERACTION_BOOST
endif

LOCAL_MODULE := power.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += -Wno-unused-parameter -Wno-unused-variable
include $(BUILD_SHARED_LIBRARY)

endif
endif
