#!/bin/bash
# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export COMPONENT=display
export VENDOR=qcom/common/system

"../extract-files.sh" "$@"
