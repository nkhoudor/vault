#!/bin/bash

# Formats the app code.
# Usage: ./scripts/code_format.sh [--useFvm]

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1; pwd -P )"
FVM=''
if [ "$1" = "--useFvm" ]; then
    FVM='fvm'
fi

cd "$SCRIPT_PATH/.." || exit 1

echo "⏳ Code formatting..."
# shellcheck disable=SC2046
if ! $FVM dart format -l 120 $("$SCRIPT_PATH"/dart_files.sh); then
    echo "⛔️ Error: can not format code"
    exit 1
fi
echo "✅ Code formatted"
