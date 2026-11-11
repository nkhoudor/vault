import 'package:app_core/app/presentation/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

/// Central navigation service for navigation.
class NavigationService {
  NavigationService(this._router);

  final GoRouter _router;

  /// Navigate to a route using AppRoute.
  void goRoute(AppRoute route) {
    _router.goNamed(route.name);
  }

  /// Push a new route onto the stack using AppRoute.
  Future<T?> pushRoute<T extends Object?>(AppRoute route) => _router.pushNamed<T>(route.name);

  /// Replace the current route using AppRoute.
  Future<T?> pushReplacementRoute<T extends Object?>(AppRoute route) => _router.pushReplacementNamed<T>(route.name);

  /// Navigate back. Returns true if a route was popped.
  bool goBack() {
    if (_router.canPop()) {
      _router.pop();
      return true;
    }
    return false;
  }

  /// Check if we can navigate back.
  bool canGoBack() {
    return _router.canPop();
  }

  /// Get the current location.
  String get currentLocation => _router.routerDelegate.currentConfiguration.uri.toString();
}
