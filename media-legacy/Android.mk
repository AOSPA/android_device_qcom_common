LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_COPY_HEADERS_TO := fastcv
LOCAL_COPY_HEADERS := include/fastcv.h
LOCAL_VENDOR_MODULE := true
include $(BUILD_COPY_HEADERS)
