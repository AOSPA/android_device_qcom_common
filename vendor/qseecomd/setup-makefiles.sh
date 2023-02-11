#!/bin/bash

set -e

# Required!
export COMPONENT=qseecomd
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
