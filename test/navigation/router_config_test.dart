import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/config/router_config.dart';

void main() {
  group('Router Configuration', () {
    late ProviderContainer container;
    late GoRouter router;

    setUp(() {
      container = ProviderContainer();
      router = container.read(routerProvider);
    });

    tearDown(() {
      container.dispose();
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

  group('Navigation Tests', () {
    testWidgets('should navigate to create room', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
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
                  builder: (context, state) => const Scaffold(
                    body: Center(child: Text('Create Room Screen')),
                  ),
                ),
              ],
            ),
          ),
        ),
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

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
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
            ),
          ),
        ),
      );

      // Navigate to room with ID
      await tester.tap(find.text('Join Room'));
      await tester.pumpAndSettle();

      // Verify room ID is passed correctly
      expect(find.text('Room: $testRoomId'), findsOneWidget);
    });

    testWidgets('error page should show for invalid route', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) =>
                      const Scaffold(body: Center(child: Text('Home'))),
                ),
              ],
              errorBuilder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Page not found'))),
              initialLocation: '/invalid-route',
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error page is shown
      expect(find.text('Page not found'), findsOneWidget);
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
  });
}
