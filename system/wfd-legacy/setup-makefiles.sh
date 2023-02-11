#!/bin/bash

set -e

# Required!
export COMPONENT=wfd-legacy
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
