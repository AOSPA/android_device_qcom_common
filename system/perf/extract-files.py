#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import blob_fixups_user_type
from extract_utils.main import ExtractUtils

from extract_utils_qti.fixups_blob import blob_fixup_qti
from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

blob_fixups: blob_fixups_user_type = {
    'system/framework/QXPerformance.jar': blob_fixup_qti()
        .zipalign(),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'perf',
    QTIComponentType.SYSTEM,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
