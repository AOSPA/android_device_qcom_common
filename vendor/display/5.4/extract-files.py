#!/usr/bin/env -S PYTHONPATH=../../../:../../../../../../tools/extract-utils python3
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

from extract_utils_qti.fixups_lib import lib_fixup_vendor_suffix
from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'hardware/qcom/display',
    'hardware/qcom/display/libdebug',
    'vendor/qcom/common/vendor/display',
    'vendor/qcom/common/vendor/qseecomd-legacy',
    'vendor/qcom/common/vendor/qseecomd',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'vendor.display.color@1.0',
        'vendor.display.color@1.1',
        'vendor.display.color@1.2',
        'vendor.display.color@1.3',
        'vendor.display.color@1.4',
        'vendor.display.color@1.5',
        'vendor.display.postproc@1.0',
    ): lib_fixup_vendor_suffix,
    'libqrtr': lib_fixup_remove,
}

module = ExtractUtilsQTIModule(
    'display/5.4',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
