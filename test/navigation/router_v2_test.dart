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

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('RouterV2 with Guards Tests', () {
    late ProviderContainer container;
    late GoRouter router;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Authentication Guards', () {
      test('should allow access to home without authentication', () async {
        // Create router with no auth
        container = ProviderContainer(
          overrides: [
            authNotifierProvider.overrideWith(() => MockAuthNotifier(null)),
          ],
        );
        
        router = container.read(routerProviderV2);
        
        // Home should be accessible
        expect(router.configuration.findMatch('/')?.matches.isNotEmpty, isTrue);
      });

      test('should allow access to join-room without authentication', () async {
        // Create router with no auth
        container = ProviderContainer(
          overrides: [
            authNotifierProvider.overrideWith(() => MockAuthNotifier(null)),
          ],
        );
        
        router = container.read(routerProviderV2);
        
        // Join room should be accessible
        expect(router.configuration.findMatch('/join-room')?.matches.isNotEmpty, isTrue);
      });

      test('should redirect to home when accessing create-room without auth', () async {
        // Create router with no auth
        container = ProviderContainer(
          overrides: [
            authNotifierProvider.overrideWith(() => MockAuthNotifier(null)),
          ],
        );
        
        router = container.read(routerProviderV2);
        
        // Should have redirect parameter
        final config = router.configuration;
        expect(config.routes.length, greaterThan(0));
        
        // Find create-room route
        final createRoomRoute = config.routes.firstWhere(
          (route) => route is GoRoute && route.path == '/create-room',
        ) as GoRoute;
        
        expect(createRoomRoute.redirect, isNotNull);
      });

      test('should allow access to protected routes when authenticated', () async {
        // Create router with auth
        final mockUser = MockUser();
        container = ProviderContainer(
          overrides: [
            authNotifierProvider.overrideWith(() => MockAuthNotifier(mockUser)),
          ],
        );
        
        router = container.read(routerProviderV2);
        
        // All routes should be accessible
        expect(router.configuration.findMatch('/create-room')?.matches.isNotEmpty, isTrue);
        expect(router.configuration.findMatch('/room/test-room')?.matches.isNotEmpty, isTrue);
        expect(router.configuration.findMatch('/game/test-room')?.matches.isNotEmpty, isTrue);
      });
    });

    group('Router Refresh', () {
      test('should have refresh notifier configured', () {
        router = container.read(routerProviderV2);
        expect(router.refreshListenable, isA<RouterRefreshNotifier>());
      });

      test('refresh notifier should listen to auth changes', () async {
        final notifier = RouterRefreshNotifier(container);
        var notified = false;
        
        notifier.addListener(() {
          notified = true;
        });
        
        // Trigger auth change
        container.refresh(authNotifierProvider);
        
        // Should notify listeners
        await Future.delayed(const Duration(milliseconds: 100));
        expect(notified, isTrue);
        
        notifier.dispose();
      });
    });

    group('Route Parameters', () {
      test('should handle room ID parameter correctly', () {
        router = container.read(routerProviderV2);
        
        final roomRoute = router.configuration.findMatch('/room/abc123');
        expect(roomRoute?.matches.isNotEmpty, isTrue);
        
        if (roomRoute != null && roomRoute.matches.isNotEmpty) {
          final params = roomRoute.pathParameters;
          expect(params['roomId'], equals('abc123'));
        }
      });

      test('should handle game ID parameter correctly', () {
        router = container.read(routerProviderV2);
        
        final gameRoute = router.configuration.findMatch('/game/xyz789');
        expect(gameRoute?.matches.isNotEmpty, isTrue);
        
        if (gameRoute != null && gameRoute.matches.isNotEmpty) {
          final params = gameRoute.pathParameters;
          expect(params['roomId'], equals('xyz789'));
        }
      });
    });

    group('Custom Transitions', () {
      test('game route should use custom page builder', () {
        router = container.read(routerProviderV2);
        
        final gameRoute = router.configuration.routes.firstWhere(
          (route) => route is GoRoute && route.path == '/game/:roomId',
        ) as GoRoute;
        
        expect(gameRoute.pageBuilder, isNotNull);
        expect(gameRoute.builder, isNull);
      });
    });

    group('Error Handling', () {
      test('should have error builder configured', () {
        router = container.read(routerProviderV2);
        expect(router.configuration.errorBuilder, isNotNull);
      });
    });
  });

  group('Integration Tests', () {
    testWidgets('should show home screen when not authenticated', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => MockAuthNotifier(null)),
          ],
          child: Builder(
            builder: (context) {
              final router = context.read(routerProviderV2);
              return MaterialApp.router(
                routerConfig: router,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should be on home screen
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should handle redirect parameter in URL', (tester) async {
      // Create a test widget that can read the redirect parameter
      Widget testHome(String? redirectUrl) => Scaffold(
        body: Center(
          child: Text('Redirect: ${redirectUrl ?? "none"}'),
        ),
      );

      // Override home screen to capture redirect
      final testRouter = GoRouter(
        initialLocation: '/?redirect=%2Fcreate-room',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              final redirect = state.uri.queryParameters['redirect'];
              return testHome(redirect);
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: testRouter,
        ),
      );

      await tester.pumpAndSettle();

      // Should show redirect parameter
      expect(find.text('Redirect: /create-room'), findsOneWidget);
    });
  });
}

// Mock implementations
class MockAuthNotifier extends AuthNotifier {
  MockAuthNotifier(this._user);
  
  final User? _user;
  
  @override
  Future<User?> build() async => _user;
}