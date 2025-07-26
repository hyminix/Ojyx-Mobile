import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'dart:convert';

void main() {
  group('JSON Serialization Tests', () {
    group('Card Entity Serialization', () {
      test('should serialize/deserialize Card correctly', () {
        const card = Card(value: 7, isRevealed: true);

        final json = card.toJson();
        expect(json['value'], 7);
        expect(json['is_revealed'], true);

        final decoded = Card.fromJson(json);
        expect(decoded, equals(card));
      });

      test('should handle Card with default values', () {
        const card = Card(value: -2);

        final json = card.toJson();
        expect(json['value'], -2);
        expect(json['is_revealed'], false);

        final decoded = Card.fromJson(json);
        expect(decoded.value, -2);
        expect(decoded.isRevealed, false);
      });

      test('should round-trip Card through JSON string', () {
        const card = Card(value: 10, isRevealed: true);

        final jsonString = jsonEncode(card.toJson());
        final decoded = Card.fromJson(jsonDecode(jsonString));

        expect(decoded, equals(card));
      });
    });

    group('PlayerGrid Entity Serialization', () {
      test('should serialize/deserialize empty PlayerGrid', () {
        final grid = PlayerGrid.empty();

        final json = grid.toJson();
        expect(json['cards'], isA<List>());
        expect((json['cards'] as List).length, 3); // 3 rows

        final decoded = PlayerGrid.fromJson(json);
        expect(decoded, equals(grid));
      });

      test('should serialize/deserialize PlayerGrid with cards', () {
        final grid = PlayerGrid.empty()
            .setCard(0, 0, const Card(value: 5))
            .setCard(1, 1, const Card(value: -2, isRevealed: true))
            .setCard(2, 3, const Card(value: 10));

        final json = grid.toJson();
        final decoded = PlayerGrid.fromJson(json);

        expect(decoded.getCard(0, 0)?.value, 5);
        expect(decoded.getCard(1, 1)?.value, -2);
        expect(decoded.getCard(1, 1)?.isRevealed, true);
        expect(decoded.getCard(2, 3)?.value, 10);
      });

      test('should handle null cards in grid', () {
        final grid = PlayerGrid.empty()
            .setCard(0, 0, const Card(value: 5))
            .setCard(0, 0, null); // Remove card

        final json = grid.toJson();
        final decoded = PlayerGrid.fromJson(json);

        expect(decoded.getCard(0, 0), isNull);
      });
    });

    group('GamePlayer Entity Serialization', () {
      test('should serialize/deserialize GamePlayer', () {
        final player = GamePlayer(
          id: 'player1',
          name: 'Test Player',
          grid: PlayerGrid.empty().setCard(0, 0, const Card(value: 5)),
          actionCards: const [],
          isConnected: true,
          isHost: false,
          hasFinishedRound: false,
          scoreMultiplier: 1,
        );

        final json = player.toJson();
        expect(json['id'], 'player1');
        expect(json['name'], 'Test Player');
        expect(json['is_connected'], true);

        final decoded = GamePlayer.fromJson(json);
        expect(decoded.id, player.id);
        expect(decoded.name, player.name);
        expect(decoded.grid.getCard(0, 0)?.value, 5);
      });
    });

    group('Room Entity Serialization', () {
      test('should serialize/deserialize Room', () {
        final room = Room(
          id: 'room1',
          creatorId: 'creator1',
          playerIds: const ['player1', 'player2'],
          status: RoomStatus.waiting,
          maxPlayers: 8,
          createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
        );

        final json = room.toJson();
        expect(json['id'], 'room1');
        expect(json['creator_id'], 'creator1');
        expect(json['player_ids'], ['player1', 'player2']);
        expect(json['status'], 'waiting');

        final decoded = Room.fromJson(json);
        expect(decoded, equals(room));
      });
    });

    group('Malformed JSON Handling', () {
      test('should throw on invalid Card JSON', () {
        expect(
          () => Card.fromJson({'invalid': 'data'}),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw on missing required fields', () {
        expect(
          () => Room.fromJson({
            'id': 'room1',
            // Missing creatorId, playerIds, status, maxPlayers
          }),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Performance Tests', () {
      test('should serialize large PlayerGrid efficiently', () {
        final stopwatch = Stopwatch()..start();

        // Create a full grid
        var grid = PlayerGrid.empty();
        for (int row = 0; row < 3; row++) {
          for (int col = 0; col < 4; col++) {
            grid = grid.setCard(
              row,
              col,
              Card(value: (row * 4 + col) % 13 - 2),
            );
          }
        }

        // Serialize 1000 times
        for (int i = 0; i < 1000; i++) {
          final json = grid.toJson();
          PlayerGrid.fromJson(json);
        }

        stopwatch.stop();
        print(
          '1000 PlayerGrid serializations took ${stopwatch.elapsedMilliseconds}ms',
        );

        // Should complete in reasonable time (< 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });
  });
}
