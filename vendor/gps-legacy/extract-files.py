#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import ExtractUtils

from extract_utils_qti.fixups_lib import lib_fixup_vendor_suffix
from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'vendor/qcom/common/vendor/display/4.19',
    'vendor/qcom/common/vendor/display/5.4',
    'vendor/qcom/common/vendor/qseecomd-legacy',
    'vendor/qcom/common/vendor/qseecomd',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'vendor.qti.hardware.qccsyshal@1.0',
        'vendor.qti.hardware.qccvndhal@1.0',
    ): lib_fixup_vendor_suffix,
    (
        'libidl',
        'libmdmdetect',
        'libpdmapper',
        'libperipheral_client',
        'libqcbor',
        'libqmi_cci',
        'libqmi_csi',
        'libqmi_common_so',
        'libqmi_encdec',
        'libqmiservices',
        'libril-qc-logger',
        'libwpa_client',
        'qcril_hal_client',
    ): lib_fixup_remove,
}

module = ExtractUtilsQTIModule(
    'gps-legacy',
    QTIComponentType.VENDOR,
    namespace_imports=namespace_imports,
    lib_fixups=lib_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
