#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
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
    'vendor/qcom/common/vendor/display/4.19',
    'vendor/qcom/common/vendor/display/5.10',
    'vendor/qcom/common/vendor/display/5.15',
    'vendor/qcom/common/vendor/display/5.4',
]

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
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
