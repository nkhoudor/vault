import 'package:app_core/features/theme/domain/model/app_theme.dart';
import 'package:app_core/features/theme/l10n/theme_localizations.dart';
import 'package:app_core/features/theme/themes/app_theme_data.dart';
import 'package:flutter/material.dart';

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
  };

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final previewTheme = brightness == Brightness.light ? appTheme.lightThemeData : appTheme.darkThemeData;
    final colorScheme = previewTheme.colorScheme;
    final textTheme = previewTheme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: Stack(
          children: [
            // Content
            DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Mock App Bar
                    Container(
                      height: 48,
                      color: colorScheme.surfaceContainerHighest,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.menu, size: 16, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Container(
                            width: 60,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.onSurfaceVariant.withAlpha(100),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Mock Body
                    Expanded(
                      child: Container(
                        color: colorScheme.surface,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mock Card
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.person, size: 16, color: colorScheme.onPrimaryContainer),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: colorScheme.onSurface.withAlpha(150),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 24,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: colorScheme.onSurfaceVariant.withAlpha(100),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Mock FAB
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.shadow.withAlpha(50),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(Icons.add, size: 20, color: colorScheme.onPrimary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Theme Name Label
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      color: colorScheme.surface,
                      alignment: Alignment.center,
                      child: Text(
                        _name(context.l10n),
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Selection Border Overlay
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            // Selection Checkmark
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                  child: Icon(Icons.check, size: 12, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
