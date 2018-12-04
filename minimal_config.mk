#
#  Copyright (c) 2018, The Linux Foundation. All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are
#  met:
#       * Redistributions of source code must retain the above copyright
#         notice, this list of conditions and the following disclaimer.
#       * Redistributions in binary form must reproduce the above
#         copyright notice, this list of conditions and the following
#         disclaimer in the documentation and/or other materials provided
#         with the distribution.
#       * Neither the name of The Linux Foundation nor the names of its
#         contributors may be used to endorse or promote products derived
#         from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
#  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#  IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Minimal configuration definition for basic boot to shell

ANDROID_BUILD_EMBEDDED := true

ifneq ($(BOARD_FRP_PARTITION_NAME),)
    PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/bootdevice/by-name/$(BOARD_FRP_PARTITION_NAME)
else
    PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/bootdevice/by-name/config
endif

PRODUCT_PRIVATE_KEY := device/qcom/common/qcom.key

#INIT
INIT := init.qcom.rc
INIT += init.qcom.sh
INIT += init.qcom.class_core.sh
INIT += init.class_main.sh
INIT += init.qcom.early_boot.sh
INIT += init.qcom.post_boot.sh
INIT += init.target.rc
INIT += vold.fstab
INIT += fstab.qcom
INIT += fstab.qti
INIT += init.recovery.qcom.rc
INIT += init.qcom.factory.rc
INIT += init.qcom.composition_type.sh
INIT += init.qti.ims.sh
INIT += init.qcom.coex.sh
INIT += init.qcom.sdio.sh
INIT += init.qcom.ril.path.sh
INIT += init.qcom.usb.rc
INIT += init.msm.usb.configfs.rc
INIT += init.qcom.usb.sh
INIT += usf_post_boot.sh
INIT += init.qcom.efs.sync.sh
INIT += ueventd.qcom.rc
INIT += qca6234-service.sh
INIT += ssr_setup
INIT += enable_swap.sh
INIT += init.mdm.sh
INIT += init.qcom.sensors.sh
INIT += init.qcom.crashdata.sh
INIT += init.qcom.vendor.rc
INIT += init.target.vendor.rc
INIT += init.qti.fm.sh
PRODUCT_PACKAGES += $(INIT)

ifneq ($(strip $(TARGET_USES_RRO)),true)
# enable overlays to use our version of
# source/resources etc.
DEVICE_PACKAGE_OVERLAYS += device/qcom/common/device/overlay
PRODUCT_PACKAGE_OVERLAYS += device/qcom/common/product/overlay
endif

# Set up flags to determine the kernel version
ifeq ($(TARGET_KERNEL_VERSION),)
     TARGET_KERNEL_VERSION := 3.18
endif
ifneq ($(KERNEL_OVERRIDE),)
     TARGET_KERNEL_VERSION := $(KERNEL_OVERRIDE)
endif
ifeq ($(wildcard kernel/msm-$(TARGET_KERNEL_VERSION)),)
     KERNEL_TO_BUILD_ROOT_OFFSET := ../
     TARGET_KERNEL_SOURCE := kernel
else
     KERNEL_TO_BUILD_ROOT_OFFSET := ../../
     TARGET_KERNEL_SOURCE := kernel/msm-$(TARGET_KERNEL_VERSION)
endif
# include additional build utilities
-include device/qcom/common/utils.mk

# dm-verity definitions
ifneq ($(BOARD_AVB_ENABLE), true)
   PRODUCT_SYSTEM_VERITY_PARTITION=/dev/block/bootdevice/by-name/system
   ifeq ($(ENABLE_VENDOR_IMAGE), true)
      PRODUCT_VENDOR_VERITY_PARTITION=/dev/block/bootdevice/by-name/vendor
   endif
   $(call inherit-product, build/target/product/verity.mk)
endif

#skip boot jars check
SKIP_BOOT_JARS_CHECK := true

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
    ro.adb.secure=1
endif

# OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

# VNDK-SP:
PRODUCT_PACKAGES += \
    vndk-sp \

# Temporary handling
#
# Include config.fs get only if legacy device/qcom/<target>/android_filesystem_config.h
# does not exist as they are mutually exclusive.  Once all target's android_filesystem_config.h
# have been removed, TARGET_FS_CONFIG_GEN should be made unconditional.
DEVICE_CONFIG_DIR := $(dir $(firstword $(subst ]],, $(word 2, $(subst [[, ,$(_node_import_context))))))
ifeq ($(wildcard $(DEVICE_CONFIG_DIR)/android_filesystem_config.h),)
  TARGET_FS_CONFIG_GEN := device/qcom/common/config.fs
else
  $(warning **********)
  $(warning TODO: Need to replace legacy $(DEVICE_CONFIG_DIR)android_filesystem_config.h with config.fs)
  $(warning **********)
endif

PRODUCT_PACKAGES += liboemaids_system
PRODUCT_PACKAGES += liboemaids_vendor

# Include the AOSP embedded configuration but strip display related modules out
include build/target/product/base_system.mk
include build/target/product/base_vendor.mk
include build/target/product/core_64_bit.mk
_MINIMAL_STRIP_MODULES := blank_screen \
                              bootanimation \
                              libgui \
                              libpixelflinger \
                              libsurfaceflinger \
                              libsurfaceflinger_ddmconnection \
                              surfaceflinger \
                              libui \
                              surfaceflinger \
                              appwidget \
                              BackupRestoreConfirmation \
                              android.test.base \
                              android.test.mock \
                              android.test.runner \
                              audioserver \
                              app_process \
                              cameraserver \
                              com.android.location.provider \
                              ContactsProvider \
                              DefaultContainerService \
                              DownloadProvider \
                              ExtServices \
                              ExtShared \
                              ims-common \
                              libaaudio \
                              libamidi \
                              libandroid \
                              libandroidfw \
                              libandroid_runtime \
                              libandroid_servers \
                              libaudioeffect_jni \
                              libaudioflinger \
                              libaudiopolicymanager \
                              libaudiopolicyservice \
                              libaudioutils \
                              libcamera2ndk \
                              libcamera_client \
                              libcameraservice \
                              libdrmframework \
                              libdrmframework_jni \
                              libEGL \
                              libETC1 \
                              libFFTEm \
                              libGLESv1_CM \
                              libGLESv2 \
                              libGLESv3 \
                              libgui \
                              libmedia \
                              libmedia_jni \
                              libmediandk \
                              libmediaplayerservice \
                              libsoundpool \
                              libsoundtrigger \
                              libsoundtriggerservice \
                              libstagefright \
                              libstagefright_amrnb_common \
                              libstagefright_enc_common \
                              libstagefright_foundation \
                              libstagefright_omx \
                              libwifi-service \
                              media \
                              media_cmd \
                              mediadrmserver \
                              mediaextractor \
                              mediametrics \
                              MediaProvider \
                              mediaserver \
                              PackageInstaller \
                              PermissionController \
                              SettingsProvider \
                              telecom \
                              telephony-common \
                              voip-common \
                              WallpaperBackup \
                              wificond \
                              wifi-service \
                              wm \
                              @inherit:build/target/product/runtime_libart.mk

PRODUCT_PACKAGES := $(filter-out $(_MINIMAL_STRIP_MODULES),$(PRODUCT_PACKAGES))
#PRODUCT_BOOT_JARS := $(filter-out telephony-common voip-common ims-common,$(PRODUCT_BOOT_JARS))
PRODUCT_BOOT_JARS :=
