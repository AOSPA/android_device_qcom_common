#!/bin/bash

set -e

# Required!
export COMPONENT=adreno-6xx-legacy
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
