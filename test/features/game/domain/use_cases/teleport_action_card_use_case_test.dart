import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';
import 'package:ojyx/core/errors/failures.dart';

class FakeActionCardRepository implements ActionCardRepository {
  final Map<String, List<ActionCard>> _playerCards = {};
  final List<ActionCard> _availableCards = [];
  final List<ActionCard> _discardedCards = [];

  @override
  List<ActionCard> getAvailableActionCards() => _availableCards;

  @override
  List<ActionCard> getPlayerActionCards(String playerId) =>
      _playerCards[playerId] ?? [];

  @override
  void addActionCardToPlayer(String playerId, ActionCard card) {
    _playerCards.putIfAbsent(playerId, () => []).add(card);
  }

  @override
  void removeActionCardFromPlayer(String playerId, ActionCard card) {
    _playerCards[playerId]?.remove(card);
  }

  @override
  ActionCard? drawActionCard() {
    if (_availableCards.isEmpty) return null;
    return _availableCards.removeAt(0);
  }

  @override
  void discardActionCard(ActionCard card) {
    _discardedCards.add(card);
  }

  @override
  void shuffleActionCards() {
    _availableCards.shuffle();
  }

  // Helper methods for testing
  void setupPlayerCards(String playerId, List<ActionCard> cards) {
    _playerCards[playerId] = List.from(cards);
  }

  bool wasCardDiscarded(ActionCard card) => _discardedCards.contains(card);
  bool doesPlayerHaveCard(String playerId, ActionCard card) =>
      _playerCards[playerId]?.contains(card) ?? false;
}

