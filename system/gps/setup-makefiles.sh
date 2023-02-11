#!/bin/bash

set -e

# Required!
export COMPONENT=gps
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
