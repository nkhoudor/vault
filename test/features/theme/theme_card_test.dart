import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/theme_picker/widgets/theme_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const names = {
    AppTheme.cobalt: 'Cobalt',
    AppTheme.lavender: 'Lavender',
    AppTheme.mint: 'Mint',
    AppTheme.clay: 'Clay',
    AppTheme.honey: 'Honey',
    AppTheme.rose: 'Rose',
    AppTheme.glacier: 'Glacier',
    AppTheme.graphite: 'Graphite',
  };

  for (final theme in AppTheme.values) {
    testWidgets('${theme.name} is shown as "${names[theme]}"', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: localizationsDelegates,
          home: Center(
            child: SizedBox(
              width: 200,
              height: 250,
              child: ThemeCard(appTheme: theme, isSelected: false, onTap: () {}),
            ),
          ),
        ),
      );

      expect(find.text(names[theme]!), findsOneWidget);
    });
  }
}
