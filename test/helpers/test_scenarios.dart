import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'test_builders.dart';

/// Pre-built test scenarios for common game situations
/// Reduces duplication and ensures consistent test data

class GameScenarios {
  /// Standard 2-player game at start
  static GameState twoPlayerGameStart() {
    return TestGameState()
        .players([
          TestGamePlayer()
              .id('player1')
              .name('Alice')
              .host()
              .grid(TestPlayerGrid().revealCard(0).revealCard(1).build())
              .build(),
          TestGamePlayer()
              .id('player2')
              .name('Bob')
              .grid(TestPlayerGrid().revealCard(0).revealCard(1).build())
              .build(),
        ])
        .currentPlayer(0)
        .status(GameStatus.playing)
        .build();
  }

  /// Game near end - one player needs one more card
  static GameState gameNearEnd() {
    return TestGameState()
        .players([
          TestGamePlayer()
              .id('player1')
              .name('Alice')
              .host()
              .grid(TestPlayerGrid().allRevealed().build())
              .build(),
          TestGamePlayer()
              .id('player2')
              .name('Bob')
              .grid(
                TestPlayerGrid()
                    .revealCard(0)
                    .revealCard(1)
                    .revealCard(2)
                    .revealCard(3)
                    .revealCard(4)
                    .revealCard(5)
                    .revealCard(6)
                    .revealCard(7)
                    .revealCard(8)
                    .revealCard(9)
                    .revealCard(10)
                    // Card 11 still hidden - one more to go
                    .build(),
              )
              .build(),
        ])
        .currentPlayer(1)
        .status(GameStatus.playing)
        .build();
  }

  /// Last round scenario
  static GameState lastRoundScenario() {
    return TestGameState()
        .players([
          TestGamePlayer()
              .id('player1')
              .name('Alice')
              .host()
              .grid(TestPlayerGrid().allRevealed().build())
              .finishedRound()
              .build(),
          TestGamePlayer()
              .id('player2')
              .name('Bob')
              .grid(
                TestPlayerGrid()
                    .revealCard(0)
                    .revealCard(1)
                    .revealCard(2)
                    .revealCard(3)
                    .revealCard(4)
                    .revealCard(5)
                    .revealCard(6)
                    .revealCard(7)
                    .revealCard(8)
                    .revealCard(9)
                    .build(),
              )
              .build(),
        ])
        .lastRound(initiator: 'player1')
        .currentPlayer(1)
        .status(GameStatus.playing)
        .build();
  }

  /// Multiplayer game (4 players)
  static GameState fourPlayerGame() {
    return TestGameState()
        .players([
          TestGamePlayer().id('player1').name('Alice').host().build(),
          TestGamePlayer().id('player2').name('Bob').build(),
          TestGamePlayer().id('player3').name('Charlie').build(),
          TestGamePlayer().id('player4').name('Diana').build(),
        ])
        .currentPlayer(0)
        .status(GameStatus.playing)
        .build();
  }

  /// Game with disconnected player
  static GameState gameWithDisconnectedPlayer() {
    return TestGameState()
        .players([
          TestGamePlayer().id('player1').name('Alice').host().build(),
          TestGamePlayer().id('player2').name('Bob').disconnected().build(),
        ])
        .currentPlayer(0)
        .status(GameStatus.playing)
        .build();
  }

  /// Game with completed column
  static GameState gameWithCompletedColumn() {
    final gridWithCompletedColumn = TestPlayerGrid()
        // Complete first column with value 5
        .cards([
          // Column 0: all 5s, revealed
          TestCard().value(5).revealed().build(),
          TestCard().value(3).build(),
          TestCard().value(-1).build(),
          TestCard().value(8).build(),
          // Column 1
          TestCard().value(5).revealed().build(),
          TestCard().value(2).build(),
          TestCard().value(0).build(),
          TestCard().value(4).build(),
          // Column 2
          TestCard().value(5).revealed().build(),
          TestCard().value(1).build(),
          TestCard().value(7).build(),
          TestCard().value(6).build(),
        ])
        .build();

    return TestGameState().players([
      TestGamePlayer()
          .id('player1')
          .name('Alice')
          .host()
          .grid(gridWithCompletedColumn)
          .build(),
      TestGamePlayer().id('player2').name('Bob').build(),
    ]).build();
  }

  /// Empty deck scenario (reshuffle needed)
  static GameState emptyDeckScenario() {
    return TestGameState().emptyDeck().players([
      TestGamePlayer().id('player1').name('Alice').host().build(),
      TestGamePlayer().id('player2').name('Bob').build(),
    ]).build();
  }

  /// Game with action cards
  static GameState gameWithActionCards() {
    final actionCards = [
      TestActionCard()
          .id('teleport1')
          .type(ActionCardType.teleport)
          .immediate()
          .build(),
      TestActionCard().id('peek1').type(ActionCardType.peek).optional().build(),
      TestActionCard()
          .id('shield1')
          .type(ActionCardType.shield)
          .reactive()
          .build(),
    ];

    return TestGameState()
        .players([
          TestGamePlayer().id('player1').name('Alice').host().actionCards([
            actionCards[0],
          ]).build(),
          TestGamePlayer().id('player2').name('Bob').actionCards([
            actionCards[1],
            actionCards[2],
          ]).build(),
        ])
        .actionCards(actionCards)
        .build();
  }
}

