#!/bin/bash

set -e

# Required!
export COMPONENT=wfd-legacy
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
