#
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from __future__ import annotations

from enum import Enum
from os import path
from typing import List, Optional

from extract_utils.extract import extract_fns_user_type
from extract_utils.fixups_blob import blob_fixups_user_type
from extract_utils.fixups_lib import lib_fixups_user_type
from extract_utils.makefiles import (
    MakefilesCtx,
    write_mk_guard_begin,
    write_mk_guard_end,
    write_mk_header,
    write_mk_local_path,
)
from extract_utils.module import ExtractUtilsModule
from extract_utils.tools import android_root


class QTIComponentType(str, Enum):
    SYSTEM = 'system'
    VENDOR = 'vendor'


class ExtractUtilsQTIModule(ExtractUtilsModule):
    """
    Extension of ExtractUtilsModule for handling Qualcomm components.
    Supports both system and vendor components with their specific directory structures.
    """

    def __init__(
        self,
        component: str,
        component_type: QTIComponentType,
        vendor: str = 'qcom',
        device_rel_path: Optional[str] = None,
        blob_fixups: Optional[blob_fixups_user_type] = None,
        lib_fixups: Optional[lib_fixups_user_type] = None,
        namespace_imports: Optional[List[str]] = None,
        extract_fns: Optional[extract_fns_user_type] = None,
        check_elf: bool = True,
        add_firmware_proprietary_file: bool = False,
        add_factory_proprietary_file: bool = False,
        add_generated_carriersettings: bool = False,
    ):
        self.component_type = component_type
        self.component = component
        self.base_component = component.split('/')[0]

        # Set up paths according to QTI structure
        if device_rel_path is None:
            device_rel_path = path.join(
                'device', vendor, 'common', component_type, component
            )

        # Initialize base class
        super().__init__(
            device=self.base_component,
            vendor=vendor,
            device_rel_path=device_rel_path,
            blob_fixups=blob_fixups,
            lib_fixups=lib_fixups,
            namespace_imports=namespace_imports,
            extract_fns=extract_fns,
            check_elf=check_elf,
            add_firmware_proprietary_file=add_firmware_proprietary_file,
            add_factory_proprietary_file=add_factory_proprietary_file,
            add_generated_carriersettings=add_generated_carriersettings,
            skip_main_proprietary_file=True,
        )

        # Override vendor paths for QTI components
        self.vendor_rel_path = path.join(
            'vendor', vendor, 'common', component_type, component
        )
        self.vendor_path = path.join(android_root, self.vendor_rel_path)

        # Add proprietary files for this component
        self.add_proprietary_file('proprietary-files.txt')

    def write_makefiles(self, legacy: bool, extract_factory: bool):
        """Write Android.bp, Android.mk and other makefiles with QTI-specific guards."""
        with MakefilesCtx.from_paths(
            legacy,
            path.join(self.vendor_path, 'Android.bp'),
            path.join(self.vendor_path, 'Android.mk'),
            path.join(self.vendor_path, f'{self.device}-vendor.mk'),
            path.join(self.vendor_path, 'BoardConfigVendor.mk'),
        ) as ctx:
            # Write the headers and LOCAL_PATH
            write_mk_header(ctx.mk_out)
            write_mk_local_path(ctx.mk_out)

            # Add QTI component guard
            write_mk_guard_begin(
                'TARGET_COMMON_QTI_COMPONENTS',
                self.component,
                ctx.mk_out,
                invert=True,
            )

            super().write_makefiles(legacy, extract_factory)

            write_mk_guard_end(ctx.mk_out)
