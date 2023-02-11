ifeq ($(TARGET_COMMON_QTI_COMPONENTS), all)
TARGET_COMMON_QTI_COMPONENTS := \
    adreno \
    audio \
    av \
    bt \
    display \
    gps \
    init \
    media \
    nfc \
    overlay \
    perf \
    telephony \
    usb \
    vibrator \
    wfd \
    wlan
endif

# QTI Common Components

ifneq (,$(filter adreno, $(TARGET_COMMON_QTI_COMPONENTS)))
  ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
    include $(QCOM_COMMON_PATH)/vendor/adreno/qti-adreno.mk
  else ifeq ($(call is-board-platform-in-list,$(3_18_FAMILY) $(4_4_FAMILY) msm8953),true)
    include $(QCOM_COMMON_PATH)/vendor/adreno-5xx/qti-adreno-5xx.mk
  else
    include $(QCOM_COMMON_PATH)/vendor/adreno-6xx-legacy/qti-adreno-6xx-legacy.mk
  endif
endif

ifneq (,$(filter audio, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/audio/qti-audio.mk
  include $(QCOM_COMMON_PATH)/vendor/audio/qti-audio.mk
endif

ifneq (,$(filter av, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/av/qti-av.mk
endif

ifneq (,$(filter bt, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/bt/qti-bt.mk
  include $(QCOM_COMMON_PATH)/vendor/bt/qti-bt.mk
endif

ifneq (,$(filter display, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/display/qti-display.mk
  include $(QCOM_COMMON_PATH)/vendor/display/qti-display.mk
endif

ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
  include $(QCOM_COMMON_PATH)/dlkm/qti-dlkm.mk
endif

ifneq (,$(filter gps, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/gps/qti-gps.mk
  include $(QCOM_COMMON_PATH)/vendor/gps/qti-gps.mk
endif

ifneq (,$(filter init, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/vendor/init/qti-init.mk
endif

ifneq (,$(filter media, $(TARGET_COMMON_QTI_COMPONENTS)))
  ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY) bengal),true)
    include $(QCOM_COMMON_PATH)/vendor/media/qti-media.mk
  else ifeq ($(call is-board-platform-in-list,$(5_4_FAMILY)),true)
    include $(QCOM_COMMON_PATH)/vendor/media-5.4/qti-media-5.4.mk
  else
    include $(QCOM_COMMON_PATH)/vendor/media-legacy/qti-media-legacy.mk
  endif
endif

ifneq (,$(filter nfc, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/vendor/nfc/qti-nfc.mk
endif

ifneq (,$(filter overlay, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/overlay/qti-overlay.mk
endif

ifneq (,$(filter perf, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/perf/qti-perf.mk
  ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
    include $(QCOM_COMMON_PATH)/vendor/perf/qti-perf.mk
  else
    include $(QCOM_COMMON_PATH)/vendor/perf-legacy/qti-perf-legacy.mk
  endif
endif

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/system/telephony/qti-telephony.mk
  include $(QCOM_COMMON_PATH)/vendor/telephony/qti-telephony.mk
endif

ifneq (,$(filter usb, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/vendor/usb/qti-usb.mk
endif

ifneq (,$(filter vibrator, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/vendor/vibrator/qti-vibrator.mk
endif

ifneq (,$(filter wfd, $(TARGET_COMMON_QTI_COMPONENTS)))
  ifeq ($(call is-board-platform-in-list,$(3_18_FAMILY) $(4_4_FAMILY) msm8953),true)
    include $(QCOM_COMMON_PATH)/system/wfd-legacy/qti-wfd-legacy.mk
    include $(QCOM_COMMON_PATH)/vendor/wfd-legacy/qti-wfd-legacy.mk
  else
    include $(QCOM_COMMON_PATH)/system/wfd/qti-wfd.mk
  endif
endif

ifneq (,$(filter wlan, $(TARGET_COMMON_QTI_COMPONENTS)))
  include $(QCOM_COMMON_PATH)/vendor/wlan/qti-wlan.mk
endif
