#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

module = ExtractUtilsQTIModule(
    'bt',
    QTIComponentType.SYSTEM,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
