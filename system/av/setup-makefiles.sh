#!/bin/bash

set -e

# Required!
export COMPONENT=av
export VENDOR=qcom/common/system

"../setup-makefiles.sh" "$@"
