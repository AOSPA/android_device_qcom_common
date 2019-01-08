# define flag to determine the kernel
TARGET_KERNEL_VERSION := $(shell ls kernel | grep "msm-*" | sed 's/msm-//')

# Set TARGET_USES_NEW_ION for 4.14 and higher kernels
ifeq ($(TARGET_KERNEL_VERSION),$(filter $(TARGET_KERNEL_VERSION),3.18 4.4 4.9))
TARGET_USES_NEW_ION := false
else
TARGET_USES_NEW_ION := true
endif

# Pure AOSP framework vs vendor modified framework detection
# - using BUILD_ID xKQ* as mechanism

ifeq ($(filter $(shell echo $(BUILD_ID) | sed 's/.KQ.*/KQ/g'),KQ),KQ)
  TARGET_FWK_SUPPORTS_FULL_VALUEADDS := true
  $(warning "Compile using modified AOSP tree supporting full vendor value-adds")
else
  TARGET_FWK_SUPPORTS_FULL_VALUEADDS := false
  $(warning "Compile using pure AOSP tree")
endif

# Board platforms lists to be used for
# TARGET_BOARD_PLATFORM specific featurization
QCOM_BOARD_PLATFORMS += msm8974
QCOM_BOARD_PLATFORMS += msm8610
QCOM_BOARD_PLATFORMS += msm8226
QCOM_BOARD_PLATFORMS += apq8084
QCOM_BOARD_PLATFORMS += mpq8092
QCOM_BOARD_PLATFORMS += msm_bronze
QCOM_BOARD_PLATFORMS += msm8916
QCOM_BOARD_PLATFORMS += msm8916_32
QCOM_BOARD_PLATFORMS += msm8916_32_512
QCOM_BOARD_PLATFORMS += msm8916_64
QCOM_BOARD_PLATFORMS += msm8994
QCOM_BOARD_PLATFORMS += msm8909
QCOM_BOARD_PLATFORMS += msm8909_512
QCOM_BOARD_PLATFORMS += msm8992
QCOM_BOARD_PLATFORMS += msm8996
QCOM_BOARD_PLATFORMS += msm8952
QCOM_BOARD_PLATFORMS += msm8937
QCOM_BOARD_PLATFORMS += msm8953
QCOM_BOARD_PLATFORMS += msm8998
QCOM_BOARD_PLATFORMS += apq8098_latv
QCOM_BOARD_PLATFORMS += sdm660
QCOM_BOARD_PLATFORMS += sdm845
QCOM_BOARD_PLATFORMS += msmnile
QCOM_BOARD_PLATFORMS += sdm710
QCOM_BOARD_PLATFORMS += msmnile_au
QCOM_BOARD_PLATFORMS += qcs605
QCOM_BOARD_PLATFORMS += $(MSMSTEPPE)

QSD8K_BOARD_PLATFORMS := qsd8k

TARGET_USE_VENDOR_CAMERA_EXT := true
TARGET_USE_QTI_BT_STACK := true

BOARD_HAVE_QCOM_FM ?= true


# Boot additions
#Android Telephony library
PRODUCT_BOOT_JARS += qtiNetworkLib
ifeq ($(strip $(TARGET_USES_NQ_NFC)),true)
PRODUCT_BOOT_JARS += com.nxp.nfc.nq
endif
ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
PRODUCT_BOOT_JARS += qcom.fmradio
endif #BOARD_HAVE_QCOM_FM
#Camera QC extends API
#ifeq ($(strip $(TARGET_USES_QTIC_EXTENSION)),true)
#PRODUCT_BOOT_JARS += com.qualcomm.qti.camera
#endif
ifneq ($(strip $(TARGET_DISABLE_PERF_OPTIMIATIONS)),true)
# Preloading QPerformance jar to ensure faster perflocks in Boost Framework
PRODUCT_BOOT_JARS += QPerformance
# Preloading UxPerformance jar to ensure faster UX invoke in Boost Framework
PRODUCT_BOOT_JARS += UxPerformance
endif

#skip boot jars check
SKIP_BOOT_JARS_CHECK := true


#Enable suspend during charger mode
BOARD_CHARGER_ENABLE_SUSPEND := true

#List of targets that use video hw
MSM_VIDC_TARGET_LIST := msm8974 msm8610 msm8226 apq8084 msm8916 msm8994 msm8909 msm8992 msm8996 msm8952 msm8937 msm8953 msm8998 apq8098_latv sdm660 sdm845 sdm710 qcs605 msmnile $(MSMSTEPPE)

#List of targets that use master side content protection
MASTER_SIDE_CP_TARGET_LIST := msm8996 msm8998 sdm660 sdm845 apq8098_latv sdm710 qcs605 msmnile $(MSMSTEPPE)

# Below projects/packages with LOCAL_MODULEs will be used by
# PRODUCT_PACKAGES to build LOCAL_MODULEs that are tagged with
# optional tag, which will not be available on target unless
# explicitly list here. Where project corresponds to the vars here
# in CAPs.

#ALSA
ALSA_HARDWARE := alsa.msm8960
ALSA_HARDWARE += alsa.msm8974
ALSA_HARDWARE += alsa.msm8226
ALSA_HARDWARE += alsa.msm8610
ALSA_HARDWARE += alsa.apq8084

