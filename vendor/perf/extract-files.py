#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import blob_fixup, blob_fixups_user_type
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import ExtractUtils

from extract_utils_qti.fixups_lib import lib_fixup_vendor_suffix
from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'hardware/qcom/display',
    'vendor/qcom/common/vendor/display/4.19',
    'vendor/qcom/common/vendor/display/5.10',
    'vendor/qcom/common/vendor/display/5.15',
    'vendor/qcom/common/vendor/display/5.4',
]

blob_fixups: blob_fixups_user_type = {
    'vendor/lib64/libmemperfd.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-lite-21.7.so', 'libprotobuf-cpp-lite-21.12.so'),
    'vendor/lib64/libprekill.so': blob_fixup()
        .replace_needed('libprotobuf-cpp-full-21.7.so', 'libprotobuf-cpp-full-21.12.so'),
}  # fmt: skip

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'vendor.qti.hardware.iop@2.0',
        'vendor.qti.hardware.perf@2.0',
        'vendor.qti.hardware.perf@2.1',
        'vendor.qti.hardware.perf@2.2',
        'vendor.qti.hardware.perf2-V1-ndk',
        'vendor.qti.qspmhal-V1-ndk',
    ): lib_fixup_vendor_suffix,
    'libthermalclient': lib_fixup_remove,
}

module = ExtractUtilsQTIModule(
    'perf',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
