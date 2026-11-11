import 'package:app_core/app/presentation/routes/route_name.dart';

/// Annotation to mark a screen as an app route.
///
/// Example:
/// ```dart
/// @AppRoute(name: RouteName.home, path: '/')
/// class HomeScreen extends StatelessWidget {
///   const HomeScreen({super.key});
///   // ...
/// }
/// ```
class AppRoute {
  const AppRoute({required this.name, this.path, this.parent, this.params = const []});

  /// The unique route name (from RouteName enum).
  final RouteName name;

  /// The path for the route. If not provided, defaults to the name.
  final String? path;

  /// The parent route name if this is a child route.
  final RouteName? parent;

  /// List of parameter names that this route accepts.
  /// Parameters are extracted from GoRouterState and passed to the widget constructor.
  final List<String> params;
}
