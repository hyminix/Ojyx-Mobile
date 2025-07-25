import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/core/errors/failures.dart';

/// Custom matchers for domain-specific assertions
/// Makes tests more readable and expressive

/// Matcher for card values
Matcher hasCardValue(int expectedValue) => _HasCardValue(expectedValue);

class _HasCardValue extends Matcher {
  final int expectedValue;

  const _HasCardValue(this.expectedValue);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! game.Card) return false;
    return item.value == expectedValue;
  }

  @override
  Description describe(Description description) =>
      description.add('has card value $expectedValue');
}

/// Matcher for revealed cards
Matcher isRevealed() => _IsRevealed();
Matcher isHidden() => _IsHidden();

class _IsRevealed extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! game.Card) return false;
    return item.isRevealed;
  }

  @override
  Description describe(Description description) =>
      description.add('is a revealed card');
}

class _IsHidden extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! game.Card) return false;
    return !item.isRevealed;
  }

  @override
  Description describe(Description description) =>
      description.add('is a hidden card');
}

/// Matcher for game state status
Matcher hasGameStatus(GameStatus expectedStatus) =>
    _HasGameStatus(expectedStatus);

class _HasGameStatus extends Matcher {
  final GameStatus expectedStatus;

  const _HasGameStatus(this.expectedStatus);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! GameState) return false;
    return item.status == expectedStatus;
  }

  @override
  Description describe(Description description) =>
      description.add('has game status $expectedStatus');
}

/// Matcher for player turn
Matcher isPlayerTurn(String playerId) => _IsPlayerTurn(playerId);

class _IsPlayerTurn extends Matcher {
  final String playerId;

  const _IsPlayerTurn(this.playerId);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! GameState) return false;
    final currentPlayer = item.players[item.currentPlayerIndex];
    return currentPlayer.id == playerId;
  }

  @override
  Description describe(Description description) =>
      description.add('is turn of player $playerId');
}

/// Matcher for room status
Matcher hasRoomStatus(RoomStatus expectedStatus) =>
    _HasRoomStatus(expectedStatus);

class _HasRoomStatus extends Matcher {
  final RoomStatus expectedStatus;

  const _HasRoomStatus(this.expectedStatus);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Room) return false;
    return item.status == expectedStatus;
  }

  @override
  Description describe(Description description) =>
      description.add('has room status $expectedStatus');
}

/// Matcher for room player count
Matcher hasPlayerCount(int expectedCount) => _HasPlayerCount(expectedCount);

class _HasPlayerCount extends Matcher {
  final int expectedCount;

  const _HasPlayerCount(this.expectedCount);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Room) return item.playerIds.length == expectedCount;
    if (item is GameState) return item.players.length == expectedCount;
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('has $expectedCount players');
}

/// Matcher for revealed cards in grid
Matcher hasRevealedCardsCount(int expectedCount) =>
    _HasRevealedCardsCount(expectedCount);

class _HasRevealedCardsCount extends Matcher {
  final int expectedCount;

  const _HasRevealedCardsCount(this.expectedCount);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! PlayerGrid) return false;
    final revealedCount = item.cards.where((card) => card?.isRevealed ?? false).length;
    return revealedCount == expectedCount;
  }

  @override
  Description describe(Description description) =>
      description.add('has $expectedCount revealed cards');
}

/// Matcher for column completion (3 identical revealed cards)
Matcher hasCompletedColumn() => _HasCompletedColumn();

class _HasCompletedColumn extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! PlayerGrid) return false;

    for (int col = 0; col < 4; col++) {
      final columnCards = [
        item.cards[col], // Row 0
        item.cards[col + 4], // Row 1
        item.cards[col + 8], // Row 2
      ];

      final allRevealed = columnCards.every((card) => card?.isRevealed ?? false);
      final sameValue = columnCards.every(
        (card) => card != null && columnCards[0] != null && card.value == columnCards[0]!.value,
      );

      if (allRevealed && sameValue) {
        return true;
      }
    }
    return false;
  }

  @override
  Description describe(Description description) =>
      description.add('has a completed column (3 identical revealed cards)');
}

/// Matcher for failure types
Matcher isFailureOfType<T extends Failure>() => _IsFailureOfType<T>();

class _IsFailureOfType<T extends Failure> extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    return item is T;
  }

  @override
  Description describe(Description description) =>
      description.add('is a failure of type $T');
}

/// Matcher for player connection status
Matcher isConnected() => _IsConnected();
Matcher isDisconnected() => _IsDisconnected();

class _IsConnected extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! GamePlayer) return false;
    return item.isConnected;
  }

  @override
  Description describe(Description description) =>
      description.add('is connected');
}

class _IsDisconnected extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! GamePlayer) return false;
    return !item.isConnected;
  }

  @override
  Description describe(Description description) =>
      description.add('is disconnected');
}

/// Helper function for behavioral assertion groups
class BehaviorTest {
  final String description;
  final dynamic input;
  final Matcher expectedOutput;
  final String? reason;

  const BehaviorTest({
    required this.description,
    required this.input,
    required this.expectedOutput,
    this.reason,
  });
}

/// Function to run a group of behavioral tests
void testBehaviorGroup(String groupDescription, List<BehaviorTest> tests) {
  group(groupDescription, () {
    for (final behaviorTest in tests) {
      test('should ${behaviorTest.description}', () {
        expect(
          behaviorTest.input,
          behaviorTest.expectedOutput,
          reason: behaviorTest.reason ?? 'Expected ${behaviorTest.description}',
        );
      });
    }
  });
}

/// Common assertion helpers for game behavior
class GameAssertions {
  /// Assert that a game action produces expected state change
  static void assertGameAction({
    required GameState initialState,
    required GameState resultState,
    required String actionDescription,
  }) {
    expect(
      resultState,
      isNot(equals(initialState)),
      reason: '$actionDescription should change game state',
    );
  }

  /// Assert that player state reflects expected behavior
  static void assertPlayerBehavior({
    required GamePlayer player,
    required bool shouldBeConnected,
    required String behaviorDescription,
  }) {
    expect(
      player.isConnected,
      shouldBeConnected,
      reason: '$behaviorDescription should result in correct connection status',
    );
  }

  /// Assert that turn progression follows game rules
  static void assertTurnProgression({
    required GameState beforeState,
    required GameState afterState,
    required String actionDescription,
  }) {
    final expectedNextPlayer =
        beforeState.turnDirection == TurnDirection.clockwise
        ? (beforeState.currentPlayerIndex + 1) % beforeState.players.length
        : (beforeState.currentPlayerIndex - 1 + beforeState.players.length) %
              beforeState.players.length;

    expect(
      afterState.currentPlayerIndex,
      expectedNextPlayer,
      reason: '$actionDescription should advance turn correctly',
    );
  }
}