class RoomScenarios {
  /// New empty room
  static Room newEmptyRoom() {
    return TestRoom()
        .id('room-1')
        .host('alice')
        .maxPlayers(4)
        .status(RoomStatus.waiting)
        .build();
  }

  /// Room with multiple players but not full
  static Room roomWithMultiplePlayers() {
    return TestRoom()
        .id('room-2')
        .host('alice')
        .maxPlayers(4)
        .addPlayer('bob')
        .addPlayer('charlie')
        .status(RoomStatus.waiting)
        .build();
  }

  /// Full room ready to start
  static Room fullRoomReadyToStart() {
    return TestRoom()
        .id('room-3')
        .host('alice')
        .maxPlayers(4)
        .full()
        .status(RoomStatus.waiting)
        .build();
  }

  /// Active game room
  static Room activeGameRoom() {
    return TestRoom()
        .id('room-4')
        .host('alice')
        .maxPlayers(4)
        .full()
        .playing()
        .build();
  }
}

class ActionCardScenarios {
  /// Common action cards for testing
  static List<ActionCard> basicActionCards() {
    return [
      TestActionCard()
          .id('teleport-basic')
          .type(ActionCardType.teleport)
          .name('Téléportation')
          .immediate()
          .targetOpponent()
          .build(),

      TestActionCard()
          .id('peek-basic')
          .type(ActionCardType.peek)
          .name('Coup d\'œil')
          .optional()
          .targetSelf()
          .parameters({'cardCount': 2})
          .build(),

      TestActionCard()
          .id('shield-basic')
          .type(ActionCardType.shield)
          .name('Bouclier')
          .reactive()
          .targetSelf()
          .parameters({'duration': 1})
          .build(),

      TestActionCard()
          .id('swap-basic')
          .type(ActionCardType.swap)
          .name('Échange')
          .optional()
          .targetOpponent()
          .build(),

      TestActionCard()
          .id('reverse-basic')
          .type(ActionCardType.reverse)
          .name('Demi-tour')
          .immediate()
          .targetSelf()
          .build(),
    ];
  }

  /// Problematic action card combinations for edge case testing
  static List<ActionCard> problematicCombinations() {
    return [
      // Multiple immediate cards that could conflict
      TestActionCard()
          .id('reverse-1')
          .type(ActionCardType.reverse)
          .immediate()
          .build(),

      TestActionCard()
          .id('reverse-2')
          .type(ActionCardType.reverse)
          .immediate()
          .build(),

      // Reactive card with complex parameters
      TestActionCard()
          .id('shield-complex')
          .type(ActionCardType.shield)
          .reactive()
          .parameters({
            'duration': 3,
            'blockTypes': ['teleport', 'swap'],
            'stackable': false,
          })
          .build(),
    ];
  }
}

/// Common test patterns for behavioral verification
class TestPatterns {
  /// Test that a behavior function produces expected results for multiple inputs
  static void testBehaviorWithCases<TInput, TOutput>({
    required String description,
    required List<(TInput input, TOutput expected, String description)>
    testCases,
    required TOutput Function(TInput) behaviorFunction,
    Matcher Function(TOutput)? customMatcher,
  }) {
    group(description, () {
      for (final (input, expected, caseDesc) in testCases) {
        test('should $caseDesc', () {
          final result = behaviorFunction(input);
          if (customMatcher != null) {
            expect(result, customMatcher(expected));
          } else {
            expect(result, expected);
          }
        });
      }
    });
  }

  /// Test that an action produces expected state transitions
  static void testStateTransitions({
    required String actionDescription,
    required List<(GameState initial, GameState expected, String scenario)>
    transitions,
    required GameState Function(GameState) actionFunction,
  }) {
    group('$actionDescription state transitions', () {
      for (final (initial, expected, scenario) in transitions) {
        test('should transition correctly when $scenario', () {
          final result = actionFunction(initial);
          expect(
            result,
            expected,
            reason: 'State transition failed for scenario: $scenario',
          );
        });
      }
    });
  }

  /// Test validation rules with multiple invalid inputs
  static void testValidationRules<T>({
    required String validatorDescription,
    required List<T> validInputs,
    required List<(T invalid, String reason)> invalidInputs,
    required bool Function(T) validatorFunction,
  }) {
    group('$validatorDescription validation', () {
      for (final validInput in validInputs) {
        test('should accept valid input: $validInput', () {
          expect(validatorFunction(validInput), isTrue);
        });
      }

      for (final (invalidInput, reason) in invalidInputs) {
        test('should reject invalid input: $reason', () {
          expect(validatorFunction(invalidInput), isFalse);
        });
      }
    });
  }
}
