import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'card.dart';

part 'player_grid.freezed.dart';
part 'player_grid.g.dart';

@freezed
class PlayerGrid with _$PlayerGrid {
  const factory PlayerGrid({required List<List<Card?>> cards}) = _PlayerGrid;

  const PlayerGrid._();

  factory PlayerGrid.empty() {
    return PlayerGrid(
      cards: List.generate(
        kGridRows,
        (_) => List.generate(kGridColumns, (_) => null),
      ),
    );
  }

  factory PlayerGrid.fromCards(List<Card> cardsList) {
    assert(cardsList.length == kCardsPerPlayer);

    final grid = List.generate(
      kGridRows,
      (row) => List.generate(
        kGridColumns,
        (col) => cardsList[row * kGridColumns + col],
      ),
    );

    return PlayerGrid(cards: grid);
  }

  factory PlayerGrid.fromJson(Map<String, dynamic> json) =>
      _$PlayerGridFromJson(json);

  Card? getCard(int row, int col) {
    if (row < 0 || row >= kGridRows || col < 0 || col >= kGridColumns) {
      return null;
    }
    return cards[row][col];
  }

  PlayerGrid setCard(int row, int col, Card? card) {
    final newCards = cards.map((r) => List<Card?>.from(r)).toList();
    newCards[row][col] = card;
    return copyWith(cards: newCards);
  }

  PlayerGrid revealCard(int row, int col) {
    final card = getCard(row, col);
    if (card == null) return this;

    return setCard(row, col, card.reveal());
  }

  int get totalScore {
    int score = 0;
    for (final row in cards) {
      for (final card in row) {
        if (card != null) {
          score += card.value;
        }
      }
    }
    return score;
  }

  bool get allCardsRevealed {
    for (final row in cards) {
      for (final card in row) {
        if (card != null && !card.isRevealed) {
          return false;
        }
      }
    }
    return true;
  }

  List<int> getIdenticalColumns() {
    final identicalColumns = <int>[];

    for (int col = 0; col < kGridColumns; col++) {
      final columnCards = <Card>[];

      for (int row = 0; row < kGridRows; row++) {
        final card = cards[row][col];
        if (card == null || !card.isRevealed) {
          break;
        }
        columnCards.add(card);
      }

      if (columnCards.length == kGridRows &&
          columnCards.every((card) => card.value == columnCards.first.value)) {
        identicalColumns.add(col);
      }
    }

    return identicalColumns;
  }

  PlayerGrid removeColumn(int col) {
    final newCards = cards.map((row) {
      final newRow = List<Card?>.from(row);
      newRow[col] = null;
      return newRow;
    }).toList();

    return copyWith(cards: newCards);
  }

  PlayerGrid placeCard(Card card, int row, int col) {
    return setCard(row, col, card);
  }

  PlayerGrid clearPosition(int row, int col) {
    return setCard(row, col, null);
  }
}
