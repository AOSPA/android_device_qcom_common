#!/bin/bash

set -e

# Required!
export COMPONENT=adreno
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
