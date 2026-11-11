import 'package:app_core/app/presentation/app_navigator.dart';
import 'package:app_core/app/presentation/navigation_service.dart';
import 'package:app_core/app/presentation/routes/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class _MockNavigationService extends Mock implements NavigationService {}

void main() {
  late _MockNavigationService navigationService;
  late AppNavigator navigator;

  setUpAll(() => registerFallbackValue(const AppRoute.home()));

  setUp(() {
    navigationService = _MockNavigationService();
    when(() => navigationService.goBack()).thenReturn(true);
    navigator = AppNavigator(navigationService);
  });

  test('navigateToOtpScanner goes to the scanner route', () async {
    await navigator.navigateToOtpScanner();

    verify(() => navigationService.goRoute(const AppRoute.otpScanner())).called(1);
  });

  test('navigateToOtpManualEntry goes to the manual entry route', () async {
    await navigator.navigateToOtpManualEntry();

    verify(() => navigationService.goRoute(const AppRoute.otpManualEntry())).called(1);
  });

  test('navigateBack pops the current route', () async {
    await navigator.navigateBack();

    verify(() => navigationService.goBack()).called(1);
  });

  test('every route has a registered screen', () {
    final registered = <String>{};
    void collect(List<RouteBase> routes) {
      for (final route in routes.whereType<GoRoute>()) {
        registered.add(route.name!);
        collect(route.routes);
      }
    }

    collect(routeRegistry.buildRoutes());

    for (final route in const [
      AppRoute.home(),
      AppRoute.settings(),
      AppRoute.otpScanner(),
      AppRoute.otpManualEntry(),
    ]) {
      expect(registered, contains(route.name));
    }
  });
}
