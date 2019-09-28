#!/bin/sh

set -eu

export GITHUB="true"

[ -z "$INPUT_TIMEOUT" ] && export INPUT_TIMEOUT="30s"
[ -z "$INPUT_COMMAND_TIMEOUT" ] && export INPUT_COMMAND_TIMEOUT="1m"

sh -c "/bin/drone-scp $*"
