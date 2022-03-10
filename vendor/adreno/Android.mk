# Copyright (C) 2022 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This Android.mk is included regardless of device using adreno or adreno-legacy
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib/egl && pushd $(TARGET_OUT_VENDOR)/lib > /dev/null && ln -s egl/libEGL_adreno.so libEGL_adreno.so && popd > /dev/null)
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib/egl && pushd $(TARGET_OUT_VENDOR)/lib > /dev/null && ln -s egl/libGLESv2_adreno.so libGLESv2_adreno.so && popd > /dev/null)
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib/egl && pushd $(TARGET_OUT_VENDOR)/lib > /dev/null && ln -s egl/libq3dtools_adreno.so libq3dtools_adreno.so && popd > /dev/null)
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib64/egl && pushd $(TARGET_OUT_VENDOR)/lib64 > /dev/null && ln -s egl/libEGL_adreno.so libEGL_adreno.so && popd > /dev/null)
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib64/egl && pushd $(TARGET_OUT_VENDOR)/lib64 > /dev/null && ln -s egl/libGLESv2_adreno.so libGLESv2_adreno.so && popd > /dev/null)
$(shell mkdir -p $(TARGET_OUT_VENDOR)/lib64/egl && pushd $(TARGET_OUT_VENDOR)/lib64 > /dev/null && ln -s egl/libq3dtools_adreno.so libq3dtools_adreno.so && popd > /dev/null)
