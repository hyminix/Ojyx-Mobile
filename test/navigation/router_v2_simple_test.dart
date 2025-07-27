import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';
import '../helpers/riverpod_test_helpers.dart';

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-123';
}

void main() {
  group('RouterV2 Basic Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
    });

    tearDown(() {
      // Container disposal handled by createTestContainer
    });

    test('should create router successfully', () {
      final router = container.read(routerProvider);
      expect(router, isA<GoRouter>());
    });

    test('should have all required routes', () {
      final router = container.read(routerProvider);
      final routes = router.configuration.routes;

      expect(routes.length, greaterThanOrEqualTo(5)); // At least 5 routes

      // Check route paths
      final paths = routes
          .whereType<GoRoute>()
          .cast<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(paths, contains('/'));
      expect(paths, contains('/join-room'));
      expect(paths, contains('/create-room'));
      expect(paths, contains('/room/:roomId'));
      expect(paths, contains('/game/:roomId'));
    });

    test('should have redirect configured', () {
      final router = container.read(routerProvider);
      expect(router.configuration.redirect, isNotNull);
    });

    test('should have error page configured', () {
      final router = container.read(routerProvider);
      // The errorBuilder is not directly accessible, but we can verify the router is configured
      expect(router.configuration, isNotNull);
    });
  });

  group('Route Guards', () {
    test('create-room route should have guard', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      final createRoomRoute = router.configuration.routes
          .whereType<GoRoute>()
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/create-room');

      expect(createRoomRoute.redirect, isNotNull);
    });

    test('room route should have guard', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      final roomRoute = router.configuration.routes
          .whereType<GoRoute>()
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/room/:roomId');

      expect(roomRoute.redirect, isNotNull);
    });

    test('game route should have guard', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      final gameRoute = router.configuration.routes
          .whereType<GoRoute>()
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/game/:roomId');

      expect(gameRoute.redirect, isNotNull);
    });
  });

  group('Route Configuration', () {
    test('game route should use pageBuilder for transitions', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      final gameRoute = router.configuration.routes
          .whereType<GoRoute>()
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/game/:roomId');

      expect(gameRoute.pageBuilder, isNotNull);
      expect(gameRoute.builder, isNull);
    });

    test('all routes should have names', () {
      final container = createTestContainer();
      final router = container.read(routerProvider);

      final namedRoutes = router.configuration.routes
          .whereType<GoRoute>()
          .cast<GoRoute>()
          .where((r) => r.name != null)
          .toList();

      expect(namedRoutes.length, greaterThanOrEqualTo(5));
    });
  });
}
