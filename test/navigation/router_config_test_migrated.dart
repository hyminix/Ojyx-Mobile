import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/riverpod_test_helpers.dart';
import '../helpers/go_router_test_helpers.dart';

void main() {
  group('Router Configuration', () {
    late ProviderContainer container;
    late GoRouter router;

    setUp(() {
      container = createTestContainer();
      router = container.read(routerProvider);
    });

    test('initial location should be home', () {
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/');
    });

    test('should have all required routes', () {
      final routes = router.configuration.routes;
      expect(routes.length, 5);

      // Extract route paths
      final paths = routes.map((route) => (route as GoRoute).path).toSet();
      expect(
        paths,
        containsAll([
          '/',
          '/create-room',
          '/join-room',
          '/room/:roomId',
          '/game/:roomId',
        ]),
      );
    });

    test('should have named routes', () {
      final routes = router.configuration.routes.cast<GoRoute>();

      final namedRoutes = <String, String>{};
      for (final route in routes) {
        if (route.name != null) {
          namedRoutes[route.name!] = route.path;
        }
      }

      expect(namedRoutes, {
        'home': '/',
        'createRoom': '/create-room',
        'joinRoom': '/join-room',
        'roomLobby': '/room/:roomId',
        'game': '/game/:roomId',
      });
    });

    test('should parse room lobby route with parameter', () {
      final route = router.configuration.routes.cast<GoRoute>().firstWhere(
        (r) => r.name == 'roomLobby',
      );

      expect(route.path, '/room/:roomId');
    });

    test('should parse game route with parameter', () {
      final route = router.configuration.routes.cast<GoRoute>().firstWhere(
        (r) => r.name == 'game',
      );

      expect(route.path, '/game/:roomId');
    });

    test('router should be properly configured', () {
      expect(router, isNotNull);
      expect(router.configuration, isNotNull);
    });
  });

  group('Navigation Tests with MockGoRouter', () {
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
      setupNavigationStubs(mockRouter);
    });

    testWidgets('should navigate to create room', (tester) async {
      await tester.pumpWidget(
        createMockRouterApp(
          mockRouter: mockRouter,
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => context.go('/create-room'),
                child: const Text('Create Room'),
              ),
            ),
          ),
        ),
      );

      // Verify button is present
      expect(find.text('Create Room'), findsOneWidget);

      // Tap button to navigate
      await tester.tap(find.text('Create Room'));
      await tester.pumpAndSettle();

      // Verify navigation was called
      mockRouter.verifyGo('/create-room');
    });

    testWidgets('should navigate with goNamed', (tester) async {
      await tester.pumpWidget(
        createMockRouterApp(
          mockRouter: mockRouter,
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => context.goNamed(
                  'roomLobby',
                  pathParameters: {'roomId': 'test-123'},
                ),
                child: const Text('Join Room'),
              ),
            ),
          ),
        ),
      );

      // Tap button to navigate
      await tester.tap(find.text('Join Room'));
      await tester.pumpAndSettle();

      // Verify navigation was called with correct parameters
      mockRouter.verifyGoNamed(
        'roomLobby',
        pathParameters: {'roomId': 'test-123'},
      );
    });

    testWidgets('should handle push navigation', (tester) async {
      await tester.pumpWidget(
        createMockRouterApp(
          mockRouter: mockRouter,
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => context.push('/join-room'),
                child: const Text('Push Join Room'),
              ),
            ),
          ),
        ),
      );

      // Tap button to navigate
      await tester.tap(find.text('Push Join Room'));
      await tester.pumpAndSettle();

      // Verify push was called
      mockRouter.verifyPush('/join-room');
    });

    testWidgets('should handle pop navigation', (tester) async {
      when(() => mockRouter.canPop()).thenReturn(true);

      await tester.pumpWidget(
        createMockRouterApp(
          mockRouter: mockRouter,
          child: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ),
          ),
        ),
      );

      // Tap button to go back
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();

      // Verify pop was called
      verify(() => mockRouter.pop(any())).called(1);
    });
  });

  group('Navigation Tests with Real Router', () {
    testWidgets('should navigate to create room', (tester) async {
      final testRouter = createTestRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => context.go('/create-room'),
                child: const Text('Create Room'),
              ),
            ),
          ),
          GoRoute(
            path: '/create-room',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Create Room Screen'))),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: testRouter)),
      );

      // Verify we start at home
      expect(find.text('Create Room'), findsOneWidget);

      // Navigate to create room
      await tester.tap(find.text('Create Room'));
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.text('Create Room Screen'), findsOneWidget);
    });

    testWidgets('should navigate with room ID parameter', (tester) async {
      const testRoomId = 'test-room-123';

      final testRouter = createTestRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => context.go('/room/$testRoomId'),
                child: const Text('Join Room'),
              ),
            ),
          ),
          GoRoute(
            path: '/room/:roomId',
            builder: (context, state) {
              final roomId = state.pathParameters['roomId']!;
              return Scaffold(body: Center(child: Text('Room: $roomId')));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: testRouter)),
      );

      // Navigate to room with ID
      await tester.tap(find.text('Join Room'));
      await tester.pumpAndSettle();

      // Verify room ID is passed correctly
      expect(find.text('Room: $testRoomId'), findsOneWidget);
    });

    testWidgets('error page should show for invalid route', (tester) async {
      final testRouter = createTestRouter(
        initialLocation: '/invalid-route',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Home'))),
          ),
        ],
      );

      // Add error builder to the router
      final errorRouter = GoRouter(
        routes: testRouter.configuration.routes,
        errorBuilder: (context, state) =>
            const Scaffold(body: Center(child: Text('Page not found'))),
        initialLocation: '/invalid-route',
      );

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: errorRouter)),
      );

      await tester.pumpAndSettle();

      // Verify error page is shown
      expect(find.text('Page not found'), findsOneWidget);
    });

    testWidgets('should track navigation with observer', (tester) async {
      final observer = TestNavigatorObserver();

      final testRouter = createTestRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => context.push('/page2'),
                child: const Text('Navigate'),
              ),
            ),
          ),
          GoRoute(
            path: '/page2',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Page 2'))),
          ),
        ],
        observers: [observer],
      );

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: testRouter)),
      );

      // Navigate
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // Verify observer tracked the navigation
      expect(observer.pushedRoutes.length, greaterThan(0));
    });
  });

  group('Route Guards', () {
    test('should support authentication guards', () {
      // This test verifies the structure supports guards
      // Actual guard implementation would be tested with auth state
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Placeholder(),
            redirect: (context, state) {
              // Example auth check
              final isAuthenticated = false; // Would come from auth provider
              if (!isAuthenticated && state.uri.toString() != '/login') {
                return '/login';
              }
              return null;
            },
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const Placeholder(),
          ),
        ],
      );

      expect(router.configuration.routes.length, 2);
    });

    testWidgets('should redirect unauthenticated users', (tester) async {
      final isAuthenticated = false;

      final testRouter = GoRouter(
        initialLocation: '/protected',
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Login Screen'))),
          ),
          GoRoute(
            path: '/protected',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Protected Screen'))),
            redirect: (context, state) {
              // ignore: dead_code
              if (!isAuthenticated) {
                return '/login';
              }
              return null;
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: testRouter)),
      );

      await tester.pumpAndSettle();

      // Verify we were redirected to login
      expect(find.text('Login Screen'), findsOneWidget);
      expect(find.text('Protected Screen'), findsNothing);
    });
  });

  group('Deep Link Tests', () {
    testWidgets('should handle deep links correctly', (tester) async {
      final testRouter = createTestRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Home'))),
          ),
          GoRoute(
            path: '/room/:roomId',
            builder: (context, state) {
              final roomId = state.pathParameters['roomId']!;
              return Scaffold(body: Center(child: Text('Room: $roomId')));
            },
          ),
        ],
      );

      final deepLinkHelper = DeepLinkTestHelper(testRouter);

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: testRouter)),
      );

      // Start at home
      expect(find.text('Home'), findsOneWidget);
      expect(deepLinkHelper.isAtRoute('/'), isTrue);

      // Simulate deep link
      await deepLinkHelper.simulateDeepLink('/room/deep-link-room');
      await tester.pumpAndSettle();

      // Verify navigation to deep link
      expect(find.text('Room: deep-link-room'), findsOneWidget);
      expect(deepLinkHelper.currentLocation, '/room/deep-link-room');
    });

    testWidgets('should handle query parameters in deep links', (tester) async {
      String? inviteCode;

      final testRouter = createTestRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Home'))),
          ),
          GoRoute(
            path: '/join',
            builder: (context, state) {
              inviteCode = state.uri.queryParameters['code'];
              return Scaffold(
                body: Center(child: Text('Join with code: $inviteCode')),
              );
            },
          ),
        ],
      );

      final deepLinkHelper = DeepLinkTestHelper(testRouter);

      await tester.pumpWidget(
        ProviderScope(child: createRouterApp(router: testRouter)),
      );

      // Simulate deep link with query parameter
      await deepLinkHelper.simulateDeepLink('/join?code=ABC123');
      await tester.pumpAndSettle();

      // Verify query parameter was parsed
      expect(find.text('Join with code: ABC123'), findsOneWidget);
      expect(inviteCode, 'ABC123');
    });
  });
}
