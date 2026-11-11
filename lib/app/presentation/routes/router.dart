import 'package:app_core/app/l10n/app_localizations.dart';
import 'package:app_core/app/presentation/routes/app_routes.dart';
import 'package:app_core/core/logs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Creates and configures the app's GoRouter instance.
///
/// Builds router configuration from registered routes using @AppRoute annotations.
GoRouter createRouter() {
  return GoRouter(
    observers: [AppRouteObserver()],
    initialLocation: '/',
    routes: routeRegistry.buildRoutes(),
    errorBuilder: (context, state) {
      final l10n = context.l10n;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.error)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(l10n.routeNotFound(state.matchedLocation), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => context.go('/'), child: Text(l10n.goHome)),
            ],
          ),
        ),
      );
    },
  );
}

/// Route observer for debugging and analytics.
class AppRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    Logs.d('Pushed route: ${route.settings.name ?? route.settings}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    Logs.d('Popped route: ${route.settings.name ?? route.settings}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    Logs.d('Replaced route: ${newRoute?.settings.name ?? newRoute?.settings}');
  }
}
