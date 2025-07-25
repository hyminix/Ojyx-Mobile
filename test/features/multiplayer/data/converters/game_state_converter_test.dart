import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/converters/game_state_converter.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

GameState _createTestGameState() {
  final mockPlayerGrid = PlayerGrid(
    cards: List.generate(3, (_) => List.generate(4, (_) => null)),
  );

  return GameState(
    roomId: 'competitive-room-456',
    players: [
      GamePlayer(
        id: 'player-one',
        name: 'Strategic Player',
        grid: mockPlayerGrid,
        actionCards: [],
        isConnected: true,
        isHost: true,
        hasFinishedRound: false,
        scoreMultiplier: 1,
      ),
      GamePlayer(
        id: 'player-two', 
        name: 'Tactical Player',
        grid: mockPlayerGrid,
        actionCards: [],
        isConnected: true,
        isHost: false,
        hasFinishedRound: false,
        scoreMultiplier: 1,
      ),
    ],
    currentPlayerIndex: 0,
    deck: [Card(value: 5)],
    discardPile: [Card(value: 3)],
    actionDeck: [],
    actionDiscard: [],
    turnDirection: TurnDirection.clockwise,
    status: GameStatus.playing,
    lastRound: false,
    initiatorPlayerId: null,
    endRoundInitiator: null,
    drawnCard: null,
    createdAt: DateTime.now(),
    startedAt: DateTime.now(),
    finishedAt: null,
  );
}

