# Copyright (C) 2021 Paranoid Android
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

target=`getprop ro.board.platform`

case "$target" in
    "msm8937" | "msm8953" | "msm8998" | "qcs605" | "sdm660" | "sdm710" | "sdm845")
        setprop ctl.stop iop-hal-2-0
        ;;
esac
