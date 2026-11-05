# Configure audio HAL features
ifeq ($(AUDIO_FEATURE_ENABLED_AGM_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_agm_hidl,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLE_BT_A2DP_LPI),true)
    $(call soong_config_set,qtiaudio,feature_bt_a2dp_lpi,true)
endif

ifeq ($(AUDIO_FEATURE_DISABLED_DTS_EAGLE),true)
    $(call soong_config_set,qtiaudio,feature_disabled_dts_eagle,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_GEF_SUPPORT),true)
    $(call soong_config_set,qtiaudio,feature_gef_support,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_INSTANCE_ID),true)
    $(call soong_config_set,qtiaudio,feature_instance_id,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_LSM_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_lsm_hidl,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_MCS),true)
    $(call soong_config_set,qtiaudio,feature_mcs,true)
endif

ifeq ($(AUDIO_FEATURE_ENABLED_PAL_HIDL),true)
    $(call soong_config_set,qtiaudio,feature_pal_hidl,true)
endif

ifeq ($(BOARD_SUPPORTS_OPENSOURCE_STHAL),true)
     PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/audio-hal/st-hal-ar
endif
