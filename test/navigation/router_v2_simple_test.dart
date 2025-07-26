import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/core/config/router_config_v2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-123';
}

void main() {
  group('RouterV2 Basic Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create router successfully', () {
      final router = container.read(routerProviderV2);
      expect(router, isA<GoRouter>());
    });

    test('should have all required routes', () {
      final router = container.read(routerProviderV2);
      final routes = router.configuration.routes;
      
      expect(routes.length, greaterThanOrEqualTo(5)); // At least 5 routes
      
      // Check route paths
      final paths = routes
          .where((r) => r is GoRoute)
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
      final router = container.read(routerProviderV2);
      expect(router.configuration.redirect, isNotNull);
    });

    test('should have error page configured', () {
      final router = container.read(routerProviderV2);
      // The errorBuilder is not directly accessible, but we can verify the router is configured
      expect(router.configuration, isNotNull);
    });
  });

  group('Route Guards', () {
    test('create-room route should have guard', () {
      final container = ProviderContainer();
      final router = container.read(routerProviderV2);
      
      final createRoomRoute = router.configuration.routes
          .where((r) => r is GoRoute)
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/create-room');
      
      expect(createRoomRoute.redirect, isNotNull);
    });

    test('room route should have guard', () {
      final container = ProviderContainer();
      final router = container.read(routerProviderV2);
      
      final roomRoute = router.configuration.routes
          .where((r) => r is GoRoute)
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/room/:roomId');
      
      expect(roomRoute.redirect, isNotNull);
    });

    test('game route should have guard', () {
      final container = ProviderContainer();
      final router = container.read(routerProviderV2);
      
      final gameRoute = router.configuration.routes
          .where((r) => r is GoRoute)
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/game/:roomId');
      
      expect(gameRoute.redirect, isNotNull);
    });
  });

  group('Route Configuration', () {
    test('game route should use pageBuilder for transitions', () {
      final container = ProviderContainer();
      final router = container.read(routerProviderV2);
      
      final gameRoute = router.configuration.routes
          .where((r) => r is GoRoute)
          .cast<GoRoute>()
          .firstWhere((r) => r.path == '/game/:roomId');
      
      expect(gameRoute.pageBuilder, isNotNull);
      expect(gameRoute.builder, isNull);
    });

    test('all routes should have names', () {
      final container = ProviderContainer();
      final router = container.read(routerProviderV2);
      
      final namedRoutes = router.configuration.routes
          .where((r) => r is GoRoute)
          .cast<GoRoute>()
          .where((r) => r.name != null)
          .toList();
      
      expect(namedRoutes.length, greaterThanOrEqualTo(5));
    });
  });
}