ALSA_UCM := snd_soc_msm
ALSA_UCM += snd_soc_msm_2x
ALSA_UCM += snd_soc_msm_2x_mpq
ALSA_UCM += snd_soc_msm_2x_Fusion3
ALSA_UCM += snd_soc_msm_Sitar
ALSA_UCM += snd_soc_msm_auxpcm
ALSA_UCM += snd_soc_msm_2x_auxpcm
ALSA_UCM += snd_soc_msm_2x_mpq_auxpcm
ALSA_UCM += snd_soc_msm_2x_Fusion3_auxpcm
ALSA_UCM += snd_soc_msm_Sitar_auxpcm
ALSA_UCM += snd_soc_msm_Taiko
ALSA_UCM += snd_soc_msm_Taiko_CDP
ALSA_UCM += snd_soc_msm_Taiko_Fluid
ALSA_UCM += snd_soc_msm_Taiko_liquid
ALSA_UCM += snd_soc_apq_Taiko_DB
ALSA_UCM += snd_soc_msm_I2SFusion
ALSA_UCM += snd_soc_msm_Tapan
ALSA_UCM += snd_soc_msm_TapanLite
ALSA_UCM += snd_soc_msm_Tapan_SKUF
ALSA_UCM += snd_soc_msm_TapanLite_SKUF
ALSA_UCM += snd_soc_msm_8x10_wcd
ALSA_UCM += snd_soc_msm_8x10_wcd_skuab
ALSA_UCM += snd_soc_msm_8x10_wcd_skuaa
ALSA_UCM += snd_soc_msm_samarium_Tapan

#ANGLE
ANGLE := libangle

#APPOPS_POLICY
APPOPS_POLICY := appops_policy.xml

AUDIO_HARDWARE := audio.primary.mpq8064
AUDIO_HARDWARE += audio.primary.apq8084
AUDIO_HARDWARE += audio.primary.msm8960
AUDIO_HARDWARE += audio.primary.msm8974
AUDIO_HARDWARE += audio.primary.msm8226
AUDIO_HARDWARE += audio.primary.msm8660
AUDIO_HARDWARE += audio.primary.msm8610
#AUDIO_HARDWARE += audio.primary.msm7627_surf
AUDIO_HARDWARE += audio.primary.msm7627a
AUDIO_HARDWARE += audio.primary.msm7630_surf
AUDIO_HARDWARE += audio.primary.msm7630_fusion
#AUDIO_HARDWARE += audio.primary.default
AUDIO_HARDWARE += audio.a2dp.default
AUDIO_HARDWARE += audio.usb.default
AUDIO_HARDWARE += audio.r_submix.default
AUDIO_HARDWARE += audio.primary.mpq8092
AUDIO_HARDWARE += audio.primary.msm8916
AUDIO_HARDWARE += audio.primary.msm8909
AUDIO_HARDWARE += audio.primary.msm8994
AUDIO_HARDWARE += audio.primary.msm8992
AUDIO_HARDWARE += audio.primary.msm8996
AUDIO_HARDWARE += audio.primary.msm8952
AUDIO_HARDWARE += audio.primary.msm8937
AUDIO_HARDWARE += audio.primary.msm8953
AUDIO_HARDWARE += audio.primary.msmgold
AUDIO_HARDWARE += audio.primary.msm8998
AUDIO_HARDWARE += audio.primary.sdm660
AUDIO_HARDWARE += audio.primary.sdm845
AUDIO_HARDWARE += audio.primary.apq8098_latv
AUDIO_HARDWARE += audio.primary.sdm710
AUDIO_HARDWARE += audio.primary.qcs605
AUDIO_HARDWARE += audio.primary.msmnile
AUDIO_HARDWARE += audio.primary.$(MSMSTEPPE)
#
AUDIO_POLICY := audio_policy.mpq8064
AUDIO_POLICY += audio_policy.apq8084
AUDIO_POLICY += audio_policy.msm8960
AUDIO_POLICY += audio_policy.msm8974
AUDIO_POLICY += audio_policy.msm8226
AUDIO_POLICY += audio_policy.msm8660
AUDIO_POLICY += audio_policy.msm8610
AUDIO_POLICY += audio_policy.mpq8092
#AUDIO_POLICY += audio_policy.msm7627_surf
AUDIO_POLICY += audio_policy.msm7627a
AUDIO_POLICY += audio_policy.msm7630_surf
AUDIO_POLICY += audio_policy.msm7630_fusion
#AUDIO_POLICY += audio_policy.default
AUDIO_POLICY += audio_policy.conf
AUDIO_POLICY += audio_policy_8064.conf
AUDIO_POLICY += audio_policy.msm8916
AUDIO_POLICY += audio_policy.msm8909
AUDIO_POLICY += audio_policy.msm8994
AUDIO_POLICY += audio_policy.msm8992
AUDIO_POLICY += audio_policy.msm8996
AUDIO_POLICY += audio_policy.msm8952
AUDIO_POLICY += audio_policy.msm8937
AUDIO_POLICY += audio_policy.msm8953
AUDIO_POLICY += audio_policy.msmgold

#HAL Wrapper
AUDIO_WRAPPER := libqahw
AUDIO_WRAPPER += libqahwwrapper

#HAL Test app
AUDIO_HAL_TEST_APPS := hal_play_test
AUDIO_HAL_TEST_APPS += hal_rec_test

#tinyalsa test apps
TINY_ALSA_TEST_APPS := tinyplay
TINY_ALSA_TEST_APPS += tinycap
TINY_ALSA_TEST_APPS += tinymix
TINY_ALSA_TEST_APPS += tinypcminfo
TINY_ALSA_TEST_APPS += cplay

#AMPLOADER
AMPLOADER := amploader

#APPS
APPS := QualcommSoftAP
APPS += TSCalibration

#BRCTL
BRCTL := brctl
BRTCL += libbridge

#BSON
BSON := libbson

#BT
BT := javax.btobex
BT += libattrib_static
BT += libbt-vendor
BT += libbthost_if
BT += libbt-logClient
BT += bt_logger
ifeq ($(TARGET_USE_QTI_BT_STACK), true)
BT += libbluetooth_qti
endif
BT += libbt-hidlclient
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/qcom/common

#C2DColorConvert
C2DCC := libc2dcolorconvert

CHROMIUM := libwebviewchromium
CHROMIUM += libwebviewchromium_loader
CHROMIUM += libwebviewchromium_plat_support

#CIMAX
CIMAX := libcimax_spi

ifneq ($(TARGET_HAS_LOW_RAM),true)
#CM
CM :=CMFileManager
#CM += Trebuchet
endif

