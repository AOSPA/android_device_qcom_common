# This makefile is used to generate extra images for QTI targets
# persist, device tree & NAND images required for different QTI targets.

# These variables are required to make sure that the required
# files/targets are available before generating NAND images.
# This file is included from device/qcom/<TARGET>/AndroidBoard.mk
# and gets parsed before build/core/Makefile, which has these
# variables defined. build/core/Makefile will overwrite these
# variables again.
ifneq ($(strip $(TARGET_NO_KERNEL)),true)
INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img
INSTALLED_RAMDISK_TARGET := $(PRODUCT_OUT)/ramdisk.img
INSTALLED_SYSTEMIMAGE := $(PRODUCT_OUT)/system.img
ifneq ($(TARGET_NO_RECOVERY), true)
INSTALLED_RECOVERYIMAGE_TARGET := $(PRODUCT_OUT)/recovery.img
else
INSTALLED_RECOVERYIMAGE_TARGET :=
endif
recovery_ramdisk := $(PRODUCT_OUT)/ramdisk-recovery.img
endif

#A/B builds require us to create the mount points at compile time.
#Just creating it for all cases since it does not hurt.
FIRMWARE_MOUNT_POINT := $(TARGET_ROOT_OUT)/firmware
BT_FIRMWARE_MOUNT_POINT := $(TARGET_ROOT_OUT)/bt_firmware
DSP_MOUNT_POINT := $(TARGET_ROOT_OUT)/dsp
PERSIST_MOUNT_POINT := $(TARGET_ROOT_OUT)/persist
ALL_DEFAULT_INSTALLED_MODULES += $(FIRMWARE_MOUNT_POINT) \
				 $(BT_FIRMWARE_MOUNT_POINT) \
				 $(DSP_MOUNT_POINT) \
				 $(PERSIST_MOUNT_POINT)
$(FIRMWARE_MOUNT_POINT):
	@echo "Creating $(FIRMWARE_MOUNT_POINT)"
	@mkdir -p $(TARGET_ROOT_OUT)/firmware
	@mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/firmware

$(BT_FIRMWARE_MOUNT_POINT):
	@echo "Creating $(BT_FIRMWARE_MOUNT_POINT)"
	@mkdir -p $(TARGET_ROOT_OUT)/bt_firmware
	@mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/bt_firmware

$(DSP_MOUNT_POINT):
	@echo "Creating $(DSP_MOUNT_POINT)"
	@mkdir -p $(TARGET_ROOT_OUT)/dsp
	@mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/dsp

$(PERSIST_MOUNT_POINT):
	@echo "Creating $(PERSIST_MOUNT_POINT)"
	@mkdir -p $(TARGET_ROOT_OUT)/persist
	@mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/persist

#----------------------------------------------------------------------
# Generate device tree overlay image (dtbo.img)
#----------------------------------------------------------------------
ifneq ($(strip $(TARGET_NO_KERNEL)),true)
ifeq ($(strip $(BOARD_KERNEL_SEPARATED_DTBO)),true)

MKDTIMG := $(HOST_OUT_EXECUTABLES)/mkdtimg$(HOST_EXECUTABLE_SUFFIX)

INSTALLED_DTBOIMAGE_TARGET := $(PRODUCT_OUT)/dtbo.img

# Most specific paths must come first in possible_dtbo_dirs
possible_dtbo_dirs = $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/dts $(KERNEL_OUT)/arch/arm/boot/dts
$(shell mkdir -p $(possible_dtbo_dirs))
dtbo_dir = $(firstword $(wildcard $(possible_dtbo_dirs)))
dtbo_objs = $(shell find $(dtbo_dir) -name \*.dtbo)

define build-dtboimage-target
    $(call pretty,"Target dtbo image: $(INSTALLED_DTBOIMAGE_TARGET)")
    $(hide) $(MKDTIMG) create $@ --page_size=$(BOARD_KERNEL_PAGESIZE) $(dtbo_objs)
    $(hide) chmod a+r $@
    $(hide) $(AVBTOOL) add_hash_footer \
	    --image $@ \
	    --partition_size $(BOARD_DTBOIMAGE_PARTITION_SIZE) \
	    --partition_name dtbo $(INTERNAL_AVB_SIGNING_ARGS)
