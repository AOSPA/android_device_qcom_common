#
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from __future__ import annotations

from enum import Enum
from os import path
from typing import List, Optional

from extract_utils.fixups_blob import blob_fixups_user_type
from extract_utils.fixups_lib import lib_fixups_user_type
from extract_utils.module import ExtractUtilsModule
from extract_utils.tools import android_root


class QTIComponentType(str, Enum):
    SYSTEM = 'system'
    VENDOR = 'vendor'


class ExtractUtilsQTIModule(ExtractUtilsModule):
    def __init__(
        self,
        component: str,
        component_type: QTIComponentType,
        blob_fixups: Optional[blob_fixups_user_type] = None,
        lib_fixups: Optional[lib_fixups_user_type] = None,
        namespace_imports: Optional[List[str]] = None,
        check_elf=True,
    ):
        self.component_type = component_type
        self.component = component
        self.device = component.split('/')[0]
        self.vendor = 'qcom'
        self.device_rel_path = path.join(
            'device', self.vendor, 'common', component_type, component
        )

        super().__init__(
            device=self.device,
            vendor=self.vendor,
            device_rel_path=self.device_rel_path,
            blob_fixups=blob_fixups,
            lib_fixups=lib_fixups,
            namespace_imports=namespace_imports,
            check_elf=check_elf,
        )

        self.vendor_rel_path = path.join(
            'vendor', self.vendor, 'common', component_type, component
        )
        self.vendor_path = path.join(android_root, self.vendor_rel_path)
