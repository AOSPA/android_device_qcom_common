#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_lib import lib_fixups, lib_fixups_user_type
from extract_utils.main import ExtractUtils

from extract_utils_qti.fixups_lib import lib_fixup_vendor_suffix
from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'hardware/qcom/display/gralloc',
    'vendor/qcom/common/vendor/perf',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'vendor.qti.qspmhal-V1-ndk': lib_fixup_vendor_suffix,
}

module = ExtractUtilsQTIModule(
    'adreno-u',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
