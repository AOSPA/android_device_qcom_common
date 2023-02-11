#!/bin/bash

set -e

# Required!
export COMPONENT=media
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
