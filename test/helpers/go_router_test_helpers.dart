import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

/// Mock implementation of GoRouter for testing
class MockGoRouter extends Mock implements GoRouter {}

/// Provider widget for injecting MockGoRouter into the widget tree
class MockGoRouterProvider extends StatelessWidget {
  const MockGoRouterProvider({
    required this.goRouter,
    required this.child,
    super.key,
  });

  final MockGoRouter goRouter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InheritedGoRouter(goRouter: goRouter, child: child);
  }
}

/// Helper to create a test GoRouter with minimal configuration
GoRouter createTestRouter({
  required String initialLocation,
  required List<RouteBase> routes,
  GoRouterRedirect? redirect,
  List<NavigatorObserver>? observers,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: routes,
    redirect: redirect,
    observers: observers ?? [],
  );
}

/// Creates a simple test route configuration
List<RouteBase> createTestRoutes({
  required Widget home,
  Map<String, Widget>? additionalRoutes,
}) {
  final routes = <RouteBase>[
    GoRoute(path: '/', name: 'home', builder: (context, state) => home),
  ];

  if (additionalRoutes != null) {
    routes.addAll(
      additionalRoutes.entries.map(
        (entry) => GoRoute(
          path: entry.key,
          name: entry.key.replaceAll('/', ''),
          builder: (context, state) => entry.value,
        ),
      ),
    );
  }

  return routes;
}

/// Helper to create a MaterialApp with router for testing
Widget createRouterApp({required GoRouter router, ThemeData? theme}) {
  return MaterialApp.router(
    routerConfig: router,
    theme: theme ?? ThemeData.light(),
  );
}

/// Helper to create a test app with MockGoRouter
Widget createMockRouterApp({
  required MockGoRouter mockRouter,
  required Widget child,
  ThemeData? theme,
}) {
  return MaterialApp(
    theme: theme ?? ThemeData.light(),
    home: MockGoRouterProvider(goRouter: mockRouter, child: child),
  );
}

/// Setup common navigation stubs for MockGoRouter
void setupNavigationStubs(MockGoRouter mockRouter) {
  // Setup common navigation method stubs
  when(() => mockRouter.go(any())).thenAnswer((_) async {});
  when(
    () =>
        mockRouter.goNamed(any(), pathParameters: any(named: 'pathParameters')),
  ).thenAnswer((_) async {});
  when(() => mockRouter.push(any())).thenAnswer((_) async => null);
  when(
    () => mockRouter.pushNamed(
      any(),
      pathParameters: any(named: 'pathParameters'),
    ),
  ).thenAnswer((_) async => null);
  when(() => mockRouter.replace(any())).thenAnswer((_) async => null);
  when(
    () => mockRouter.replaceNamed(
      any(),
      pathParameters: any(named: 'pathParameters'),
    ),
  ).thenAnswer((_) async => null);
  when(() => mockRouter.pop(any())).thenAnswer((_) async {});
  when(() => mockRouter.canPop()).thenReturn(false);

  // Setup router delegate configuration
  final mockRouterDelegate = MockRouterDelegate();
  when(() => mockRouter.routerDelegate).thenReturn(mockRouterDelegate);

  // Setup route information parser
  final mockRouteInformationParser = MockRouteInformationParser();
  when(
    () => mockRouter.routeInformationParser,
  ).thenReturn(mockRouteInformationParser);

  // Setup route information provider
  final mockRouteInformationProvider = MockRouteInformationProvider();
  when(
    () => mockRouter.routeInformationProvider,
  ).thenReturn(mockRouteInformationProvider);
}

/// Mock implementations for GoRouter components
class MockRouterDelegate extends Mock implements GoRouterDelegate {}

class MockRouteInformationParser extends Mock
    implements GoRouteInformationParser {}

class MockRouteInformationProvider extends Mock
    implements GoRouteInformationProvider {}

/// Extension to easily verify navigation calls
extension GoRouterVerify on MockGoRouter {
  /// Verify that go was called with specific path
  void verifyGo(String location, {int times = 1}) {
    verify(() => go(location)).called(times);
  }

  /// Verify that goNamed was called with specific name
  void verifyGoNamed(
    String name, {
    Map<String, String>? pathParameters,
    int times = 1,
  }) {
    verify(
      () => goNamed(
        name,
        pathParameters: pathParameters ?? any(named: 'pathParameters'),
      ),
    ).called(times);
  }

  /// Verify that push was called with specific path
  void verifyPush(String location, {int times = 1}) {
    verify(() => push(location)).called(times);
  }

  /// Verify that no navigation happened
  void verifyNoNavigation() {
    verifyNever(() => go(any()));
    verifyNever(
      () => goNamed(any(), pathParameters: any(named: 'pathParameters')),
    );
    verifyNever(() => push(any()));
    verifyNever(
      () => pushNamed(any(), pathParameters: any(named: 'pathParameters')),
    );
    verifyNever(() => replace(any()));
    verifyNever(
      () => replaceNamed(any(), pathParameters: any(named: 'pathParameters')),
    );
  }
}

/// Helper to test deep links
class DeepLinkTestHelper {
  final GoRouter router;

  DeepLinkTestHelper(this.router);

  /// Simulate opening app with deep link
  Future<void> simulateDeepLink(String url) async {
    final uri = Uri.parse(url);
    router.go(uri.toString());
  }

  /// Get current location
  String get currentLocation =>
      router.routerDelegate.currentConfiguration.uri.toString();

  /// Check if currently at specific route
  bool isAtRoute(String path) => currentLocation == path;
}

/// Create a test NavigatorObserver for tracking navigation events
class TestNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = [];
  final List<Route<dynamic>> poppedRoutes = [];
  final List<Route<dynamic>> replacedRoutes = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    poppedRoutes.add(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) {
      replacedRoutes.add(newRoute);
    }
  }

  void reset() {
    pushedRoutes.clear();
    poppedRoutes.clear();
    replacedRoutes.clear();
  }
}
