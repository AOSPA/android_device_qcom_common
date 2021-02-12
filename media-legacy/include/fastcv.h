/*
 * Copyright (c) 2020, The Linux Foundation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef FASTCV_H
#define FASTCV_H

#define FASTCV_API

typedef enum {
  FASTCV_OP_LOW_POWER = 0,
  FASTCV_OP_CPU_PERFORMANCE = 3
} fcvOperationMode;

typedef enum {
  FASTCV_FLIP_HORIZ = 1,
  FASTCV_FLIP_VERT = 2,
  FASTCV_FLIP_BOTH = 3
} fcvFlipDir;

extern "C" {
FASTCV_API void fcvFlipu8(const uint8_t *src, uint32_t srcWidth,
                          uint32_t srcHeight, uint32_t srcStride, uint8_t *dst,
                          uint32_t dstStride, fcvFlipDir dir);

FASTCV_API void fcvFlipu16(const uint16_t *src, uint32_t srcWidth,
                           uint32_t srcHeight, uint32_t srcStride,
                           uint16_t *dst, uint32_t dstStride, fcvFlipDir dir);

FASTCV_API int fcvSetOperationMode(fcvOperationMode mode);

FASTCV_API void fcvCleanUp(void);

FASTCV_API void fcvMemInit(void);

FASTCV_API void fcvMemDeInit(void);
}

#endif