void main() {
  group('Game State Data Conversion for Multiplayer Persistence', () {
    late GameStateConverter converter;
    late GameState testGameState;

    setUp(() {
      converter = const GameStateConverter();
      testGameState = _createTestGameState();
    });

    test('should enable bidirectional game state conversion for multiplayer persistence and synchronization', () {
      // Test behavior: seamless conversion between domain objects and persistence layer for multiplayer game continuity
      final persistedGameData = {
        'room_id': 'competitive-room-456',
        'status': 'playing',
        'current_player_id': 'player-one',
        'turn_number': 5,
        'round_number': 2,
        'game_data': {
          'players': [
            {
              'id': 'player-one',
              'name': 'Strategic Player',
              'grid': {
                'cards': List.generate(3, (_) => List.generate(4, (_) => null)),
              },
              'actionCards': [],
              'isConnected': true,
              'isHost': true,
              'hasFinishedRound': false,
              'scoreMultiplier': 1,
            },
            {
              'id': 'player-two',
              'name': 'Tactical Player', 
              'grid': {
                'cards': List.generate(3, (_) => List.generate(4, (_) => null)),
              },
              'actionCards': [],
              'isConnected': true,
              'isHost': false,
              'hasFinishedRound': false,
              'scoreMultiplier': 1,
            },
          ],
          'currentPlayerIndex': 0,
          'deck': [{'value': 8}],
          'discardPile': [{'value': 3}],
          'actionDeck': [],
          'actionDiscard': [],
          'turnDirection': 'clockwise',
          'lastRound': false,
          'initiatorPlayerId': null,
          'endRoundInitiator': null,
          'drawnCard': null,
          'startedAt': DateTime.now().toIso8601String(),
        },
        'winner_id': null,
        'ended_at': null,
      };

      // Database to domain conversion for game continuity
      final domainGameState = converter.fromJson(persistedGameData);
      expect(domainGameState.roomId, 'competitive-room-456', reason: 'Room context should be preserved for multiplayer continuity');
      expect(domainGameState.status, GameStatus.playing, reason: 'Game status should enable proper state management');
      expect(domainGameState.players.length, 2, reason: 'All competitive players should be restored from persistence');
      expect(domainGameState.players.first.name, 'Strategic Player', reason: 'Player identity should be maintained across sessions');

      // Domain to database conversion for state synchronization
      final synchronizedData = converter.toJson(testGameState);
      expect(synchronizedData['room_id'], 'competitive-room-456', reason: 'Room identification should be preserved for multiplayer coordination');
      expect(synchronizedData['status'], 'playing', reason: 'Game status should be consistently represented');
      expect(synchronizedData['game_data']['players'], hasLength(2), reason: 'Complete player roster should be synchronized');

      // Roundtrip conversion ensures data integrity for multiplayer persistence
      final roundtripState = converter.fromJson(converter.toJson(testGameState));
      expect(roundtripState.roomId, testGameState.roomId, reason: 'Room context should survive roundtrip conversion');
      expect(roundtripState.players.length, testGameState.players.length, reason: 'Player roster should remain complete through persistence cycles');
      expect(roundtripState.status, testGameState.status, reason: 'Game state should maintain consistency for competitive integrity');
    });

    test('should handle edge cases for robust multiplayer game persistence', () {
      // Test behavior: conversion handles incomplete or edge-case data for system resilience
      
      // Missing optional fields scenario (new game initialization)
      final minimalGameData = {
        'room_id': 'new-competitive-room',
        'status': 'waitingToStart', 
        'current_player_id': 'host-player',
        'turn_number': 1,
        'round_number': 1,
        'game_data': {
          'players': [],
          'currentPlayerIndex': 0,
          'deck': [],
          'discardPile': [],
          'actionDeck': [],
          'actionDiscard': [],
          'turnDirection': 'clockwise',
          'lastRound': false,
          'initiatorPlayerId': null,
          'endRoundInitiator': null,
          'drawnCard': null,
          'startedAt': null,
        },
      };
      
      final newGameState = converter.fromJson(minimalGameData);
      expect(newGameState.roomId, 'new-competitive-room', reason: 'New game rooms should be properly initialized');
      expect(newGameState.status, GameStatus.waitingToStart, reason: 'Pre-game status should be correctly handled');
      expect(newGameState.players, isEmpty, reason: 'Empty player roster should be valid for game initialization');
      
      // Missing ID generation scenario (temporary local games)
      final noIdGameData = {
        'room_id': 'temp-competitive-room',
        'status': 'playing',
        'current_player_id': 'temp-player',
        'turn_number': 1,
        'round_number': 1,
        'game_data': {
          'players': [],
          'currentPlayerIndex': 0,
          'deck': [],
          'discardPile': [],
          'actionDeck': [],
          'actionDiscard': [],
          'turnDirection': 'clockwise',
          'lastRound': false,
          'initiatorPlayerId': null,
          'endRoundInitiator': null,
          'drawnCard': null,
          'startedAt': null,
        },
      };
      
      final tempGameState = converter.fromJson(noIdGameData);
      expect(tempGameState.roomId, 'temp-competitive-room', reason: 'Temporary games should maintain room identity');
      
      // Mixed case convention handling (legacy compatibility)
      final mixedCaseData = {
        'id': 'legacy-game-123',
        'roomId': 'mixed-case-room', // camelCase variant
        'status': 'playing',
        'currentPlayerId': 'legacy-player', // camelCase variant
        'turnNumber': 3,
        'roundNumber': 1,
        'gameData': { // camelCase variant
          'players': [{
            'id': 'legacy-player',
            'name': 'Legacy Player',
            'grid': {'cards': List.generate(3, (_) => List.generate(4, (_) => null))},
            'actionCards': [],
            'isConnected': true,
            'isHost': true,
            'hasFinishedRound': false,
            'scoreMultiplier': 1,
          }],
          'currentPlayerIndex': 0,
          'deck': [],
          'discardPile': [],
          'actionDeck': [],
          'actionDiscard': [],
          'turnDirection': 'clockwise',
          'lastRound': false,
          'initiatorPlayerId': null,
          'endRoundInitiator': null,
          'drawnCard': null,
          'startedAt': DateTime.now().toIso8601String(),
        },
        'winnerId': null,
        'endedAt': null,
      };
      
      final legacyGameState = converter.fromJson(mixedCaseData);
      expect(legacyGameState.roomId, 'mixed-case-room', reason: 'Legacy camelCase data should be compatible');
      expect(legacyGameState.players.length, 1, reason: 'Legacy player data should be preserved');
    });
  });
}
