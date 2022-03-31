#!/bin/bash
#
# Copyright (C) 2022 Paranoid Android
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

# Determine Android sources root
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../../../.."

# Define qtimapper shim patched libraries directory and create it
QTIMAPPER_DIR="${ANDROID_ROOT}/vendor/qcom/common/vendor/adreno/qtimapper-shim"
mkdir -p "${QTIMAPPER_DIR}"

# Define vendor/adreno blobs directory
NON_PATCHED_DIR="${ANDROID_ROOT}/vendor/qcom/common/vendor/adreno/proprietary"

# Libraries which require qtimapper shim patch
QTIMAPPER_PATCH_REQUIRED=(
    egl/eglSubDriverAndroid.so
    hw/vulkan.adreno.so
    libCB.so
)

# Apply patch for every library and create makefile entry for it
NON_PATCHED_PREFIX="${NON_PATCHED_DIR}/vendor/lib"
QTIMAPPER_PREFIX="${QTIMAPPER_DIR}/proprietary/vendor/lib"

for i in ${QTIMAPPER_PATCH_REQUIRED[@]}; do
    # Get full path to input and output files
    OUT_FILE_64="${QTIMAPPER_PREFIX}64/${i}"
    OUT_FILE_32="${QTIMAPPER_PREFIX}/${i}"

    # Create output files' directories
    mkdir -p "${OUT_FILE_64%/*}" "${OUT_FILE_32%/*}"

    # Copy libraries
    cp "${NON_PATCHED_PREFIX}64/${i}" "${OUT_FILE_64}"
    cp "${NON_PATCHED_PREFIX}/${i}" "${OUT_FILE_32}"

    # Use qtimapper-shim in them
    sed -i 's/android\.hardware\.graphics\.mapper@[3-4]\.0\.so/android\.hardware\.graphics\.mappershim\.so/g' \
        "${OUT_FILE_64}" "${OUT_FILE_32}"
    sed -i 's/vendor\.qti\.hardware\.display\.mapper@[3-4]\.0\.so/vendor\.qti\.hardware\.display\.mappershim\.so/g' \
        "${OUT_FILE_64}" "${OUT_FILE_32}"
done

cp "${MY_DIR}/qtimapper-shim_vendor_bp" "${QTIMAPPER_DIR}/Android.bp"
