#!/bin/bash
set -e

# Root directory containing features
FEATURES_DIR="lib/features"
L10N_DELEGATES_FILE="lib/app/l10n_delegates.dart"

# Arrays to store feature information
declare -a FEATURE_NAMES
declare -a OUTPUT_CLASSES
declare -a FILE_PATHS

# Collect all l10n directories: app layer first, then features
L10N_DIRS=()
# App layer l10n (lib/app/l10n)
if [ -d "lib/app/l10n" ] && [ -f "lib/app/l10n/en.arb" ]; then
  L10N_DIRS+=("lib/app/l10n")
fi
# Feature l10n (lib/features/*/l10n)
while IFS= read -r -d '' L10N_DIR; do
  L10N_DIRS+=("$L10N_DIR")
done < <(find "$FEATURES_DIR" -type d -name "l10n" -print0)

# Sort L10N_DIRS alphabetically (app, otp, settings, shared, theme)
IFS=$'\n' L10N_DIRS=($(sort <<<"${L10N_DIRS[*]}"))
unset IFS

# Loop through all collected l10n directories
for L10N_DIR in "${L10N_DIRS[@]}"; do
  echo "🔍 Found l10n directory: $L10N_DIR"

  # Determine the feature/app name: for lib/app/l10n -> "app", for lib/features/X/l10n -> "X"
  if [[ "$L10N_DIR" == lib/app/* ]]; then
    FEATURE_NAME="app"
  else
    FEATURE_NAME=$(basename "$(dirname "$L10N_DIR")")
  fi

  # Set the expected template ARB file (you can modify this if needed)
  TEMPLATE_FILE="$L10N_DIR/en.arb"

  if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "⚠️ Skipping $L10N_DIR — no en.arb found."
    continue
  fi

  OUTPUT_FILE_NAME="${FEATURE_NAME}_localizations.dart"
  OUTPUT_CLASS="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}Localizations"

  echo "🚀 Generating localizations for $FEATURE_NAME..."
  fvm flutter gen-l10n \
    --arb-dir "$L10N_DIR" \
    --template-arb-file "en.arb" \
    --output-localization-file "$OUTPUT_FILE_NAME" \
    --output-class "$OUTPUT_CLASS"

  # Append Flutter extension to the generated file

  EXTENSION="
extension L10nUtils on BuildContext {
  $OUTPUT_CLASS get l10n => $OUTPUT_CLASS.of(this)!;
}"
  OUTPUT_FILE_PATH="$L10N_DIR/$OUTPUT_FILE_NAME"

  echo "$EXTENSION" >> "$OUTPUT_FILE_PATH"
  echo "✨ Added BuildContext extension to $OUTPUT_FILE_PATH"
  
  # Store feature info for delegates file generation
  FEATURE_NAMES+=("$FEATURE_NAME")
  OUTPUT_CLASSES+=("$OUTPUT_CLASS")
  FILE_PATHS+=("$OUTPUT_FILE_PATH")
  echo
done

# Generate l10n_delegates.dart
echo "📝 Generating l10n_delegates.dart..."
echo "//THIS FILE IS AUTO-GENERATED. DO NOT EDIT." > "$L10N_DELEGATES_FILE"

# Add imports for each feature
for i in "${!FILE_PATHS[@]}"; do
  FILE_PATH="${FILE_PATHS[$i]}"
  # Convert file path to package import path
  IMPORT_PATH=$(echo "$FILE_PATH" | sed 's|^lib/|package:app_core/|')
  echo "import '$IMPORT_PATH';" >> "$L10N_DELEGATES_FILE"
done

cat >> "$L10N_DELEGATES_FILE" << 'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
EOF

# Add constants and delegates list
cat >> "$L10N_DELEGATES_FILE" << 'EOF'

const supportedLocales = [Locale('en')];

const localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
EOF

# Add feature delegates
for OUTPUT_CLASS in "${OUTPUT_CLASSES[@]}"; do
  echo "  $OUTPUT_CLASS.delegate," >> "$L10N_DELEGATES_FILE"
done

# Close the delegates list
cat >> "$L10N_DELEGATES_FILE" << 'EOF'
];
EOF

echo "✨ Generated $L10N_DELEGATES_FILE"
echo "🎉 All localization files generated successfully!"