#CONNECTIVITY
CONNECTIVITY := libcnefeatureconfig
CONNECTIVITY += services-ext

#CURL
CURL := libcurl
CURL += curl

#DASH
DASH := libdashplayer
DASH += libqcmediaplayer
DASH += qcmediaplayer
DASH += libextmedia_jni

#EXTENDEDMEDIA_EXT
EXTENDEDMEDIA_EXT := libextendedmediaextractor
EXTENDEDMEDIA_EXT += libextendedmediaextractor_jni
EXTENDEDMEDIA_EXT += extendedmediaextractor
EXTENDEDMEDIA_EXT += ExtendedMediaPlayer


#DATA_OS
DATA_OS := librmnetctl

#E2FSPROGS
E2FSPROGS := e2fsck

#EBTABLES
EBTABLES := ebtables
EBTABLES += ethertypes
EBTABLES += libebtc

#FASTPOWERON
FASTPOWERON := FastBoot

#FM
FM := qcom.fmradio
FM += libqcomfm_jni
FM += libfmjni
FM += fm_helium
FM += ftm_fm_lib
FM += libfm-hci

#GPS
GPS_HARDWARE := gps.conf
GPS_HARDWARE += gps.default
GPS_HARDWARE += libgps.utils
GPS_HARDWARE += libloc_api_v02
GPS_HARDWARE += libloc_ds_api
GPS_HARDWARE += libgnsspps
GPS_HARDWARE += libgnss
GPS_HARDWARE += liblocation_api
GPS_HARDWARE += android.hardware.gnss@1.0-impl-qti
GPS_HARDWARE += android.hardware.gnss@1.0-service-qti
GPS_HARDWARE += android.hardware.gnss@1.1-impl-qti
GPS_HARDWARE += android.hardware.gnss@1.1-service-qti

#HDMID
HDMID := hdmid

#HOSTAPD
HOSTAPD := hostapd
HOSTAPD += hostapd_cli
HOSTAPD += nt_password_hash
HOSTAPD += hlr_auc_gw
HOSTAPD += test-milenage
HOSTAPD += hostapd.conf
HOSTAPD += hostapd_default.conf
HOSTAPD += hostapd.deny
HOSTAPD += hostapd.accept

#I420COLORCONVERT
I420CC := libI420colorconvert

#INIT
INIT := init.qcom.composition_type.sh
INIT += init.target.8x25.sh
INIT += init.qcom.mdm_links.sh
INIT += init.qcom.modem_links.sh
INIT += init.qcom.sensor.sh
INIT += init.target.rc
INIT += init.qti.ims.sh
INIT += init.qcom.coex.sh
INIT += init.qcom.early_boot.sh
INIT += init.qcom.post_boot.sh
INIT += init.qcom.syspart_fixup.sh
INIT += init.qcom.rc
INIT += init.recovery.qcom.rc
INIT += init.qcom.factory.rc
INIT += init.qcom.sdio.sh
INIT += init.qcom.sh
INIT += init.qcom.class_core.sh
INIT += init.class_main.sh
INIT += init.qcom.wifi.sh
INIT += vold.fstab
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
INIT += fstab.qcom
INIT += fstab.qti
INIT += init.qcom.sensors.sh
INIT += init.qcom.crashdata.sh
INIT += init.qcom.vendor.rc
INIT += init.target.vendor.rc
INIT += init.qti.fm.sh

#IPROUTE2
IPROUTE2 := ip
IPROUTE2 += libiprouteutil

#IPACM
IPACM += ipacm
IPACM += IPACM_cfg.xml
IPACM += ipacm-diag

#IPTABLES
IPTABLES := libiptc
IPTABLES += libext
IPTABLES += iptables

#KERNEL_TESTS
KERNEL_TESTS := mm-audio-native-test

#KEYPAD
KEYPAD := ffa-keypad_qwerty.kcm
KEYPAD += ffa-keypad_numeric.kcm
KEYPAD += fluid-keypad_qwerty.kcm
KEYPAD += fluid-keypad_numeric.kcm
KEYPAD += surf_keypad_qwerty.kcm
KEYPAD += surf_keypad_numeric.kcm
KEYPAD += surf_keypad.kcm
KEYPAD += 7k_ffa_keypad.kcm
KEYPAD += 7x27a_kp.kcm
KEYPAD += keypad_8960_qwerty.kcm
KEYPAD += 7k_ffa_keypad.kl
KEYPAD += 7k_handset.kl
KEYPAD += 7x27a_kp.kl
KEYPAD += 8660_handset.kl
KEYPAD += atmel_mxt_ts.kl
KEYPAD += synaptics_rmi4_i2c.kl
KEYPAD += synaptics_dsx.kl
KEYPAD += synaptics_dsxv26.kl
KEYPAD += cyttsp-i2c.kl
KEYPAD += ft5x06_ts.kl
KEYPAD += ffa-keypad.kl
KEYPAD += fluid-keypad.kl
KEYPAD += gpio-keys.kl
KEYPAD += qpnp_pon.kl
KEYPAD += keypad_8960.kl
KEYPAD += keypad_8960_liquid.kl
KEYPAD += synaptics_rmi4_i2c.kl
KEYPAD += msm_tma300_ts.kl
KEYPAD += philips_remote_ir.kl
KEYPAD += samsung_remote_ir.kl
KEYPAD += surf_keypad.kl
KEYPAD += ue_rf4ce_remote.kl

#KS
KS := ks
KS += qcks
KS += efsks

#LIB_NL
LIB_NL := libnl_2

#LIB_XML2
LIB_XML2 := libxml2

