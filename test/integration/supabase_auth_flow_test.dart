import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';
import '../helpers/riverpod_test_helpers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockSession extends Mock implements Session {}

class MockUser extends Mock implements User {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  group('Supabase Anonymous Auth Flow Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late ProviderContainer container;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();

      when(() => mockSupabase.auth).thenReturn(mockAuth);

      container = createTestContainer(
        overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
      );
    });

    test('should complete anonymous sign-in flow successfully', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();
      final mockAuthResponse = MockAuthResponse();

      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockAuthResponse.session).thenReturn(mockSession);
      when(() => mockAuthResponse.user).thenReturn(mockUser);

      // No current user
      when(() => mockAuth.currentUser).thenReturn(null);

      // Successful anonymous sign-in
      when(
        () => mockAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockAuthResponse);

      // Test auth flow
      final result = await container.read(authNotifierProvider.future);

      expect(result, isNotNull);
      expect(result!.id, equals('test-user-id'));
      verify(() => mockAuth.signInAnonymously()).called(1);
    });

    test('should handle anonymous sign-in failure gracefully', () async {
      // No current user
      when(() => mockAuth.currentUser).thenReturn(null);

      // Failed anonymous sign-in
      when(
        () => mockAuth.signInAnonymously(),
      ).thenThrow(Exception('Auth failed'));

      // Test auth flow
      final result = await container.read(authNotifierProvider.future);

      expect(result, isNull);
      verify(() => mockAuth.signInAnonymously()).called(1);
    });

    test('should skip sign-in if user already authenticated', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('existing-user-id');
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Test auth flow
      final result = await container.read(authNotifierProvider.future);

      expect(result, isNotNull);
      expect(result!.id, equals('existing-user-id'));
      verifyNever(() => mockAuth.signInAnonymously());
    });

    test('should handle sign-out and state invalidation', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockAuth.signOut()).thenAnswer((_) async {});

      // First authenticate
      await container.read(authNotifierProvider.future);

      // Then sign out
      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signOut();

      verify(() => mockAuth.signOut()).called(1);
    });

    test('should handle concurrent auth requests properly', () async {
      final mockUser = MockUser();
      final mockAuthResponse = MockAuthResponse();

      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      when(() => mockAuth.currentUser).thenReturn(null);

      // Delay to simulate slow network
      when(() => mockAuth.signInAnonymously()).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return mockAuthResponse;
      });

      // Make concurrent requests
      final futures = List.generate(
        5,
        (_) => container.read(authNotifierProvider.future),
      );

      final results = await Future.wait(futures);

      // All should return the same user
      expect(results.every((user) => user?.id == 'test-user-id'), isTrue);

      // But signInAnonymously should only be called once
      verify(() => mockAuth.signInAnonymously()).called(1);
    });

    test('currentUserId provider should reflect auth state', () async {
      final mockUser = MockUser();
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      // Initially loading
      expect(container.read(authNotifierProvider).isLoading, isTrue);
      expect(container.read(currentUserIdProvider), isNull);

      // After auth completes
      await container.read(authNotifierProvider.future);

      expect(container.read(currentUserIdProvider), equals('test-user-id'));
    });

    test('should handle network errors during auth', () async {
      when(() => mockAuth.currentUser).thenReturn(null);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenThrow(const AuthException('Network error'));

      final result = await container.read(authNotifierProvider.future);

      expect(result, isNull);
    });

    test('should handle session expiration', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();

      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockSession.expiresAt).thenReturn(
        DateTime.now()
                .subtract(const Duration(hours: 1))
                .millisecondsSinceEpoch ~/
            1000,
      );

      // Expired session
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.currentSession).thenReturn(mockSession);

      // Should trigger new sign-in
      final mockAuthResponse = MockAuthResponse();
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenAnswer((_) async => mockAuthResponse);

      final result = await container.read(authNotifierProvider.future);

      expect(result, isNotNull);
      verify(() => mockAuth.signInAnonymously()).called(1);
    });
  });
}
