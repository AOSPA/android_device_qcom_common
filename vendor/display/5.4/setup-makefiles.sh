#!/bin/bash

set -e

# Required!
export COMPONENT=display
export VENDOR=qcom/common/vendor
export KERNEL_VERSION=5.4

"../../setup-makefiles.sh" "$@"
