#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from enum import Enum
from os import path
from typing import List, Optional

from extract_utils.file import FileArgs
from extract_utils.fixups import fixups_user_type
from extract_utils.main import ExtractUtils
from extract_utils.makefiles import (
    MakefilesCtx,
    write_bp_header,
    write_bp_soong_namespaces,
    write_mk_guard_begin,
    write_mk_guard_end,
    write_mk_soong_namespace,
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
        blob_fixups: Optional[fixups_user_type] = None,
        lib_fixups: Optional[fixups_user_type] = None,
        namespace_imports: Optional[List[str]] = None,
        extract_fns: Optional[fixups_user_type] = None,
        check_elf: bool = False,
    ):
        self.component_type = component_type
        self.component = component

        # Set up paths according to QTI structure
        if device_rel_path is None:
            device_rel_path = path.join(
                'device', vendor, 'common', component_type, component
            )

        # Initialize base class
        super().__init__(
            device=component,
            vendor=vendor,
            device_rel_path=device_rel_path,
            blob_fixups=blob_fixups,
            lib_fixups=lib_fixups,
            namespace_imports=namespace_imports,
            extract_fns=extract_fns,
            check_elf=check_elf,
            skip_main_proprietary_file=True,
        )

        # Override vendor paths for QTI components
        self.vendor_rel_path = path.join(
            'vendor', vendor, 'common', component_type, component
        )
        self.vendor_path = path.join(android_root, self.vendor_rel_path)

        # Add proprietary files
        self.add_proprietary_file('proprietary-files.txt')

    def write_makefiles(self, legacy: bool):
        """
        Write Android.bp, Android.mk and other makefiles with QTI-specific guards.
        """
        bp_path = path.join(self.vendor_path, 'Android.bp')
        mk_path = path.join(self.vendor_path, 'Android.mk')
        product_mk_path = path.join(
            self.vendor_path, f'{self.device}-vendor.mk'
        )
        board_config_mk_path = path.join(
            self.vendor_path, 'BoardConfigVendor.mk'
        )

        with MakefilesCtx.from_paths(
            legacy,
            bp_path,
            mk_path,
            product_mk_path,
            board_config_mk_path,
        ) as ctx:
            # Write headers and namespaces
            write_bp_header(ctx.bp_out)
            write_bp_soong_namespaces(ctx, self.namespace_imports)
            write_mk_soong_namespace(self.vendor_rel_path, ctx.product_mk_out)

            # Add QTI component guard
            write_mk_guard_begin(
                'TARGET_COMMON_QTI_COMPONENTS',
                self.component,
                ctx.mk_out,
                invert=True,
            )

            # Write makefiles for all proprietary files
            for proprietary_file in self.proprietary_files:
                proprietary_file.write_makefiles(self, ctx)

            write_mk_guard_end(ctx.mk_out)
