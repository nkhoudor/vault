# widget

Creates the MVP (Model-View-Presenter) unit for a widget and registers it in the feature's dependency injection.

Run it from `tools/templates`:

```bash
mason make widget
```

It asks for the absolute path to the project root, the widget name, the feature name and the subdirectory inside the feature.

In a feature that already has an `en.arb`, answer `n` when Mason asks to overwrite it, or pass `--on-conflict skip`. Overwriting replaces the feature's strings with an empty file.

## Created files

```
lib/features/<feature>/<subdirectory>/<name>_widget.dart
lib/features/<feature>/<subdirectory>/<name>_presenter.dart
lib/features/<feature>/<subdirectory>/<name>_state.dart
lib/features/<feature>/<subdirectory>/<name>_navigator.dart
lib/features/<feature>/<subdirectory>/domain/repository/<name>_repository.dart
lib/features/<feature>/l10n/en.arb
```

## Changed files

- `lib/features/<feature>/di/feature_component.dart` registers the state and presenter. A new feature gets this file, and `lib/di/app_component.dart` registers it.

The navigator and repository are interfaces only. Implement them and register the implementations, then run `make gen`.