#LIBCAMERA
LIBCAMERA := camera.apq8084
LIBCAMERA += camera.msm8974
LIBCAMERA += camera.msm8226
LIBCAMERA += camera.msm8610
LIBCAMERA += camera.msm8960
LIBCAMERA += camera.msm8660
LIBCAMERA += camera.msm7630_surf
LIBCAMERA += camera.msm7630_fusion
LIBCAMERA += camera.msm7627a
LIBCAMERA += camera.msm8909
LIBCAMERA += camera.msm8916
LIBCAMERA += camera.msm8994
LIBCAMERA += camera.msm8992
LIBCAMERA += camera.msm8996
LIBCAMERA += camera.msm8998
LIBCAMERA += camera.apq8098_latv
LIBCAMERA += camera.sdm660
LIBCAMERA += camera.msm8952
LIBCAMERA += camera.msm8937
LIBCAMERA += camera.msm8953
LIBCAMERA += libcamera
LIBCAMERA += libmmcamera_interface
LIBCAMERA += libmmcamera_interface2
LIBCAMERA += libmmjpeg_interface
LIBCAMERA += libmmlib2d_interface
LIBCAMERA += libqomx_core
LIBCAMERA += mm-qcamera-app
LIBCAMERA += camera_test
LIBCAMERA += org.codeaurora.camera

#LIBCOPYBIT
LIBCOPYBIT := copybit.msm8660
LIBCOPYBIT += copybit.msm8960
LIBCOPYBIT += copybit.msm8974
LIBCOPYBIT += copybit.msm8226
LIBCOPYBIT += copybit.msm8610
LIBCOPYBIT += copybit.msm8909
LIBCOPYBIT += copybit.msm8916
LIBCOPYBIT += copybit.msm8994
LIBCOPYBIT += copybit.msm8992
LIBCOPYBIT += copybit.apq8084
LIBCOPYBIT += copybit.msm7k
LIBCOPYBIT += copybit.qsd8k
LIBCOPYBIT += copybit.msm7630_surf
LIBCOPYBIT += copybit.msm7630_fusion
LIBCOPYBIT += copybit.msm7627_surf
LIBCOPYBIT += copybit.msm7627_6x
LIBCOPYBIT += copybit.msm7627a
LIBCOPYBIT += copybit.msm8996
LIBCOPYBIT += copybit.msm8952
LIBCOPYBIT += copybit.msm8937
LIBCOPYBIT += copybit.msm8953
LIBCOPYBIT += copybit.msm8998
LIBCOPYBIT += copybit.sdm630
LIBCOPYBIT += copybit.sdm660
LIBCOPYBIT += copybit.sda630
LIBCOPYBIT += copybit.apq8098_latv
LIBCOPYBIT += copybit.sdm710
LIBCOPYBIT += copybit.qcs605

#LIBGESTURES
LIBGESTURES := libgestures
LIBGESTURES += gestures.msm8960

#LIBGRALLOC
LIBGRALLOC := gralloc.default
LIBGRALLOC += gralloc.msm8660
LIBGRALLOC += gralloc.msm8960
LIBGRALLOC += gralloc.msm8974
LIBGRALLOC += gralloc.msm8226
LIBGRALLOC += gralloc.msm8610
LIBGRALLOC += gralloc.msm8909
LIBGRALLOC += gralloc.msm8916
LIBGRALLOC += gralloc.msm8994
LIBGRALLOC += gralloc.msm8992
LIBGRALLOC += gralloc.apq8084
LIBGRALLOC += gralloc.mpq8092
LIBGRALLOC += gralloc.msm7k
LIBGRALLOC += gralloc.msm7630_surf
LIBGRALLOC += gralloc.msm7630_fusion
LIBGRALLOC += gralloc.msm7627_surf
LIBGRALLOC += gralloc.msm7627_6x
LIBGRALLOC += gralloc.msm7627a
LIBGRALLOC += gralloc.msm8996
LIBGRALLOC += gralloc.msm8952
LIBGRALLOC += gralloc.msm8937
LIBGRALLOC += gralloc.msm8953
LIBGRALLOC += gralloc.msm8998
LIBGRALLOC += gralloc.msmnile
LIBGRALLOC += gralloc.sdm845
LIBGRALLOC += gralloc.apq8098_latv
LIBGRALLOC += libmemalloc
LIBGRALLOC += gralloc.sdm630
LIBGRALLOC += gralloc.sdm660
LIBGRALLOC += gralloc.sdm710
LIBGRALLOC += gralloc.qcs605
LIBGRALLOC += gralloc.$(MSMSTEPPE)

#memtrack
LIBMEMTRACK := memtrack.default
LIBMEMTRACK += memtrack.msm8974
LIBMEMTRACK += memtrack.msm8226
LIBMEMTRACK += memtrack.msm8909
LIBMEMTRACK += memtrack.msm8916
LIBMEMTRACK += memtrack.msm8994
LIBMEMTRACK += memtrack.msm8610
LIBMEMTRACK += memtrack.apq8084
LIBMEMTRACK += memtrack.mpq8092
LIBMEMTRACK += memtrack.msm8996
LIBMEMTRACK += memtrack.msm8952
LIBMEMTRACK += memtrack.msm8937
LIBMEMTRACK += memtrack.msm8953
LIBMEMTRACK += memtrack.msm8998
LIBMEMTRACK += memtrack.msmnile
LIBMEMTRACK += memtrack.sdm660
LIBMEMTRACK += memtrack.sdm845
LIBMEMTRACK += memtrack.apq8098_latv
LIBMEMTRACK += memtrack.sdm710
LIBMEMTRACK += memtrack.qcs605
LIBMEMTRACK += memtrack.$(MSMSTEPPE)

