#!/bin/bash

set -e

# Required!
export COMPONENT=perf-legacy
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
