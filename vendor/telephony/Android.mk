# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))

include $(CLEAR_VARS)

CNE_SYMLINKS := $(TARGET_OUT_VENDOR_APPS)/CneApp/lib/arm64/
$(CNE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@rm -rf $@
	@mkdir -p $(dir $@)
	$(hide) ln -sf $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/libvndfwk_detect_jni.qti.so $@/libvndfwk_detect_jni.qti.so

ALL_DEFAULT_INSTALLED_MODULES += $(CNE_SYMLINKS)

endif
