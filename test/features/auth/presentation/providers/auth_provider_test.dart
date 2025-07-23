import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {
  @override
  String get id => 'test-user-id';
}

class MockAuthResponse extends Mock implements AuthResponse {
  @override
  User? get user => MockUser();
}

void main() {
  late ProviderContainer container;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuth;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();

    when(() => mockSupabaseClient.auth).thenReturn(mockAuth);

    container = ProviderContainer(
      overrides: [supabaseClientProvider.overrideWithValue(mockSupabaseClient)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    test('should return existing user if already authenticated', () async {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      final result = await container.read(authNotifierProvider.future);

      // Assert
      expect(result, equals(mockUser));
      verify(() => mockAuth.currentUser).called(1);
      verifyNever(() => mockAuth.signInAnonymously());
    });

    test('should sign in anonymously if no current user', () async {
      // Arrange
      final mockAuthResponse = MockAuthResponse();
      when(() => mockAuth.currentUser).thenReturn(null);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockAuthResponse);

      // Act
      final result = await container.read(authNotifierProvider.future);

      // Assert
      expect(result, isA<User>());
      verify(() => mockAuth.currentUser).called(1);
      verify(() => mockAuth.signInAnonymously()).called(1);
    });

    test('should return null if anonymous sign in fails', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenThrow(Exception('Auth failed'));

      // Act
      final result = await container.read(authNotifierProvider.future);

      // Assert
      expect(result, isNull);
      verify(() => mockAuth.currentUser).called(1);
      verify(() => mockAuth.signInAnonymously()).called(1);
    });

    test('signOut should sign out user and invalidate state', () async {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      // Act
      await container.read(authNotifierProvider.future);
      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signOut();

      // Assert
      verify(() => mockAuth.signOut()).called(1);
    });

    test('currentUserId should return user id when authenticated', () async {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      await container.read(authNotifierProvider.future);
      final notifier = container.read(authNotifierProvider.notifier);
      final userId = notifier.currentUserId;

      // Assert
      expect(userId, equals('test-user-id'));
    });

    test('currentUserId should return null when not authenticated', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenThrow(Exception('Auth failed'));

      // Act
      await container.read(authNotifierProvider.future);
      final notifier = container.read(authNotifierProvider.notifier);
      final userId = notifier.currentUserId;

      // Assert
      expect(userId, isNull);
    });
  });

  group('currentUserId provider', () {
    test('should return user id when user is authenticated', () async {
      // Arrange
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Act
      await container.read(authNotifierProvider.future);
      final userId = container.read(currentUserIdProvider);

      // Assert
      expect(userId, equals('test-user-id'));
    });

    test('should return null when user is not authenticated', () async {
      // Arrange
      when(() => mockAuth.currentUser).thenReturn(null);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenThrow(Exception('Auth failed'));

      // Act
      await container.read(authNotifierProvider.future);
      final userId = container.read(currentUserIdProvider);

      // Assert
      expect(userId, isNull);
    });
  });
}
