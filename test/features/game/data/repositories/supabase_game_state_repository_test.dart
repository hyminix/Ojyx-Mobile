import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/game/data/repositories/supabase_game_state_repository.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/data/models/player_grid_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/data/models/db_player_grid_model.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as domain;

class MockSupabaseClient extends Mock implements SupabaseClient {}
class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder<dynamic> {}
class MockPostgrestFilterBuilder extends Mock implements PostgrestFilterBuilder<dynamic> {}
class MockPostgrestResponse extends Mock implements PostgrestResponse<dynamic> {}

void main() {
  group('SupabaseGameStateRepository', () {
    late SupabaseGameStateRepository repository;
    late MockSupabaseClient mockSupabase;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late MockPostgrestFilterBuilder mockFilterBuilder;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      mockFilterBuilder = MockPostgrestFilterBuilder();
      repository = SupabaseGameStateRepository(mockSupabase);
    });

    setUpAll(() {
      registerFallbackValue(<String, dynamic>{});
    });

    group('initializeGame', () {
      test('should initialize game successfully', () async {
        final rpcResponse = {
          'valid': true,
          'game_state_id': 'game123',
        };

        final gameStateResponse = {
          'id': 'game123',
          'room_id': 'room123',
          'current_player_index': 0,
          'turn_direction': 'clockwise',
          'game_status': 'in_progress',
          'round_number': 1,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'players': [],
          'deck': {
            'draw_pile': [],
            'discard_pile': [],
          },
        };

        when(() => mockSupabase.rpc(
          'initialize_game',
          params: any(named: 'params'),
        )).thenAnswer((_) async => rpcResponse);

        when(() => mockSupabase.from('game_states'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => gameStateResponse);

        final result = await repository.initializeGame(
          roomId: 'room123',
          playerIds: ['player1', 'player2'],
          creatorId: 'player1',
        );

        expect(result.id, 'game123');
        expect(result.roomId, 'room123');
        verify(() => mockSupabase.rpc(
          'initialize_game',
          params: {
            'p_room_id': 'room123',
            'p_player_ids': ['player1', 'player2'],
            'p_creator_id': 'player1',
          },
        )).called(1);
      });

      test('should throw exception when initialization fails', () async {
        final rpcResponse = {
          'valid': false,
          'error': 'Room not found',
        };

        when(() => mockSupabase.rpc(
          'initialize_game',
          params: any(named: 'params'),
        )).thenAnswer((_) async => rpcResponse);

        expect(
          () => repository.initializeGame(
            roomId: 'invalid',
            playerIds: ['player1'],
            creatorId: 'player1',
          ),
          throwsException,
        );
      });
    });

    group('getGameState', () {
      test('should return game state when found', () async {
        final response = {
          'id': 'game123',
          'room_id': 'room123',
          'current_player_index': 0,
          'turn_direction': 'clockwise',
          'game_status': 'in_progress',
          'round_number': 1,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'players': [],
          'deck': {
            'draw_pile': [],
            'discard_pile': [],
          },
        };

        when(() => mockSupabase.from('game_states'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await repository.getGameState('game123');

        expect(result, isNotNull);
        expect(result!.id, 'game123');
      });

      test('should return null when game state not found', () async {
        when(() => mockSupabase.from('game_states'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'nonexistent'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenThrow(Exception('No rows found'));

        final result = await repository.getGameState('nonexistent');

        expect(result, isNull);
      });
    });

    group('watchGameState', () {
      test('should stream game state updates', () async {
        final gameStateData = {
          'id': 'game123',
          'room_id': 'room123',
          'current_player_index': 0,
          'turn_direction': 'clockwise',
          'game_status': 'in_progress',
          'round_number': 1,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'players': [],
          'deck': {
            'draw_pile': [],
            'discard_pile': [],
          },
        };

        when(() => mockSupabase.from('game_states'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'game123'))
            .thenReturn(Stream.value([gameStateData]));

        final stream = repository.watchGameState('game123');

        await expectLater(
          stream,
          emits(isA<GameState>().having((gs) => gs.id, 'id', 'game123')),
        );
      });

      test('should throw exception when stream is empty', () async {
        when(() => mockSupabase.from('game_states'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('id', 'game123'))
            .thenReturn(Stream.value([]));

        final stream = repository.watchGameState('game123');

        await expectLater(stream, emitsError(isException));
      });
    });

    group('getPlayerGrid', () {
      test('should return player grid when found', () async {
        final response = {
          'id': 'grid123',
          'game_state_id': 'game123',
          'player_id': 'player1',
          'grid_cards': [],
          'action_cards': [],
          'score': 0,
          'position': 0,
          'is_active': true,
          'has_revealed_all': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        when(() => mockSupabase.from('player_grids'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'player1'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenAnswer((_) async => response);

        final result = await repository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'player1',
        );

        expect(result, isNotNull);
        expect(result!.id, 'grid123');
      });

      test('should return null when player grid not found', () async {
        when(() => mockSupabase.from('player_grids'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('player_id', 'nonexistent'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.single())
            .thenThrow(Exception('No rows found'));

        final result = await repository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'nonexistent',
        );

        expect(result, isNull);
      });
    });

    group('revealCard', () {
      test('should reveal card successfully', () async {
        final response = {
          'valid': true,
          'revealed_value': 5,
          'column_completed': false,
        };

        when(() => mockSupabase.rpc(
          'process_card_reveal',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.revealCard(
          gameStateId: 'game123',
          playerId: 'player1',
          position: 0,
        );

        expect(result['valid'], isTrue);
        expect(result['revealed_value'], 5);
        verify(() => mockSupabase.rpc(
          'process_card_reveal',
          params: {
            'p_game_state_id': 'game123',
            'p_player_id': 'player1',
            'p_position': 0,
          },
        )).called(1);
      });

      test('should throw exception when reveal fails', () async {
        final response = {
          'valid': false,
          'error': 'Not your turn',
        };

        when(() => mockSupabase.rpc(
          'process_card_reveal',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        expect(
          () => repository.revealCard(
            gameStateId: 'game123',
            playerId: 'player1',
            position: 0,
          ),
          throwsException,
        );
      });
    });

    group('useActionCard', () {
      test('should use action card successfully', () async {
        final response = {
          'valid': true,
          'action_applied': 'teleport',
        };

        when(() => mockSupabase.rpc(
          'process_action_card',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.useActionCard(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.teleport,
          targetData: {'position1': 0, 'position2': 1},
        );

        expect(result['valid'], isTrue);
        expect(result['action_applied'], 'teleport');
      });

      test('should handle empty target data', () async {
        final response = {
          'valid': true,
          'action_applied': 'turnAround',
        };

        when(() => mockSupabase.rpc(
          'process_action_card',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.useActionCard(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.turnAround,
        );

        expect(result['valid'], isTrue);
        verify(() => mockSupabase.rpc(
          'process_action_card',
          params: {
            'p_game_state_id': 'game123',
            'p_player_id': 'player1',
            'p_action_card_type': 'turnAround',
            'p_target_data': {},
          },
        )).called(1);
      });
    });

    group('advanceTurn', () {
      test('should advance turn successfully', () async {
        final response = {
          'valid': true,
          'new_current_player_index': 1,
        };

        when(() => mockSupabase.rpc(
          'advance_turn',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.advanceTurn(gameStateId: 'game123');

        expect(result['valid'], isTrue);
        expect(result['new_current_player_index'], 1);
      });
    });

    group('checkEndGameConditions', () {
      test('should check end game conditions', () async {
        final response = {
          'game_ended': false,
          'winner_id': null,
          'final_scores': {},
        };

        when(() => mockSupabase.rpc(
          'check_end_game_conditions',
          params: any(named: 'params'),
        )).thenAnswer((_) async => response);

        final result = await repository.checkEndGameConditions(
          gameStateId: 'game123',
        );

        expect(result['game_ended'], isFalse);
        expect(result['winner_id'], isNull);
      });
    });

    group('getAllPlayerGrids', () {
      test('should return all player grids', () async {
        final response = [
          {
            'id': 'grid1',
            'game_state_id': 'game123',
            'player_id': 'player1',
            'grid_cards': [],
            'action_cards': [],
            'score': 10,
            'position': 0,
            'is_active': true,
            'has_revealed_all': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
          {
            'id': 'grid2',
            'game_state_id': 'game123',
            'player_id': 'player2',
            'grid_cards': [],
            'action_cards': [],
            'score': 15,
            'position': 1,
            'is_active': true,
            'has_revealed_all': false,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          },
        ];

        when(() => mockSupabase.from('player_grids'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('position'))
            .thenAnswer((_) async => response);

        final result = await repository.getAllPlayerGrids('game123');

        expect(result.length, 2);
        expect(result[0].playerId, 'player1');
        expect(result[1].playerId, 'player2');
      });
    });

    group('getGameActions', () {
      test('should get game actions with limit', () async {
        final response = [
          {'id': '1', 'action': 'reveal_card', 'player_id': 'player1'},
          {'id': '2', 'action': 'use_action_card', 'player_id': 'player2'},
        ];

        when(() => mockSupabase.from('game_actions'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.limit(10))
            .thenAnswer((_) async => response);

        final result = await repository.getGameActions(
          gameStateId: 'game123',
          limit: 10,
        );

        expect(result.length, 2);
        expect(result[0]['action'], 'reveal_card');
      });

      test('should get game actions without limit', () async {
        final response = [
          {'id': '1', 'action': 'reveal_card'},
          {'id': '2', 'action': 'use_action_card'},
        ];

        when(() => mockSupabase.from('game_actions'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.select())
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenAnswer((_) async => response);

        final result = await repository.getGameActions(
          gameStateId: 'game123',
        );

        expect(result.length, 2);
      });
    });

    group('watchGameActions', () {
      test('should stream game actions', () async {
        final actionData = [
          {'id': '1', 'action': 'reveal_card', 'player_id': 'player1'},
        ];

        when(() => mockSupabase.from('game_actions'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenReturn(Stream.value(actionData));

        final stream = repository.watchGameActions('game123');

        await expectLater(
          stream,
          emits(actionData.first),
        );
      });

      test('should return empty map when no actions', () async {
        when(() => mockSupabase.from('game_actions'))
            .thenReturn(mockQueryBuilder);
        when(() => mockQueryBuilder.stream(primaryKey: ['id']))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.eq('game_state_id', 'game123'))
            .thenReturn(mockFilterBuilder);
        when(() => mockFilterBuilder.order('created_at', ascending: false))
            .thenReturn(Stream.value([]));

        final stream = repository.watchGameActions('game123');

        await expectLater(
          stream,
          emits(<String, dynamic>{}),
        );
      });
    });
  });
}