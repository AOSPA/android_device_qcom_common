#!/bin/bash

set -e

# Required!
export COMPONENT=audio
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
