LOCAL_PATH := $(call my-dir)

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))

include $(CLEAR_VARS)

CNE_LIBRARIES := libvndfwk_detect_jni.qti.so

CNE_SYMLINKS := $(addprefix $(TARGET_OUT_VENDOR_APPS)/CneApp/lib/arm64/,$(notdir $(CNE_LIBRARIES)))
$(CNE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /vendor/lib64/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(CNE_SYMLINKS)

endif
