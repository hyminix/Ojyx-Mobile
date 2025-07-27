import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_state.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/domain/entities/play_direction.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/end_game/domain/entities/player_score.dart';

/// Test Data Builder for Card entity
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

/// Test Data Builder for GamePlayer entity
class GamePlayerBuilder {
  String _id;
  String _name;
  PlayerGrid _grid;
  List<ActionCard> _actionCards;
  bool _isConnected;
  bool _isHost;
  bool _hasFinishedRound;
  int _scoreMultiplier;

  GamePlayerBuilder({
    String id = 'player-1',
    String name = 'Test Player',
    PlayerGrid? grid,
    List<ActionCard>? actionCards,
    bool isConnected = true,
    bool isHost = false,
    bool hasFinishedRound = false,
    int scoreMultiplier = 1,
  }) : _id = id,
       _name = name,
       _grid = grid ?? PlayerGridBuilder().build(),
       _actionCards = actionCards ?? [],
       _isConnected = isConnected,
       _isHost = isHost,
       _hasFinishedRound = hasFinishedRound,
       _scoreMultiplier = scoreMultiplier;

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

  GamePlayerBuilder withActionCards(List<ActionCard> actionCards) {
    _actionCards = actionCards;
    return this;
  }

  GamePlayerBuilder connected() => withConnected(true);
  GamePlayerBuilder disconnected() => withConnected(false);

  GamePlayerBuilder withConnected(bool isConnected) {
    _isConnected = isConnected;
    return this;
  }

  GamePlayerBuilder asHost() => withHost(true);
  GamePlayerBuilder asGuest() => withHost(false);

  GamePlayerBuilder withHost(bool isHost) {
    _isHost = isHost;
    return this;
  }

  GamePlayerBuilder withFinishedRound(bool hasFinishedRound) {
    _hasFinishedRound = hasFinishedRound;
    return this;
  }

  GamePlayerBuilder withScoreMultiplier(int scoreMultiplier) {
    _scoreMultiplier = scoreMultiplier;
    return this;
  }

  GamePlayer build() => GamePlayer(
    id: _id,
    name: _name,
    grid: _grid,
    actionCards: _actionCards,
    isConnected: _isConnected,
    isHost: _isHost,
    hasFinishedRound: _hasFinishedRound,
    scoreMultiplier: _scoreMultiplier,
  );
}

/// Test Data Builder for PlayerGrid entity
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

  PlayerGridBuilder withCardAt(int row, int col, Card? card) {
    if (row >= 0 &&
        row < _cards.length &&
        col >= 0 &&
        col < _cards[row].length) {
      _cards[row][col] = card;
    }
    return this;
  }

  PlayerGridBuilder withAllRevealed() {
    _cards = _cards
        .map((row) => row.map((card) => card?.reveal()).toList())
        .toList();
    return this;
  }

  PlayerGridBuilder withRevealedAt(List<CardPosition> positions) {
    for (final pos in positions) {
      if (pos.row >= 0 &&
          pos.row < _cards.length &&
          pos.col >= 0 &&
          pos.col < _cards[pos.row].length &&
          _cards[pos.row][pos.col] != null) {
        _cards[pos.row][pos.col] = _cards[pos.row][pos.col]!.reveal();
      }
    }
    return this;
  }

  PlayerGrid build() => PlayerGrid(cards: _cards);
}

/// Test Data Builder for PlayerState entity
class PlayerStateBuilder {
  String _playerId;
  List<Card?> _cards;
  int _currentScore;
  int _revealedCount;
  List<int> _identicalColumns;
  bool _hasFinished;

  PlayerStateBuilder({
    String playerId = 'player-1',
    List<Card?>? cards,
    int currentScore = 0,
    int revealedCount = 0,
    List<int>? identicalColumns,
    bool hasFinished = false,
  }) : _playerId = playerId,
       _cards = cards ?? List.filled(12, null),
       _currentScore = currentScore,
       _revealedCount = revealedCount,
       _identicalColumns = identicalColumns ?? [],
       _hasFinished = hasFinished;

  PlayerStateBuilder withPlayerId(String playerId) {
    _playerId = playerId;
    return this;
  }

  PlayerStateBuilder withCards(List<Card?> cards) {
    _cards = cards;
    return this;
  }

  PlayerStateBuilder withGrid(PlayerGrid grid) {
    // Flatten the grid to a list
    _cards = [];
    for (final row in grid.cards) {
      _cards.addAll(row);
    }
    return this;
  }

  PlayerStateBuilder withCurrentScore(int currentScore) {
    _currentScore = currentScore;
    return this;
  }

