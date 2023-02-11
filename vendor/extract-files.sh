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

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

# Initialize the helper
if [ -f "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" ] && [ ! -z ${KERNEL_VERSION} ]; then
    setup_vendor "${COMPONENT}/${KERNEL_VERSION}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}" "${COMPONENT}" true
else
    setup_vendor "${COMPONENT}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}" "" true
fi

if [ -f "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" ] && [ ! -z ${KERNEL_VERSION} ]; then
    extract "${MY_DIR}/${COMPONENT}/${KERNEL_VERSION}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"
else
    extract "${MY_DIR}/${COMPONENT}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"
fi

"${MY_DIR}/setup-makefiles.sh"
