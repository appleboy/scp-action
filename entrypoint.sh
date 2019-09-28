#!/bin/sh

set -eu

export GITHUB="true"

[ -n "$INPUT_STRIP_COMPONENTS" ] && export INPUT_STRIP_COMPONENTS=$((INPUT_STRIP_COMPONENTS + 0))
echo $INPUT_STRIP_COMPONENTS
sh -c "/bin/drone-scp $*"