  PlayerStateBuilder withRevealedCount(int revealedCount) {
    _revealedCount = revealedCount;
    return this;
  }

  PlayerStateBuilder withIdenticalColumns(List<int> identicalColumns) {
    _identicalColumns = identicalColumns;
    return this;
  }

  PlayerStateBuilder withFinished(bool hasFinished) {
    _hasFinished = hasFinished;
    return this;
  }

  PlayerState build() => PlayerState(
    playerId: _playerId,
    cards: _cards,
    currentScore: _currentScore,
    revealedCount: _revealedCount,
    identicalColumns: _identicalColumns,
    hasFinished: _hasFinished,
  );
}

/// Test Data Builder for DeckState entity
class DeckStateBuilder {
  List<Card> _drawPile;
  List<Card> _discardPile;

  DeckStateBuilder({List<Card>? drawPile, List<Card>? discardPile})
    : _drawPile = drawPile ?? _generateDefaultDrawPile(),
      _discardPile = discardPile ?? [];

  static List<Card> _generateDefaultDrawPile() {
    return List.generate(20, (index) => Card(value: index % 13 - 2));
  }

  DeckStateBuilder withDrawPile(List<Card> drawPile) {
    _drawPile = drawPile;
    return this;
  }

  DeckStateBuilder withDiscardPile(List<Card> discardPile) {
    _discardPile = discardPile;
    return this;
  }

  DeckStateBuilder withEmptyDrawPile() => withDrawPile([]);
  DeckStateBuilder withEmptyDiscardPile() => withDiscardPile([]);

  DeckState build() =>
      DeckState(drawPile: _drawPile, discardPile: _discardPile);
}

/// Test Data Builder for GameState entity
class GameStateBuilder {
  String _id;
  String _roomId;
  List<GamePlayer> _players;
  Map<String, PlayerState> _playersState;
  String _currentPlayerId;
  DeckState _deck;
  PlayDirection _direction;
  int _currentRound;
  int _maxRounds;
  DateTime _lastActionTime;
  bool _isLastRound;
  String? _lastRoundInitiator;
  bool _isPaused;

  GameStateBuilder({
    String id = 'game-1',
    String roomId = 'test-room',
    List<GamePlayer>? players,
    Map<String, PlayerState>? playersState,
    String currentPlayerId = 'player-1',
    DeckState? deck,
    PlayDirection direction = PlayDirection.forward,
    int currentRound = 1,
    int maxRounds = 5,
    DateTime? lastActionTime,
    bool isLastRound = false,
    String? lastRoundInitiator,
    bool isPaused = false,
  }) : _id = id,
       _roomId = roomId,
       _players = players ?? [GamePlayerBuilder().build()],
       _playersState = playersState ?? {},
       _currentPlayerId = currentPlayerId,
       _deck = deck ?? DeckStateBuilder().build(),
       _direction = direction,
       _currentRound = currentRound,
       _maxRounds = maxRounds,
       _lastActionTime = lastActionTime ?? DateTime.now(),
       _isLastRound = isLastRound,
       _lastRoundInitiator = lastRoundInitiator,
       _isPaused = isPaused {
    // Auto-generate player states if not provided
    if (_playersState.isEmpty && _players.isNotEmpty) {
      _playersState = {
        for (final player in _players)
          player.id: PlayerStateBuilder().withPlayerId(player.id).build(),
      };
    }
  }

  GameStateBuilder withId(String id) {
    _id = id;
    return this;
  }

  GameStateBuilder withRoomId(String roomId) {
    _roomId = roomId;
    return this;
  }

  GameStateBuilder withPlayers(List<GamePlayer> players) {
    _players = players;
    return this;
  }

  GameStateBuilder withPlayerStates(Map<String, PlayerState> playersState) {
    _playersState = playersState;
    return this;
  }

  GameStateBuilder withCurrentPlayerId(String currentPlayerId) {
    _currentPlayerId = currentPlayerId;
    return this;
  }

  GameStateBuilder withDeck(DeckState deck) {
    _deck = deck;
    return this;
  }

  GameStateBuilder withDirection(PlayDirection direction) {
    _direction = direction;
    return this;
  }

  GameStateBuilder withCurrentRound(int currentRound) {
    _currentRound = currentRound;
    return this;
  }

  GameStateBuilder withMaxRounds(int maxRounds) {
    _maxRounds = maxRounds;
    return this;
  }

  GameStateBuilder withLastActionTime(DateTime lastActionTime) {
    _lastActionTime = lastActionTime;
    return this;
  }