#LIBLIGHTS
LIBLIGHTS := lights.msm8660
LIBLIGHTS += lights.msm8960
LIBLIGHTS += lights.msm8974
LIBLIGHTS += lights.msm8226
LIBLIGHTS += lights.msm8909
LIBLIGHTS += lights.msm8916
LIBLIGHTS += lights.msm8994
LIBLIGHTS += lights.msm8992
LIBLIGHTS += lights.msm7k
LIBLIGHTS += lights.msm7630_surf
LIBLIGHTS += lights.msm7630_fusion
LIBLIGHTS += lights.msm7627_surf
LIBLIGHTS += lights.msm7627_6x
LIBLIGHTS += lights.msm7627a
LIBLIGHTS += lights.msm8610
LIBLIGHTS += lights.apq8084
LIBLIGHTS += lights.msm8996
LIBLIGHTS += lights.msm8952
LIBLIGHTS += lights.msm8937
LIBLIGHTS += lights.msm8953
LIBLIGHTS += lights.msm8998
LIBLIGHTS += lights.msmnile
LIBLIGHTS += lights.sdm660
LIBLIGHTS += lights.sdm845
LIBLIGHTS += lights.apq8098_latv
LIBLIGHTS += lights.sdm710
LIBLIGHTS += lights.qcs605
LIBLIGHTS += lights.$(MSMSTEPPE)

#LIBHWCOMPOSER
LIBHWCOMPOSER := hwcomposer.msm8660
LIBHWCOMPOSER += hwcomposer.msm8960
LIBHWCOMPOSER += hwcomposer.msm8974
LIBHWCOMPOSER += hwcomposer.msm8226
LIBHWCOMPOSER += hwcomposer.msm8610
LIBHWCOMPOSER += hwcomposer.msm8909
LIBHWCOMPOSER += hwcomposer.msm8916
LIBHWCOMPOSER += hwcomposer.msm8994
LIBHWCOMPOSER += hwcomposer.msm8992
LIBHWCOMPOSER += hwcomposer.apq8084
LIBHWCOMPOSER += hwcomposer.mpq8092
LIBHWCOMPOSER += hwcomposer.msm7k
LIBHWCOMPOSER += hwcomposer.msm7630_surf
LIBHWCOMPOSER += hwcomposer.msm7630_fusion
LIBHWCOMPOSER += hwcomposer.msm7627_surf
LIBHWCOMPOSER += hwcomposer.msm7627_6x
LIBHWCOMPOSER += hwcomposer.msm7627a
LIBHWCOMPOSER += hwcomposer.msm8996
LIBHWCOMPOSER += hwcomposer.msm8952
LIBHWCOMPOSER += hwcomposer.msm8937
LIBHWCOMPOSER += hwcomposer.msm8953
LIBHWCOMPOSER += hwcomposer.msm8998
LIBHWCOMPOSER += hwcomposer.msmnile
LIBHWCOMPOSER += hwcomposer.sdm660
LIBHWCOMPOSER += hwcomposer.sdm845
LIBHWCOMPOSER += hwcomposer.apq8098_latv
LIBHWCOMPOSER += hwcomposer.sdm710
LIBHWCOMPOSER += hwcomposer.qcs605
LIBHWCOMPOSER += hwcomposer.$(MSMSTEPPE)

#LIBAUDIOPARAM -- Exposing AudioParameter as dynamic library for SRS TruMedia to work
LIBAUDIOPARAM := libaudioparameter

#LIBAUDIORESAMPLER -- High-quality audio resampler
LIBAUDIORESAMPLER := libaudio-resampler

#LIBOPENCOREHW
LIBOPENCOREHW := libopencorehw

#LIBOVERLAY
LIBOVERLAY := liboverlay
LIBOVERLAY += overlay.default

#LIBGENLOCK
LIBGENLOCK := libgenlock

#LIBPERFLOCK
LIBPERFLOCK := org.codeaurora.Performance

#LIBQCOMUI
LIBQCOMUI := libQcomUI

#LIBQDUTILS
LIBQDUTILS := libqdutils

#LIBQDMETADATA
LIBQDMETADATA := libqdMetaData
LIBQDMETADATA += libqdMetaData.system

#LIBPOWER
LIBPOWER := power.qcom
#LIBPOWER -- Add HIDL Packages
LIBPOWER += android.hardware.power@1.0-impl
LIBPOWER += android.hardware.power@1.0-service

#LLVM for RenderScript
#use qcom LLVM
$(call inherit-product-if-exists, external/llvm/llvm-select.mk)

#LOC_API
LOC_API := libloc_api-rpc-qc

#MEDIA_PROFILES
MEDIA_PROFILES := media_profiles.xml

#MM_AUDIO
MM_AUDIO := libOmxAacDec
MM_AUDIO += libOmxAacEnc
MM_AUDIO += libOmxAmrEnc
MM_AUDIO += libOmxEvrcEnc
MM_AUDIO += libOmxMp3Dec
MM_AUDIO += libOmxQcelp13Enc
MM_AUDIO += libOmxAc3HwDec
MM_AUDIO += libstagefright_soft_flacdec

#MM_CORE
MM_CORE := libmm-omxcore
MM_CORE += libOmxCore

#WFD
MM_WFD := libwfdaac


#MM_VIDEO
MM_VIDEO := ast-mm-vdec-omx-test
MM_VIDEO += beat
MM_VIDEO += liblasic
MM_VIDEO += libOmxVdec
MM_VIDEO += libOmxVdecHevc
MM_VIDEO += libOmxVenc
MM_VIDEO += libOmxVidEnc
MM_VIDEO += libOmxSwVdec
MM_VIDEO += libOmxSwVencMpeg4
MM_VIDEO += libstagefrighthw
MM_VIDEO += mm-vdec-omx-property-mgr
MM_VIDEO += mm-vdec-omx-test
MM_VIDEO += mm-venc-omx-test
MM_VIDEO += mm-venc-omx-test720p
MM_VIDEO += mm-video-driver-test
MM_VIDEO += mm-video-encdrv-test
MM_VIDEO += ExoplayerDemo
MM_VIDEO += libaacwrapper

