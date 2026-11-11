# Vault

Vault is a two-factor authenticator app. It stores the setup keys of your accounts and shows their time-based one-time codes (TOTP, RFC 6238). It is built with Flutter, and iOS builds ship through TestFlight.

## Features

- Add an account by scanning its QR code or by typing its setup key
- Live codes with a countdown ring; tap a code to copy it
- SHA1, SHA256 and SHA512 codes with 6 to 8 digits and custom periods, read from the QR code
- Search by service or account name
- Swipe to delete, with a confirmation
- Seven color themes, each with light and dark modes

Setup keys are stored only on the device, in the iOS Keychain or Android Keystore through `flutter_secure_storage`. The app has no backend and no user account. Codes are computed on the device.

## Why it is built this way

The structure is heavier than an app of this size strictly needs, and that is deliberate. It is the structure a larger codebase with a team would use:

- Every UI unit has the same shape (widget, presenter, state, navigator, repository interface), and a template generates it, so reading one explains them all.
- Presenters and use cases reach storage and navigation only through interfaces, and the time comes from `package:clock`, which a test can set, so they are tested without a device.
- Features never import each other or the router, so each can change on its own. Screens are the only place they meet.

## Architecture Overview

The project follows Clean Architecture principles with a feature-based modular structure, ensuring separation of concerns, testability, and maintainability.

### Layer Structure

#### 1. **Domain Layer** (`lib/features/{feature}/domain/`)
- **Models**: Immutable data classes using `freezed` for entities (in `domain/model/`)
- **Use cases**: Stateless business rules (in `domain/use_case/`), registered in the feature's DI and injected into presenters. Example: `ParseOtpAuthUriUseCase` turns the `otpauth://` link from a setup QR code into an `OtpSecret`
- A unit's **repository** is its only port to the outside: stored data and device services such as the clipboard. Its **navigator** is its only way to another screen
- **Repository interfaces** and **navigator interfaces** are defined in the feature (repository contracts in `{widget}/domain/repository/`, navigator in `{widget}_navigator.dart`); implementations are provided by the app layer or live in the feature’s data layer

#### 2. **Data Layer**
- **App-level** (`lib/app/data/repository/`): Shared data sources and repository implementations (e.g. secure storage, reactive storage, the clipboard)
- **Feature-level** (`lib/features/{feature}/data/repository/`): Repository implementations; they may also be registered from app DI
- **Data flow**: Reactive streams (e.g. RxDart) where applicable

#### 3. **Presentation Layer** (`lib/features/{feature}/`)
- **MVP Pattern**:
  - **Widgets (Views)**: StatefulWidgets with `MaybeHasPresenter` mixin
  - **Presenters**: Extend `Cubit` for state management, react to user actions and call use cases and repositories
  - **States**: Immutable state objects using `freezed`, represent UI state
- **State Management**: Uses `flutter_bloc` (Cubit) with custom MVP extensions
- **Reactive UI**: Views observe state changes through `BlocBuilder`

### Modular Architecture

#### Feature Modules (`lib/features/`)

The project uses two types of features:

**1. Business features** (`lib/features/{feature}/`)
Self-contained business capabilities with:
- Domain models (`domain/model/`); repository and navigator interfaces defined in the feature (e.g. `{widget}/domain/repository/` for repo contracts, `{widget}_navigator.dart` for navigator)
- Presentation layer (widgets, presenters, states) and dependency injection (`di/feature_component.dart`)
- Own localization (`l10n/`)

**2. Shared UI features** (`lib/features/shared/{component}/`)
Reusable components following the same MVP structure.

Features expose minimal public API:
- Repository interfaces (implementations in app or feature data layer)
- Navigator interfaces (implemented by app layer)
- Widgets for composition

#### Screen Composition Layer (`lib/app/presentation/screens/`)

Screens compose features into complete application screens:

