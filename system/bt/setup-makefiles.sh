#!/bin/bash

set -e

# Required!
export COMPONENT=bt
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
