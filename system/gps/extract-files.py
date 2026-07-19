#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_lib import lib_fixups, lib_fixups_user_type
from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'vendor/qcom/common/system/telephony',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'libprotobuf-cpp-full-6.33.5': lambda lib, partition: lib.rsplit('-', 1)[0],
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'gps',
    QTIComponentType.SYSTEM,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
