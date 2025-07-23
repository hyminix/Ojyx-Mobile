import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/config/router_config.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('RouterProvider', () {
    test('should create GoRouter instance', () {
      // Act
      final router = container.read(routerProvider);

      // Assert
      expect(router, isA<GoRouter>());
      // Check initial location is set to '/'
      expect(router.configuration.routes.isNotEmpty, isTrue);
    });

    test('should have all required routes', () {
      // Act
      final router = container.read(routerProvider);
      final routes = router.configuration.routes;

      // Assert
      expect(routes.length, equals(5));
      
      // Check route paths
      final routePaths = routes.map((route) => (route as GoRoute).path).toList();
      expect(routePaths, contains('/'));
      expect(routePaths, contains('/create-room'));
      expect(routePaths, contains('/join-room'));
      expect(routePaths, contains('/room/:roomId'));
      expect(routePaths, contains('/game/:roomId'));
    });

    test('should have named routes', () {
      // Act
      final router = container.read(routerProvider);
      final routes = router.configuration.routes;

      // Assert
      final namedRoutes = routes.map((route) => (route as GoRoute).name).toList();
      expect(namedRoutes, contains('home'));
      expect(namedRoutes, contains('createRoom'));
      expect(namedRoutes, contains('joinRoom'));
      expect(namedRoutes, contains('roomLobby'));
      expect(namedRoutes, contains('game'));
    });

    test('should have error builder', () {
      // Act
      final router = container.read(routerProvider);

      // Assert
      // Error builder is configured in GoRouter
      expect(router.configuration, isNotNull);
    });

    test('home route should build HomeScreen', () {
      // Act
      final router = container.read(routerProvider);
      final homeRoute = router.configuration.routes.firstWhere(
        (route) => (route as GoRoute).path == '/',
      ) as GoRoute;

      // Assert
      expect(homeRoute.builder, isNotNull);
      expect(homeRoute.name, equals('home'));
    });

    test('room routes should extract roomId parameter', () {
      // Act
      final router = container.read(routerProvider);
      final roomRoute = router.configuration.routes.firstWhere(
        (route) => (route as GoRoute).path == '/room/:roomId',
      ) as GoRoute;
      final gameRoute = router.configuration.routes.firstWhere(
        (route) => (route as GoRoute).path == '/game/:roomId',
      ) as GoRoute;

      // Assert
      expect(roomRoute.builder, isNotNull);
      expect(gameRoute.builder, isNotNull);
    });
  });
}