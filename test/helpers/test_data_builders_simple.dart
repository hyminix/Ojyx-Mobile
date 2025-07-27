import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

/// Simple Test Data Builder for Card entity
class CardBuilder {
  int _value;
  bool _isRevealed;

  CardBuilder({int value = 5, bool isRevealed = false})
    : _value = value,
      _isRevealed = isRevealed;

  CardBuilder withValue(int value) {
    _value = value;
    return this;
  }

  CardBuilder withRevealed(bool isRevealed) {
    _isRevealed = isRevealed;
    return this;
  }

  CardBuilder revealed() => withRevealed(true);
  CardBuilder hidden() => withRevealed(false);

  Card build() => Card(value: _value, isRevealed: _isRevealed);
}

/// Simple Test Data Builder for PlayerGrid entity
class PlayerGridBuilder {
  List<List<Card?>> _cards;

  PlayerGridBuilder({List<List<Card?>>? cards})
    : _cards = cards ?? _generateDefaultGrid();

  static List<List<Card?>> _generateDefaultGrid() {
    return List.generate(
      3,
      (row) => List.generate(4, (col) => Card(value: (row * 4 + col) % 13 - 2)),
    );
  }

  PlayerGridBuilder withCards(List<Card> flatCards) {
    // Convert flat list to 3x4 grid
    _cards = [];
    for (int i = 0; i < 3; i++) {
      final row = <Card?>[];
      for (int j = 0; j < 4; j++) {
        final index = i * 4 + j;
        if (index < flatCards.length) {
          row.add(flatCards[index]);
        } else {
          row.add(null);
        }
      }
      _cards.add(row);
    }
    return this;
  }

  PlayerGrid build() => PlayerGrid(cards: _cards);
}

/// Simple Test Data Builder for GamePlayer entity
class GamePlayerBuilder {
  String _id;
  String _name;
  PlayerGrid _grid;
  List<ActionCard> _actionCards;
  bool _isConnected;
  bool _isHost;

  GamePlayerBuilder({
    String id = 'player-1',
    String name = 'Test Player',
    PlayerGrid? grid,
    List<ActionCard>? actionCards,
    bool isConnected = true,
    bool isHost = false,
  }) : _id = id,
       _name = name,
       _grid = grid ?? PlayerGridBuilder().build(),
       _actionCards = actionCards ?? [],
       _isConnected = isConnected,
       _isHost = isHost;

  GamePlayerBuilder withId(String id) {
    _id = id;
    return this;
  }

  GamePlayerBuilder withName(String name) {
    _name = name;
    return this;
  }

  GamePlayerBuilder withGrid(PlayerGrid grid) {
    _grid = grid;
    return this;
  }

  GamePlayer build() => GamePlayer(
    id: _id,
    name: _name,
    grid: _grid,
    actionCards: _actionCards,
    isConnected: _isConnected,
    isHost: _isHost,
  );
}