**Purpose**: 
- Combine multiple features into cohesive screens
- Handle screen-level layout and structure
- Coordinate feature interactions when needed
- Every route maps to a screen (even single-feature screens)

Screens are stateless compositions, for example `HomeScreen` combines the app bar, the account list and the add button. A screen that has to coordinate features would get its own presenter and state, following the same MVP shape.

**Key Principles**:
- Features remain independent (no cross-feature dependencies)
- Screens are the only place features meet
- Router maps type-safe routes to screens
- Features can be reused in multiple screens

#### Dependency Injection (`lib/di/`)
- **AppComponent**: Global DI container wrapper around GetIt
- **FeatureComponent**: Interface for modular feature DI configuration
- **Initialization stages**: General deps → MVP → Repositories → Stores → Use Cases
- Features register presenters and states with parameters

#### Routing & Navigation (`lib/app/presentation/routes/`, `lib/app/presentation/navigation_service.dart`)
The project uses go_router with a clean architecture approach:
- **Type-safe routes**: `AppRoute` sealed classes (e.g. in `app_routes.dart`) with `freezed` for compile-time safety; router and route registry in `lib/app/presentation/routes/`
- **NavigationService**: Central coordinator translating `AppRoute` objects to go_router calls
- **Navigator interfaces**: Features define navigation contracts (e.g. `CustomAppBarNavigator`)
- **Navigator implementation**: `AppNavigator` (`lib/app/presentation/app_navigator.dart`) implements them all on top of `NavigationService`, and `AppFeatureComponent` registers it
- **Zero coupling**: Features navigate through interfaces; no direct dependency on go_router or `AppRoute`

Example:
```dart
// Feature defines interface
abstract class CustomAppBarNavigator {
  Future<void> navigateToSettings();
}

// App implements with type-safe routes
class AppNavigator implements CustomAppBarNavigator {
  AppNavigator(this._navigationService);
  final NavigationService _navigationService;

  @override
  Future<void> navigateToSettings() async {
    _navigationService.goRoute(const AppRoute.settings());
  }
}
```

### Key Patterns

#### MVP with Cubit
```dart
// State: Immutable UI state
@freezed abstract class OtpListState with _$OtpListState { ... }

// Presenter: Reacts to user actions and updates the state
class OtpListPresenter extends Cubit<OtpListState> with SubscriptionsMixin { ... }

// Widget: View observing state
class _OtpListWidgetState extends State<OtpListWidget>
    with PresenterStateMixin<OtpListState, OtpListPresenter, OtpListWidget> { ... }
```

#### Presenter naming convention

All **public** presenter functions are named after the event they handle: `onSomethingTapped` or `onSomethingPressed` for user actions, and `onSomethingChanged`, `onSomethingSelected`, `onSomethingConfirmed`, `onSomethingDetected` or `onSomethingFailed` for other events.

**Example — add a delete action:**

- **Repository**: add `delete` (or `deleteItem`, etc.).
- **Presenter**: add `onDeletePressed` (or `onDeleteTapped`) which calls the repository’s `delete`.
- **Widget**: call `presenter.onDeletePressed` (e.g. from a button’s `onPressed`).

#### Widget constraints

- **No private widgets in the same file**: A widget file must not define additional private widget classes (e.g. `_SubWidget`) in the same file. One public widget per file.
- **No widget-building functions**: Do not extract widget trees into functions (e.g. `Widget _buildHeader()`). Use proper widget classes instead.
- **Reusable or extracted widgets**: When you need a reusable widget or want to extract a subwidget for readability, place it under a `widgets/` folder inside the MVP unit (e.g. `lib/features/{feature}/{widget}/widgets/my_subwidget.dart`). This keeps the main widget file focused and makes subwidgets easy to find and reuse within the feature.

#### Dependency Inversion
- Features define repository interfaces (in `{widget}/domain/repository/`) and navigator interfaces; app or feature provides implementations and registers them via DI
- Navigation is handled through abstract navigator interfaces implemented at app level

