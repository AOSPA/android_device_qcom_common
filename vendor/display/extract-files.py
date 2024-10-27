#!/usr/bin/env -S PYTHONPATH=../../extract_utils:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from qti import ExtractUtilsQTIModule, QTIComponentType

from extract_utils.main import ExtractUtils

module = ExtractUtilsQTIModule(
    'display',
    QTIComponentType.VENDOR,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
