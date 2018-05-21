#!/bin/bash
# Copyright (c) 2018, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE US

# This file is used to generate blueprint/makefiles for the vendor hals

function generate_make_files() {
    local dir_path="$ANDROID_BUILD_TOP/$1"
    pushd $dir_path > /dev/null

    # Due to same package name in different folders we need to detect
    # opensource case so that it can be handled.
    local flag_opensource=false
    if echo "$dir_path" | grep "opensource" > /dev/null;then
        flag_opensource=true
    fi

    # Search for all HAL files in given dir.
    local halFilePaths=`echo $(find -iname "*.hal" | sort)`

    #Store package name in below array to create a unique set so that we trigger
    #hidl-gen only once  for a given package.
    package_collection=()

    #Iterate over identified .hal Paths
    local prev_path=""
    for file in $halFilePaths; do
        local hal_path=`echo "$file" | rev | cut -d"/" -f2- | rev`
        if [ -e "$hal_path/Android.bp" ] && [ ! -e "$hal_path/.hidl-autogen" ]; then
            if [ ! "$hal_path" = "$prev_path" ]; then
                echo "Skipping hidl-gen on $1/$hal_path as Android.bp is not compile-time generated"
                prev_path="$hal_path"
            fi
            continue;
        fi
        prev_path="$hal_path"

        # Find out package name from HAL file
        local hal_package=`echo $(cat $file | grep -E -m 1 "^package ") | cut -d' ' -f2`

        # Get rid of extra delimter
        hal_package=${hal_package%?}

        #Check if we already executed hidl-gen for a given package
        if echo "${package_collection[@]}" | grep $hal_package > /dev/null; then
            continue;
        else
            package_collection+=($hal_package)
            local delimeter=`echo "$file" | cut -d'/' -f2`
            local root=`echo "$hal_package" | sed "s/$delimeter/#/g" | cut -d'#' -f1`
            #Identify Package Root
            root=${root%?}
            #Create root arguments for hidl-command
            local root_arguments="-r $root:$1 -r  $2"
        fi

        local hal_path2=$1;
        #Handling for opensource HAL to solve package name conflict
        if [ "$flag_opensource" = true ]; then
            root="$root.$delimeter"
            hal_path2="$hal_path2/$delimeter"
        fi

        local root_arguments="-r $root:$hal_path2 -r  $2"

        update_check=0
        if [ -e "$hal_path/Android.bp" ]; then
            mv $hal_path/Android.bp $hal_path/.hidl-autogen
            update_check=1
        fi

        echo -n "Running hidl-gen on $hal_package: "
        hidl-gen -Landroidbp $root_arguments $hal_package;

        if [ "$update_check" -eq 1 ]; then
            diff -q $hal_path/Android.bp $hal_path/.hidl-autogen > /dev/null
            if [ $? -eq 0 ]; then
                echo "no changes"
                mv $hal_path/.hidl-autogen $hal_path/Android.bp
            else
                echo "updated"
            fi
        else
            echo "created"
        fi
        touch $hal_path/.hidl-autogen

        #TODO: we need to enable this once all HAL's are in proper format
        #    rc=$?; if [[ $rc != 0 ]]; then return $rc; fi
    done
    popd > /dev/null
}

function start_script_for_interfaces {
    #Find interfaces in workspace
    local interfaces=$(ls -d ${ANDROID_BUILD_TOP}/vendor/qcom/*/interfaces)

    echo "HIDL interfaces:  Scanning for changes..."
    for interface in $interfaces; do
        #generate interfaces
        local relative_interface=${interface#${ANDROID_BUILD_TOP}/}
        generate_make_files $relative_interface "android.hidl:system/libhidl/transport"
    done
    echo "HIDL interfaces:  Update complete."
}

#Start script for interfaces
start_script_for_interfaces