endef

ifeq ($(BOARD_AVB_ENABLE),true)
$(INSTALLED_DTBOIMAGE_TARGET): $(MKDTIMG) $(INSTALLED_KERNEL_TARGET) $(AVBTOOL)
	$(build-dtboimage-target)
endif

ALL_DEFAULT_INSTALLED_MODULES += $(INSTALLED_DTBOIMAGE_TARGET)
ALL_MODULES.$(LOCAL_MODULE).INSTALLED += $(INSTALLED_DTBOIMAGE_TARGET)
endif
endif

###################################################################################################

.PHONY: kernel
kernel: $(INSTALLED_BOOTIMAGE_TARGET) $(INSTALLED_SEC_BOOTIMAGE_TARGET) $(INSTALLED_4K_BOOTIMAGE_TARGET) $(INSTALLED_DTBOIMAGE_TARGET)

.PHONY: dtboimage
dtboimage: $(INSTALLED_DTBOIMAGE_TARGET)

.PHONY: recoveryimage
recoveryimage: $(INSTALLED_RECOVERYIMAGE_TARGET) $(INSTALLED_4K_RECOVERYIMAGE_TARGET)

.PHONY: kernelclean
kernelclean:
	$(hide) make -C $(TARGET_KERNEL_SOURCE) O=$(KERNEL_TO_BUILD_ROOT_OFFSET)$(PRODUCT_OUT)/obj/KERNEL_OBJ/ ARCH=$(TARGET_ARCH) CROSS_COMPILE=arm-eabi-  clean
	$(hide) make -C $(TARGET_KERNEL_SOURCE) O=$(KERNEL_TO_BUILD_ROOT_OFFSET)$(PRODUCT_OUT)/obj/KERNEL_OBJ/ ARCH=$(TARGET_ARCH) CROSS_COMPILE=arm-eabi-  mrproper
	$(hide) make -C $(TARGET_KERNEL_SOURCE) O=$(KERNEL_TO_BUILD_ROOT_OFFSET)$(PRODUCT_OUT)/obj/KERNEL_OBJ/ ARCH=$(TARGET_ARCH) CROSS_COMPILE=arm-eabi-  distclean
	$(hide) if [ -f "$(INSTALLED_BOOTIMAGE_TARGET)" ]; then  rm $(INSTALLED_BOOTIMAGE_TARGET); fi
	$(hide) if [ -f "$(INSTALLED_SEC_BOOTIMAGE_TARGET)" ]; then rm $(INSTALLED_SEC_BOOTIMAGE_TARGET); fi
	$(hide) if [ -f "$(INSTALLED_BOOTIMAGE_TARGET).nonsecure" ]; then  rm $(INSTALLED_BOOTIMAGE_TARGET).nonsecure; fi
	$(hide) if [ -f "$(PRODUCT_OUT)/kernel" ]; then  rm $(PRODUCT_OUT)/kernel; fi
	$(hide) if [ -f "$(INSTALLED_4K_BOOTIMAGE_TARGET)" ]; then rm  $(INSTALLED_4K_BOOTIMAGE_TARGET); fi
	$(hide) if [ -f "$(INSTALLED_2K_BOOTIMAGE_TARGET)" ]; then rm  $(INSTALLED_2K_BOOTIMAGE_TARGET); fi
	$(hide) if [ -f "$(INSTALLED_BCHECC_BOOTIMAGE_TARGET)" ]; then rm  $(INSTALLED_BCHECC_BOOTIMAGE_TARGET); fi
	@echo "kernel cleanup done"

# Set correct dependency for kernel modules
ifneq ($(BOARD_VENDOR_KERNEL_MODULES),)
$(BOARD_VENDOR_KERNEL_MODULES): $(INSTALLED_BOOTIMAGE_TARGET)
endif
ifneq ($(BOARD_RECOVERY_KERNEL_MODULES),)
$(BOARD_RECOVERY_KERNEL_MODULES): $(INSTALLED_BOOTIMAGE_TARGET)
endif
