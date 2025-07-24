import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/data/repositories/supabase_game_state_repository.dart';
import 'package:ojyx/features/game/domain/use_cases/game_initialization_use_case.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';

// Mock Supabase client for testing
class MockSupabaseClient extends Mock {
  // Mock implementation will be injected
}

void main() {
  group('Server-Authoritative Game Flow Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late SupabaseGameStateRepository gameStateRepository;
    late GameInitializationUseCase gameInitUseCase;
    late UseActionCardUseCase actionCardUseCase;
    late SyncGameStateUseCase syncUseCase;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      gameStateRepository = SupabaseGameStateRepository(mockSupabase);
      gameInitUseCase = GameInitializationUseCase(gameStateRepository);
      actionCardUseCase = UseActionCardUseCase(gameStateRepository);
      syncUseCase = SyncGameStateUseCase(gameStateRepository);
    });

    group('Complete Game Flow', () {
      test('should initialize game with server-side validation', () async {
        // Given
        const roomId = 'room-123';
        const playerIds = ['player-1', 'player-2', 'player-3'];
        const creatorId = 'player-1';

        // Mock successful game initialization
        when(mockSupabase.rpc('initialize_game', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'valid': true,
              'game_state_id': 'game-456',
              'current_player': 'player-1',
            });

        // Mock game state retrieval
        when(mockSupabase.from('game_states'))
            .thenReturn(MockSupabaseQueryBuilder());

        // When
        final result = await gameInitUseCase.execute(
          roomId: roomId,
          playerIds: playerIds,
          creatorId: creatorId,
        );

        // Then
        expect(result, isNotNull);
        expect(result.roomId, equals(roomId));
        expect(result.status, equals(GameStatus.active));
        
        // Verify server function was called with correct parameters
        verify(mockSupabase.rpc('initialize_game', params: {
          'p_room_id': roomId,
          'p_player_ids': playerIds,
          'p_creator_id': creatorId,
        })).called(1);
      });

      test('should handle card reveal with server validation', () async {
        // Given
        const gameStateId = 'game-456';
        const playerId = 'player-1';
        const position = 0;

        // Mock successful card reveal
        when(mockSupabase.rpc('process_card_reveal', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'valid': true,
              'action': 'card_revealed',
              'column_complete': false,
            });

        // When
        final result = await syncUseCase.revealCard(
          gameStateId: gameStateId,
          playerId: playerId,
          position: position,
        );

        // Then
        expect(result['valid'], isTrue);
        expect(result['action'], equals('card_revealed'));
        
        // Verify server function was called
        verify(mockSupabase.rpc('process_card_reveal', params: {
          'p_game_state_id': gameStateId,
          'p_player_id': playerId,
          'p_position': position,
        })).called(1);
      });

      test('should process action card with server-side validation', () async {
        // Given
        const gameStateId = 'game-456';
        const playerId = 'player-1';
        const actionCardType = ActionCardType.teleport;
        final targetData = {
          'position1': 0,
          'position2': 3,
        };

        // Mock successful action card use
        when(mockSupabase.rpc('process_action_card', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'valid': true,
              'action': 'teleport_executed',
            });

        final params = UseActionCardParams(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: targetData,
        );

        // When
        final result = await actionCardUseCase.call(params);

        // Then
        expect(result.isRight(), isTrue);
        final rightValue = result.getOrElse(() => <String, dynamic>{});
        expect(rightValue['valid'], isTrue);
        expect(rightValue['action'], equals('teleport_executed'));
        
        // Verify server function was called
        verify(mockSupabase.rpc('process_action_card', params: {
          'p_game_state_id': gameStateId,
          'p_player_id': playerId,
          'p_action_card_type': 'teleport',
          'p_target_data': targetData,
        })).called(1);
      });

      test('should advance turn with server management', () async {
        // Given
        const gameStateId = 'game-456';

        // Mock successful turn advancement
        when(mockSupabase.rpc('advance_turn', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'valid': true,
              'next_player': 'player-2',
            });

        // When
        final result = await syncUseCase.advanceTurn(
          gameStateId: gameStateId,
        );

        // Then
        expect(result['valid'], isTrue);
        expect(result['next_player'], equals('player-2'));
        
        // Verify server function was called
        verify(mockSupabase.rpc('advance_turn', params: {
          'p_game_state_id': gameStateId,
        })).called(1);
      });

      test('should detect end game conditions server-side', () async {
        // Given
        const gameStateId = 'game-456';

        // Mock game end detection
        when(mockSupabase.rpc('check_end_game_conditions', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'game_ended': true,
              'winner_id': 'player-2',
              'trigger_player': 'player-1',
              'penalty_applied': true,
            });

        // When
        final result = await syncUseCase.checkEndGameConditions(
          gameStateId: gameStateId,
        );

        // Then
        expect(result['game_ended'], isTrue);
        expect(result['winner_id'], equals('player-2'));
        expect(result['penalty_applied'], isTrue);
        
        // Verify server function was called
        verify(mockSupabase.rpc('check_end_game_conditions', params: {
          'p_game_state_id': gameStateId,
        })).called(1);
      });
    });

    group('Error Handling', () {
      test('should handle invalid card reveal gracefully', () async {
        // Given
        const gameStateId = 'game-456';
        const playerId = 'player-1';
        const position = 0;

        // Mock invalid card reveal
        when(mockSupabase.rpc('process_card_reveal', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'valid': false,
              'error': 'Card already revealed',
            });

        // When & Then
        expect(
          () => syncUseCase.revealCard(
            gameStateId: gameStateId,
            playerId: playerId,
            position: position,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Card already revealed'),
          )),
        );
      });

      test('should handle invalid action card use gracefully', () async {
        // Given
        const gameStateId = 'game-456';
        const playerId = 'player-1';
        const actionCardType = ActionCardType.teleport;

        // Mock invalid action card use
        when(mockSupabase.rpc('process_action_card', params: anyNamed('params')))
            .thenAnswer((_) async => {
              'valid': false,
              'error': 'Not your turn',
            });

        final params = UseActionCardParams(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
        );

        // When
        final result = await actionCardUseCase.call(params);

        // Then
        expect(result.isLeft(), isTrue);
        final leftValue = result.fold((l) => l, (r) => null);
        expect(leftValue?.message, contains('Not your turn'));
      });

      test('should handle database connection errors', () async {
        // Given
        const gameStateId = 'game-456';

        // Mock database connection error
        when(mockSupabase.rpc('check_end_game_conditions', params: anyNamed('params')))
            .thenThrow(Exception('Database connection failed'));

        // When & Then
        expect(
          () => syncUseCase.checkEndGameConditions(
            gameStateId: gameStateId,
          ),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to check end game conditions'),
          )),
        );
      });
    });

    group('Real-time Synchronization', () {
      test('should provide game state streams', () async {
        // Given
        const gameStateId = 'game-456';

        // Mock stream setup
        when(mockSupabase.from('game_states'))
            .thenReturn(MockSupabaseStreamBuilder());

        // When
        final stream = syncUseCase.watchGameState(gameStateId);

        // Then
        expect(stream, isA<Stream<GameState>>());
      });

      test('should provide player grid streams', () async {
        // Given
        const gameStateId = 'game-456';
        const playerId = 'player-1';

        // Mock stream setup
        when(mockSupabase.from('player_grids'))
            .thenReturn(MockSupabaseStreamBuilder());

        // When
        final stream = syncUseCase.watchPlayerGrid(
          gameStateId: gameStateId,
          playerId: playerId,
        );

        // Then
        expect(stream, isA<Stream<PlayerGrid>>());
      });

      test('should provide game actions stream', () async {
        // Given
        const gameStateId = 'game-456';

        // Mock stream setup
        when(mockSupabase.from('game_actions'))
            .thenReturn(MockSupabaseStreamBuilder());

        // When
        final stream = syncUseCase.watchGameActions(gameStateId);

        // Then
        expect(stream, isA<Stream<Map<String, dynamic>>>());
      });
    });
  });
}

// Mock classes for testing
class MockSupabaseQueryBuilder extends Mock {
  // Mock implementation
}

class MockSupabaseStreamBuilder extends Mock {
  // Mock implementation  
}