import 'package:app_core/features/theme/theme_picker/theme_picker_presenter.dart';
import 'package:app_core/features/theme/theme_picker/theme_picker_state.dart';
import 'package:app_core/features/theme/theme_picker/widgets/theme_card.dart';
import 'package:app_core/utils/mvp_extensions.dart';
import 'package:app_core/utils/selectable.dart';
import 'package:flutter/material.dart';

class ThemePickerWidget extends StatefulWidget with MaybeHasPresenter<ThemePickerPresenter> {
  const ThemePickerWidget({this.presenter, super.key});

  @override
  final ThemePickerPresenter? presenter;

  @override
  State<ThemePickerWidget> createState() => _ThemePickerWidgetState();
}

class _ThemePickerWidgetState extends State<ThemePickerWidget>
    with PresenterStateMixin<ThemePickerState, ThemePickerPresenter, ThemePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return stateObserver(
      builder: (context, state) {
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: state.themes.length,
          itemBuilder: (context, index) {
            final selectableTheme = state.themes.elementAt(index);
            final (appTheme, isSelected) = selectableTheme.map(
              selected: (s) => (s.item, true),
              deselected: (d) => (d.item, false),
            );

            return ThemeCard(
              appTheme: appTheme,
              isSelected: isSelected,
              onTap: () => presenter.onThemeSelected(appTheme),
            );
          },
        );
      },
    );
  }
}
