#!/bin/bash
# Generates or updates golden files under test/goldens/.
# Run from project root: ./scripts/update_goldens.sh

SCRIPT_PATH="$(cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1; pwd -P)"
PROJECT_ROOT="$(cd "$SCRIPT_PATH/.." && pwd -P)"

cd "$PROJECT_ROOT" || exit 1
fvm flutter test test/golden/ --update-goldens
