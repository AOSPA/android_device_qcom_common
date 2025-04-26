#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

module = ExtractUtilsQTIModule(
    'display',
    QTIComponentType.SYSTEM,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
