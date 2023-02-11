#!/bin/bash

set -e

# Required!
export COMPONENT=media-5.4
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
