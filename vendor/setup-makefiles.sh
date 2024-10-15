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
        "vendor/qcom/common/vendor/alarm",
        "vendor/qcom/common/vendor/charging",
        "vendor/qcom/common/vendor/display/4.19",
        "vendor/qcom/common/vendor/display/5.4",
        "vendor/qcom/common/vendor/display/5.10",
        "vendor/qcom/common/vendor/display/5.15",
        "vendor/qcom/common/vendor/dsprpcd",
        "vendor/qcom/common/vendor/gps-legacy",
        "vendor/qcom/common/vendor/keymaster",
        "vendor/qcom/common/vendor/nfc/nq",
        "vendor/qcom/common/vendor/perf",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        vendor.qti.hardware.perf@2.0 | \
            vendor.qti.hardware.perf@2.1 | \
            vendor.qti.hardware.perf@2.2 | \
            vendor.qti.qspmhal@1.0)
            echo "$1_vendor"
            ;;
        libwpa_client | \
            libdiag | \
            libmdmdetect | \
            libperipheral_client | \
            libqmiservices | \
            libqmi_common_so | \
            libqmi_cci | \
            libqmi_encdec | \
            libsnsapi | \
            libtime_genoff)
            # Android.mk only packages
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
