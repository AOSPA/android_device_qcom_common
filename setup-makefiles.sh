#!/bin/bash
#
# Copyright (C) 2018-2019 The LineageOS Project
# Copyright (C) 2020 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ROOT="${MY_DIR}/../../.."

HELPER="${ROOT}/vendor/pa/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper for device
setup_vendor "${COMPONENT}" "${VENDOR}" "${ROOT}" false true "" true

# Copyright headers and guards
write_headers

# The standard common blobs
write_makefiles "${MY_DIR}/${COMPONENT}/proprietary-files.txt" true

# Finish
write_footers

VENDOR_OVERLAY_FILES="${MY_DIR}/${COMPONENT}/proprietary-files-vendor-overlay.txt"
if [ -f "${VENDOR_OVERLAY_FILES}" ]; then

    # Conditionally include vendor-overlay Makefile in vendor Makefile
    # To simplify, we can still include the default vendor Makefile in case
    # system and vendor blobs are mixed.
    printf '\n%s\n' "ifneq (\$(TARGET_COPY_OUT_VENDOR_OVERLAY),)" >> "$PRODUCTMK"
    printf '%s\n' "\$(call inherit-product-if-exists, "$OUTDIR"/"$COMPONENT"-overlay-vendor.mk)" >> "$PRODUCTMK"
    #printf '%s\n' "include "$OUTDIR"/"$COMPONENT"-overlay-vendor.mk" >> "$PRODUCTMK"
    printf '%s\n' "endif" >> "$PRODUCTMK"
    printf '%s\n' >> "$PRODUCTMK"

    # Initialize the helper for device
    setup_vendor "${COMPONENT}" "${VENDOR}" "${ROOT}" false false "$VNDNAME"-overlay true

    # Copyright headers and guards
    write_headers

    # The standard common blobs
    write_makefiles "${VENDOR_OVERLAY_FILES}" true

    # Finish
    write_footers

fi
