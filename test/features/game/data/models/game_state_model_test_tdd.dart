import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import '../../../../helpers/test_data_builders.dart';

void main() {
  group('GameStateModel', () {
    // Test data constants
    const TEST_GAME_ID = 'test-game-123';
    const TEST_ROOM_ID = 'test-room-456';
    const TEST_PLAYER_1_ID = 'player-1';
    const TEST_PLAYER_2_ID = 'player-2';
    
    group('JSON serialization', () {
      test('should_create_model_from_json_when_all_fields_are_present', () {
        // Arrange
        final testDateTime = DateTime.parse('2024-01-25T14:00:00Z');
        final json = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'players': [
            {
              'id': TEST_PLAYER_1_ID,
              'name': 'Player One',
              'grid': {'cards': []},
              'action_cards': [],
              'is_connected': true,
              'is_host': true,
              'has_finished_round': false,
              'score_multiplier': 1,
            },
            {
              'id': TEST_PLAYER_2_ID,
              'name': 'Player Two',
              'grid': {'cards': []},
              'action_cards': [],
              'is_connected': true,
              'is_host': false,
              'has_finished_round': false,
              'score_multiplier': 1,
            },
          ],
          'players_state': {
            TEST_PLAYER_1_ID: {
              'player_id': TEST_PLAYER_1_ID,
              'cards': [],
              'current_score': 0,
              'revealed_count': 0,
              'identical_columns': [],
              'has_finished': false,
            },
            TEST_PLAYER_2_ID: {
              'player_id': TEST_PLAYER_2_ID,
              'cards': [],
              'current_score': 0,
              'revealed_count': 0,
              'identical_columns': [],
              'has_finished': false,
            },
          },
          'current_player_id': TEST_PLAYER_1_ID,
          'deck': {
            'draw_pile': [
              {'value': 5, 'is_revealed': false},
              {'value': 10, 'is_revealed': false},
            ],
            'discard_pile': [
              {'value': 7, 'is_revealed': true},
            ],
          },
          'direction': 'forward',
          'current_round': 1,
          'max_rounds': 5,
          'last_action_time': testDateTime.toIso8601String(),
          'is_last_round': false,
          'last_round_initiator': null,
          'is_paused': false,
        };
        
        // Act
        final model = GameStateModel.fromJson(json);
        
        // Assert
        expect(model.id, equals(TEST_GAME_ID), 
          reason: 'Model ID should match JSON id field');
        expect(model.roomId, equals(TEST_ROOM_ID),
          reason: 'Room ID should be correctly parsed');
        expect(model.players.length, equals(2),
          reason: 'All players should be parsed from JSON');
        expect(model.players.first.id, equals(TEST_PLAYER_1_ID),
          reason: 'First player ID should match');
        expect(model.players.first.isHost, isTrue,
          reason: 'Host status should be preserved');
        expect(model.currentPlayerId, equals(TEST_PLAYER_1_ID),
          reason: 'Current player should be correctly identified');
        expect(model.deck.drawPile.length, equals(2),
          reason: 'Draw pile should contain all cards');
        expect(model.deck.discardPile.length, equals(1),
          reason: 'Discard pile should contain correct cards');
        expect(model.direction, equals(PlayDirection.forward),
          reason: 'Play direction should be parsed correctly');
        expect(model.currentRound, equals(1),
          reason: 'Current round should match JSON value');
        expect(model.maxRounds, equals(5),
          reason: 'Max rounds should be preserved');
        expect(model.lastActionTime, equals(testDateTime),
          reason: 'DateTime should be correctly parsed from ISO string');
        expect(model.isLastRound, isFalse,
          reason: 'Last round flag should be correctly set');
        expect(model.isPaused, isFalse,
          reason: 'Paused state should be correctly parsed');
      });

      test('should_convert_model_to_json_when_serializing', () {
        // Arrange
        final testDateTime = DateTime.parse('2024-01-25T14:00:00Z');
        final model = GameStateModel(
          id: TEST_GAME_ID,
          roomId: TEST_ROOM_ID,
          players: [
            GamePlayerBuilder()
              .withId(TEST_PLAYER_1_ID)
              .withName('Player One')
              .asHost()
              .build(),
            GamePlayerBuilder()
              .withId(TEST_PLAYER_2_ID)
              .withName('Player Two')
              .asGuest()
              .build(),
          ],
          playersState: {
            TEST_PLAYER_1_ID: PlayerStateBuilder()
              .withPlayerId(TEST_PLAYER_1_ID)
              .withCurrentScore(25)
              .withRevealedCount(4)
              .build(),
            TEST_PLAYER_2_ID: PlayerStateBuilder()
              .withPlayerId(TEST_PLAYER_2_ID)
              .withCurrentScore(30)
              .withRevealedCount(3)
              .build(),
          },
          currentPlayerId: TEST_PLAYER_1_ID,
          deck: DeckStateBuilder()
            .withDrawPile([
              CardBuilder().withValue(5).build(),
              CardBuilder().withValue(10).build(),
            ])
            .withDiscardPile([
              CardBuilder().withValue(7).revealed().build(),
            ])
            .build(),
          direction: PlayDirection.forward,
          currentRound: 1,
          maxRounds: 5,
          lastActionTime: testDateTime,
          isLastRound: false,
          lastRoundInitiator: null,
          isPaused: false,
        );
        
        // Act
        final json = model.toJson();
        
        // Assert
        expect(json['id'], equals(TEST_GAME_ID),
          reason: 'ID should be serialized to JSON');
        expect(json['room_id'], equals(TEST_ROOM_ID),
          reason: 'Room ID should use snake_case in JSON');
        expect(json['players'], isA<List>(),
          reason: 'Players should be serialized as array');
        expect(json['players'].length, equals(2),
          reason: 'All players should be included');
        expect(json['current_player_id'], equals(TEST_PLAYER_1_ID),
          reason: 'Current player ID should be serialized');
        expect(json['deck']['draw_pile'].length, equals(2),
          reason: 'Deck draw pile should be fully serialized');
        expect(json['direction'], equals('forward'),
          reason: 'Direction enum should serialize to string');
        expect(json['last_action_time'], equals(testDateTime.toIso8601String()),
          reason: 'DateTime should serialize to ISO8601 string');
      });

      test('should_handle_null_optional_fields_when_parsing_json', () {
        // Arrange
        final minimalJson = {
          'id': TEST_GAME_ID,
          'room_id': TEST_ROOM_ID,
          'players': [],
          'players_state': {},
          'current_player_id': TEST_PLAYER_1_ID,
          'deck': {
            'draw_pile': [],
            'discard_pile': [],
          },
          'direction': 'forward',
          'current_round': 1,
          'max_rounds': 5,
          'last_action_time': DateTime.now().toIso8601String(),
          'is_last_round': false,
          'last_round_initiator': null, // Explicitly null
          'is_paused': false,
        };
        
        // Act
        final model = GameStateModel.fromJson(minimalJson);
        
        // Assert
        expect(model.lastRoundInitiator, isNull,
          reason: 'Null optional fields should remain null');
        expect(model.players, isEmpty,
          reason: 'Empty arrays should be preserved');
        expect(model.playersState, isEmpty,
          reason: 'Empty maps should be preserved');
      });

      test('should_throw_exception_when_required_field_is_missing', () {
        // Arrange
        final invalidJson = {
          'id': TEST_GAME_ID,
          // Missing room_id
          'players': [],
          'players_state': {},
          'current_player_id': TEST_PLAYER_1_ID,
          'deck': {
            'draw_pile': [],
            'discard_pile': [],
          },
        };
        
        // Act & Assert
        expect(
          () => GameStateModel.fromJson(invalidJson),
          throwsA(isA<TypeError>()),
          reason: 'Missing required fields should throw TypeError',
        );
      });
    });

    group('Domain conversion', () {
      test('should_convert_to_domain_entity_when_toDomain_is_called', () {
        // Arrange
        final model = GameStateModel(
          id: TEST_GAME_ID,
          roomId: TEST_ROOM_ID,
          players: [
            GamePlayerBuilder()
              .withId(TEST_PLAYER_1_ID)
              .asHost()
              .build(),
          ],
          playersState: {
            TEST_PLAYER_1_ID: PlayerStateBuilder()
              .withPlayerId(TEST_PLAYER_1_ID)
              .build(),
          },
          currentPlayerId: TEST_PLAYER_1_ID,
          deck: DeckStateBuilder().build(),
          direction: PlayDirection.forward,
          currentRound: 1,
          maxRounds: 5,
          lastActionTime: DateTime.now(),
          isLastRound: false,
          lastRoundInitiator: null,
          isPaused: false,
        );
        
        // Act
        final domainEntity = model.toDomain();
        
        // Assert
        expect(domainEntity, isA<GameState>(),
          reason: 'Should return domain entity type');
        expect(domainEntity.id, equals(TEST_GAME_ID),
          reason: 'Domain entity should have same ID');
        expect(domainEntity.roomId, equals(TEST_ROOM_ID),
          reason: 'All properties should be transferred to domain');
      });

      test('should_create_from_domain_entity_when_fromDomain_is_called', () {
        // Arrange
        final domainEntity = GameStateBuilder()
          .withId(TEST_GAME_ID)
          .withRoomId(TEST_ROOM_ID)
          .withPlayers([
            GamePlayerBuilder()
              .withId(TEST_PLAYER_1_ID)
              .build(),
          ])
          .build();
        
        // Act
        final model = GameStateModel.fromDomain(domainEntity);
        
        // Assert
        expect(model, isA<GameStateModel>(),
          reason: 'Should create model from domain entity');
        expect(model.id, equals(TEST_GAME_ID),
          reason: 'Model should preserve domain entity ID');
        expect(model.roomId, equals(TEST_ROOM_ID),
          reason: 'All domain properties should be preserved');
      });
    });
  });
}