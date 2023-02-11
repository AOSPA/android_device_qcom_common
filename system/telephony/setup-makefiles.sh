#!/bin/bash

set -e

# Required!
export COMPONENT=telephony
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
