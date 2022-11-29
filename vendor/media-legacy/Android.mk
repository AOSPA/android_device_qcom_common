ifeq ($(TARGET_MEDIA_COMPONENT_VARIANT),media-legacy)

LOCAL_PATH := $(call my-dir)

ifeq ($(BUILD_BROKEN_USES_BUILD_COPY_HEADERS),true)
include $(CLEAR_VARS)
LOCAL_COPY_HEADERS_TO := fastcv
LOCAL_COPY_HEADERS := include/fastcv.h
LOCAL_VENDOR_MODULE := true
include $(BUILD_COPY_HEADERS)
endif
