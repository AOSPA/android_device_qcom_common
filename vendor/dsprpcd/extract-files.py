#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'vendor/qcom/common/vendor/qseecomd-legacy',
    'vendor/qcom/common/vendor/qseecomd',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'libqmi_cci',
        'libqmi_common_so',
        'libqmi_encdec',
        'libsnsapi',
    ): lib_fixup_remove,
}

module = ExtractUtilsQTIModule(
    'dsprpcd',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
