#!/bin/bash

# Prints the Dart files that the format scripts work on: the app's own code.
# - lib/generated/ is skipped because it is not committed and build_runner does not format it;
# - tools/ and packages/ are separate packages whose formatting depends on how they are resolved.
# Run from the project root.
find lib test -name '*.dart' -not -path 'lib/generated/*'
