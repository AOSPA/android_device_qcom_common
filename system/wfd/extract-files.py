#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import blob_fixup, blob_fixups_user_type
from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'vendor/qcom/common/system/av',
]

blob_fixups: blob_fixups_user_type = {
    (
        'system_ext/lib/libwfdservice.so',
        'system_ext/lib64/libwfdservice.so',
    ): blob_fixup()
        .replace_needed(
            'android.media.audio.common.types-V4-cpp.so',
            'android.media.audio.common.types-V5-cpp.so',
        ),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'wfd',
    QTIComponentType.SYSTEM,
    blob_fixups=blob_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
