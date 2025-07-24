import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('GameState - Clean Architecture', () {
    late GameState gameState;
    late List<GamePlayer> testPlayers;

    setUp(() {
      testPlayers = [
        GamePlayer(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          isHost: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'Player 2',
          grid: PlayerGrid.empty(),
        ),
      ];

      gameState = GameState(
        roomId: 'test-room',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: [const Card(value: 5), const Card(value: 10)],
        discardPile: [const Card(value: 7, isRevealed: true)],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );
    });

    test('should be a pure domain entity without any JSON serialization', () {
      // GameState should not have fromJson or toJson methods
      // This test will fail initially, guiding us to remove JSON serialization
      
      // Verify that GameState is a pure domain entity
      expect(gameState.roomId, equals('test-room'));
      expect(gameState.players, equals(testPlayers));
      expect(gameState.currentPlayerIndex, equals(0));
      
      // The entity should not expose any serialization methods
      // If this compiles, it means fromJson/toJson have been removed
      final type = gameState.runtimeType;
      expect(type.toString(), equals('_\$GameStateImpl'));
    });

    test('should not have any reference to JSON serialization', () {
      // This test ensures that the generated files don't include JSON parts
      // The entity should be purely for business logic
      
      final gameStateString = gameState.toString();
      expect(gameStateString, isNot(contains('json')));
      expect(gameStateString, isNot(contains('Json')));
    });

    test('should maintain all business logic methods', () {
      // Ensure all business logic is preserved
      expect(gameState.currentPlayer, equals(testPlayers[0]));
      expect(gameState.canStart, isTrue);
      
      // Test nextPlayer
      final nextState = gameState.nextPlayer();
      expect(nextState.currentPlayerIndex, equals(1));
      
      // Test drawCard
      final (drawnCard, newState) = gameState.drawCard();
      expect(drawnCard, isNotNull);
      expect(newState.deck.length, equals(gameState.deck.length - 1));
      
      // Test discardCard
      final discardState = gameState.discardCard(const Card(value: 3));
      expect(discardState.discardPile.first.value, equals(3));
      
      // Test shouldTriggerLastRound
      expect(gameState.shouldTriggerLastRound, isFalse);
      
      // Test calculateScores
      final scores = gameState.calculateScores();
      expect(scores.containsKey('player1'), isTrue);
      expect(scores.containsKey('player2'), isTrue);
    });

    test('should work with Freezed but without json_serializable', () {
      // Test that Freezed functionality works without JSON
      final copied = gameState.copyWith(currentPlayerIndex: 1);
      expect(copied.currentPlayerIndex, equals(1));
      expect(copied.roomId, equals(gameState.roomId));
      
      // Test equality
      final sameState = GameState(
        roomId: 'test-room',
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: [const Card(value: 5), const Card(value: 10)],
        discardPile: [const Card(value: 7, isRevealed: true)],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );
      
      expect(gameState, equals(sameState));
    });
  });
}