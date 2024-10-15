#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
# Copyright (C) 2020 Paranoid Android
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
        "hardware/qcom/display",
        "hardware/qcom/display/gralloc",
        "hardware/qcom/display/libdebug",
        "hardware/qcom/wlan/qcwcn",
        "vendor/qcom/common/vendor/adreno-5xx",
        "vendor/qcom/common/vendor/adreno-r",
        "vendor/qcom/common/vendor/adreno-s",
        "vendor/qcom/common/vendor/adreno-t",
        "vendor/qcom/common/vendor/adreno-u",
        "vendor/qcom/common/vendor/alarm",
        "vendor/qcom/common/vendor/charging",
        "vendor/qcom/common/vendor/display",
        "vendor/qcom/common/vendor/display/4.19",
        "vendor/qcom/common/vendor/display/5.10",
        "vendor/qcom/common/vendor/display/5.15",
        "vendor/qcom/common/vendor/display/5.4",
        "vendor/qcom/common/vendor/dsprpcd",
        "vendor/qcom/common/vendor/gps-legacy",
        "vendor/qcom/common/vendor/keymaster",
        "vendor/qcom/common/vendor/media-5.4",
        "vendor/qcom/common/vendor/media-legacy",
        "vendor/qcom/common/vendor/media",
        "vendor/qcom/common/vendor/nfc/nq",
        "vendor/qcom/common/vendor/perf",
        "vendor/qcom/common/vendor/qseecomd-legacy",
        "vendor/qcom/common/vendor/qseecomd",
        "vendor/qcom/common/vendor/wlan-legacy",
        "vendor/qcom/common/vendor/wlan",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        vendor.display.color@1.0 | \
            vendor.display.color@1.1 | \
            vendor.display.color@1.2 | \
            vendor.display.color@1.3 | \
            vendor.display.color@1.4 | \
            vendor.display.color@1.5 | \
            vendor.display.color@1.6 | \
            vendor.display.color@1.7 | \
            vendor.display.postproc@1.0 | \
            vendor.qti.hardware.iop@2.0 | \
            vendor.qti.hardware.perf@2.0 | \
            vendor.qti.hardware.perf@2.1 | \
            vendor.qti.hardware.perf@2.2 | \
            vendor.qti.hardware.perf2-V1-ndk | \
            vendor.qti.hardware.qccsyshal@1.0 | \
            vendor.qti.hardware.qccvndhal@1.0 | \
            vendor.qti.qspmhal@1.0 | \
            vendor.qti.qspmhal-V1-ndk)
            echo "$1_vendor"
            ;;
        libprotobuf-cpp-full-21.12)
            echo "libprotobuf-cpp-full"
            ;;
        libprotobuf-cpp-lite-21.12)
            echo "libprotobuf-cpp-lite"
            ;;
        libc2dcolorconvert | \
            libdiag | \
            libdisplayqos | \
            libidl | \
            libminksocket_vendor | \
            libmdmdetect | \
            libmmosal | \
            libOmxCore | \
            libpalclient | \
            libpdmapper | \
            libperipheral_client | \
            libplatformconfig | \
            libqcbor | \
            libqmi_cci | \
            libqmi_csi | \
            libqmi_common_so | \
            libqmi_encdec | \
            libqmiservices | \
            libqrtr | \
            libQSEEComAPI | \
            libril-qc-logger | \
            libsdmdal | \
            libsnsapi | \
            libthermalclient | \
            libtime_genoff | \
            libvmmem | \
            libwfdcommonutils_proprietary | \
            libwfdmmservice_proprietary | \
            libwfdutils_proprietary | \
            libwpa_client | \
            qcril_hal_client)
            # Unreachable soong namespace
            ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
if [ -f "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" ] && [ ! -z ${KERNEL_VERSION} ]; then
    setup_vendor "${COMPONENT}/${KERNEL_VERSION}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" false true "${COMPONENT}" true
else
    setup_vendor "${COMPONENT}" "${VENDOR}" "${ANDROID_ROOT}" false true "" true
fi

# Warning headers and guards
write_headers

# The standard common blobs
if [ -f "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" ] && [ ! -z ${KERNEL_VERSION} ]; then
    write_makefiles "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt"
else
    write_makefiles "${MY_DIR}/${COMPONENT}/proprietary-files.txt"
fi

# Finish
write_footers
