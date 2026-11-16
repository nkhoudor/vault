import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/l10n/theme_localizations.dart';
import 'package:app_core/features/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';

/// A small preview of [appTheme] in its own colors, with its name.
class ThemeCard extends StatelessWidget {
  const ThemeCard({required this.appTheme, required this.isSelected, required this.onTap, super.key});

  final AppTheme appTheme;
  final bool isSelected;
  final VoidCallback onTap;

  String _name(ThemeLocalizations l10n) => switch (appTheme) {
    AppTheme.cozy => l10n.themeCozy,
    AppTheme.catppuccin => l10n.themeCatppuccin,
    AppTheme.nord => l10n.themeNord,
    AppTheme.dracula => l10n.themeDracula,
    AppTheme.tokyoNight => l10n.themeTokyoNight,
    AppTheme.gruvbox => l10n.themeGruvbox,
    AppTheme.oneDark => l10n.themeOneDark,
    AppTheme.mint => l10n.themeMint,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = theme.brightness == Brightness.light ? appTheme.lightThemeData : appTheme.darkThemeData;
    final colorScheme = preview.colorScheme;
    final name = _name(context.l10n);

    return Semantics(
      button: true,
      selected: isSelected,
      label: name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : colorScheme.outlineVariant,
              width: 3,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 44,
                      child: CircularProgressIndicator(
                        value: 0.7,
                        strokeWidth: 6,
                        strokeCap: StrokeCap.round,
                        color: colorScheme.primary,
                        backgroundColor: colorScheme.surfaceContainerHigh,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Container(
                              height: 8,
                              decoration: ShapeDecoration(shape: const StadiumBorder(), color: colorScheme.onSurface),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FractionallySizedBox(
                            widthFactor: 0.55,
                            child: Container(
                              height: 6,
                              decoration: ShapeDecoration(
                                shape: const StadiumBorder(),
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                name,
                style: preview.textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
