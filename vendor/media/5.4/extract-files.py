#!/usr/bin/env -S PYTHONPATH=../../../:../../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import blob_fixup, blob_fixups_user_type
from extract_utils.fixups_lib import lib_fixups, lib_fixups_user_type
from extract_utils.main import ExtractUtils

from extract_utils_qti.fixups_lib import lib_fixup_vendor_suffix
from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'hardware/qcom/display',
    'hardware/qcom/display/gralloc',
]

blob_fixups: blob_fixups_user_type = {
    'vendor/etc/init/vendor.qti.media.c2@1.0-service.rc': blob_fixup()
        .regex_replace(r'writepid\s+/dev/cpuset/foreground/tasks', 'task_profiles ProcessCapacityHigh HighPerformance'),
}

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'vendor.qti.hardware.perf@2.0',
        'vendor.qti.hardware.perf@2.1',
        'vendor.qti.hardware.perf@2.2',
    ): lib_fixup_vendor_suffix,
}

module = ExtractUtilsQTIModule(
    'media/5.4',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
