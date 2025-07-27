import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/riverpod_test_helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/config/router_config.dart';

void main() {
  group('go_router Audit Tests', () {
    late GoRouter router;
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
      router = container.read(routerProvider);
    });

    group('Route Configuration', () {
      test('should have correct number of routes', () {
        final routes = router.configuration.routes;
        expect(routes.length, 5);
      });

      test('should have all required route paths', () {
        final routes = router.configuration.routes.cast<GoRoute>();
        final paths = routes.map((r) => r.path).toList();

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

      test('should have all required route names', () {
        final routes = router.configuration.routes.cast<GoRoute>();
        final names = routes
            .where((r) => r.name != null)
            .map((r) => r.name!)
            .toList();

        expect(
          names,
          containsAll(['home', 'createRoom', 'joinRoom', 'roomLobby', 'game']),
        );
      });

      test('should have correct initial location', () {
        expect(router.routerDelegate.currentConfiguration.uri.toString(), '/');
      });

      test('router configuration should be valid', () {
        // Router is properly configured
        expect(router.configuration, isNotNull);
        expect(router.configuration.routes, isNotEmpty);
      });
    });

    group('Route Parameters', () {
      test('room lobby route should accept roomId parameter', () {
        final route = router.configuration.routes.cast<GoRoute>().firstWhere(
          (r) => r.name == 'roomLobby',
        );

        expect(route.path, contains(':roomId'));
      });

      test('game route should accept roomId parameter', () {
        final route = router.configuration.routes.cast<GoRoute>().firstWhere(
          (r) => r.name == 'game',
        );

        expect(route.path, contains(':roomId'));
      });
    });

    group('Navigation Methods Used', () {
      test('should document all navigation methods', () {
        // Based on grep results, the app uses:
        // - context.go() for navigation
        // No usage of:
        // - context.push()
        // - context.pop()
        // - GoRouter.of()
        // - context.goNamed()
        // - context.pushNamed()

        expect(true, true); // Documentation test
      });
    });

    group('Guards and Redirects', () {
      test('should not have any guards currently', () {
        // No redirects or guards found in current implementation
        final routes = router.configuration.routes.cast<GoRoute>();

        for (final route in routes) {
          expect(route.redirect, null);
        }
      });
    });

    testWidgets('error page should be configured', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to invalid route
      router.go('/invalid-route');
      await tester.pumpAndSettle();

      // Should show error page
      expect(find.text('Page non trouvée'), findsOneWidget);
      expect(find.text('Retour à l\'accueil'), findsOneWidget);
    });
  });

  group('Navigation Flow Tests', () {
    testWidgets('should navigate from home to create room', (tester) async {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Should start at home
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/');

      // Navigate to create room
      router.go('/create-room');
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/create-room',
      );
    });

    testWidgets('should navigate to room with ID', (tester) async {
      final container = createTestContainer();
      final router = container.read(routerProvider);
      const testRoomId = 'test-room-123';

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to room
      router.go('/room/$testRoomId');
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/room/$testRoomId',
      );
    });

    testWidgets('should navigate to game with ID', (tester) async {
      final container = createTestContainer();
      final router = container.read(routerProvider);
      const testRoomId = 'test-room-123';

      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to game
      router.go('/game/$testRoomId');
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/game/$testRoomId',
      );
    });
  });

  group('Deep Linking', () {
    test('should support deep link to home', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      router.go('/');
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/');
    });

    test('should support deep link to create room', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      router.go('/create-room');
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/create-room',
      );
    });

    test('should support deep link to room with ID', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      router.go('/room/abc123');
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/room/abc123',
      );
    });

    test('should support deep link to game with ID', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      router.go('/game/xyz789');
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/game/xyz789',
      );
    });

    test('should handle invalid deep links', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      router.go('/invalid/path/here');
      // Should still navigate (error page will be shown)
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        '/invalid/path/here',
      );
    });
  });
}
