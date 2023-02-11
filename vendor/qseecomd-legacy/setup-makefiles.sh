#!/bin/bash

set -e

# Required!
export COMPONENT=qseecomd-legacy
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
