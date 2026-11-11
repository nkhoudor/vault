import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_list_item.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double ring(WidgetTester tester) =>
      tester.widget<CircularProgressIndicator>(find.byType(CircularProgressIndicator)).value!;

  Future<void> pumpItem(WidgetTester tester, {required DateTime createdAt, required DateTime expiresAt}) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpListItem(
              otp: OtpDisplayable(id: 'id', name: 'GitHub', code: '123456', createdAt: createdAt, expiresAt: expiresAt),
              onTap: () {},
            ),
          ),
        ),
      );

  testWidgets('the ring starts at the share of the period that is left and empties as it runs out', (tester) async {
    final now = clock.now();
    await pumpItem(
      tester,
      createdAt: now.subtract(const Duration(seconds: 20)),
      expiresAt: now.add(const Duration(seconds: 10)),
    );
    expect(ring(tester), closeTo(1 / 3, 0.001));

    await tester.pump(const Duration(seconds: 5));
    expect(ring(tester), closeTo(1 / 6, 0.001));

    await tester.pump(const Duration(seconds: 5));
    expect(ring(tester), 0);
  });

  testWidgets('the ring fills again when the next code arrives', (tester) async {
    final now = clock.now();
    final expiresAt = now.add(const Duration(seconds: 10));
    await pumpItem(tester, createdAt: now.subtract(const Duration(seconds: 20)), expiresAt: expiresAt);
    await tester.pump(const Duration(seconds: 10));

    await pumpItem(tester, createdAt: expiresAt, expiresAt: expiresAt.add(const Duration(seconds: 30)));

    expect(ring(tester), 1);
  });

  testWidgets('the ring is empty for a code that has already expired', (tester) async {
    final now = clock.now();
    await pumpItem(
      tester,
      createdAt: now.subtract(const Duration(seconds: 40)),
      expiresAt: now.subtract(const Duration(seconds: 10)),
    );

    expect(ring(tester), 0);
  });
}
