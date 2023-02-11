#!/bin/bash

set -e

# Required!
export COMPONENT=keymaster
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
