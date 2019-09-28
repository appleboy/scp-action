#!/bin/sh

set -eu

export GITHUB="true"

[ -n "$INPUT_STRIP_COMPONENTS" ] && export INPUT_STRIP_COMPONENTS=$((INPUT_STRIP_COMPONENTS + 0))

sh -c "/bin/drone-scp $*"