#NQ_NFC
NQ_NFC := NQNfcNci
NQ_NFC += libnqnfc-nci
NQ_NFC += libnqnfc_nci_jni
NQ_NFC += libsn100nfc_nci_jni
NQ_NFC += libsn100nfc-nci
NQ_NFC += nfc_nci.nqx.default
NQ_NFC += libp61-jcop-kit
NQ_NFC += com.nxp.nfc.nq
NQ_NFC += com.nxp.nfc.nq.xml
NQ_NFC += com.gsma.services.nfc
NQ_NFC += libpn547_fw.so
NQ_NFC += libpn548ad_fw.so
NQ_NFC += libnfc-brcm.conf
NQ_NFC += libnfc-brcm_NCI2_0.conf
NQ_NFC += libnfc-nci.conf
NQ_NFC += libnfc-nci_NCI2_0.conf
NQ_NFC += libnfc-nxp_default.conf
NQ_NFC += nqnfcee_access.xml
NQ_NFC += nqnfcse_access.xml
NQ_NFC += Tag
NQ_NFC += nqnfcinfo
NQ_NFC += com.android.nfc_extras
NQ_NFC += vendor.nxp.hardware.nfc@1.1-service
NQ_NFC += nfc_nci.nqx.default.hw
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.nfc_nci=nqx.default

#OPENCORE
OPENCORE := libomx_aacdec_sharedlibrary
OPENCORE += libomx_avcdec_sharedlibrary
OPENCORE += libomx_m4vdec_sharedlibrary
OPENCORE += libomx_mp3dec_sharedlibrary
OPENCORE += libopencore_author
OPENCORE += libopencore_common
OPENCORE += libopencore_download
OPENCORE += libopencore_downloadreg
OPENCORE += libopencore_mp4local
OPENCORE += libopencore_mp4localreg
OPENCORE += libopencore_net_support
OPENCORE += libopencore_player
OPENCORE += libopencore_rtsp
OPENCORE += libopencore_rtspreg
OPENCORE += libpvplayer_engine
OPENCORE += libpvauthorengine
OPENCORE += pvplayer
OPENCORE += pvplayer_engine_test

#PPP
PPP := ip-up-vpn

PROTOBUF := libprotobuf-cpp-full

#PVOMX
PVOMX := libqcomm_omx
PVOMX += 01_qcomm_omx

#RF4CE
RF4CE := RemoTI_RNP.cfg
RF4CE += rf4ce

#SENSORS_HARDWARE
SENSORS_HARDWARE := sensors.msm7630_surf
SENSORS_HARDWARE += sensors.msm7630_fusion
SENSORS_HARDWARE += sensors.msm8996_auto

#SOFTAP
SOFTAP := libQWiFiSoftApCfg
SOFTAP += libqsap_sdk

#STK
STK := Stk

#STM LOG
STMLOG := libstm-log

#THERMAL_HAL
THERMAL_HAL := thermal.msm8998
THERMAL_HAL += thermal.sdm845
THERMAL_HAL += thermal.sdm710
THERMAL_HAL += thermal.qcs605
THERMAL_HAL += thermal.sdm660
THERMAL_HAL += thermal.msm8996
THERMAL_HAL += thermal.msm8953
THERMAL_HAL += thermal.msm8937

#TSLIB_EXTERNAL
TSLIB_EXTERNAL := corgi
TSLIB_EXTERNAL += dejitter
TSLIB_EXTERNAL += inputraw
TSLIB_EXTERNAL += linear
TSLIB_EXTERNAL += variance
TSLIB_EXTERNAL += pthres
TSLIB_EXTERNAL += libtslib
TSLIB_EXTERNAL += tsprint
TSLIB_EXTERNAL += tstest
TSLIB_EXTERNAL += tsutils
TSLIB_EXTERNAL += tscalib
TSLIB_EXTERNAL += ts

#VR_HAL
VR_HAL := vr.msm8998
VR_HAL += vr.sdm845

#QRGND
QRGND := qrngd
QRGND += qrngp
QRGND += qrngtest

#WPA
WPA := wpa_supplicant.conf
WPA += wpa_supplicant_wcn.conf
WPA += wpa_supplicant_ath6kl.conf
WPA += wpa_supplicant
WPA += hs20-osu-client

#ZLIB
ZLIB := gzip
ZLIB += minigzip
ZLIB += libunz

#Charger
CHARGER := charger
CHARGER += charger_res_images

#VT_JNI
VT_JNI := libvt_jni
VT_JNI += libimscamera_jni

# VT QTI Permissions
VT_QTI_PERMISSIONS := qti_permissions.xml

#RCS
RCS := rcs_service_aidl
RCS += rcs_service_aidl.xml
RCS += rcs_service_aidl_static
RCS += rcs_service_api
RCS += rcs_service_api.xml

#IMS SETTINGS
IMS_SETTINGS := imssettings

#IMS Extension module for Android Telephony
IMS_EXT := ims-ext-common
IMS_EXT += ConfURIDialer

#CRDA
CRDA := crda
CRDA += regdbdump
CRDA += regulatory.bin
CRDA += linville.key.pub.pem
CRDA += init.crda.sh

#WLAN
WLAN := prima_wlan.ko
WLAN += pronto_wlan.ko
WLAN += qca_cld_wlan.ko

#FSTMAN
FSTMAN := fstman
FSTMAN += fstman.ini

# WIGIG
WIGIG := host_manager_11ad
WIGIG += wigig_remoteserver
WIGIG += wigig_wiburn
WIGIG += wigig_logcollector
WIGIG += wigig_logcollector.ini
WIGIG += libwigig_utils
WIGIG += libwigig_flashaccess
WIGIG += libwigig_pciaccess

#FD_LEAK
FD_LEAK := libc_leak_detector

