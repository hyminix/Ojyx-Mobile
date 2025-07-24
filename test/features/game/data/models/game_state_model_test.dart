import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';

void main() {
  group('GameStateModel', () {
    late List<GamePlayer> testPlayers;
    late List<Card> testDeck;
    late List<Card> testDiscardPile;
    late List<ActionCard> testActionDeck;
    late List<ActionCard> testActionDiscard;

    setUp(() {
      testPlayers = [
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

      testDeck = [
        const Card(value: 5, isRevealed: false),
        const Card(value: 10, isRevealed: false),
      ];

      testDiscardPile = [const Card(value: 7, isRevealed: true)];

      testActionDeck = [
        const ActionCard(
          id: 'action1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport to a new position',
        ),
      ];

      testActionDiscard = [];
    });

    test('should create GameStateModel with all required fields', () {
      // Act
      final model = GameStateModel(
        roomId: 'room123',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: testActionDiscard,
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Assert
      expect(model.roomId, equals('room123'));
      expect(model.players, equals(testPlayers));
      expect(model.currentPlayerIndex, equals(0));
      expect(model.deck, equals(testDeck));
      expect(model.discardPile, equals(testDiscardPile));
      expect(model.actionDeck, equals(testActionDeck));
      expect(model.actionDiscard, equals(testActionDiscard));
      expect(model.status, equals(GameStatus.waitingToStart));
      expect(model.turnDirection, equals(TurnDirection.clockwise));
      expect(model.lastRound, isFalse);
    });

    test('should create GameStateModel with optional fields', () {
      // Arrange
      final now = DateTime.now();
      final drawnCard = const Card(value: 3, isRevealed: false);

      // Act
      final model = GameStateModel(
        roomId: 'room123',
        players: testPlayers,
        currentPlayerIndex: 1,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: testActionDiscard,
        status: GameStatus.playing,
        turnDirection: TurnDirection.counterClockwise,
        lastRound: true,
        initiatorPlayerId: 'player1',
        endRoundInitiator: 'player2',
        drawnCard: drawnCard,
        createdAt: now,
        startedAt: now,
        finishedAt: null,
      );

      // Assert
      expect(model.initiatorPlayerId, equals('player1'));
      expect(model.endRoundInitiator, equals('player2'));
      expect(model.drawnCard, equals(drawnCard));
      expect(model.createdAt, equals(now));
      expect(model.startedAt, equals(now));
      expect(model.finishedAt, isNull);
    });

    group('Domain conversion', () {
      test('should convert from domain entity correctly', () {
        // Arrange
        final now = DateTime.now();
        final gameState = GameState(
          roomId: 'room456',
          players: testPlayers,
          currentPlayerIndex: 1,
          deck: testDeck,
          discardPile: testDiscardPile,
          actionDeck: testActionDeck,
          actionDiscard: testActionDiscard,
          status: GameStatus.playing,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
          initiatorPlayerId: 'player1',
          endRoundInitiator: null,
          drawnCard: null,
          createdAt: now,
          startedAt: now,
          finishedAt: null,
        );

        // Act
        final model = GameStateModel.fromDomain(gameState);

        // Assert
        expect(model.roomId, equals(gameState.roomId));
        expect(model.players, equals(gameState.players));
        expect(model.currentPlayerIndex, equals(gameState.currentPlayerIndex));
        expect(model.deck, equals(gameState.deck));
        expect(model.discardPile, equals(gameState.discardPile));
        expect(model.actionDeck, equals(gameState.actionDeck));
        expect(model.actionDiscard, equals(gameState.actionDiscard));
        expect(model.status, equals(gameState.status));
        expect(model.turnDirection, equals(gameState.turnDirection));
        expect(model.lastRound, equals(gameState.lastRound));
        expect(model.initiatorPlayerId, equals(gameState.initiatorPlayerId));
        expect(model.endRoundInitiator, equals(gameState.endRoundInitiator));
        expect(model.drawnCard, equals(gameState.drawnCard));
        expect(model.createdAt, equals(gameState.createdAt));
        expect(model.startedAt, equals(gameState.startedAt));
        expect(model.finishedAt, equals(gameState.finishedAt));
      });

      test('should convert to domain entity correctly', () {
        // Arrange
        final now = DateTime.now();
        final model = GameStateModel(
          roomId: 'room789',
          players: testPlayers,
          currentPlayerIndex: 0,
          deck: testDeck,
          discardPile: testDiscardPile,
          actionDeck: testActionDeck,
          actionDiscard: testActionDiscard,
          status: GameStatus.finished,
          turnDirection: TurnDirection.counterClockwise,
          lastRound: true,
          initiatorPlayerId: 'player2',
          endRoundInitiator: 'player1',
          drawnCard: null,
          createdAt: now,
          startedAt: now,
          finishedAt: now,
        );

        // Act
        final domainEntity = model.toDomain();

        // Assert
        expect(domainEntity.roomId, equals(model.roomId));
        expect(domainEntity.players, equals(model.players));
        expect(
          domainEntity.currentPlayerIndex,
          equals(model.currentPlayerIndex),
        );
        expect(domainEntity.deck, equals(model.deck));
        expect(domainEntity.discardPile, equals(model.discardPile));
        expect(domainEntity.actionDeck, equals(model.actionDeck));
        expect(domainEntity.actionDiscard, equals(model.actionDiscard));
        expect(domainEntity.status, equals(model.status));
        expect(domainEntity.turnDirection, equals(model.turnDirection));
        expect(domainEntity.lastRound, equals(model.lastRound));
        expect(domainEntity.initiatorPlayerId, equals(model.initiatorPlayerId));
        expect(domainEntity.endRoundInitiator, equals(model.endRoundInitiator));
        expect(domainEntity.drawnCard, equals(model.drawnCard));
        expect(domainEntity.createdAt, equals(model.createdAt));
        expect(domainEntity.startedAt, equals(model.startedAt));
        expect(domainEntity.finishedAt, equals(model.finishedAt));
      });

      test('should maintain data integrity through round-trip conversion', () {
        // Arrange
        final gameState = GameState(
          roomId: 'room999',
          players: testPlayers,
          currentPlayerIndex: 1,
          deck: testDeck,
          discardPile: testDiscardPile,
          actionDeck: testActionDeck,
          actionDiscard: testActionDiscard,
          status: GameStatus.playing,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
          createdAt: DateTime.now(),
        );

        // Act
        final model = GameStateModel.fromDomain(gameState);
        final convertedBack = model.toDomain();

        // Assert
        expect(convertedBack, equals(gameState));
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        // Arrange
        final now = DateTime.now();
        final model = GameStateModel(
          roomId: 'room123',
          players: testPlayers,
          currentPlayerIndex: 0,
          deck: testDeck,
          discardPile: testDiscardPile,
          actionDeck: testActionDeck,
          actionDiscard: testActionDiscard,
          status: GameStatus.waitingToStart,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
          createdAt: now,
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['room_id'], equals('room123'));
        expect(json['current_player_index'], equals(0));
        expect(json['status'], equals('waitingToStart'));
        expect(json['turn_direction'], equals('clockwise'));
        expect(json['last_round'], isFalse);
        expect(json['players'], isA<List>());
        expect(json['deck'], isA<List>());
        expect(json['discard_pile'], isA<List>());
        expect(json['action_deck'], isA<List>());
        expect(json['action_discard'], isA<List>());
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final now = DateTime.now();
        final json = {
          'room_id': 'room456',
          'players': testPlayers.map((p) => p.toJson()).toList(),
          'current_player_index': 1,
          'deck': testDeck.map((c) => c.toJson()).toList(),
          'discard_pile': testDiscardPile.map((c) => c.toJson()).toList(),
          'action_deck': testActionDeck.map((c) => c.toJson()).toList(),
          'action_discard': [],
          'status': 'playing',
          'turn_direction': 'counterClockwise',
          'last_round': true,
          'initiator_player_id': 'player1',
          'end_round_initiator': null,
          'drawn_card': null,
          'created_at': now.toIso8601String(),
          'started_at': now.toIso8601String(),
          'finished_at': null,
        };

        // Act
        final model = GameStateModel.fromJson(json);

        // Assert
        expect(model.roomId, equals('room456'));
        expect(model.currentPlayerIndex, equals(1));
        expect(model.status, equals(GameStatus.playing));
        expect(model.turnDirection, equals(TurnDirection.counterClockwise));
        expect(model.lastRound, isTrue);
        expect(model.initiatorPlayerId, equals('player1'));
        expect(model.players.length, equals(2));
        expect(model.deck.length, equals(2));
        expect(model.discardPile.length, equals(1));
        expect(model.actionDeck.length, equals(1));
      });
    });

    test('should support equality comparison', () {
      // Arrange
      final model1 = GameStateModel(
        roomId: 'room123',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: testActionDiscard,
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      final model2 = GameStateModel(
        roomId: 'room123',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: testActionDiscard,
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      final model3 = GameStateModel(
        roomId: 'room456',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: testActionDiscard,
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Assert
      expect(model1, equals(model2));
      expect(model1, isNot(equals(model3)));
    });
  });
}
