import 'package:app_core/app/app.dart';
import 'package:app_core/di/app_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('starts on a device whose language the app is not translated into', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.platformDispatcher
      ..localeTestValue = const Locale('ru', 'RU')
      ..localesTestValue = const [Locale('ru', 'RU')];
    addTearDown(tester.platformDispatcher.clearLocaleTestValue);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await DI.configureDependencies();

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Vault'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
