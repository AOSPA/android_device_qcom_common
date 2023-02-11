#!/bin/bash

set -e

# Required!
export COMPONENT=perf
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