#### Reactive Data Flow
- Repositories return reactive streams (e.g. `Stream<Iterable<OtpSecret>>`)
- Presenters subscribe to streams using `SubscriptionsMixin`
- State updates trigger UI rebuilds automatically

### Project Structure

```
lib/
├── app/                          # Application-level code
│   ├── data/
│   │   └── repository/           # App-level repository implementations, data sources
│   ├── presentation/
│   │   ├── screens/              # Screen composition layer
│   │   │   └── {area}/
│   │   │       └── {screen}_screen.dart       # Screen widget (composition)
│   │   ├── routes/               # Type-safe routing
│   │   │   ├── app_routes.dart   # Generated: AppRoute (freezed), route registry
│   │   │   ├── route_name.dart   # Route names, maintained by hand
│   │   │   ├── router.dart       # GoRouter configuration
│   │   │   └── ...
│   │   ├── app_navigator.dart    # Implements every feature's navigator
│   │   └── navigation_service.dart
│   ├── app.dart                  # Root App widget
│   └── bootstrap.dart            # App initialization
├── core/                         # Core utilities (logs, uncaught errors, storage and clipboard contracts)
├── di/                           # Dependency injection
│   ├── app_component.dart        # Global DI container (GetIt wrapper)
│   └── app_feature_component.dart # App-level DI configuration
├── features/                     # Feature modules
│   ├── {business_feature}/       # Business features
│   │   ├── domain/
│   │   │   ├── model/            # Feature entities (freezed)
│   │   │   └── use_case/         # Business rules
│   │   ├── data/repository/      # Repository implementations
│   │   ├── di/                   # Feature DI configuration
│   │   ├── l10n/                 # Feature localization
│   │   └── {widget}/             # Feature widget (MVP unit)
│   │       ├── widgets/          # Reusable/extracted widgets (one class per file)
│   │       ├── {widget}_widget.dart    # View
│   │       ├── {widget}_presenter.dart # Presenter (Cubit)
│   │       ├── {widget}_state.dart     # State
│   │       ├── {widget}_navigator.dart  # Navigator interface
│   │       └── domain/repository/      # Repository interface
│   └── shared/                   # Shared UI features
│       └── {component}/          # Reusable UI components (same MVP structure)
├── generated/                    # Code generation output
└── utils/                        # Shared utilities (MVP mixins, etc.)

packages/route_aggregator/        # build_runner generator for the routes
scripts/                          # Scripts behind the Makefile targets
tools/templates/                  # Mason templates
```

### Code Generation

The project uses code generation for:
- **Freezed**: Immutable models and state classes with copyWith, equality
- **JSON Serialization**: Model serialization/deserialization
- **Routes**: `packages/route_aggregator` finds every screen annotated with `@AppRoute` and writes `lib/app/presentation/routes/app_routes.dart`. To add a route, add its name to `RouteName`, annotate the screen and run `make gen`. Do not edit the generated file.
- **Localization**: Feature-specific i18n, generated by `make l10n` and committed next to the `.arb` files in each `l10n/` folder

### Mason Templates

