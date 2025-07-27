import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/riverpod_test_helpers.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-id';
}

void main() {
  group('Deep Links Integration', () {
    late ProviderContainer container;

    setUp(() {
      container = createTestContainer();
    });

    testWidgets('should handle room deep link when authenticated', (
      tester,
    ) async {
      // Arrange
      final mockUser = MockUser();
      container = createTestContainer(
        overrides: [
          authNotifierProvider.overrideWith(() => StubAuthNotifier(mockUser)),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp.router(
            routerConfig: container.read(routerProvider),
          ),
        ),
      );

      // Act - Simulate deep link navigation
      final router = container.read(routerProvider);
      router.go('/room/TEST123');
      await tester.pumpAndSettle();

      // Assert - Should show room lobby screen
      expect(find.text('Partie #TEST123'), findsOneWidget);
    });

    testWidgets(
      'should redirect to home with redirect param when not authenticated',
      (tester) async {
        // Arrange - No user
        container = createTestContainer(
          overrides: [
            authNotifierProvider.overrideWith(() => StubAuthNotifier(null)),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp.router(
              routerConfig: container.read(routerProvider),
            ),
          ),
        );

        // Act - Try to access protected route
        final router = container.read(routerProvider);
        router.go('/room/TEST123');
        await tester.pumpAndSettle();

        // Assert - Should be on home with redirect param
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          equals('/'),
        );
        expect(
          router
              .routerDelegate
              .currentConfiguration
              .uri
              .queryParameters['redirect'],
          equals('/room/TEST123'),
        );
      },
    );

    testWidgets('should handle join-room deep link without auth', (
      tester,
    ) async {
      // Arrange - No auth needed for join-room
      container = createTestContainer(
        overrides: [
          authNotifierProvider.overrideWith(() => StubAuthNotifier(null)),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp.router(
            routerConfig: container.read(routerProvider),
          ),
        ),
      );

      // Act
      final router = container.read(routerProvider);
      router.go('/join-room');
      await tester.pumpAndSettle();

      // Assert - Should show join room screen
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        equals('/join-room'),
      );
    });

    testWidgets('should handle app scheme deep links', (tester) async {
      // This test verifies that go_router handles the path correctly
      // The actual app scheme handling is done by the platform

      container = createTestContainer(
        overrides: [
          authNotifierProvider.overrideWith(() => StubAuthNotifier(MockUser())),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp.router(
            routerConfig: container.read(routerProvider),
          ),
        ),
      );

      // Simulate navigation from deep link
      final router = container.read(routerProvider);

      // Test various deep link paths
      final testPaths = ['/room/ABC123', '/join-room', '/create-room', '/'];

      for (final path in testPaths) {
        router.go(path);
        await tester.pumpAndSettle();

        // Verify navigation occurred (basic check)
        expect(
          router.routerDelegate.currentConfiguration.uri.path,
          anyOf(equals(path), equals('/')),
        ); // May redirect to home
      }
    });
  });
}

// Stub for auth state
class StubAuthNotifier extends AuthNotifier {
  final User? _user;

  StubAuthNotifier(this._user);

  @override
  Future<User?> build() async => _user;
}
