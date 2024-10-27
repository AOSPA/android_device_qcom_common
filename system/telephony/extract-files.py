#!/usr/bin/env -S PYTHONPATH=../../extract_utils:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from qti import ExtractUtilsQTIModule, QTIComponentType

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import ExtractUtils

blob_fixups: blob_fixups_user_type = {
    (
        'product/etc/permissions/vendor.qti.hardware.data.connection-V1.0-java.xml',
        'product/etc/permissions/vendor.qti.hardware.data.connection-V1.1-java.xml',
        'product/etc/permissions/vendor.qti.hardware.data.connectionaidl-V1-java.xml',
    ): blob_fixup()
        .regex_replace('xml version="2.0"', 'xml version="1.0"'),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'telephony',
    QTIComponentType.SYSTEM,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
