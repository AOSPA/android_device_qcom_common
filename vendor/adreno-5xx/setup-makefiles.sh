#!/bin/bash

set -e

# Required!
export COMPONENT=adreno-5xx
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
