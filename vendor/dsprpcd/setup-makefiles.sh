#!/bin/bash

set -e

# Required!
export COMPONENT=dsprpcd
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
