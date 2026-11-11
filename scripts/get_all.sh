#!/bin/bash

# Full setup after cloning: clean, dependencies, code generation, pods, icons, splash, format.
# Usage: ./scripts/get_all.sh [--useFvm] [--arch86To64]

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1; pwd -P )"
PROJECT_ROOT="$( cd "$SCRIPT_PATH/.." && pwd -P )"
FVM=''
ARCH=''
FVM_SUFFIX=''

getAll() {
    cd "$PROJECT_ROOT" || exit 1

    EXIT_STATUS=0

    echo "⏳ Cleaning..."
    cd "$PROJECT_ROOT"
    $FVM flutter clean || EXIT_STATUS=$?
    if [ $EXIT_STATUS -ne 0 ]; then
        echo "⛔️ Error: exit with $EXIT_STATUS for ./lib"
        exit $EXIT_STATUS
    fi
    echo "✅ Cleaning completed"

    echo "⏳ Downloading deps for ./lib ..."
    cd "$PROJECT_ROOT"
    $FVM flutter pub get || EXIT_STATUS=$?
    $FVM flutter pub run build_runner build --delete-conflicting-outputs || EXIT_STATUS=$?
    if [ $EXIT_STATUS -ne 0 ]; then
        echo "⛔️ Error: exit with $EXIT_STATUS for ./lib"
        exit $EXIT_STATUS
    fi
    echo "✅ Deps for ./lib downloaded"

    echo "✅ Installing pods..."
    cd ios
    $ARCH pod install --repo-update
    cd ..
    echo "✅ Pods installed"

    echo "🖼️ Generating icon resource constants..."
    cd "$PROJECT_ROOT"
    "$SCRIPT_PATH"/generate_icons.sh$FVM_SUFFIX || EXIT_STATUS=$?

    echo "🖼️ Generating splash screen..."
    cd "$PROJECT_ROOT"
    $FVM dart run flutter_native_splash:create --path=./flutter_native_splash.yaml || EXIT_STATUS=$?

    cd "$PROJECT_ROOT"
    "$SCRIPT_PATH"/code_format.sh$FVM_SUFFIX || EXIT_STATUS=$?

    echo "Exiting with exit status $EXIT_STATUS"
    exit $EXIT_STATUS
}

case $1 in
    --useFvm)
        FVM='fvm'
        FVM_SUFFIX=' --useFvm'
        ;;
    *)  
        ;;
esac

case $2 in
    --arch86To64)
        ARCH='arch -x86_64'
        ;;
    *)  
        ;;
esac

getAll
