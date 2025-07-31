#!/usr/bin/env -S PYTHONPATH=../../../:../../../../../../tools/extract-utils python3
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

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'hardware/qcom/display',
    'hardware/qcom/display/gralloc',
    'vendor/qcom/common/vendor/dsprpcd',
    'vendor/qcom/common/vendor/media/6.6',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'qti.video.utils.videobufferlayout',
        'vendor.qti.hardware.vpp-V1-ndk',
        'vendor.qti.hardware.vpp@1.1',
        'vendor.qti.hardware.vpp@1.2',
        'vendor.qti.hardware.vpp@1.3',
    ): lib_fixup_vendor_suffix,
    (
        'libcv_common',
        'libeva',
        'libpowercore',
        'libvmmem',
    ): lib_fixup_remove,
}

module = ExtractUtilsQTIModule(
    'media/6.6',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
