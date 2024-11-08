#!/usr/bin/env -S PYTHONPATH=../../extract_utils:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from qti import ExtractUtilsQTIModule, QTIComponentType, lib_fixup_vendor_suffix

from extract_utils.fixups_lib import lib_fixups_user_type
from extract_utils.main import ExtractUtils

namespace_imports = [
    'hardware/qcom/display/gralloc',
]

lib_fixups: lib_fixups_user_type = {
    'vendor.qti.qspmhal@1.0': lib_fixup_vendor_suffix,
}

module = ExtractUtilsQTIModule(
    'adreno-s',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