  GameStateBuilder inLastRound() => withLastRound(true);
  GameStateBuilder notInLastRound() => withLastRound(false);

  GameStateBuilder withLastRound(bool isLastRound) {
    _isLastRound = isLastRound;
    return this;
  }

  GameStateBuilder withLastRoundInitiator(String? lastRoundInitiator) {
    _lastRoundInitiator = lastRoundInitiator;
    return this;
  }

  GameStateBuilder paused() => withPaused(true);
  GameStateBuilder playing() => withPaused(false);

  GameStateBuilder withPaused(bool isPaused) {
    _isPaused = isPaused;
    return this;
  }

  GameState build() => GameState(
    id: _id,
    roomId: _roomId,
    players: _players,
    playersState: _playersState,
    currentPlayerId: _currentPlayerId,
    deck: _deck,
    direction: _direction,
    currentRound: _currentRound,
    maxRounds: _maxRounds,
    lastActionTime: _lastActionTime,
    isLastRound: _isLastRound,
    lastRoundInitiator: _lastRoundInitiator,
    isPaused: _isPaused,
  );
}

/// Test Data Builder for ActionCard entity
class ActionCardBuilder {
  String _id;
  ActionCardType _type;
  String _name;
  String _description;
  ActionTiming _timing;
  ActionTarget _target;
  Map<String, dynamic> _parameters;

  ActionCardBuilder({
    String? id,
    ActionCardType type = ActionCardType.draw,
    String? name,
    String? description,
    ActionTiming timing = ActionTiming.optional,
    ActionTarget target = ActionTarget.none,
    Map<String, dynamic>? parameters,
  }) : _id = id ?? 'action-${DateTime.now().millisecondsSinceEpoch}',
       _type = type,
       _name = name ?? _getDefaultName(type),
       _description = description ?? _getDefaultDescription(type),
       _timing = timing,
       _target = target,
       _parameters = parameters ?? {};

  static String _getDefaultName(ActionCardType type) {
    switch (type) {
      case ActionCardType.draw:
        return 'Piocher';
      case ActionCardType.swap:
        return 'Échanger';
      case ActionCardType.reveal:
        return 'Révéler';
      case ActionCardType.teleport:
        return 'Téléporter';
      default:
        return type.name;
    }
  }

  static String _getDefaultDescription(ActionCardType type) {
    switch (type) {
      case ActionCardType.draw:
        return 'Piochez une carte';
      case ActionCardType.swap:
        return 'Échangez deux cartes';
      case ActionCardType.reveal:
        return 'Révélez une carte';
      case ActionCardType.teleport:
        return 'Déplacez une carte';
      default:
        return 'Action: ${type.name}';
    }
  }

  ActionCardBuilder withId(String id) {
    _id = id;
    return this;
  }

  ActionCardBuilder withType(ActionCardType type) {
    _type = type;
    _name = _getDefaultName(type);
    _description = _getDefaultDescription(type);
    return this;
  }

  ActionCardBuilder withName(String name) {
    _name = name;
    return this;
  }

  ActionCardBuilder withDescription(String description) {
    _description = description;
    return this;
  }

  ActionCardBuilder withTiming(ActionTiming timing) {
    _timing = timing;
    return this;
  }

  ActionCardBuilder immediate() => withTiming(ActionTiming.immediate);
  ActionCardBuilder optional() => withTiming(ActionTiming.optional);
  ActionCardBuilder reactive() => withTiming(ActionTiming.reactive);

  ActionCardBuilder withTarget(ActionTarget target) {
    _target = target;
    return this;
  }

  ActionCardBuilder withParameters(Map<String, dynamic> parameters) {
    _parameters = parameters;
    return this;
  }

  ActionCard build() => ActionCard(
    id: _id,
    type: _type,
    name: _name,
    description: _description,
    timing: _timing,
    target: _target,
    parameters: _parameters,
  );
}

/// Test Data Builder for Room entity
class RoomBuilder {
  String _id;
  String _hostId;
  List<GamePlayer> _players;
  bool _isStarted;
  DateTime _createdAt;
  int _maxPlayers;
  String? _gameStateId;

  RoomBuilder({
    String id = 'room-1',
    String hostId = 'host-1',
    List<GamePlayer>? players,
    bool isStarted = false,
    DateTime? createdAt,
    int maxPlayers = 8,
    String? gameStateId,
  }) : _id = id,
       _hostId = hostId,
       _players =
           players ?? [GamePlayerBuilder().withId(hostId).asHost().build()],
       _isStarted = isStarted,
       _createdAt = createdAt ?? DateTime.now(),
       _maxPlayers = maxPlayers,
       _gameStateId = gameStateId;

