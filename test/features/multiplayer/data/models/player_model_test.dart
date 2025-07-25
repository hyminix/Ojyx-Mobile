import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/models/player_model.dart';
import 'package:ojyx/features/multiplayer/domain/entities/lobby_player.dart';

void main() {
  group('PlayerModel', () {
    final testCases = [
      // Case 1: Domain to Model conversion
      {
        'description': 'should handle domain to model conversion',
        'operation': 'fromDomain',
        'input': LobbyPlayer(
          id: 'test-id',
          name: 'TestPlayer',
          avatarUrl: 'http://example.com/avatar.png',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          lastSeenAt: DateTime(2024, 1, 1),
          connectionStatus: ConnectionStatus.online,
          currentRoomId: 'room-id',
        ),
        'expectedId': 'test-id',
        'expectedName': 'TestPlayer',
        'expectedAvatarUrl': 'http://example.com/avatar.png',
        'expectedConnectionStatus': 'online',
        'expectedRoomId': 'room-id',
      },
      // Case 2: Model to Domain conversion
      {
        'description': 'should handle model to domain conversion',
        'operation': 'toDomain',
        'input': PlayerModel(
          id: 'test-id',
          name: 'TestPlayer',
          avatarUrl: 'http://example.com/avatar.png',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          lastSeenAt: DateTime(2024, 1, 1),
          connectionStatus: 'online',
          currentRoomId: 'room-id',
        ),
        'expectedId': 'test-id',
        'expectedName': 'TestPlayer',
        'expectedAvatarUrl': 'http://example.com/avatar.png',
        'expectedConnectionStatus': ConnectionStatus.online,
        'expectedRoomId': 'room-id',
      },
      // Case 3: JSON serialization with null values
      {
        'description': 'should handle JSON serialization with null values',
        'operation': 'toJson',
        'input': PlayerModel(
          id: 'test-id',
          name: 'TestPlayer',
          avatarUrl: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          lastSeenAt: DateTime(2024, 1, 1),
          connectionStatus: 'offline',
          currentRoomId: null,
        ),
        'expectedId': 'test-id',
        'expectedName': 'TestPlayer',
        'expectedAvatarUrl': null,
        'expectedConnectionStatus': 'offline',
        'expectedRoomId': null,
      },
      // Case 4: JSON deserialization
      {
        'description': 'should handle JSON deserialization',
        'operation': 'fromJson',
        'input': {
          'id': 'test-id',
          'name': 'TestPlayer',
          'avatar_url': 'http://example.com/avatar.png',
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
          'last_seen_at': '2024-01-01T00:00:00.000Z',
          'connection_status': 'away',
          'current_room_id': 'room-id',
        },
        'expectedId': 'test-id',
        'expectedName': 'TestPlayer',
        'expectedAvatarUrl': 'http://example.com/avatar.png',
        'expectedConnectionStatus': 'away',
        'expectedRoomId': 'room-id',
      },
      // Case 5: JSON deserialization with null values
      {
        'description': 'should handle JSON deserialization with null values',
        'operation': 'fromJson',
        'input': {
          'id': 'test-id',
          'name': 'TestPlayer',
          'avatar_url': null,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-01-01T00:00:00.000Z',
          'last_seen_at': '2024-01-01T00:00:00.000Z',
          'connection_status': 'online',
          'current_room_id': null,
        },
        'expectedId': 'test-id',
        'expectedName': 'TestPlayer',
        'expectedAvatarUrl': null,
        'expectedConnectionStatus': 'online',
        'expectedRoomId': null,
      },
    ];

    for (final testCase in testCases) {
      test(testCase['description'] as String, () {
        final operation = testCase['operation'] as String;
        final input = testCase['input'];
        final expectedId = testCase['expectedId'];
        final expectedName = testCase['expectedName'];
        final expectedAvatarUrl = testCase['expectedAvatarUrl'];
        final expectedConnectionStatus = testCase['expectedConnectionStatus'];
        final expectedRoomId = testCase['expectedRoomId'];

        // Execute operation based on type
        dynamic result;
        switch (operation) {
          case 'fromDomain':
            result = PlayerModel.fromDomain(input as LobbyPlayer);
            break;
          case 'toDomain':
            result = (input as PlayerModel).toDomain();
            break;
          case 'toJson':
            result = (input as PlayerModel).toJson();
            break;
          case 'fromJson':
            result = PlayerModel.fromJson(input as Map<String, dynamic>);
            break;
        }

        // Verify results based on operation type
        if (operation == 'toJson') {
          final json = result as Map<String, dynamic>;
          expect(json['id'], equals(expectedId));
          expect(json['name'], equals(expectedName));
          expect(json['avatar_url'], equals(expectedAvatarUrl));
          expect(json['connection_status'], equals(expectedConnectionStatus));
          expect(json['current_room_id'], equals(expectedRoomId));
        } else {
          // For domain entities and models
          expect(result.id, equals(expectedId));
          expect(result.name, equals(expectedName));
          expect(result.avatarUrl, equals(expectedAvatarUrl));
          if (operation == 'fromDomain') {
            expect(result.connectionStatus, equals(expectedConnectionStatus));
          } else {
            expect(result.connectionStatus, equals(expectedConnectionStatus));
          }
          expect(result.currentRoomId, equals(expectedRoomId));
        }
      });
    }
  });
}