void main() {
  group('UseActionCardUseCase - Teleportation', () {
    late UseActionCardUseCase useCase;
    late FakeActionCardRepository repository;
    late GameState gameState;
    late Player player;
    late ActionCard teleportCard;

    setUp(() {
      repository = FakeActionCardRepository();
      useCase = UseActionCardUseCase(repository);

      // Create test cards for grid using fromCards constructor
      final testCards = [
        Card(value: 5),  // (0,0)
        Card(value: 8),  // (0,1)
        Card(value: 1),  // (0,2)
        Card(value: 9),  // (0,3)
        Card(value: 2),  // (1,0)
        Card(value: -1), // (1,1)
        Card(value: 3),  // (1,2)
        Card(value: 7),  // (1,3)
        Card(value: 0),  // (2,0)
        Card(value: 6),  // (2,1)
        Card(value: 4),  // (2,2)
        Card(value: 10), // (2,3)
      ];

      final grid = PlayerGrid.fromCards(testCards);
      player = Player(
        id: 'player1',
        name: 'Test Player',
        grid: grid,
        actionCards: [],
      );

      teleportCard = ActionCard(
        id: 'teleport-1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échange la position de deux cartes',
        timing: ActionTiming.optional,
      );

      gameState = GameState(
        roomId: 'room1',
        players: [player],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Setup player to have the teleport card
      repository.setupPlayerCards('player1', [teleportCard]);
    });

    group('Teleport Success Cases', () {
      test('should swap two cards at different positions', () async {
        // Arrange
        final targetData = {
          'position1': {'row': 0, 'col': 0}, // Card with value 5
          'position2': {'row': 0, 'col': 1}, // Card with value 8
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => gameState);
        final updatedPlayer = updatedState.players.first;
        
        // Card that was at (0,0) should now be at (0,1)
        expect(updatedPlayer.grid.getCard(0, 1)?.value, equals(5));
        // Card that was at (0,1) should now be at (0,0)
        expect(updatedPlayer.grid.getCard(0, 0)?.value, equals(8));

        // Verify card was removed and discarded
        expect(repository.doesPlayerHaveCard('player1', teleportCard), isFalse);
        expect(repository.wasCardDiscarded(teleportCard), isTrue);
      });

      test('should swap cards at same row different columns', () async {
        // Arrange
        final targetData = {
          'position1': {'row': 1, 'col': 0}, // Card with value 2
          'position2': {'row': 1, 'col': 1}, // Card with value -1
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => gameState);
        final updatedPlayer = updatedState.players.first;
        
        expect(updatedPlayer.grid.getCard(1, 1)?.value, equals(2));
        expect(updatedPlayer.grid.getCard(1, 0)?.value, equals(-1));
      });

      test('should swap cards at diagonal positions', () async {
        // Arrange
        final targetData = {
          'position1': {'row': 0, 'col': 0}, // Card with value 5
          'position2': {'row': 2, 'col': 3}, // Card with value 10
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => gameState);
        final updatedPlayer = updatedState.players.first;
        
        expect(updatedPlayer.grid.getCard(2, 3)?.value, equals(5));
        expect(updatedPlayer.grid.getCard(0, 0)?.value, equals(10));
      });

      test('should work with revealed and hidden cards', () async {
        // Arrange - Create cards with different reveal status
        final revealedCard = Card(value: 7, isRevealed: true);
        final hiddenCard = Card(value: 3, isRevealed: false);
        
        final mixedCards = List.generate(12, (index) => Card(value: index));
        mixedCards[0] = revealedCard; // Position (0,0)
        mixedCards[1] = hiddenCard;   // Position (0,1)
        
        final gridWithMixedCards = PlayerGrid.fromCards(mixedCards);
        final playerWithMixedCards = player.updateGrid(gridWithMixedCards);
        final stateWithMixedCards = gameState.copyWith(
          players: [playerWithMixedCards],
        );

        final targetData = {
          'position1': {'row': 0, 'col': 0}, // Revealed card
          'position2': {'row': 0, 'col': 1}, // Hidden card
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: stateWithMixedCards,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => stateWithMixedCards);
        final updatedPlayer = updatedState.players.first;
        
        // Cards should be swapped but maintain their reveal status
        final cardAt00 = updatedPlayer.grid.getCard(0, 0);
        final cardAt01 = updatedPlayer.grid.getCard(0, 1);
        
        expect(cardAt00?.value, equals(3));
        expect(cardAt00?.isRevealed, isFalse); // Hidden card moved here
        expect(cardAt01?.value, equals(7));
        expect(cardAt01?.isRevealed, isTrue); // Revealed card moved here
      });
    });

    group('Teleport Validation Failures', () {
      test('should fail if player does not own the teleport card', () async {
        // Arrange - Player has no action cards
        repository.setupPlayerCards('player1', []);

        final targetData = {
          'position1': {'row': 0, 'col': 0},
          'position2': {'row': 0, 'col': 1},
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.getLeft().getOrElse(() => Failure.unknown(message: 'test'));
        expect(failure, isA<GameLogicFailure>());
        expect(failure.message, contains('Player does not have this action card'));
      });

      test('should fail if it is not the player\'s turn', () async {
        // Arrange
        final otherPlayer = Player(
          id: 'player2',
          name: 'Other Player',
          grid: PlayerGrid.empty(),
          actionCards: [],
        );
        
        final gameStateNotMyTurn = gameState.copyWith(
          players: [player, otherPlayer],
          currentPlayerIndex: 1, // Other player's turn
        );

        final targetData = {
          'position1': {'row': 0, 'col': 0},
          'position2': {'row': 0, 'col': 1},
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameStateNotMyTurn,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.getLeft().getOrElse(() => Failure.unknown(message: 'test'));
        expect(failure, isA<GameLogicFailure>());
        expect(failure.message, contains('It is not your turn'));
      });

      test('should fail if target data is missing', () async {
        // Arrange
        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: null, // Missing target data
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isLeft(), isTrue);
        final failure = result.getLeft().getOrElse(() => Failure.unknown(message: 'test'));
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('This action card requires target data'));
      });
    });

    group('Teleport Edge Cases', () {
      test('should handle same position teleport gracefully', () async {
        // Arrange
        final targetData = {
          'position1': {'row': 0, 'col': 0}, // Same position
          'position2': {'row': 0, 'col': 0}, // Same position
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => gameState);
        final updatedPlayer = updatedState.players.first;
        
        // Card should remain the same
        expect(updatedPlayer.grid.getCard(0, 0)?.value, equals(5));
      });

      test('should handle grid boundary positions', () async {
        // Arrange
        final targetData = {
          'position1': {'row': 0, 'col': 0}, // Top-left corner
          'position2': {'row': 2, 'col': 3}, // Bottom-right corner
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => gameState);
        final updatedPlayer = updatedState.players.first;
        
        expect(updatedPlayer.grid.getCard(0, 0)?.value, equals(10)); // Card from (2,3)
        expect(updatedPlayer.grid.getCard(2, 3)?.value, equals(5));  // Card from (0,0)
      });

      test('should fail with non-existent player who doesn\'t have the card', () async {
        // Arrange - Don't setup any cards for nonexistent player
        final targetData = {
          'position1': {'row': 0, 'col': 0},
          'position2': {'row': 0, 'col': 1},
        };

        final params = UseActionCardParams(
          playerId: 'nonexistent',
          actionCard: teleportCard,
          gameState: gameState,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert - Should fail because player doesn't have the card
        expect(result.isLeft(), isTrue);
        final failure = result.getLeft().getOrElse(() => Failure.unknown(message: 'test'));
        expect(failure, isA<GameLogicFailure>());
        expect(failure.message, contains('Player does not have this action card'));
      });

      test('should return unchanged state if one card is null', () async {
        // Arrange - Create grid with empty position
        final emptyGrid = PlayerGrid.empty();
        final playerWithEmptyGrid = player.updateGrid(emptyGrid);
        final stateWithEmptyGrid = gameState.copyWith(
          players: [playerWithEmptyGrid],
        );

        final targetData = {
          'position1': {'row': 0, 'col': 0}, // Empty position
          'position2': {'row': 0, 'col': 1}, // Empty position
        };

        final params = UseActionCardParams(
          playerId: 'player1',
          actionCard: teleportCard,
          gameState: stateWithEmptyGrid,
          targetData: targetData,
        );

        // Act
        final result = await useCase.call(params);

        // Assert
        expect(result.isRight(), isTrue);
        final updatedState = result.getRight().getOrElse(() => stateWithEmptyGrid);
        // State should be unchanged due to null cards
        expect(updatedState.players.first.grid.cards, 
               equals(stateWithEmptyGrid.players.first.grid.cards));
        
        // Card should still be removed and discarded
        expect(repository.doesPlayerHaveCard('player1', teleportCard), isFalse);
        expect(repository.wasCardDiscarded(teleportCard), isTrue);
      });
    });
  });
}