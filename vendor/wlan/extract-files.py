#!/usr/bin/env -S PYTHONPATH=../../extract_utils:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from qti import ExtractUtilsQTIModule, QTIComponentType

from extract_utils.fixups_lib import lib_fixup_remove, lib_fixups_user_type
from extract_utils.main import ExtractUtils

lib_fixups: lib_fixups_user_type = {
    (
        'libmdmdetect',
        'libperipheral_client',
        'libqmi_cci',
        'libqmi_common_so',
        'libqmiservices',
    ): lib_fixup_remove,
}

module = ExtractUtilsQTIModule(
    'wlan',
    QTIComponentType.VENDOR,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
