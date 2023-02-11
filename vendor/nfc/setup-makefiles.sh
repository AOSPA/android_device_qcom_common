#!/bin/bash

set -e

# Required!
export COMPONENT=nfc
export VENDOR=qcom/common/vendor

"../setup-makefiles.sh" "$@"
