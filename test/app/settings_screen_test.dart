import 'package:app_core/app/app.dart';
import 'package:app_core/di/app_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('the settings fit a phone held sideways', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view
      ..physicalSize = const Size(667, 375)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await DI.configureDependencies();

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Print backup sheet'), 100);
    expect(find.text('Print backup sheet'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });
}
