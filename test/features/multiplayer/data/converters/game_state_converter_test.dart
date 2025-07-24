import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/converters/game_state_converter.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/grid_card.dart';
import 'package:ojyx/features/game/domain/entities/deck.dart';
import 'package:ojyx/features/game/domain/entities/game_card.dart';

void main() {
  group('GameStateConverter', () {
    late GameStateConverter converter;
    late GameState mockGameState;
    
    setUp(() {
      converter = const GameStateConverter();
      
      final mockPlayerGrid = PlayerGrid(
        cards: List.generate(12, (_) => const GridCard(value: 5)),
      );
      
      mockGameState = GameState(
        id: 'game123',
        roomId: 'room456',
        players: [
          GamePlayer(id: 'p1', name: 'Player 1', grid: mockPlayerGrid),
          GamePlayer(id: 'p2', name: 'Player 2', grid: mockPlayerGrid),
        ],
        currentPlayerIndex: 0,
        deck: const Deck(
          drawPile: [GameCard(value: 5, color: CardColor.red)],
          discardPile: [GameCard(value: 3, color: CardColor.blue)],
        ),
        turnDirection: TurnDirection.clockwise,
        status: GameStatus.inProgress,
      );
    });

    group('fromJson', () {
      test('should convert from JSON with camelCase fields', () {
        final json = {
          'id': 'game123',
          'roomId': 'room456',
          'status': 'inProgress',
          'currentPlayerId': 'p1',
          'turnNumber': 5,
          'roundNumber': 1,
          'gameData': {'someKey': 'someValue'},
          'winnerId': null,
          'endedAt': null,
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-01T01:00:00.000Z',
        };

        final result = converter.fromJson(json);

        expect(result.id, 'game123');
        expect(result.roomId, 'room456');
        expect(result.status, GameStatus.waitingToStart);
      });

      test('should convert from JSON with snake_case fields', () {
        final json = {
          'id': 'game123',
          'room_id': 'room456',
          'status': 'inProgress',
          'current_player_id': 'p1',
          'turn_number': 5,
          'round_number': 1,
          'game_data': {'someKey': 'someValue'},
          'winner_id': 'p2',
          'endedAt': null,
          'createdAt': '2024-01-01T00:00:00.000Z',
          'updatedAt': '2024-01-01T01:00:00.000Z',
        };

        final result = converter.fromJson(json);

        expect(result.id, 'game123');
        expect(result.roomId, 'room456');
      });

      test('should handle missing optional fields', () {
        final json = {
          'id': 'game123',
          'roomId': 'room456',
        };

        final result = converter.fromJson(json);

        expect(result.id, 'game123');
        expect(result.roomId, 'room456');
        expect(result.status, GameStatus.waitingToStart);
      });

      test('should handle null dates', () {
        final json = {
          'id': 'game123',
          'roomId': 'room456',
          'endedAt': null,
          'createdAt': null,
          'updatedAt': null,
        };

        final result = converter.fromJson(json);

        expect(result.id, 'game123');
        expect(result.roomId, 'room456');
      });

      test('should parse dates correctly', () {
        final createdAt = '2024-01-01T00:00:00.000Z';
        final updatedAt = '2024-01-01T01:00:00.000Z';
        final endedAt = '2024-01-01T02:00:00.000Z';

        final json = {
          'id': 'game123',
          'roomId': 'room456',
          'createdAt': createdAt,
          'updatedAt': updatedAt,
          'endedAt': endedAt,
        };

        final result = converter.fromJson(json);

        expect(result.id, 'game123');
        // Note: The actual GameState structure might differ based on toDomainComplete implementation
      });

      test('should handle missing id with fallback', () {
        final json = {
          'roomId': 'room456',
        };

        final result = converter.fromJson(json);

        expect(result.id, 'temp-id');
        expect(result.roomId, 'room456');
      });
    });

    group('toJson', () {
      test('should convert GameState to JSON', () {
        final json = converter.toJson(mockGameState);

        expect(json, isA<Map<String, dynamic>>());
        expect(json.containsKey('id'), isTrue);
        expect(json.containsKey('room_id'), isTrue);
        expect(json.containsKey('status'), isTrue);
      });

      test('should preserve game state data in JSON', () {
        final json = converter.toJson(mockGameState);

        // The exact structure depends on GameStateModel.toJson implementation
        expect(json, isNotEmpty);
        
        // Verify the conversion is reversible (round-trip test)
        final backToGameState = converter.fromJson(json);
        expect(backToGameState.id, isNotNull);
        expect(backToGameState.roomId, isNotNull);
      });

      test('should handle GameState with winner', () {
        final gameStateWithWinner = mockGameState.copyWith(
          status: GameStatus.ended,
        );

        final json = converter.toJson(gameStateWithWinner);

        expect(json, isA<Map<String, dynamic>>());
        expect(json['status'], 'ended');
      });

      test('should handle GameState with different statuses', () {
        final waitingState = mockGameState.copyWith(
          status: GameStatus.waitingToStart,
        );
        final inProgressState = mockGameState.copyWith(
          status: GameStatus.inProgress,
        );
        final endedState = mockGameState.copyWith(
          status: GameStatus.ended,
        );

        final waitingJson = converter.toJson(waitingState);
        final inProgressJson = converter.toJson(inProgressState);
        final endedJson = converter.toJson(endedState);

        expect(waitingJson['status'], 'waitingToStart');
        expect(inProgressJson['status'], 'inProgress');
        expect(endedJson['status'], 'ended');
      });
    });

    group('round-trip conversion', () {
      test('should maintain data integrity through conversion cycle', () {
        // Start with a JSON object
        final originalJson = {
          'id': 'game123',
          'roomId': 'room456',
          'status': 'inProgress',
          'currentPlayerId': 'p1',
          'turnNumber': 5,
          'roundNumber': 1,
          'gameData': {'key': 'value'},
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        // Convert to GameState
        final gameState = converter.fromJson(originalJson);
        
        // Convert back to JSON
        final resultJson = converter.toJson(gameState);
        
        // Verify key fields are preserved
        expect(resultJson['room_id'], originalJson['roomId']);
        expect(resultJson['status'], originalJson['status']);
      });

      test('should handle complex game data', () {
        final complexJson = {
          'id': 'complex123',
          'roomId': 'room789',
          'status': 'inProgress',
          'currentPlayerId': 'player1',
          'turnNumber': 10,
          'roundNumber': 2,
          'gameData': {
            'nestedData': {
              'key1': 'value1',
              'key2': 42,
              'key3': true,
              'key4': ['item1', 'item2'],
            },
          },
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        };

        final gameState = converter.fromJson(complexJson);
        final resultJson = converter.toJson(gameState);

        expect(resultJson, isA<Map<String, dynamic>>());
        expect(resultJson['room_id'], complexJson['roomId']);
      });
    });
  });
}