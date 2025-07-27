import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/game/data/datasources/game_state_datasource.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/core/errors/exceptions.dart';
import '../../../../helpers/data_layer_test_helpers.dart';

void main() {
  group('GameStateDataSourceImpl', () {
    late MockSupabaseClient mockClient;
    late GameStateDataSourceImpl dataSource;
    
    // Test constants
    const TEST_GAME_ID = 'game-123';
    const TEST_ROOM_ID = 'room-456';
    const TEST_PLAYER_ID = 'player-789';
    const TABLE_GAME_STATES = 'game_states';
    const TABLE_PLAYER_GRIDS = 'player_grids';
    
    setUp(() {
      mockClient = DataLayerTestUtils.createMockSupabaseClient();
      dataSource = GameStateDataSourceImpl(supabaseClient: mockClient);
    });
    
    group('createGameState', () {
      test('should_create_game_state_when_all_parameters_are_valid', () async {
        // Arrange
        final expectedResponse = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'current_player_id': TEST_PLAYER_ID,
          'round_number': 1,
          'turn_number': 1,
          'game_phase': 'waiting',
          'direction': 'clockwise',
          'deck_count': 150,
          'discard_pile': [],
          'action_cards_deck_count': 21,
          'action_cards_discard': [],
          'round_initiator_id': null,
          'is_last_round': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        DataLayerTestUtils.setupSuccessfulQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          response: [expectedResponse], // Supabase returns array
        );
        
        // Act
        final result = await dataSource.createGameState(
          roomId: TEST_ROOM_ID,
          players: [TEST_PLAYER_ID],
        );
        
        // Assert
        expect(result, isA<GameStateModel>(),
          reason: 'Should return GameStateModel when creation succeeds');
        expect(result.id, equals(TEST_GAME_ID),
          reason: 'Created game state should have server-assigned ID');
        expect(result.roomId, equals(TEST_ROOM_ID),
          reason: 'Room ID should match the provided value');
        
        verify(() => mockClient.from(TABLE_GAME_STATES)).called(1);
      });
      
      test('should_throw_server_exception_when_database_insert_fails', () async {
        // Arrange
        DataLayerTestUtils.setupFailedQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          errorMessage: 'Unique constraint violation',
          errorCode: '23505',
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.createGameState(
            roomId: TEST_ROOM_ID,
            players: [TEST_PLAYER_ID],
          ),
          throwsServerException(withMessage: 'Unique constraint violation'),
          reason: 'Should throw ServerException when database operation fails',
        );
      });
      
      test('should_throw_server_exception_when_response_is_empty', () async {
        // Arrange
        DataLayerTestUtils.setupSuccessfulQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          response: [], // Empty response
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.createGameState(
            roomId: TEST_ROOM_ID,
            players: [TEST_PLAYER_ID],
          ),
          throwsServerException(withMessage: 'Failed to create game state'),
          reason: 'Should throw ServerException when no data is returned',
        );
      });
    });
    
    group('fetchGameState', () {
      test('should_return_game_state_when_fetch_is_successful', () async {
        // Arrange
        final gameStateData = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'current_player_id': TEST_PLAYER_ID,
          'round_number': 2,
          'turn_number': 5,
          'game_phase': 'playing',
          'direction': 'clockwise',
          'deck_count': 140,
          'discard_pile': [
            {'value': 5, 'is_revealed': true},
            {'value': 10, 'is_revealed': true},
          ],
          'action_cards_deck_count': 18,
          'action_cards_discard': [],
          'round_initiator_id': null,
          'is_last_round': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        DataLayerTestUtils.setupSuccessfulQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          response: [gameStateData],
          filters: {'id': TEST_GAME_ID},
        );
        
        // Act
        final result = await dataSource.fetchGameState(TEST_GAME_ID);
        
        // Assert
        expect(result, isA<GameStateModel>(),
          reason: 'Should return GameStateModel on successful fetch');
        expect(result.id, equals(TEST_GAME_ID),
          reason: 'Fetched game state should have requested ID');
        expect(result.currentRound, equals(2),
          reason: 'Round number should be correctly parsed');
        expect(result.deck.discardPile.length, equals(2),
          reason: 'Discard pile cards should be parsed');
      });
      
      test('should_throw_server_exception_when_game_state_not_found', () async {
        // Arrange
        DataLayerTestUtils.setupSuccessfulQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          response: [], // No results
          filters: {'id': TEST_GAME_ID},
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.fetchGameState(TEST_GAME_ID),
          throwsServerException(withMessage: 'Game state not found'),
          reason: 'Should throw when game state does not exist',
        );
      });
      
      test('should_throw_server_exception_when_network_error_occurs', () async {
        // Arrange
        DataLayerTestUtils.setupFailedQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          errorMessage: 'Network timeout',
          errorCode: 'NETWORK_ERROR',
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.fetchGameState(TEST_GAME_ID),
          throwsServerException(withMessage: 'Network timeout'),
          reason: 'Should propagate network errors as ServerException',
        );
      });
    });
    
    group('updateGameState', () {
      test('should_update_game_state_when_valid_updates_provided', () async {
        // Arrange
        final updates = {
          'current_player_id': 'player-next',
          'turn_number': 6,
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        final updatedResponse = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'current_player_id': 'player-next',
          'round_number': 2,
          'turn_number': 6,
          'game_phase': 'playing',
          'direction': 'clockwise',
          'deck_count': 139,
          'discard_pile': [],
          'action_cards_deck_count': 18,
          'action_cards_discard': [],
          'round_initiator_id': null,
          'is_last_round': false,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        
        final queryBuilder = MockSupabaseQueryBuilder();
        final filterBuilder = MockPostgrestFilterBuilder();
        
        when(() => mockClient.from(TABLE_GAME_STATES)).thenReturn(queryBuilder);
        when(() => queryBuilder.update(updates)).thenReturn(filterBuilder);
        when(() => filterBuilder.eq('id', TEST_GAME_ID)).thenReturn(filterBuilder);
        when(() => filterBuilder.select()).thenReturn(filterBuilder);
        when(() => filterBuilder.execute()).thenAnswer(
          (_) async => MockPostgrestResponse()..data = [updatedResponse],
        );
        
        // Act
        final result = await dataSource.updateGameState(TEST_GAME_ID, updates);
        
        // Assert
        expect(result, isA<GameStateModel>(),
          reason: 'Should return updated GameStateModel');
        expect(result.currentPlayerId, equals('player-next'),
          reason: 'Current player should be updated');
        expect(result.turnNumber, equals(6),
          reason: 'Turn number should be incremented');
        
        verify(() => mockClient.from(TABLE_GAME_STATES)).called(1);
        verify(() => filterBuilder.eq('id', TEST_GAME_ID)).called(1);
      });
      
      test('should_throw_server_exception_when_update_fails', () async {
        // Arrange
        final updates = {'current_player_id': 'invalid-player'};
        
        DataLayerTestUtils.setupFailedQuery(
          client: mockClient,
          table: TABLE_GAME_STATES,
          errorMessage: 'Foreign key constraint violation',
          errorCode: '23503',
        );
        
        // Act & Assert
        await expectLater(
          () => dataSource.updateGameState(TEST_GAME_ID, updates),
          throwsServerException(withMessage: 'Foreign key constraint violation'),
          reason: 'Should throw when update violates constraints',
        );
      });
    });
    
    group('watchGameState', () {
      test('should_emit_game_state_updates_when_subscribed_to_changes', () async {
        // Arrange
        final initialState = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'current_player_id': TEST_PLAYER_ID,
          'turn_number': 1,
        };
        
        final updatedState = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'current_player_id': 'player-2',
          'turn_number': 2,
        };
        
        final channel = MockRealtimeChannel();
        final streamController = StreamController<Map<String, dynamic>>();
        
        when(() => mockClient.realtime.channel(any())).thenReturn(channel);
        when(() => channel.onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: TABLE_GAME_STATES,
          filter: 'id=eq.$TEST_GAME_ID',
          callback: any(named: 'callback'),
        )).thenReturn(channel);
        
        when(() => channel.subscribe()).thenAnswer((_) async {
          // Simulate initial state and update
          Future.delayed(Duration(milliseconds: 50), () {
            streamController.add({'new': initialState});
          });
          Future.delayed(Duration(milliseconds: 100), () {
            streamController.add({'new': updatedState});
          });
          return channel;
        });
        
        // Act
        final stream = dataSource.watchGameState(TEST_GAME_ID);
        final emittedStates = <GameStateModel>[];
        
        final subscription = stream.listen(emittedStates.add);
        
        // Simulate realtime updates
        await Future.delayed(Duration(milliseconds: 150));
        
        // Assert
        expect(emittedStates.length, greaterThanOrEqualTo(1),
          reason: 'Should emit at least one state update');
        
        if (emittedStates.length >= 2) {
          expect(emittedStates[1].currentPlayerId, equals('player-2'),
            reason: 'Should emit updated player information');
          expect(emittedStates[1].turnNumber, equals(2),
            reason: 'Should emit updated turn number');
        }
        
        // Cleanup
        await subscription.cancel();
        await streamController.close();
      });
      
      test('should_handle_subscription_errors_gracefully', () async {
        // Arrange
        final channel = MockRealtimeChannel();
        
        when(() => mockClient.realtime.channel(any())).thenReturn(channel);
        when(() => channel.onPostgresChanges(
          event: any(named: 'event'),
          schema: any(named: 'schema'),
          table: any(named: 'table'),
          filter: any(named: 'filter'),
          callback: any(named: 'callback'),
        )).thenReturn(channel);
        
        when(() => channel.subscribe()).thenThrow(
          Exception('WebSocket connection failed'),
        );
        
        // Act & Assert
        expect(
          () => dataSource.watchGameState(TEST_GAME_ID),
          throwsA(isA<Exception>()),
          reason: 'Should propagate subscription errors',
        );
      });
    });
  });
}