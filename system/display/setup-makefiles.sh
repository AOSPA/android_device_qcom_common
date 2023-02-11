#!/bin/bash

set -e

# Required!
export COMPONENT=display
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
