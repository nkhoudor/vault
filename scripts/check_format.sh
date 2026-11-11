#!/bin/bash

# Fails if the app code is not formatted. Changes nothing.
# Usage: ./scripts/check_format.sh [--useFvm]

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1; pwd -P )"
FVM=''
if [ "$1" = "--useFvm" ]; then
    FVM='fvm'
fi

cd "$SCRIPT_PATH/.." || exit 1

echo "⏳ Checking code format..."
# shellcheck disable=SC2046
if ! $FVM dart format --set-exit-if-changed --output=none -l 120 $("$SCRIPT_PATH"/dart_files.sh); then
    echo "⛔️ Error: the files listed above are not formatted. Run ./scripts/code_format.sh"
    exit 1
fi
echo "✅ Code format checked"
