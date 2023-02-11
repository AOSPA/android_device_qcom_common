#!/bin/bash

set -e

# Required!
export COMPONENT=display
export VENDOR=qcom/common/vendor
export KERNEL_VERSION=4.19

"../../setup-makefiles.sh" "$@"
