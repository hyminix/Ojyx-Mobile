import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/converters/game_state_converter.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';

void main() {
  group('GameStateConverter', () {
    late GameStateConverter converter;
    late GameState mockGameState;
    
    setUp(() {
      converter = const GameStateConverter();
      
      final mockPlayerGrid = PlayerGrid(
        cards: List.generate(3, (_) => List.generate(4, (_) => null)),
      );
      
      mockGameState = GameState(
        roomId: 'room456',
        players: [
          GamePlayer(
            id: 'p1', 
            name: 'Player 1', 
            grid: mockPlayerGrid,
            actionCards: [],
            isConnected: true,
            isHost: true,
            hasFinishedRound: false,
            scoreMultiplier: 1,
          ),
          GamePlayer(
            id: 'p2', 
            name: 'Player 2', 
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
    });

    group('fromJson', () {
      test('should convert from JSON with camelCase fields', () {
        final json = {
          'id': 'game123',
          'roomId': 'room456',
          'status': 'playing',
          'currentPlayerId': 'p1',
          'turnNumber': 5,
          'roundNumber': 1,
          'gameData': {
            'players': [
              {
                'id': 'p1',
                'name': 'Player 1',
                'grid': {
                  'cards': List.generate(3, (_) => List.generate(4, (_) => null)),
                },
                'actionCards': [],
                'isConnected': true,
                'isHost': true,
                'hasFinishedRound': false,
                'scoreMultiplier': 1,
              }
            ],
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

        final result = converter.fromJson(json);
        
        expect(result.roomId, 'room456');
        expect(result.status, GameStatus.playing);
        expect(result.players.length, 1);
        expect(result.players.first.id, 'p1');
      });

      test('should convert from JSON with snake_case fields', () {
        final json = {
          'id': 'game123',
          'room_id': 'room456',
          'status': 'playing',
          'current_player_id': 'p1',
          'turn_number': 5,
          'round_number': 1,
          'game_data': {
            'players': [
              {
                'id': 'p1',
                'name': 'Player 1',
                'grid': {
                  'cards': List.generate(3, (_) => List.generate(4, (_) => null)),
                },
                'actionCards': [],
                'isConnected': true,
                'isHost': true,
                'hasFinishedRound': false,
                'scoreMultiplier': 1,
              }
            ],
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
          'winner_id': null,
          'ended_at': null,
        };

        final result = converter.fromJson(json);
        
        expect(result.roomId, 'room456');
        expect(result.status, GameStatus.playing);
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': 'game123',
          'room_id': 'room456',
          'status': 'waitingToStart',
          'current_player_id': 'p1',
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

        final result = converter.fromJson(json);
        
        expect(result.roomId, 'room456');
        expect(result.status, GameStatus.waitingToStart);
      });

      test('should generate temporary ID if not provided', () {
        final json = {
          'room_id': 'room456',
          'status': 'playing',
          'current_player_id': 'p1',
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

        final result = converter.fromJson(json);
        
        expect(result.roomId, 'room456');
      });
    });

    group('toJson', () {
      test('should convert GameState to JSON with snake_case fields', () {
        final json = converter.toJson(mockGameState);
        
        expect(json['room_id'], 'room456');
        expect(json['status'], 'playing');
        expect(json['current_player_id'], 'p1');
        expect(json['game_data'], isNotNull);
        expect(json['game_data']['players'], isNotNull);
        expect(json['game_data']['players'], hasLength(2));
      });

      test('should handle roundtrip conversion', () {
        final json = converter.toJson(mockGameState);
        final backToGameState = converter.fromJson(json);
        
        expect(backToGameState.roomId, mockGameState.roomId);
        expect(backToGameState.status, mockGameState.status);
        expect(backToGameState.players.length, mockGameState.players.length);
      });
    });
  });
}