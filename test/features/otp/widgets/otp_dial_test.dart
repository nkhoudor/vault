import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_dial.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2020, 1, 1, 12);

  OtpDisplayable otp({String id = 'id', String account = '', DateTime? from}) => OtpDisplayable(
    id: id,
    name: 'GitHub',
    account: account,
    code: '123456',
    createdAt: from ?? createdAt,
    expiresAt: (from ?? createdAt).add(const Duration(seconds: 30)),
  );

  Widget app(OtpDisplayable otp, {VoidCallback? onTap}) => MaterialApp(
    localizationsDelegates: localizationsDelegates,
    supportedLocales: supportedLocales,
    home: Scaffold(
      body: OtpDial(otp: otp, onTap: onTap ?? () {}),
    ),
  );

  double ringValue(WidgetTester tester) =>
      tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator)).value!;

  testWidgets('shows the share of the lifetime that is left', (tester) async {
    await withClock(Clock.fixed(createdAt.add(const Duration(seconds: 12))), () async {
      await tester.pumpWidget(app(otp()));
    });

    expect(ringValue(tester), closeTo(0.6, 0.001));

    await tester.pump(const Duration(seconds: 9));

    expect(ringValue(tester), closeTo(0.3, 0.001));
  });

  Color ringColor(WidgetTester tester) =>
      tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator)).color!;

  ColorScheme colorSchemeOf(WidgetTester tester) => Theme.of(tester.element(find.byType(OtpDial))).colorScheme;

  testWidgets('the whole ring lights up over 300 ms when the next code starts', (tester) async {
    final next = createdAt.add(const Duration(seconds: 30));
    await withClock(Clock.fixed(next), () async {
      await tester.pumpWidget(app(otp()));
      await tester.pumpWidget(app(otp(from: next)));
    });

    final colorScheme = colorSchemeOf(tester);
    expect(ringValue(tester), 1);
    expect(ringColor(tester), colorScheme.surfaceContainerHigh);

    await tester.pump(const Duration(milliseconds: 150));
    expect(ringColor(tester), isNot(colorScheme.surfaceContainerHigh));
    expect(ringColor(tester), isNot(colorScheme.primary));

    await tester.pump(const Duration(milliseconds: 150));
    expect(ringColor(tester), colorScheme.primary);
  });

  testWidgets('the ring is lit at once when another account is shown', (tester) async {
    await withClock(Clock.fixed(createdAt), () async {
      await tester.pumpWidget(app(otp()));
      await tester.pumpWidget(app(otp(id: 'other', from: createdAt.add(const Duration(seconds: 1)))));
    });

    expect(ringColor(tester), colorSchemeOf(tester).primary);
  });

  testWidgets('is empty once the code has run out', (tester) async {
    await withClock(Clock.fixed(createdAt.add(const Duration(minutes: 1))), () async {
      await tester.pumpWidget(app(otp()));
    });

    expect(ringValue(tester), 0);
  });

  testWidgets('shows the account under the ring when there is one', (tester) async {
    await tester.pumpWidget(app(otp(account: 'work@example.com')));

    expect(find.text('GitHub'), findsOneWidget);
    expect(find.text('work@example.com'), findsOneWidget);
  });

  testWidgets('reports a tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(app(otp(), onTap: () => taps++));

    await tester.tap(find.text('GitHub'));

    expect(taps, 1);
  });
}
