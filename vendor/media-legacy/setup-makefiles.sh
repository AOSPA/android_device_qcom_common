#!/bin/bash

set -e

# Required!
export COMPONENT=media-legacy
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
