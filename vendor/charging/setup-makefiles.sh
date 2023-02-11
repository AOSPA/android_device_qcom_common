#!/bin/bash

set -e

# Required!
export COMPONENT=charging
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
