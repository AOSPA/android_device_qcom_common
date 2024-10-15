#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-FileCopyrightText: 2020 Paranoid Android
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
        "vendor/qcom/common/system/alarm",
        "vendor/qcom/common/system/audio",
        "vendor/qcom/common/system/av",
        "vendor/qcom/common/system/bt",
        "vendor/qcom/common/system/display",
        "vendor/qcom/common/system/gps",
        "vendor/qcom/common/system/perf",
        "vendor/qcom/common/system/telephony",
        "vendor/qcom/common/system/wfd",
EOF
}

# Initialize the helper
setup_vendor "${COMPONENT}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" false true "" true

# Warning headers and guards
write_headers

# The standard common blobs
write_makefiles "${MY_DIR}/${COMPONENT}/proprietary-files.txt"

# Finish
write_footers
