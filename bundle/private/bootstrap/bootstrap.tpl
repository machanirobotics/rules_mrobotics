#!/bin/bash

set -eo pipefail

PYTHON_INTERPRETER_PATH=@PYTHON_INTERPRETER_PATH@
if [ ! -z "$PYTHON_INTERPRETER_PATH" ]; then
    export PYTHONHOME="$(dirname @PYTHON_INTERPRETER_PATH@)/.."
fi
export PYTHONPATH="$PWD:@PYTHONPATH@"
export PATH="@PYTHON_INTERPRETER_PATH@:$PATH"
export LD_LIBRARY_PATH="@LD_LIBRARY_PATH@"

exec @APP@ "$@"
