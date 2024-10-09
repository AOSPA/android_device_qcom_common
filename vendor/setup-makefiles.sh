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
        "vendor/qcom/common/vendor/alarm",
        "vendor/qcom/common/vendor/charging",
        "vendor/qcom/common/vendor/dsprpcd",
        "vendor/qcom/common/vendor/gps-legacy",
        "vendor/qcom/common/vendor/keymaster",
        "vendor/qcom/common/vendor/nfc/nq",
        "vendor/qcom/common/vendor/perf",
EOF
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