The project uses [Mason](https://github.com/felangel/mason) for scaffolding new feature components with proper MVP architecture.

#### Available Templates

**Widget Template** (`tools/templates/widget/`)
- Generates complete MVP structure for a new screen/widget
- Creates: Widget, Presenter, State, Navigator interface, Repository interface and the feature's `en.arb`
- Registers the state and presenter in the feature's DI (`di/feature_component.dart`)
- The navigator and repository are interfaces only: implement them and register the implementations (the navigator usually on `AppNavigator`, registered in `lib/di/app_feature_component.dart`)
- Mocks are test code: add them to `test/mocks.dart`, never to `lib/`

#### Usage

1. Navigate to templates directory:
```bash
cd tools/templates
```

2. Generate a new widget:
```bash
mason make widget
```

3. Follow the prompts:
   - **root_folder_path**: Absolute path to project root
   - **widget_name**: Display name (e.g., "Circle Details")
   - **feature_name**: Feature directory name in snake_case (e.g., "circles")
   - **subdirectory**: Subdirectory inside the feature (e.g., "circle_details")

4. Run code generation to update generated files:
```bash
make gen
```

The template will create all necessary files following the project's architecture patterns and register them in the dependency injection container.

## Getting Started

### Prerequisites
- [fvm](https://fvm.app/), which installs the Flutter version pinned in `.fvmrc`
- Xcode and CocoaPods for iOS, or the Android SDK for Android
- [Mason](https://github.com/felangel/mason) only if you generate new widgets: `dart pub global activate mason_cli`

### Running the app

```bash
make setup
fvm flutter run
```

### Commands

Everyday commands are grouped in the `Makefile`; run `make` to list them. They use the Flutter version pinned in `.fvmrc` when fvm is installed. CI runs the same targets.

| Command | Does |
|---|---|
| `make setup` | Full setup after cloning: clean, dependencies, code generation, pods, icons, splash, format |
| `make deps` | Download dependencies |
| `make gen` | Generate freezed, json and route code into `lib/generated/` |
| `make l10n` | Regenerate localization classes from the `.arb` files |
| `make icons` | Generate an `AppImages` class if `assets/icons` or `assets/images` exist (the app has none today) |
| `make format` | Format the app code (`lib/` and `test/`) |
| `make format-check` | Fail if the app code is not formatted, without changing it |
| `make analyze` | Run the static analyzer |
| `make test` | Run unit and widget tests, golden tests excluded |
| `make goldens` | Regenerate the golden images |
| `make check` | Everything CI checks on a pull request: format check, code generation, analyze, test |
| `make certificates` | Install the development certificate and profile on this Mac, to run on a real iPhone |
| `make beta` | Build and upload to TestFlight (needs the signing secrets, see [CI/CD](#cicd)) |

### Testing
- Run all tests: `fvm flutter test`
- Run golden tests only: `fvm flutter test test/golden/`
- Generate or update golden images: `make goldens` (or `fvm flutter test test/golden/ --update-goldens`)
- Golden files live under `test/golden/features/<feature>/goldens/` (one directory per feature)

#### Golden Tests

Golden tests use the `goldenTest()` helper from `test/golden/helpers/golden_test_helpers.dart`.
All specified screen sizes are rendered **side by side** in a single golden image.

**Coverage:** theme (theme picker, theme mode switch), settings (theme picker), shared (custom app bar), otp (list empty, with items and with no search matches; manual entry empty and with errors).

```dart
import '../helpers/golden_test_helpers.dart';

void main() {
  // Default: multiple screen sizes side by side
  goldenTest(
    'my_widget',
    builder: () => MyWidget(presenter: ...),
  );

  // Fewer sizes for faster local runs:
  goldenTest(
    'my_widget',
    screenSizes: [ScreenSize.iPhone17],
    builder: () => MyWidget(presenter: ...),
  );

  // Light and dark theme side by side (theme regression coverage):
  goldenTestThemed(
    'my_widget_themed',
    builder: () => MyWidget(presenter: ...),
  );
}
```

Golden files are written to `goldens/{name}.png` relative to the test file.

## CI/CD

Two GitHub Actions workflows, both on GitHub-hosted runners. Each one runs on the triggers below while it is enabled in the repository's Actions settings.

| Workflow | Runs on | Does |
|---|---|---|
| `ci.yml` | Every pull request to `main` | `make format-check`, `make gen`, `make analyze`, `make test` — the same as `make check` locally |
| `testflight.yml` | Every push to `main` (docs-only changes are skipped), or manually | The same checks, then builds a signed release and uploads it to TestFlight |

Golden tests are tagged `golden` and skipped in CI: the images are rendered on a developer machine and differ by a few pixels elsewhere. Run them locally with `fvm flutter test --tags golden`.

### How a TestFlight build is made

`ios/fastlane/Fastfile`, lane `beta`:

1. `match` fetches the development and App Store certificates and provisioning profiles from the private certs repo. Whatever is missing or expired is created on Apple's side and stored in the repo, so there is nothing to renew by hand. The development profile is rebuilt when a device is added to the account.
2. The build number is the latest one on TestFlight plus one. The version comes from `pubspec.yaml`.
3. `flutter build ios --release --no-codesign` compiles the app.
4. `build_app` signs it with the fetched profile and exports the `.ipa`.
5. `upload_to_testflight` uploads it with an App Store Connect API key.

### Repository secrets

| Secret | What it is |
|---|---|
| `ASC_KEY_ID` | App Store Connect API key ID |
| `ASC_ISSUER_ID` | App Store Connect issuer ID |
| `ASC_KEY_CONTENT` | The API key `.p8` file, base64-encoded (`base64 -i AuthKey_XXXX.p8`) |
| `MATCH_PASSWORD` | Passphrase that encrypts the certs repo branch |
| `MATCH_GIT_PRIVATE_KEY` | Private SSH key with push access to the certs repo |

### One-time setup

1. Register the bundle ID and create the app record in App Store Connect.
2. Create an App Store Connect API key with the App Manager role.
3. Give an SSH key push access to the certs repo and set the five secrets above.

The first TestFlight run creates the certificates and profiles. Other apps that use the same certs repo and branch reuse the certificates and only get their own profiles.

### Running on a real iPhone

Debug and Profile builds are signed with the development profile from the certs repo. Install it once per Mac, after the first TestFlight run has created it:

```bash
MATCH_PASSWORD=... make certificates
```

To add a device, register it in the Apple Developer portal; the next TestFlight run rebuilds the profile, then run the command again. The simulator needs none of this.

## Dependency Version Management

**Important**: This project specifies **exact versions** (without `^`) for all dependencies in `pubspec.yaml` to ensure consistency and prevent unintended updates.

### Requirements

- All dependencies should be sorted alphabetically
- All dependencies must use exact version numbers (e.g., `package_name: 1.2.3` instead of `package_name: ^1.2.3`)
- Versions change only on purpose, and must work with the Flutter version pinned in `.fvmrc`

### Updating Dependencies

1. Check the available versions on [pub.dev](https://pub.dev/)
2. Update the exact version in `pubspec.yaml` (without `^`)
3. Run `flutter pub get` to fetch the specified versions
4. Test the application to ensure compatibility

This approach ensures reproducible builds and prevents unexpected breaking changes from automatic dependency updates.

## Project Configuration

### Splash screen

App uses `flutter_native_splash` package. Configuration is in `flutter_native_splash.yaml`.
- Set background `color` or `background_image` (line 40)
- Optionally add center `image` for logo (line 66)
- Configure Android 12+ separately (line 134+)
- Changes apply when you run `make setup`

### App icon

App uses `flutter_launcher_icons` package.
- Config: `flutter_launcher_icons.yaml`, source image: `assets/icon/icon.png`
- For in-app icons: create `assets/icons/`, add the images, then run `make icons` to generate the `AppImages` class in `lib/utils/app_images.dart`

### App theme

App uses Material 3 with predefined themes. `AppTheme` in `lib/features/theme/domain/model/app_theme.dart` lists them, and `lib/features/theme/themes/app_theme_data.dart` turns each one into Flutter's `ThemeData`.
- Define new themes by adding an entry to `AppTheme`, its color schemes to `AppThemeData` and its name to the theme feature's `en.arb`
- Each theme includes light/dark color schemes and text theme
- The default theme is `AppTheme.defaultTheme`

## License

Copyright (C) 2026 Nikita Khudorozhkov.

Vault is free software under the [GNU Affero General Public License, version 3](LICENSE). You may use, change and share it, but anything you distribute or run as a service that is built on it must be published under the same license. It comes with no warranty.