  RoomBuilder withId(String id) {
    _id = id;
    return this;
  }

  RoomBuilder withHostId(String hostId) {
    _hostId = hostId;
    return this;
  }

  RoomBuilder withPlayers(List<GamePlayer> players) {
    _players = players;
    return this;
  }

  RoomBuilder withMaxPlayers(int maxPlayers) {
    _maxPlayers = maxPlayers;
    return this;
  }

  RoomBuilder started() => withStarted(true);
  RoomBuilder notStarted() => withStarted(false);

  RoomBuilder withStarted(bool isStarted) {
    _isStarted = isStarted;
    return this;
  }

  RoomBuilder withCreatedAt(DateTime createdAt) {
    _createdAt = createdAt;
    return this;
  }

  RoomBuilder withGameStateId(String? gameStateId) {
    _gameStateId = gameStateId;
    return this;
  }

  Room build() => Room(
    id: _id,
    hostId: _hostId,
    players: _players,
    isStarted: _isStarted,
    createdAt: _createdAt,
    maxPlayers: _maxPlayers,
    gameStateId: _gameStateId,
  );
}

/// Test Data Builder for EndGameState entity
class EndGameStateBuilder {
  String _roomId;
  List<PlayerScore> _playerScores;
  String _winnerId;
  int _roundsPlayed;
  DateTime _endTime;

  EndGameStateBuilder({
    String roomId = 'room-1',
    List<PlayerScore>? playerScores,
    String winnerId = 'player-1',
    int roundsPlayed = 5,
    DateTime? endTime,
  }) : _roomId = roomId,
       _playerScores =
           playerScores ??
           [
             PlayerScore(
               playerId: 'player-1',
               playerName: 'Player 1',
               score: 50,
               isWinner: true,
             ),
             PlayerScore(
               playerId: 'player-2',
               playerName: 'Player 2',
               score: 75,
               isWinner: false,
             ),
           ],
       _winnerId = winnerId,
       _roundsPlayed = roundsPlayed,
       _endTime = endTime ?? DateTime.now();

  EndGameStateBuilder withRoomId(String roomId) {
    _roomId = roomId;
    return this;
  }

  EndGameStateBuilder withPlayerScores(List<PlayerScore> playerScores) {
    _playerScores = playerScores;
    return this;
  }

  EndGameStateBuilder withWinnerId(String winnerId) {
    _winnerId = winnerId;
    return this;
  }

  EndGameStateBuilder withRoundsPlayed(int roundsPlayed) {
    _roundsPlayed = roundsPlayed;
    return this;
  }

  EndGameStateBuilder withEndTime(DateTime endTime) {
    _endTime = endTime;
    return this;
  }

  EndGameState build() => EndGameState(
    roomId: _roomId,
    playerScores: _playerScores,
    winnerId: _winnerId,
    roundsPlayed: _roundsPlayed,
    endTime: _endTime,
  );
}

/// Helper builder for PlayerScore
class PlayerScoreBuilder {
  String _playerId;
  String _playerName;
  int _score;
  bool _isWinner;

  PlayerScoreBuilder({
    String playerId = 'player-1',
    String playerName = 'Player 1',
    int score = 0,
    bool isWinner = false,
  }) : _playerId = playerId,
       _playerName = playerName,
       _score = score,
       _isWinner = isWinner;

  PlayerScoreBuilder withPlayerId(String playerId) {
    _playerId = playerId;
    return this;
  }

  PlayerScoreBuilder withPlayerName(String playerName) {
    _playerName = playerName;
    return this;
  }

  PlayerScoreBuilder withScore(int score) {
    _score = score;
    return this;
  }

  PlayerScoreBuilder asWinner() => withWinner(true);
  PlayerScoreBuilder asLoser() => withWinner(false);

  PlayerScoreBuilder withWinner(bool isWinner) {
    _isWinner = isWinner;
    return this;
  }

  PlayerScore build() => PlayerScore(
    playerId: _playerId,
    playerName: _playerName,
    score: _score,
    isWinner: _isWinner,
  );
}

/// Test Data Builder for CardPosition entity
class CardPositionBuilder {
  int _row;
  int _col;

  CardPositionBuilder({int row = 0, int col = 0}) : _row = row, _col = col;

  CardPositionBuilder withRow(int row) {
    _row = row;
    return this;
  }

  CardPositionBuilder withCol(int col) {
    _col = col;
    return this;
  }

  CardPositionBuilder at(int row, int col) {
    _row = row;
    _col = col;
    return this;
  }

  CardPosition build() => CardPosition(row: _row, col: _col);
}
