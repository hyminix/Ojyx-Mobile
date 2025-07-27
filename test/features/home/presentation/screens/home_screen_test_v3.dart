import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/home/presentation/screens/home_screen.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import '../../../../helpers/go_router_test_helpers.dart';
import '../../../../helpers/supabase_test_helpers.dart';

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-id-123456789';
}

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockAuthResponse extends Mock implements AuthResponse {
  @override
  final User? user;
  @override
  final Session? session;

  MockAuthResponse({this.user, this.session});
}

class TestAuthNotifier extends AuthNotifier {
  final User? testUser;

  TestAuthNotifier(this.testUser);

  @override
  Future<User?> build() async => testUser;
}

class TestAuthLoadingNotifier extends AuthNotifier {
  @override
  Future<User?> build() async {
    // Use a future that will be pending but doesn't complete
    final completer = Completer<User?>();
    // Don't complete it to simulate loading
    return completer.future;
  }
}

class TestAuthErrorNotifier extends AuthNotifier {
  final Object error;

  TestAuthErrorNotifier(this.error);

  @override
  Future<User?> build() async {
    throw error;
  }
}

void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;
  late GoRouter router;

  setUp(() {
    mockSupabaseClient = createMockSupabaseClient();
    mockAuth = MockGoTrueClient();
    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);

    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/create-room',
          builder: (context, state) =>
              const Scaffold(body: Text('Create Room')),
        ),
        GoRoute(
          path: '/join-room',
          builder: (context, state) => const Scaffold(body: Text('Join Room')),
        ),
      ],
    );
  });

  group('HomeScreen', () {
    testWidgets('should display app title and logo', (tester) async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.signInAnonymously()).thenAnswer((_) async {
        final mockUser = MockUser();
        final response = MockAuthResponse(user: mockUser, session: null);
        return response;
      });

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
          ],
          child: MaterialApp.router(routerConfig: router),
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
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => TestAuthLoadingNotifier()),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display user info when authenticated', (tester) async {
      // Arrange
      final mockUser = MockUser();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
            authNotifierProvider.overrideWith(() => TestAuthNotifier(mockUser)),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Joueur anonyme'), findsOneWidget);
      expect(find.text('ID: test-use...'), findsOneWidget);
    });

    testWidgets('should display action buttons when authenticated', (
      tester,
    ) async {
      // Arrange
      final mockUser = MockUser();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
            authNotifierProvider.overrideWith(() => TestAuthNotifier(mockUser)),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Créer une partie'), findsOneWidget);
      expect(find.text('Rejoindre une partie'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.login), findsOneWidget);
    });

    testWidgets('should show loading when user is null', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(() => TestAuthNotifier(null)),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to create room when button is tapped', (
      tester,
    ) async {
      // Arrange
      final mockUser = MockUser();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
            authNotifierProvider.overrideWith(() => TestAuthNotifier(mockUser)),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Créer une partie'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Create Room'), findsOneWidget);
    });

    testWidgets('should navigate to join room when button is tapped', (
      tester,
    ) async {
      // Arrange
      final mockUser = MockUser();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supabaseClientProvider.overrideWithValue(mockSupabaseClient),
            authNotifierProvider.overrideWith(() => TestAuthNotifier(mockUser)),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Rejoindre une partie'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Join Room'), findsOneWidget);
    });

    testWidgets('should display error state with retry button', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authNotifierProvider.overrideWith(
              () => TestAuthErrorNotifier(Exception('Connection failed')),
            ),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur de connexion'), findsOneWidget);
      expect(
        find.textContaining('Exception: Connection failed'),
        findsOneWidget,
      );
      expect(find.text('Réessayer'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
