#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import lib_fixups
from extract_utils.main import ExtractUtils

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType

namespace_imports = [
    'vendor/qcom/common/system/telephony',
]

blob_fixups: blob_fixups_user_type = {
    'system_ext/etc/init/vendor.qti.hardware.qccsyshal@1.2-service.rc': blob_fixup()
        .regex_replace('group misc system', 'group misc system\\n    interface vendor.qti.hardware.qccsyshal@1.2::IQccsyshal qccsyshal\\n    interface vendor.qti.hardware.qccsyshal@1.1::IQccsyshal qccsyshal\\n    interface vendor.qti.hardware.qccsyshal@1.0::IQccsyshal qccsyshal'),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'gps',
    QTIComponentType.SYSTEM,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
