import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadMaterialFonts();
  return testMain();
}

Future<void> _loadMaterialFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) {
    throw StateError('FLUTTER_ROOT is not set. Run tests with `fvm flutter test`.');
  }

  final fontsDir = '$flutterRoot/bin/cache/artifacts/material_fonts';
  await Future.wait([
    _loadFont('Roboto', [
      '$fontsDir/Roboto-Regular.ttf',
      '$fontsDir/Roboto-Medium.ttf',
      '$fontsDir/Roboto-Bold.ttf',
      '$fontsDir/Roboto-Black.ttf',
      '$fontsDir/Roboto-Light.ttf',
      '$fontsDir/Roboto-Thin.ttf',
      '$fontsDir/Roboto-Italic.ttf',
      '$fontsDir/Roboto-MediumItalic.ttf',
      '$fontsDir/Roboto-BoldItalic.ttf',
    ]),
    _loadFont('MaterialIcons', ['$fontsDir/MaterialIcons-Regular.otf']),
  ]);
}

Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    final file = File(path);
    if (file.existsSync()) {
      final bytes = file.readAsBytesSync();
      loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    }
  }
  await loader.load();
}
