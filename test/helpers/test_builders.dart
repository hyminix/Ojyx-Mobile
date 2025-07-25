import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/deck_state.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/lobby_player.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';

/// Builder pattern for creating test entities with sensible defaults
/// Reduces duplication and improves test readability

class TestCardBuilder {
  int _value = 5;
  bool _isRevealed = false;

  TestCardBuilder value(int value) {
    _value = value;
    return this;
  }

  TestCardBuilder revealed() {
    _isRevealed = true;
    return this;
  }

  TestCardBuilder hidden() {
    _isRevealed = false;
    return this;
  }

  game.Card build() => game.Card(value: _value, isRevealed: _isRevealed);
}

class TestActionCardBuilder {
  String _id = 'test-action-card';
  ActionCardType _type = ActionCardType.teleport;
  String _name = 'Test Card';
  String _description = 'Test action card';
  ActionTiming _timing = ActionTiming.optional;
  ActionTarget _target = ActionTarget.self;
  Map<String, dynamic> _parameters = {};

  TestActionCardBuilder id(String id) {
    _id = id;
    return this;
  }

  TestActionCardBuilder type(ActionCardType type) {
    _type = type;
    return this;
  }

  TestActionCardBuilder name(String name) {
    _name = name;
    return this;
  }

  TestActionCardBuilder immediate() {
    _timing = ActionTiming.immediate;
    return this;
  }

  TestActionCardBuilder optional() {
    _timing = ActionTiming.optional;
    return this;
  }

  TestActionCardBuilder reactive() {
    _timing = ActionTiming.reactive;
    return this;
  }

  TestActionCardBuilder targetSelf() {
    _target = ActionTarget.self;
    return this;
  }

  TestActionCardBuilder targetOpponent() {
    _target = ActionTarget.singleOpponent;
    return this;
  }

