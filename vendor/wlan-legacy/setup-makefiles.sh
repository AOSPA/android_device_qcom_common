#!/bin/bash

set -e

# Required!
export COMPONENT=wlan-legacy
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
