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
    'vendor/qcom/common/system/telephony',
]

blob_fixups: blob_fixups_user_type = {
       ('system_ext/lib64/vendor.qti.hardware.qccsyshal@1.2-halimpl.so'): blob_fixup()
            .replace_needed('libprotobuf-cpp-full.so','libprotobuf-cpp-full-21.7.so'),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'gps',
    QTIComponentType.SYSTEM,
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