  TestActionCardBuilder parameters(Map<String, dynamic> params) {
    _parameters = params;
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

class TestPlayerGridBuilder {
  List<game.Card> _cards = [];

  TestPlayerGridBuilder() {
    // Default 3x4 grid with some revealed cards
    _cards = List.generate(
      12,
      (i) => TestCard().value(i % 13 - 2).build(),
    );
    // Reveal first two cards by default
    _cards[0] = TestCard().value(_cards[0].value).revealed().build();
    _cards[1] = TestCard().value(_cards[1].value).revealed().build();
  }

  TestPlayerGridBuilder cards(List<game.Card> cards) {
    if (cards.length != 12) {
      throw ArgumentError('Player grid must have exactly 12 cards');
    }
    _cards = cards;
    return this;
  }

  TestPlayerGridBuilder revealCard(int index) {
    if (index < 0 || index >= 12) {
      throw ArgumentError('Card index must be between 0 and 11');
    }
    _cards[index] = game.Card(value: _cards[index].value, isRevealed: true);
    return this;
  }

  TestPlayerGridBuilder revealColumn(int column) {
    if (column < 0 || column >= 4) {
      throw ArgumentError('Column must be between 0 and 3');
    }
    for (int row = 0; row < 3; row++) {
      final index = row * 4 + column;
      revealCard(index);
    }
    return this;
  }

  TestPlayerGridBuilder allRevealed() {
    for (int i = 0; i < 12; i++) {
      revealCard(i);
    }
    return this;
  }

  PlayerGrid build() => PlayerGrid.fromCards(_cards);
}

class TestGamePlayerBuilder {
  String _id = 'test-player';
  String _name = 'Test Player';
  PlayerGrid? _grid;
  List<ActionCard> _actionCards = [];
  bool _isConnected = true;
  bool _isHost = false;
  bool _hasFinishedRound = false;
  int _scoreMultiplier = 1;

  TestGamePlayerBuilder id(String id) {
    _id = id;
    return this;
  }

  TestGamePlayerBuilder name(String name) {
    _name = name;
    return this;
  }

  TestGamePlayerBuilder grid(PlayerGrid grid) {
    _grid = grid;
    return this;
  }

  TestGamePlayerBuilder host() {
    _isHost = true;
    return this;
  }

  TestGamePlayerBuilder disconnected() {
    _isConnected = false;
    return this;
  }

  TestGamePlayerBuilder finishedRound() {
    _hasFinishedRound = true;
    return this;
  }

  TestGamePlayerBuilder actionCards(List<ActionCard> cards) {
    _actionCards = cards;
    return this;
  }

  TestGamePlayerBuilder scoreMultiplier(int multiplier) {
    _scoreMultiplier = multiplier;
    return this;
  }

  GamePlayer build() => GamePlayer(
        id: _id,
        name: _name,
        grid: _grid ?? TestPlayerGrid().build(),
        actionCards: _actionCards,
        isConnected: _isConnected,
        isHost: _isHost,
        hasFinishedRound: _hasFinishedRound,
        scoreMultiplier: _scoreMultiplier,
      );
}

class TestGameStateBuilder {
  String _roomId = 'test-room';
  List<GamePlayer> _players = [];
  List<game.Card> _deck = [];
  List<game.Card> _discardPile = [];
  int _currentPlayerIndex = 0;
  TurnDirection _turnDirection = TurnDirection.clockwise;
  bool _lastRound = false;
  String? _initiatorPlayerId;
  GameStatus _status = GameStatus.playing;
  List<ActionCard> _actionDeck = [];
  List<ActionCard> _actionDiscard = [];

  TestGameStateBuilder() {
    // Default setup with 2 players and a standard deck
    _players = [
      TestGamePlayer().id('player1').name('Player 1').host().build(),
      TestGamePlayer().id('player2').name('Player 2').build(),
    ];
    _deck = List.generate(
      52,
      (i) => TestCard().value(i % 13 - 2).build(),
    );
    _discardPile = [TestCard().value(5).revealed().build()];
  }

  TestGameStateBuilder roomId(String roomId) {
    _roomId = roomId;
    return this;
  }

  TestGameStateBuilder players(List<GamePlayer> players) {
    _players = players;
    return this;
  }

  TestGameStateBuilder addPlayer(GamePlayer player) {
    _players.add(player);
    return this;
  }

  TestGameStateBuilder currentPlayer(int index) {
    _currentPlayerIndex = index;
    return this;
  }

  TestGameStateBuilder status(GameStatus status) {
    _status = status;
    return this;
  }

  TestGameStateBuilder lastRound({String? initiator}) {
    _lastRound = true;
    _initiatorPlayerId = initiator ?? _players.first.id;
    return this;
  }

  TestGameStateBuilder counterClockwise() {
    _turnDirection = TurnDirection.counterClockwise;
    return this;
  }

  TestGameStateBuilder emptyDeck() {
    _deck.clear();
    return this;
  }

  TestGameStateBuilder actionCards(List<ActionCard> actionDeck) {
    _actionDeck = actionDeck;
    return this;
  }

  GameState build() => GameState(
        roomId: _roomId,
        players: _players,
        deck: _deck,
        discardPile: _discardPile,
        currentPlayerIndex: _currentPlayerIndex,
        turnDirection: _turnDirection,
        lastRound: _lastRound,
        initiatorPlayerId: _initiatorPlayerId,
        status: _status,
        actionDeck: _actionDeck,
        actionDiscard: _actionDiscard,
      );
}

class TestRoomBuilder {
  String _id = 'test-room';
  String _hostId = 'test-host';
  int _maxPlayers = 4;
  List<String> _playerIds = [];
  RoomStatus _status = RoomStatus.waiting;
  String? _gameStateJson;
  DateTime? _createdAt;
  DateTime? _updatedAt;

  TestRoomBuilder() {
    _playerIds = [_hostId];
    _createdAt = DateTime.now();
    _updatedAt = DateTime.now();
  }

  TestRoomBuilder id(String id) {
    _id = id;
    return this;
  }

  TestRoomBuilder host(String hostId) {
    _hostId = hostId;
    _playerIds = [hostId, ..._playerIds.where((id) => id != hostId)];
    return this;
  }

  TestRoomBuilder maxPlayers(int max) {
    _maxPlayers = max;
    return this;
  }

  TestRoomBuilder addPlayer(String playerId) {
    if (!_playerIds.contains(playerId)) {
      _playerIds.add(playerId);
    }
    return this;
  }

  TestRoomBuilder status(RoomStatus status) {
    _status = status;
    return this;
  }

  TestRoomBuilder playing() {
    _status = RoomStatus.playing;
    return this;
  }

  TestRoomBuilder full() {
    while (_playerIds.length < _maxPlayers) {
      _playerIds.add('player-${_playerIds.length}');
    }
    return this;
  }

  Room build() => Room(
        id: _id,
        hostId: _hostId,
        maxPlayers: _maxPlayers,
        playerIds: _playerIds,
        status: _status,
        gameStateJson: _gameStateJson,
        createdAt: _createdAt!,
        updatedAt: _updatedAt!,
      );
}

// Convenient static methods for quick access
class TestCard extends TestCardBuilder {}
class TestActionCard extends TestActionCardBuilder {}
class TestPlayerGrid extends TestPlayerGridBuilder {}
class TestGamePlayer extends TestGamePlayerBuilder {}
class TestGameState extends TestGameStateBuilder {}
class TestRoom extends TestRoomBuilder {}

/// Helper function to create a test widget with providers
Widget createTestWidget({
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

/// Helper function for parameterized testing
void testParameterized<T>(
  String description,
  List<T> testCases,
  void Function(T testCase) testFunction, {
  String Function(T)? caseDescription,
}) {
  for (final testCase in testCases) {
    final caseDesc = caseDescription?.call(testCase) ?? testCase.toString();
    test('$description - $caseDesc', () => testFunction(testCase));
  }
}

/// Helper for widget parameterized testing
void testWidgetsParameterized<T>(
  String description,
  List<T> testCases,
  void Function(WidgetTester tester, T testCase) testFunction, {
  String Function(T)? caseDescription,
}) {
  for (final testCase in testCases) {
    final caseDesc = caseDescription?.call(testCase) ?? testCase.toString();
    testWidgets('$description - $caseDesc', (tester) => testFunction(tester, testCase));
  }
}