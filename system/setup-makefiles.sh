#!/bin/bash

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

# Warning headers and guards
write_headers

# The standard common blobs
write_makefiles "${MY_DIR}/${COMPONENT}/proprietary-files.txt" true

# Finish
write_footers
