#
# SPDX-FileCopyrightText: 2024 Paranoid Android
# SPDX-License-Identifier: Apache-2.0
#

from os import remove
from shutil import move
from typing import Self

from extract_utils.file import File
from extract_utils.fixups_blob import BlobFixupCtx, blob_fixup
from extract_utils.utils import run_cmd


class blob_fixup_qti(blob_fixup):
    def __init__(self):
        super().__init__()

    def zipalign_impl(
        self,
        ctx: BlobFixupCtx,
        file: File,
        file_path: str,
        *args,
        **kwargs,
    ):
        tmp_path = file_path + '.tmp'
        move(file_path, tmp_path)
        try:
            run_cmd(['zipalign', '-p', '-f', '4', tmp_path, file_path])
        finally:
            remove(tmp_path)

    def zipalign(self) -> Self:
        return self.call(self.zipalign_impl)
