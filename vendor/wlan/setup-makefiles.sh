#!/bin/bash

set -e

# Required!
export COMPONENT=wlan
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
