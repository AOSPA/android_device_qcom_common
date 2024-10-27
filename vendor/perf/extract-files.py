#!/usr/bin/env -S PYTHONPATH=../../extract_utils:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from qti import ExtractUtilsQTIModule, QTIComponentType

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import ExtractUtils

blob_fixups: blob_fixups_user_type = {
    'vendor/lib64/libmemperfd.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-21.7.so', 'libprotobuf-cpp-lite-21.12.so'),
    'vendor/lib64/libprekill.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-full-21.7.so', 'libprotobuf-cpp-full-21.12.so'),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'perf',
    QTIComponentType.VENDOR,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
