#!/usr/bin/env -S PYTHONPATH=../../:../../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from os import remove
from shutil import move

from extract_utils.file import File
from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import ExtractUtils
from extract_utils.utils import run_cmd

from extract_utils_qti.module import ExtractUtilsQTIModule, QTIComponentType


def blob_fixup_zipalign(
    ctx: BlobFixupCtx,
    file: File,
    file_path: str,
    *args,
    **kargs,
):
    tmp_path = file_path + '.tmp'
    move(file_path, tmp_path)
    try:
        run_cmd(['zipalign', '-p', '-f', '4', tmp_path, file_path])
    finally:
        remove(tmp_path)


blob_fixups: blob_fixups_user_type = {
    'system/framework/QXPerformance.jar': blob_fixup()
        .call(blob_fixup_zipalign),
}  # fmt: skip

module = ExtractUtilsQTIModule(
    'perf',
    QTIComponentType.SYSTEM,
    blob_fixups=blob_fixups,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
