PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/vendor/media

TARGET_MEDIA_COMPONENT_VARIANT := media

# Inherit configuration from the HAL.
$(call inherit-product-if-exists, hardware/qcom/media/product.mk)

# Media Codecs
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

# Packages
PRODUCT_PACKAGES += \
    libavservices_minijail.vendor \
    libgui_vendor \
    libstagefright_softomx.vendor \
    libstagefrighthw

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    media.stagefright.thumbnail.prefer_hw_codecs=true \
    ro.media.recorder-max-base-layer-fps=60

ifeq ($(TARGET_BOARD_PLATFORM), bengal)
PRODUCT_COPY_FILES += \
    device/qcom/common/vendor/media/init.qti.media.bengal.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.qti.media.rc \
    device/qcom/common/vendor/media/init.qti.media.bengal.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.media.sh

# Packages
PRODUCT_PACKAGES += \
    libcodec2_hidl@1.0.vendor \
    libcodec2_vndk.vendor \
    libplatformconfig

PRODUCT_VENDOR_PROPERTIES += \
    debug.c2.use_dmabufheaps=1 \
    vendor.audio.c2.preferred=true \
    vendor.qc2audio.suspend.enabled=true \
    vendor.qc2audio.per_frame.flac.dec.enabled=true

endif

#---------------------------------------------------------------------------------------------------
# Runtime Codec2.0 enablement
#---------------------------------------------------------------------------------------------------
# TODO(PC): Override ccodec selection option back to defult (4).
#           QSSI is forcing this to '1'. Must be reverted
ifeq ($(call is-board-platform-in-list, bengal), true)
    $(warning "Default Codec2.0 Enabled")
    PRODUCT_ODM_PROPERTIES += debug.stagefright.ccodec=4
endif

# Get non-open-source specific aspects.
$(call inherit-product-if-exists, vendor/qcom/common/vendor/media/media-vendor.mk)
