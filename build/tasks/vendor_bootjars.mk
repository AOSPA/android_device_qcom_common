# This makefile is used to include
# extra product boot jars for SDK

ifneq ($(VENDOR_QTI_PLATFORM),qssi)
ifneq ($(call is-vendor-board-platform,QCOM),true)

#call dex_preopt.mk for extra jars
include $(BUILD_SYSTEM)/dex_preopt.mk

endif
endif
