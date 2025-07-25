import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'package:ojyx/core/utils/extensions.dart';
import 'game_player.dart';
import 'card.dart';
import 'action_card.dart';

part 'game_state.freezed.dart';

enum GameStatus {
  waitingToStart,
  playing,
  drawPhase,
  lastRound,
  finished,
  cancelled,
}

enum TurnDirection { clockwise, counterClockwise }

@freezed
class GameState with _$GameState {
  const factory GameState({
    required String roomId,
    required List<GamePlayer> players,
    required int currentPlayerIndex,
    required List<Card> deck,
    required List<Card> discardPile,
    required List<ActionCard> actionDeck,
    required List<ActionCard> actionDiscard,
    required GameStatus status,
    required TurnDirection turnDirection,
    required bool lastRound,
    String? initiatorPlayerId,
    String? endRoundInitiator,
    Card? drawnCard,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
  }) = _GameState;

  const GameState._();

  factory GameState.initial({
    required String roomId,
    required List<GamePlayer> players,
    int currentPlayerIndex = 0,
  }) {
    final deck = _createInitialDeck();

    return GameState(
      roomId: roomId,
      players: players,
      currentPlayerIndex: currentPlayerIndex,
      deck: deck,
      discardPile: [],
      actionDeck: [], // TODO: Create action deck
      actionDiscard: [],
      status: GameStatus.waitingToStart,
      turnDirection: TurnDirection.clockwise,
      lastRound: false,
      createdAt: DateTime.now(),
    );
  }

  GamePlayer get currentPlayer => players[currentPlayerIndex];

  bool get canStart =>
      players.length >= kMinPlayers && players.length <= kMaxPlayers;

  GameState nextPlayer() {
    int nextIndex;

    if (turnDirection == TurnDirection.clockwise) {
      nextIndex = (currentPlayerIndex + 1) % players.length;
    } else {
      nextIndex = (currentPlayerIndex - 1 + players.length) % players.length;
    }

    return copyWith(currentPlayerIndex: nextIndex);
  }

  (Card?, GameState) drawCard() {
    if (deck.isEmpty) {
      if (discardPile.length <= 1) {
        return (null, this);
      }

      // Keep the top card of discard pile
      final topCard = discardPile.first;
      final cardsToShuffle = discardPile.skip(1).toList();

      final newDeck = cardsToShuffle.shuffled();
      final newDiscard = [topCard];

      if (newDeck.isEmpty) {
        return (null, this);
      }

      final drawnCard = newDeck.first;
      final newState = copyWith(
        deck: newDeck.skip(1).toList(),
        discardPile: newDiscard,
      );

      return (drawnCard, newState);
    }

    final drawnCard = deck.first;
    final newState = copyWith(deck: deck.skip(1).toList());

    return (drawnCard, newState);
  }

  GameState discardCard(Card card) {
    return copyWith(discardPile: [card, ...discardPile]);
  }

  bool get shouldTriggerLastRound {
    if (status != GameStatus.playing) return false;

    return players.any((player) => player.grid.allCardsRevealed);
  }

  bool get allPlayersFinishedRound {
    if (!lastRound) return false;

    return players.every((player) => player.hasFinishedRound);
  }

  Map<String, int> calculateScores() {
    final scores = <String, int>{};
    final baseScores = <String, int>{};

    // Calculate base scores
    for (final player in players) {
      baseScores[player.id] = player.currentScore;
    }

    // Find the minimum score
    final minScore = baseScores.values.reduce((a, b) => a < b ? a : b);

    // Apply penalty to initiator if they don't have the lowest score
    for (final player in players) {
      final baseScore = baseScores[player.id]!;

      if (player.id == initiatorPlayerId && baseScore > minScore) {
        scores[player.id] = baseScore * 2;
      } else {
        scores[player.id] = baseScore;
      }
    }

    return scores;
  }

  static List<Card> _createInitialDeck() {
    final cards = <Card>[];

    kCardDistribution.forEach((value, count) {
      for (int i = 0; i < count; i++) {
        cards.add(Card(value: value));
      }
    });

    return cards.shuffled();
  }
}
