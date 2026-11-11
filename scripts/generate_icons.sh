#!/bin/bash

# Generates the AppImages class: one constant per file in assets/icons and assets/images.
# Usage: ./scripts/generate_icons.sh [--useFvm]

set -eo pipefail

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit 1; pwd -P )"
OUTPUT_FILE="lib/utils/app_images.dart"
FVM=''
if [ "$1" = "--useFvm" ]; then
    FVM='fvm'
fi

cd "$SCRIPT_PATH/.."

# Patterns with no matches expand to nothing instead of staying as literal text.
shopt -s nullglob

CONSTANTS=''
for directory in assets/icons assets/images; do
    for filePath in "$directory"/*.png "$directory"/*.svg "$directory"/*.jpg; do
        fileName=$(basename "$filePath")
        attributeName=$(echo "${fileName%.*}" | perl -nE 'say lcfirst join "", map {ucfirst lc} split /[^[:alnum:]]+/')
        echo "Generated constant $attributeName for $filePath"
        CONSTANTS+="  static const String $attributeName = '$filePath';"$'\n'
    done
done

if [ -z "$CONSTANTS" ]; then
    echo "No images in assets/icons or assets/images, nothing to generate"
    rm -f "$OUTPUT_FILE"
    exit 0
fi

printf '// GENERATED CODE - DO NOT MODIFY BY HAND\n\nclass AppImages {\n%s}\n' "$CONSTANTS" > "$OUTPUT_FILE"
$FVM dart format -l 120 "$OUTPUT_FILE"
echo "✅ Generated $OUTPUT_FILE"
