#!/bin/bash

set -e

# Required!
export COMPONENT=wfd
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