PRODUCT_PACKAGES := \
    AccountAndSyncSettings \
    DeskClock \
    AlarmProvider \
    HidTestApp \
    Calculator \
    Calendar \
    Camera \
    CellBroadcastReceiver \
    CertInstaller \
    DrmProvider \
    Email \
    Gallery2 \
    LatinIME \
    Music \
    netutils-wrapper-1.0 \
    Phone \
    Provision \
    Protips \
    QuickSearchBox \
    Settings \
    Sync \
    SystemUI \
    Updater \
    CalendarProvider \
    SyncProvider \
    SoundRecorder \
    IM \
    VoiceDialer \
    FM2 \
    FMRecord \
    SnapdragonGallery \
    SnapdragonMusic \
    VideoEditor \
    SnapdragonLauncher \
    a4wpservice \
    wipowerservice \
    Mms \
    QtiDialer \
    qtiNetworkLib \
    TestApp5G

ifneq ($(BOARD_HAVE_BLUETOOTH),false)
PRODUCT_PACKAGES += \
    Bluetooth \
    BluetoothExt \
    BATestApp
endif

ifeq ($(TARGET_HAS_LOW_RAM),true)
    DELAUN := Launcher3Go
else
    # Live Wallpapers
    PRODUCT_PACKAGES += \
            LiveWallpapers \
            LiveWallpapersPicker \
            VisualizationWallpapers

    DELAUN := Launcher3
endif

PRODUCT_PACKAGES += $(ALSA_HARDWARE)
PRODUCT_PACKAGES += $(ALSA_UCM)
PRODUCT_PACKAGES += $(ANGLE)
PRODUCT_PACKAGES += $(APPOPS_POLICY)
PRODUCT_PACKAGES += $(AUDIO_HARDWARE)
PRODUCT_PACKAGES += $(AUDIO_POLICY)
PRODUCT_PACKAGES += $(AUDIO_WRAPPER)
PRODUCT_PACKAGES += $(AUDIO_HAL_TEST_APPS)
PRODUCT_PACKAGES += $(TINY_ALSA_TEST_APPS)
PRODUCT_PACKAGES += $(AMPLOADER)
PRODUCT_PACKAGES += $(APPS)
PRODUCT_PACKAGES += $(BRCTL)
PRODUCT_PACKAGES += $(BSON)
ifneq ($(BOARD_HAVE_BLUETOOTH),false)
PRODUCT_PACKAGES += $(BT)
endif
PRODUCT_PACKAGES += $(C2DCC)
PRODUCT_PACKAGES += $(CHROMIUM)
PRODUCT_PACKAGES += $(CIMAX)
PRODUCT_PACKAGES += $(CM)
PRODUCT_PACKAGES += $(DELAUN)
PRODUCT_PACKAGES += $(RCS)
PRODUCT_PACKAGES += $(CONNECTIVITY)
PRODUCT_PACKAGES += $(CHARGER)
PRODUCT_PACKAGES += $(CURL)
PRODUCT_PACKAGES += $(DASH)
PRODUCT_PACKAGES += $(DATA_OS)
PRODUCT_PACKAGES += $(E2FSPROGS)
PRODUCT_PACKAGES += $(EBTABLES)
PRODUCT_PACKAGES += $(EXTENDEDMEDIA_EXT)
PRODUCT_PACKAGES += $(FASTPOWERON)
PRODUCT_PACKAGES += $(FM)
PRODUCT_PACKAGES += $(GPS_HARDWARE)
PRODUCT_PACKAGES += $(HDMID)
PRODUCT_PACKAGES += $(HOSTAPD)
PRODUCT_PACKAGES += $(I420CC)
PRODUCT_PACKAGES += $(INIT)
PRODUCT_PACKAGES += $(IPROUTE2)
PRODUCT_PACKAGES += $(IPTABLES)
PRODUCT_PACKAGES += $(KERNEL_TESTS)
PRODUCT_PACKAGES += $(KEYPAD)
PRODUCT_PACKAGES += $(KS)
PRODUCT_PACKAGES += $(LIB_NL)
PRODUCT_PACKAGES += $(LIB_XML2)
PRODUCT_PACKAGES += $(LIBCAMERA)
PRODUCT_PACKAGES += $(LIBGESTURES)
PRODUCT_PACKAGES += $(LIBCOPYBIT)
PRODUCT_PACKAGES += $(LIBGRALLOC)
PRODUCT_PACKAGES += $(LIBMEMTRACK)
PRODUCT_PACKAGES += $(LIBLIGHTS)
PRODUCT_PACKAGES += $(LIBAUDIOPARAM)
PRODUCT_PACKAGES += $(LIBAUDIORESAMPLER)
PRODUCT_PACKAGES += $(LIBOPENCOREHW)
PRODUCT_PACKAGES += $(LIBOVERLAY)
PRODUCT_PACKAGES += $(LIBHWCOMPOSER)
PRODUCT_PACKAGES += $(LIBGENLOCK)
PRODUCT_PACKAGES += $(LIBPERFLOCK)
PRODUCT_PACKAGES += $(LIBQCOMUI)
PRODUCT_PACKAGES += $(LIBQDUTILS)
PRODUCT_PACKAGES += $(LIBQDMETADATA)
PRODUCT_PACKAGES += $(LIBPOWER)
PRODUCT_PACKAGES += $(LOC_API)
PRODUCT_PACKAGES += $(MEDIA_PROFILES)
PRODUCT_PACKAGES += $(MM_AUDIO)
PRODUCT_PACKAGES += $(MM_CORE)
PRODUCT_PACKAGES += $(MM_WFD)
PRODUCT_PACKAGES += $(MM_VIDEO)
ifeq ($(strip $(TARGET_USES_NQ_NFC)),true)
PRODUCT_PACKAGES += $(NQ_NFC)
endif
ifeq ($(strip $(BOARD_HAVE_QCOM_FM)),true)
# system prop for fm
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.hw.fm.init=0
endif #BOARD_HAVE_QCOM_FM
PRODUCT_PACKAGES += $(OPENCORE)
PRODUCT_PACKAGES += $(PPP)
PRODUCT_PACKAGES += $(PROTOBUF)
PRODUCT_PACKAGES += $(PVOMX)
PRODUCT_PACKAGES += $(RF4CE)
PRODUCT_PACKAGES += $(SENSORS_HARDWARE)
#PRODUCT_PACKAGES += $(SOFTAP)
PRODUCT_PACKAGES += $(STK)
PRODUCT_PACKAGES += $(STMLOG)
PRODUCT_PACKAGES += $(THERMAL_HAL)
PRODUCT_PACKAGES += $(TSLIB_EXTERNAL)
PRODUCT_PACKAGES += $(VR_HAL)
PRODUCT_PACKAGES += $(QRGND)
PRODUCT_PACKAGES += $(UPDATER)
PRODUCT_PACKAGES += $(WPA)
PRODUCT_PACKAGES += $(ZLIB)
PRODUCT_PACKAGES += $(VT_JNI)
PRODUCT_PACKAGES += $(VT_QTI_PERMISSIONS)
PRODUCT_PACKAGES += $(IMS_SETTINGS)
PRODUCT_PACKAGES += $(CRDA)
PRODUCT_PACKAGES += $(WLAN)
PRODUCT_PACKAGES += $(IPACM)
PRODUCT_PACKAGES += $(FSTMAN)
PRODUCT_PACKAGES += $(WIGIG)
PRODUCT_PACKAGES += $(FD_LEAK)
PRODUCT_PACKAGES += $(IMS_EXT)
# Temp workarround for b/36603742
PRODUCT_PACKAGES += android.hidl.manager@1.0-java

