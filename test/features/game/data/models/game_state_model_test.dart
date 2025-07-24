import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('GameStateModel', () {
    late GameState testGameState;
    late DateTime testDateTime;
    
    setUp(() {
      testDateTime = DateTime.now();
      
      final testPlayers = [
        GamePlayer(
          id: 'player1',
          name: 'Test GamePlayer 1',
          grid: PlayerGrid.empty(),
          actionCards: [],
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'Test GamePlayer 2',
          grid: PlayerGrid.empty(),
          actionCards: [],
          isHost: false,
        ),
      ];

      final testDeck = [
        const Card(value: 5, isRevealed: false),
        const Card(value: 10, isRevealed: false),
      ];

      final testDiscardPile = [const Card(value: 7, isRevealed: true)];

      final testActionDeck = [
        const ActionCard(
          id: 'action1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport to a new position',
        ),
      ];

      testGameState = GameState(
        roomId: 'room123',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        createdAt: testDateTime,
      );
    });

    test('should create GameStateModel with all required fields', () {
      // Act
      final model = GameStateModel(
        id: 'state123',
        roomId: 'room123',
        status: 'waitingToStart',
        currentPlayerId: 'player1',
        turnNumber: 1,
        roundNumber: 1,
        gameData: {},
        winnerId: null,
        endedAt: null,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      // Assert
      expect(model.id, equals('state123'));
      expect(model.roomId, equals('room123'));
      expect(model.status, equals('waitingToStart'));
      expect(model.currentPlayerId, equals('player1'));
      expect(model.turnNumber, equals(1));
      expect(model.roundNumber, equals(1));
      expect(model.gameData, equals({}));
      expect(model.winnerId, isNull);
      expect(model.endedAt, isNull);
      expect(model.createdAt, equals(testDateTime));
      expect(model.updatedAt, equals(testDateTime));
    });

    group('Domain conversion', () {
      test('should convert from domain entity correctly using fromDomainComplete', () {
        // Act
        final model = GameStateModel.fromDomainComplete(
          testGameState,
          id: 'state123',
          turnNumber: 1,
          roundNumber: 1,
          updatedAt: testDateTime,
        );

        // Assert
        expect(model.id, equals('state123'));
        expect(model.roomId, equals(testGameState.roomId));
        expect(model.status, equals('waitingToStart'));
        expect(model.currentPlayerId, equals('player1')); // First player
        expect(model.turnNumber, equals(1));
        expect(model.roundNumber, equals(1));
        expect(model.gameData, isNotEmpty);
        expect(model.gameData['players'], isA<List>());
        expect(model.gameData['currentPlayerIndex'], equals(0));
        expect(model.gameData['deck'], isA<List>());
        expect(model.gameData['discardPile'], isA<List>());
        expect(model.gameData['actionDeck'], isA<List>());
        expect(model.gameData['actionDiscard'], isA<List>());
        expect(model.gameData['turnDirection'], equals('clockwise'));
        expect(model.gameData['lastRound'], isFalse);
        expect(model.winnerId, isNull);
        expect(model.endedAt, isNull);
        expect(model.createdAt, equals(testGameState.createdAt));
        expect(model.updatedAt, equals(testDateTime));
      });

      test('should convert to domain entity correctly using toDomainComplete', () {
        // Arrange
        final model = GameStateModel.fromDomainComplete(
          testGameState,
          id: 'state123',
          turnNumber: 1,
          roundNumber: 1,
          updatedAt: testDateTime,
        );

        // Act
        final domainEntity = model.toDomainComplete();

        // Assert
        expect(domainEntity.roomId, equals(testGameState.roomId));
        expect(domainEntity.players.length, equals(testGameState.players.length));
        expect(domainEntity.players[0].id, equals(testGameState.players[0].id));
        expect(domainEntity.players[0].name, equals(testGameState.players[0].name));
        expect(domainEntity.currentPlayerIndex, equals(testGameState.currentPlayerIndex));
        expect(domainEntity.deck.length, equals(testGameState.deck.length));
        expect(domainEntity.discardPile.length, equals(testGameState.discardPile.length));
        expect(domainEntity.actionDeck.length, equals(testGameState.actionDeck.length));
        expect(domainEntity.actionDiscard.length, equals(testGameState.actionDiscard.length));
        expect(domainEntity.status, equals(testGameState.status));
        expect(domainEntity.turnDirection, equals(testGameState.turnDirection));
        expect(domainEntity.lastRound, equals(testGameState.lastRound));
        expect(domainEntity.createdAt, equals(testGameState.createdAt));
      });

      test('should maintain data integrity through round-trip conversion', () {
        // Act
        final model = GameStateModel.fromDomainComplete(
          testGameState,
          id: 'state123',
          turnNumber: 1,
          roundNumber: 1,
          updatedAt: testDateTime,
        );
        final convertedBack = model.toDomainComplete();

        // Assert - Check key properties
        expect(convertedBack.roomId, equals(testGameState.roomId));
        expect(convertedBack.players.length, equals(testGameState.players.length));
        expect(convertedBack.currentPlayerIndex, equals(testGameState.currentPlayerIndex));
        expect(convertedBack.status, equals(testGameState.status));
        expect(convertedBack.turnDirection, equals(testGameState.turnDirection));
        expect(convertedBack.lastRound, equals(testGameState.lastRound));
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final model = GameStateModel(
          id: 'state123',
          roomId: 'room123',
          status: 'waitingToStart',
          currentPlayerId: 'player1',
          turnNumber: 1,
          roundNumber: 1,
          gameData: {
            'test': 'data',
            'number': 42,
          },
          winnerId: null,
          endedAt: null,
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], equals('state123'));
        expect(json['room_id'], equals('room123'));
        expect(json['status'], equals('waitingToStart'));
        expect(json['current_player_id'], equals('player1'));
        expect(json['turn_number'], equals(1));
        expect(json['round_number'], equals(1));
        expect(json['game_data'], isA<Map>());
        expect(json['game_data']['test'], equals('data'));
        expect(json['game_data']['number'], equals(42));
        expect(json['winner_id'], isNull);
        expect(json['ended_at'], isNull);
        expect(json['created_at'], equals(testDateTime.toIso8601String()));
        expect(json['updated_at'], equals(testDateTime.toIso8601String()));
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {
          'id': 'state456',
          'room_id': 'room456',
          'status': 'playing',
          'current_player_id': 'player2',
          'turn_number': 5,
          'round_number': 2,
          'game_data': {
            'test': 'value',
            'list': [1, 2, 3],
          },
          'winner_id': null,
          'ended_at': null,
          'created_at': testDateTime.toIso8601String(),
          'updated_at': testDateTime.toIso8601String(),
        };

        // Act
        final model = GameStateModel.fromJson(json);

        // Assert
        expect(model.id, equals('state456'));
        expect(model.roomId, equals('room456'));
        expect(model.status, equals('playing'));
        expect(model.currentPlayerId, equals('player2'));
        expect(model.turnNumber, equals(5));
        expect(model.roundNumber, equals(2));
        expect(model.gameData['test'], equals('value'));
        expect(model.gameData['list'], equals([1, 2, 3]));
        expect(model.winnerId, isNull);
        expect(model.endedAt, isNull);
        expect(model.createdAt.toIso8601String(), equals(testDateTime.toIso8601String()));
        expect(model.updatedAt.toIso8601String(), equals(testDateTime.toIso8601String()));
      });
    });

    test('should support toSupabaseJson conversion', () {
      // Arrange
      final model = GameStateModel(
        id: 'state123',
        roomId: 'room123',
        status: 'finished',
        currentPlayerId: 'player1',
        turnNumber: 10,
        roundNumber: 3,
        gameData: {'key': 'value'},
        winnerId: 'player1',
        endedAt: testDateTime,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      // Act
      final supabaseJson = model.toSupabaseJson();

      // Assert
      expect(supabaseJson['id'], equals('state123'));
      expect(supabaseJson['room_id'], equals('room123'));
      expect(supabaseJson['status'], equals('finished'));
      expect(supabaseJson['current_player_id'], equals('player1'));
      expect(supabaseJson['turn_number'], equals(10));
      expect(supabaseJson['round_number'], equals(3));
      expect(supabaseJson['game_data'], equals({'key': 'value'}));
      expect(supabaseJson['winner_id'], equals('player1'));
      expect(supabaseJson['ended_at'], equals(testDateTime.toIso8601String()));
      expect(supabaseJson['created_at'], equals(testDateTime.toIso8601String()));
      expect(supabaseJson['updated_at'], equals(testDateTime.toIso8601String()));
    });

    test('should support equality comparison', () {
      // Arrange
      final model1 = GameStateModel(
        id: 'state123',
        roomId: 'room123',
        status: 'waitingToStart',
        currentPlayerId: 'player1',
        turnNumber: 1,
        roundNumber: 1,
        gameData: {},
        winnerId: null,
        endedAt: null,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final model2 = GameStateModel(
        id: 'state123',
        roomId: 'room123',
        status: 'waitingToStart',
        currentPlayerId: 'player1',
        turnNumber: 1,
        roundNumber: 1,
        gameData: {},
        winnerId: null,
        endedAt: null,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      final model3 = GameStateModel(
        id: 'state456',
        roomId: 'room123',
        status: 'waitingToStart',
        currentPlayerId: 'player1',
        turnNumber: 1,
        roundNumber: 1,
        gameData: {},
        winnerId: null,
        endedAt: null,
        createdAt: testDateTime,
        updatedAt: testDateTime,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });
  });
}