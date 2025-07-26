import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/auth/domain/entities/player.dart';
import 'package:ojyx/features/auth/domain/repositories/auth_repository.dart';
import 'package:ojyx/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ojyx/features/auth/data/models/player_model.dart';
import 'package:dartz/dartz.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockSession extends Mock implements Session {}
class MockUser extends Mock implements User {}
class MockAuthResponse extends Mock implements AuthResponse {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder {}
class MockPostgrestTransformBuilder extends Mock implements PostgrestTransformBuilder {}

void main() {
  group('Supabase Anonymous Auth Flow Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;
    late AuthRepository authRepository;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockAuth = MockGoTrueClient();
      authRepository = AuthRepositoryImpl(mockSupabase);
      
      when(() => mockSupabase.auth).thenReturn(mockAuth);
    });

    test('should complete anonymous sign-in flow successfully', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();
      final mockAuthResponse = MockAuthResponse();
      
      when(() => mockUser.id).thenReturn('test-user-id');
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockAuthResponse.session).thenReturn(mockSession);
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      
      when(() => mockAuth.signInAnonymously()).thenAnswer(
        (_) async => mockAuthResponse,
      );
      
      when(() => mockAuth.currentSession).thenReturn(mockSession);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      
      when(() => mockSupabase.from('players')).thenReturn(
        _createMockQueryBuilder({
          'id': 'test-user-id',
          'username': 'Guest_123',
          'created_at': DateTime.now().toIso8601String(),
          'is_guest': true,
        }),
      );
      
      final result = await authRepository.signInAnonymously();
      
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (player) {
          expect(player.id, equals('test-user-id'));
          expect(player.username, equals('Guest_123'));
          expect(player.isGuest, isTrue);
        },
      );
      
      verify(() => mockAuth.signInAnonymously()).called(1);
    });

    test('should handle auth failure with proper error propagation', () async {
      when(() => mockAuth.signInAnonymously()).thenThrow(
        AuthException('Anonymous sign-in failed'),
      );
      
      final result = await authRepository.signInAnonymously();
      
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, contains('Anonymous sign-in failed'));
        },
        (_) => fail('Should not succeed'),
      );
    });

    test('should maintain session state across operations', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();
      
      when(() => mockUser.id).thenReturn('persistent-user-id');
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockAuth.currentSession).thenReturn(mockSession);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      
      when(() => mockSupabase.from('players')).thenReturn(
        _createMockQueryBuilder({
          'id': 'persistent-user-id',
          'username': 'Guest_456',
          'created_at': DateTime.now().toIso8601String(),
          'is_guest': true,
        }),
      );
      
      final result1 = await authRepository.getCurrentPlayer();
      final result2 = await authRepository.getCurrentPlayer();
      
      expect(result1.isRight(), isTrue);
      expect(result2.isRight(), isTrue);
      
      result1.fold(
        (_) => fail('Should not fail'),
        (player1) {
          result2.fold(
            (_) => fail('Should not fail'),
            (player2) {
              expect(player1.id, equals(player2.id));
              expect(player1.username, equals(player2.username));
            },
          );
        },
      );
    });

    test('should handle session expiration and refresh', () async {
      final expiredSession = MockSession();
      final newSession = MockSession();
      final mockUser = MockUser();
      final mockAuthResponse = MockAuthResponse();
      
      when(() => mockUser.id).thenReturn('refresh-user-id');
      when(() => expiredSession.user).thenReturn(mockUser);
      when(() => newSession.user).thenReturn(mockUser);
      when(() => mockAuthResponse.session).thenReturn(newSession);
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      
      when(() => mockAuth.currentSession).thenReturn(null);
      when(() => mockAuth.refreshSession()).thenAnswer(
        (_) async => mockAuthResponse,
      );
      
      when(() => mockSupabase.from('players')).thenReturn(
        _createMockQueryBuilder({
          'id': 'refresh-user-id',
          'username': 'Guest_789',
          'created_at': DateTime.now().toIso8601String(),
          'is_guest': true,
        }),
      );
      
      final result = await authRepository.getCurrentPlayer();
      
      expect(result.isRight(), isTrue);
    });

    test('should handle concurrent auth requests properly', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();
      final mockAuthResponse = MockAuthResponse();
      
      when(() => mockUser.id).thenReturn('concurrent-user-id');
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockAuthResponse.session).thenReturn(mockSession);
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      
      when(() => mockAuth.signInAnonymously()).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockAuthResponse;
        },
      );
      
      when(() => mockAuth.currentSession).thenReturn(mockSession);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      
      when(() => mockSupabase.from('players')).thenReturn(
        _createMockQueryBuilder({
          'id': 'concurrent-user-id',
          'username': 'Guest_999',
          'created_at': DateTime.now().toIso8601String(),
          'is_guest': true,
        }),
      );
      
      final futures = List.generate(
        5,
        (_) => authRepository.signInAnonymously(),
      );
      
      final results = await Future.wait(futures);
      
      expect(results.every((r) => r.isRight()), isTrue);
      verify(() => mockAuth.signInAnonymously()).called(5);
    });

    test('should integrate with player profile creation', () async {
      final mockUser = MockUser();
      final mockSession = MockSession();
      final mockAuthResponse = MockAuthResponse();
      
      when(() => mockUser.id).thenReturn('new-player-id');
      when(() => mockSession.user).thenReturn(mockUser);
      when(() => mockAuthResponse.session).thenReturn(mockSession);
      when(() => mockAuthResponse.user).thenReturn(mockUser);
      
      when(() => mockAuth.signInAnonymously()).thenAnswer(
        (_) async => mockAuthResponse,
      );
      
      when(() => mockAuth.currentSession).thenReturn(mockSession);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      
      int callCount = 0;
      when(() => mockSupabase.from('players')).thenReturn(
        _createMockQueryBuilder(
          callCount++ == 0
              ? null
              : {
                  'id': 'new-player-id',
                  'username': 'Guest_New',
                  'created_at': DateTime.now().toIso8601String(),
                  'is_guest': true,
                },
        ),
      );
      
      final result = await authRepository.signInAnonymously();
      
      expect(result.isRight(), isTrue);
    });
  });
}

SupabaseQueryBuilder _createMockQueryBuilder(Map<String, dynamic>? data) {
  final mockBuilder = MockPostgrestFilterBuilder();
  final mockTransform = MockPostgrestTransformBuilder();
  
  when(() => mockBuilder.eq(any(), any())).thenReturn(mockTransform);
  when(() => mockTransform.single()).thenAnswer((_) async {
    if (data == null) {
      throw PostgrestException(
        message: 'Row not found',
        code: 'PGRST116',
      );
    }
    return data;
  });
  
  return mockBuilder as SupabaseQueryBuilder;
}