PRODUCT_PACKAGES += android.hardware.drm@1.0-impl
PRODUCT_PACKAGES += android.hardware.drm@1.0-service
PRODUCT_PACKAGES += android.hardware.drm@1.1-service.widevine
PRODUCT_PACKAGES += android.hardware.drm@1.1-service.clearkey
ifeq ($(strip $(OTA_FLAG_FOR_DRM)),true)
PRODUCT_PACKAGES += move_widevine_data.sh
endif
PRODUCT_PACKAGES += move_wifi_data.sh
PRODUCT_PACKAGES += librs_jni

# Filesystem management tools
PRODUCT_PACKAGES += \
    make_ext4fs \
    setup_fs

# Qcril configuration file
PRODUCT_PACKAGES += qcril.db

# MSM updater library
PRODUCT_PACKAGES += librecovery_updater_msm

# vcard jar
PRODUCT_PACKAGES += vcard

# tcmiface for tcm support
PRODUCT_PACKAGES += tcmiface

# healthd libaray expanded for mode charger
PRODUCT_PACKAGES += libhealthd.msm

#intialise PRODUCT_PACKAGES_DEBUG list for debug modules
PRODUCT_PACKAGES_DEBUG := init.qcom.testscripts.sh

#Add init.qcom.test.rc to PRODUCT_PACKAGES_DEBUG list
PRODUCT_PACKAGES_DEBUG += init.qcom.test.rc
PRODUCT_PACKAGES_DEBUG += init.qcom.debug.sh

#NANOPB_LIBRARY_NAME := libnanopb-c-2.8.0

PRODUCT_COPY_FILES := \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml\
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml\
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# Enable TDES support when KM4 is enabled
ifeq ($(ENABLE_KM_4_0), true)
    PRODUCT_PROPERTY_OVERRIDES += \
        ro.hardware.keystore_desede=true
endif

# Bluetooth configuration files
#PRODUCT_COPY_FILES += \
    system/bluetooth/data/audio.conf:system/etc/bluetooth/audio.conf \
    system/bluetooth/data/auto_pairing.conf:system/etc/bluetooth/auto_pairing.conf \
    system/bluetooth/data/blacklist.conf:system/etc/bluetooth/blacklist.conf \
    system/bluetooth/data/input.conf:system/etc/bluetooth/input.conf \
    system/bluetooth/data/network.conf:system/etc/bluetooth/network.conf \


#ifeq ($(BOARD_HAVE_BLUETOOTH_BLUEZ),true)
#PRODUCT_COPY_FILES += \
    system/bluetooth/data/stack.conf:system/etc/bluetooth/stack.conf
#endif # BOARD_HAVE_BLUETOOTH_BLUEZ

# gps/location secuity configuration file
PRODUCT_COPY_FILES += \
    device/qcom/common/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config

#copy codecs_xxx.xml to (TARGET_COPY_OUT_VENDOR)/etc/
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \
    device/qcom/common/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    device/qcom/common/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

ifneq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS),true)
PRODUCT_COPY_FILES += \
    device/qcom/common/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml
endif

ifeq ($(strip $(TARGET_USES_NQ_NFC)),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml
endif

ifneq ($(TARGET_NOT_SUPPORT_VULKAN),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml
endif

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

#Enabling Ring Tones
#include frameworks/base/data/sounds/OriginalAudio.mk

#Enabling video for live effects
-include frameworks/base/data/videos/VideoPackage1.mk

# dm-verity definitions
ifneq ($(BOARD_AVB_ENABLE), true)
   PRODUCT_SYSTEM_VERITY_PARTITION=/dev/block/bootdevice/by-name/system
   ifeq ($(ENABLE_VENDOR_IMAGE), true)
      PRODUCT_VENDOR_VERITY_PARTITION=/dev/block/bootdevice/by-name/vendor
   endif
   $(call inherit-product, build/target/product/verity.mk)
endif

ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
    ro.adb.secure=1
endif

# OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

ifeq ($(TARGET_USES_QCOM_BSP_ATEL),true)
    PRODUCT_PROPERTY_OVERRIDES += persist.radio.multisim.config=dsds
endif

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

ifeq ($(TARGET_HAS_LOW_RAM),true)
    PRODUCT_PROPERTY_OVERRIDES += \
        persist.vendor.qcomsysd.enabled=0
else
    PRODUCT_PROPERTY_OVERRIDES += \
        persist.vendor.qcomsysd.enabled=1
endif

PRODUCT_PACKAGES += liboemaids_system
PRODUCT_PACKAGES += liboemaids_vendor
PRODUCT_PACKAGES += android.hardware.health@2.0-service
