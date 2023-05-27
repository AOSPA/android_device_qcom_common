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

SCRIPT_LOCATION=$(readlink -f "${BASH_SOURCE[0]}")
ANDROID_ROOT=$(dirname $SCRIPT_LOCATION)"/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Get the COMPONENT, KERNEL_VERSION, and VENDOR from the current directory
CURRENT_DIR="$(pwd)"

if [[ "$(basename $(realpath $CURRENT_DIR/../..))" == "system" ]] || \
   [[ "$(basename $(realpath $CURRENT_DIR/..))" == "system" ]] ; then
    VENDOR="qcom/common/system"
elif [[ "$(basename $(realpath $CURRENT_DIR/../..))" == "vendor" ]] || \
   [[ "$(basename $(realpath $CURRENT_DIR/..))" == "vendor" ]] ; then
    VENDOR="qcom/common/vendor"
fi

# Extract the kernel version if it follows the format x.y
if [[ "${CURRENT_DIR}" =~ /([0-9]+\.[0-9]+)$ ]]; then
    KERNEL_VERSION="${BASH_REMATCH[1]}"
fi

if [ ! -z "${KERNEL_VERSION}" ]; then
    COMPONENT=$(basename $(realpath "$CURRENT_DIR/.."))
else
    COMPONENT=$(basename "$CURRENT_DIR")
fi
echo $COMPONENT $KERNEL_VERSION $VENDOR $ANDROID_ROOT
# Initialize the helper
if [ ! -z ${KERNEL_VERSION} ]; then
    setup_vendor "${COMPONENT}/${KERNEL_VERSION}" "${VENDOR}" "${ANDROID_ROOT}" false true "${COMPONENT}" true
else
    setup_vendor "${COMPONENT}" "${VENDOR}" "${ANDROID_ROOT}" false true "" true
fi

# Warning headers and guards
write_headers

# The standard common blobs
if [ ! -z ${KERNEL_VERSION} ]; then
    write_makefiles "${MY_DIR}/proprietary-files.txt" true
else
    write_makefiles "${MY_DIR}/proprietary-files.txt" true
fi

# Finish
write_footers
