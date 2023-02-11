#!/bin/bash

set -e

# Required!
export COMPONENT=perf
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
