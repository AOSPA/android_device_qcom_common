#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import blob_fixup, blob_fixups_user_type
from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

blob_fixups: blob_fixups_user_type = {
    ('system_ext/bin/gppservice',
     'system_ext/lib64/libgpphexlpsession.so',
     'system_ext/lib64/libgppvppgfrcplussession.so'): blob_fixup()
        .add_needed('libgui_shim.so'),
}

module = ExtractUtilsQTIModule(
    'display',
    QTIComponentType.SYSTEM,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
