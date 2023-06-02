#!/bin/bash

set -eo pipefail

export PYTHONHOME="$(dirname @PYTHON_INTERPRETER_PATH@)/.."
export PYTHONPATH="$PWD:@PYTHONPATH@"
export PATH="@PYTHON_INTERPRETER_PATH@:$PATH"
export LD_LIBRARY_PATH="@LD_LIBRARY_PATH@"

exec @APP@ "$@"
