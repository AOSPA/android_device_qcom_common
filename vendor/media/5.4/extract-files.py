#!/usr/bin/env -S PYTHONPATH=../../../:../../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'hardware/qcom/display',
    'hardware/qcom/display/gralloc',
]

module = ExtractUtilsQTIModule(
    'media/5.4',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
