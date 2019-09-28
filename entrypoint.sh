#!/bin/sh

set -eu

export GITHUB="true"

[ -n "$INPUT_TIMEOUT" ] && export INPUT_TIMEOUT="30s"
[ -n "$INPUT_COMMAND_TIMEOUT" ] && export INPUT_COMMAND_TIMEOUT="1m"

sh -c "/bin/drone-scp $*"
