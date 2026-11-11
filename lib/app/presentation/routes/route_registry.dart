import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route information for building GoRouter configuration.
class RouteInfo {
  const RouteInfo({required this.name, required this.path, required this.builder, this.parent});

  final String name;
  final String path;
  final String? parent;
  final Widget Function(BuildContext, GoRouterState) builder;
}

/// Registry for app routes.
/// Screens register themselves here using @AppRoute annotation data.
class RouteRegistry {
  RouteRegistry(List<RouteInfo> routes) {
    for (final route in routes) {
      register(route);
    }
  }

  final Map<String, RouteInfo> _routes = {};

  /// Register a route with the registry.
  /// Throws [ArgumentError] if route name is duplicate or parent doesn't exist.
  void register(RouteInfo route) {
    if (_routes.containsKey(route.name)) {
      throw ArgumentError('Route with name "${route.name}" is already registered');
    }

    if (route.parent != null && !_routes.containsKey(route.parent)) {
      throw ArgumentError(
        'Parent route "${route.parent}" not found for route "${route.name}". '
        'Register parent routes before child routes.',
      );
    }

    _routes[route.name] = route;
  }

  /// Build GoRouter routes from registered routes.
  /// Throws [StateError] if no routes are registered.
  /// Supports unlimited nesting depth (e.g., home -> settings -> themePicker).
  List<RouteBase> buildRoutes() {
    if (_routes.isEmpty) {
      throw StateError('No routes registered. Annotate a screen with @AppRoute and run `make gen`.');
    }

    // Find root routes (those without parents)
    final rootRoutes = _routes.values.where((r) => r.parent == null).toList();

    // Build routes recursively
    return rootRoutes.map((root) => _buildRoute(root)).toList();
  }

  /// Recursively build a route and its children.
  GoRoute _buildRoute(RouteInfo route) {
    // Find direct children of this route
    final children = _routes.values.where((r) => r.parent == route.name).toList();

    // Child paths should be relative to parent (no leading slash)
    final routePath = route.path.startsWith('/') ? route.path.substring(1) : route.path;

    return GoRoute(
      path: route.parent == null ? route.path : routePath,
      name: route.name,
      builder: route.builder,
      routes: children.map((child) => _buildRoute(child)).toList(),
    );
  }

  /// Clear all routes (useful for testing).
  void clear() {
    _routes.clear();
  }
}
