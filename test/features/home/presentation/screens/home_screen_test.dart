import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/home/presentation/screens/home_screen.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import '../../../../helpers/test_helpers.dart';

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-id-123456789';
}

void main() {
  group('HomeScreen', () {
    testWidgets('should display app title and logo', (tester) async {
      // Arrange
      final mockRouter = MockGoRouter();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() {
              return AuthNotifier();
            }),
          ],
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.text('OJYX'), findsOneWidget);
      expect(find.text('Le jeu de cartes stratégique'), findsOneWidget);
      expect(find.byIcon(Icons.style), findsOneWidget);
    });

    testWidgets('should display loading indicator when auth is loading', (
      tester,
    ) async {
      // Arrange
      final mockRouter = MockGoRouter();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('should display create and join buttons when authenticated', (
      tester,
    ) async {
      // Arrange
      final mockRouter = MockGoRouter();
      final mockUser = MockUser();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() {
              final notifier = AuthNotifier();
              // Override the state directly
              notifier.state = AsyncValue.data(mockUser);
              return notifier;
            }),
          ],
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Créer une partie'), findsOneWidget);
      expect(find.text('Rejoindre une partie'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
    });

    testWidgets('should display user info when authenticated', (tester) async {
      // Arrange
      final mockRouter = MockGoRouter();
      final mockUser = MockUser();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() {
              final notifier = AuthNotifier();
              notifier.state = AsyncValue.data(mockUser);
              return notifier;
            }),
          ],
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Joueur anonyme'), findsOneWidget);
      expect(find.text('ID: test-use...'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should navigate to create room when create button is tapped', (
      tester,
    ) async {
      // Arrange
      final mockRouter = MockGoRouter();
      final mockUser = MockUser();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() {
              final notifier = AuthNotifier();
              notifier.state = AsyncValue.data(mockUser);
              return notifier;
            }),
          ],
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Créer une partie'));
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter.pushedRoutes, contains('/create-room'));
    });

    testWidgets('should navigate to join room when join button is tapped', (
      tester,
    ) async {
      // Arrange
      final mockRouter = MockGoRouter();
      final mockUser = MockUser();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() {
              final notifier = AuthNotifier();
              notifier.state = AsyncValue.data(mockUser);
              return notifier;
            }),
          ],
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Rejoindre une partie'));
      await tester.pumpAndSettle();

      // Assert
      expect(mockRouter.pushedRoutes, contains('/join-room'));
    });

    testWidgets('should display error state with retry button', (tester) async {
      // Arrange
      final mockRouter = MockGoRouter();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() {
              final notifier = AuthNotifier();
              notifier.state = AsyncValue.error(
                'Connection failed',
                StackTrace.empty,
              );
              return notifier;
            }),
          ],
          child: createTestApp(child: const HomeScreen(), router: mockRouter),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur de connexion'), findsOneWidget);
      expect(find.text('Connection failed'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
