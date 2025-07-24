import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/models/game_state_model.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('GameStateModel - Complete Mapping', () {
    late GameState domainGameState;
    late List<GamePlayer> testPlayers;
    late List<Card> testDeck;
    late List<Card> testDiscardPile;
    late List<ActionCard> testActionDeck;

    setUp(() {
      testPlayers = [
        GamePlayer(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          actionCards: [
            const ActionCard(
              id: 'action1',
              type: ActionCardType.teleport,
              name: 'Teleport',
              description: 'Teleport a card',
            ),
          ],
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'Player 2',
          grid: PlayerGrid.empty(),
        ),
      ];

      testDeck = List.generate(
        10, 
        (i) => Card(value: i + 1, isRevealed: false),
      );

      testDiscardPile = [
        const Card(value: 5, isRevealed: true),
        const Card(value: 10, isRevealed: true),
      ];

      testActionDeck = [
        const ActionCard(
          id: 'action2',
          type: ActionCardType.swap,
          name: 'Swap',
          description: 'Swap two cards',
        ),
      ];

      domainGameState = GameState(
        roomId: 'test-room-123',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: testDeck,
        discardPile: testDiscardPile,
        actionDeck: testActionDeck,
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        initiatorPlayerId: 'player1',
        endRoundInitiator: null,
        drawnCard: const Card(value: 7),
        createdAt: DateTime(2024, 1, 1),
        startedAt: DateTime(2024, 1, 1, 10, 0),
        finishedAt: null,
      );
    });

    test('should have toDomainComplete method that reconstructs full GameState', () {
      // This test will initially fail, guiding us to implement toDomainComplete
      
      // Create a GameStateModel from database representation
      final model = GameStateModel(
        id: 'game-123',
        roomId: 'test-room-123',
        status: 'playing',
        currentPlayerId: 'player1',
        turnNumber: 5,
        roundNumber: 1,
        gameData: {
          'players': testPlayers.map((p) => {
            'id': p.id,
            'name': p.name,
            'grid': {
              'cards': p.grid.cards.map((row) => 
            row.map((c) => c != null ? {
              'value': c.value,
              'isRevealed': c.isRevealed,
            } : null).toList()
          ).toList(),
            },
            'actionCards': p.actionCards.map((a) => {
              'id': a.id,
              'type': a.type.name,
              'name': a.name,
              'description': a.description,
              'timing': a.timing.name,
              'target': a.target.name,
              'parameters': a.parameters,
            }).toList(),
            'isConnected': p.isConnected,
            'isHost': p.isHost,
            'hasFinishedRound': p.hasFinishedRound,
            'scoreMultiplier': p.scoreMultiplier,
          }).toList(),
          'currentPlayerIndex': 0,
          'deck': testDeck.map((c) => {
            'value': c.value,
            'isRevealed': c.isRevealed,
          }).toList(),
          'discardPile': testDiscardPile.map((c) => {
            'value': c.value,
            'isRevealed': c.isRevealed,
          }).toList(),
          'actionDeck': testActionDeck.map((a) => {
            'id': a.id,
            'type': a.type.name,
            'name': a.name,
            'description': a.description,
            'timing': a.timing.name,
            'target': a.target.name,
            'parameters': a.parameters,
          }).toList(),
          'actionDiscard': [],
          'turnDirection': 'clockwise',
          'lastRound': false,
          'initiatorPlayerId': 'player1',
          'endRoundInitiator': null,
          'drawnCard': {'value': 7, 'isRevealed': false},
          'startedAt': DateTime(2024, 1, 1, 10, 0).toIso8601String(),
        },
        winnerId: null,
        endedAt: null,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1, 10, 30),
      );

      // Convert to domain
      final reconstructed = model.toDomainComplete();

      // Verify all properties are correctly mapped
      expect(reconstructed.roomId, equals('test-room-123'));
      expect(reconstructed.status, equals(GameStatus.playing));
      expect(reconstructed.players.length, equals(2));
      expect(reconstructed.players[0].id, equals('player1'));
      expect(reconstructed.players[0].name, equals('Player 1'));
      expect(reconstructed.players[0].actionCards.length, equals(1));
      expect(reconstructed.currentPlayerIndex, equals(0));
      expect(reconstructed.deck.length, equals(10));
      expect(reconstructed.discardPile.length, equals(2));
      expect(reconstructed.actionDeck.length, equals(1));
      expect(reconstructed.turnDirection, equals(TurnDirection.clockwise));
      expect(reconstructed.lastRound, isFalse);
      expect(reconstructed.initiatorPlayerId, equals('player1'));
      expect(reconstructed.drawnCard?.value, equals(7));
      expect(reconstructed.startedAt, equals(DateTime(2024, 1, 1, 10, 0)));
      expect(reconstructed.createdAt, equals(DateTime(2024, 1, 1)));
    });

    test('should have fromDomainComplete method for complete persistence', () {
      // This test will initially fail, guiding us to implement fromDomainComplete
      
      // Convert domain to model
      final model = GameStateModel.fromDomainComplete(
        domainGameState,
        id: 'game-123',
        turnNumber: 5,
        roundNumber: 1,
        updatedAt: DateTime(2024, 1, 1, 10, 30),
      );

      // Verify the model structure
      expect(model.id, equals('game-123'));
      expect(model.roomId, equals('test-room-123'));
      expect(model.status, equals('playing'));
      expect(model.currentPlayerId, equals('player1'));
      expect(model.turnNumber, equals(5));
      expect(model.roundNumber, equals(1));
      expect(model.gameData['players'], isA<List>());
      expect((model.gameData['players'] as List).length, equals(2));
      expect(model.gameData['currentPlayerIndex'], equals(0));
      expect(model.gameData['deck'], isA<List>());
      expect((model.gameData['deck'] as List).length, equals(10));
      expect(model.gameData['discardPile'], isA<List>());
      expect(model.gameData['actionDeck'], isA<List>());
      expect(model.gameData['turnDirection'], equals('clockwise'));
      expect(model.gameData['drawnCard'], isNotNull);
      expect(model.createdAt, equals(DateTime(2024, 1, 1)));
      expect(model.updatedAt, equals(DateTime(2024, 1, 1, 10, 30)));
    });

    test('should handle round-trip conversion without data loss', () {
      // Convert domain -> model -> domain
      final model = GameStateModel.fromDomainComplete(
        domainGameState,
        id: 'game-123',
        turnNumber: 5,
        roundNumber: 1,
        updatedAt: DateTime.now(),
      );
      
      final reconstructed = model.toDomainComplete();

      // Core properties should match
      expect(reconstructed.roomId, equals(domainGameState.roomId));
      expect(reconstructed.status, equals(domainGameState.status));
      expect(reconstructed.players.length, equals(domainGameState.players.length));
      expect(reconstructed.currentPlayerIndex, equals(domainGameState.currentPlayerIndex));
      expect(reconstructed.deck.length, equals(domainGameState.deck.length));
      expect(reconstructed.discardPile.length, equals(domainGameState.discardPile.length));
      expect(reconstructed.actionDeck.length, equals(domainGameState.actionDeck.length));
      expect(reconstructed.turnDirection, equals(domainGameState.turnDirection));
      expect(reconstructed.lastRound, equals(domainGameState.lastRound));
      expect(reconstructed.initiatorPlayerId, equals(domainGameState.initiatorPlayerId));
      expect(reconstructed.drawnCard?.value, equals(domainGameState.drawnCard?.value));
    });

    test('should handle null optional fields correctly', () {
      final minimalGameState = GameState(
        roomId: 'minimal-room',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'Player 1',
            grid: PlayerGrid.empty(),
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      final model = GameStateModel.fromDomainComplete(
        minimalGameState,
        id: 'minimal-game',
        turnNumber: 0,
        roundNumber: 0,
        updatedAt: DateTime.now(),
      );

      final reconstructed = model.toDomainComplete();

      expect(reconstructed.initiatorPlayerId, isNull);
      expect(reconstructed.endRoundInitiator, isNull);
      expect(reconstructed.drawnCard, isNull);
      expect(reconstructed.startedAt, isNull);
      expect(reconstructed.finishedAt, isNull);
    });

    test('should properly serialize to Supabase JSON format', () {
      final model = GameStateModel.fromDomainComplete(
        domainGameState,
        id: 'game-123',
        turnNumber: 5,
        roundNumber: 1,
        updatedAt: DateTime(2024, 1, 1, 10, 30),
      );

      final json = model.toSupabaseJson();

      expect(json['id'], equals('game-123'));
      expect(json['room_id'], equals('test-room-123'));
      expect(json['status'], equals('playing'));
      expect(json['current_player_id'], equals('player1'));
      expect(json['turn_number'], equals(5));
      expect(json['round_number'], equals(1));
      expect(json['game_data'], isA<Map<String, dynamic>>());
      expect(json['created_at'], equals('2024-01-01T00:00:00.000'));
      expect(json['updated_at'], equals('2024-01-01T10:30:00.000'));
    });
  });
}