import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';

part 'deck_state.freezed.dart';
part 'deck_state.g.dart';

@freezed
class DeckState with _$DeckState {
  const factory DeckState({
    required List<Card> drawPile,
    required List<Card> discardPile,
  }) = _DeckState;

  const DeckState._();

  factory DeckState.fromJson(Map<String, dynamic> json) =>
      _$DeckStateFromJson(json);

  factory DeckState.empty() => const DeckState(
    drawPile: [],
    discardPile: [],
  );

  Card? get topDiscardCard => discardPile.isEmpty ? null : discardPile.last;

  int get remainingDrawCount => drawPile.length;

  bool get isDrawPileEmpty => drawPile.isEmpty;

  (DeckState, Card?) drawCard() {
    if (drawPile.isEmpty) {
      return (this, null);
    }

    final drawnCard = drawPile.first;
    final newDrawPile = drawPile.sublist(1);

    return (
      copyWith(drawPile: newDrawPile),
      drawnCard,
    );
  }

  DeckState discardCard(Card card) {
    return copyWith(
      discardPile: [...discardPile, card],
    );
  }

  DeckState reshuffleDiscardIntoDraw() {
    if (discardPile.length <= 1) {
      return this;
    }

    // Keep the top card of discard pile
    final topCard = discardPile.last;
    final cardsToShuffle = discardPile.sublist(0, discardPile.length - 1);
    
    // Shuffle the cards
    final shuffled = List<Card>.from(cardsToShuffle)..shuffle();

    return copyWith(
      drawPile: shuffled,
      discardPile: [topCard],
    );
  }
}