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

# Initialize the helper
setup_vendor "${COMPONENT}" "${VENDOR}" "${ANDROID_ROOT}" false true "" true
if [ -f "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" ]; then
    setup_vendor "${COMPONENT}/${KERNEL_VERSION}" "${VENDOR}" "${ANDROID_ROOT}" false true "${COMPONENT}" true
fi

# Warning headers and guards
write_headers

# The standard common blobs
write_makefiles "${MY_DIR}/${COMPONENT}/proprietary-files.txt" true
if [ -f "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" ]; then
    write_makefiles "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" true
fi

# Finish
write_footers
