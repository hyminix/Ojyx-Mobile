import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/core/utils/constants.dart';

/// Test Data Builders for Freezed models
/// These builders follow the Test Data Builder pattern to create
/// test fixtures with sensible defaults that can be customized

class CardBuilder {
  int value;
  bool isRevealed;

  CardBuilder({this.value = 5, this.isRevealed = false});

  CardBuilder withValue(int value) {
    this.value = value;
    return this;
  }

  CardBuilder revealed() {
    isRevealed = true;
    return this;
  }

  CardBuilder hidden() {
    isRevealed = false;
    return this;
  }

  Card build() {
    return Card(value: value, isRevealed: isRevealed);
  }
}

class PlayerGridBuilder {
  List<List<Card?>> cards;

  PlayerGridBuilder({List<List<Card?>>? cards})
    : cards = cards ?? _createEmptyGrid();

  static List<List<Card?>> _createEmptyGrid() {
    return List.generate(
      kGridRows,
      (_) => List.generate(kGridColumns, (_) => null),
    );
  }

  PlayerGridBuilder withCard(int row, int col, Card card) {
    cards[row][col] = card;
    return this;
  }

  PlayerGridBuilder withFullGrid() {
    for (int row = 0; row < kGridRows; row++) {
      for (int col = 0; col < kGridColumns; col++) {
        cards[row][col] = CardBuilder()
            .withValue((row * kGridColumns + col) % 13 + 1)
            .build();
      }
    }
    return this;
  }

  PlayerGrid build() {
    return PlayerGrid(cards: cards);
  }
}

class GamePlayerBuilder {
  String id;
  String name;
  PlayerGrid grid;
  List<ActionCard> actionCards;
  bool isConnected;
  bool isHost;
  bool hasFinishedRound;
  int scoreMultiplier;

  GamePlayerBuilder({
    this.id = 'player-1',
    this.name = 'Test Player',
    PlayerGrid? grid,
    List<ActionCard>? actionCards,
    this.isConnected = true,
    this.isHost = false,
    this.hasFinishedRound = false,
    this.scoreMultiplier = 1,
  }) : grid = grid ?? PlayerGrid.empty(),
       actionCards = actionCards ?? [];

  GamePlayerBuilder withId(String id) {
    this.id = id;
    return this;
  }

  GamePlayerBuilder withName(String name) {
    this.name = name;
    return this;
  }

  GamePlayerBuilder withGrid(PlayerGrid grid) {
    this.grid = grid;
    return this;
  }

  GamePlayerBuilder withActionCards(List<ActionCard> cards) {
    assert(cards.length <= kMaxActionCardsInHand);
    actionCards = cards;
    return this;
  }

  GamePlayerBuilder asHost() {
    isHost = true;
    return this;
  }

  GamePlayerBuilder disconnected() {
    isConnected = false;
    return this;
  }

  GamePlayerBuilder withFinishedRound() {
    hasFinishedRound = true;
    return this;
  }

  GamePlayerBuilder withScoreMultiplier(int multiplier) {
    scoreMultiplier = multiplier;
    return this;
  }

  GamePlayer build() {
    return GamePlayer(
      id: id,
      name: name,
      grid: grid,
      actionCards: actionCards,
      isConnected: isConnected,
      isHost: isHost,
      hasFinishedRound: hasFinishedRound,
      scoreMultiplier: scoreMultiplier,
    );
  }
}

/// Custom Matchers for Freezed models

class IsValidCard extends Matcher {
  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Card) return false;

    // Check value is within valid range
    return item.value >= kMinCardValue && item.value <= kMaxCardValue;
  }

  @override
  Description describe(Description description) {
    return description.add(
      'is a valid Card with value between $kMinCardValue and $kMaxCardValue',
    );
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! Card) {
      return mismatchDescription.add('is not a Card');
    }

    final card = item;
    return mismatchDescription.add(
      'has invalid value ${card.value} (must be $kMinCardValue to $kMaxCardValue)',
    );
  }
}

class HasCurrentScore extends Matcher {
  final int expectedScore;

  HasCurrentScore(this.expectedScore);

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is GamePlayer) {
      return item.currentScore == expectedScore;
    }
    return false;
  }

  @override
  Description describe(Description description) {
    return description.add('has current score of $expectedScore');
  }

  @override
  Description describeMismatch(
    dynamic item,
    Description mismatchDescription,
    Map matchState,
    bool verbose,
  ) {
    if (item is! GamePlayer) {
      return mismatchDescription.add('is not a GamePlayer');
    }

    return mismatchDescription.add(
      'has current score of ${item.currentScore} instead of $expectedScore',
    );
  }
}

/// Helper functions

Card createTestCard({int value = 5, bool isRevealed = false}) {
  return CardBuilder()
      .withValue(value)
      .apply((b) => isRevealed ? b.revealed() : b)
      .build();
}

PlayerGrid createTestGrid({bool filled = false}) {
  final builder = PlayerGridBuilder();
  if (filled) {
    builder.withFullGrid();
  }
  return builder.build();
}

GamePlayer createTestPlayer({
  String? id,
  String? name,
  bool withFullGrid = false,
  List<ActionCard>? actionCards,
}) {
  final grid = withFullGrid ? createTestGrid(filled: true) : PlayerGrid.empty();

  return GamePlayerBuilder()
      .apply((b) => id != null ? b.withId(id) : b)
      .apply((b) => name != null ? b.withName(name) : b)
      .withGrid(grid)
      .apply((b) => actionCards != null ? b.withActionCards(actionCards) : b)
      .build();
}

/// Extension to enable fluent builder pattern
extension BuilderExtension<T> on T {
  T apply(T Function(T) fn) => fn(this);
}

/// Matcher instances
final isValidCard = IsValidCard();
Matcher hasCurrentScore(int score) => HasCurrentScore(score);
