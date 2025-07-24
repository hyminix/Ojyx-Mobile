import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/data/models/player_model.dart';
import 'package:ojyx/features/multiplayer/domain/entities/lobby_player.dart';

void main() {
  group('PlayerModel', () {
    test('should create from domain entity', () {
      // Given
      final player = Player(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: 'http://example.com/avatar.png',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        lastSeenAt: DateTime(2024, 1, 1),
        connectionStatus: ConnectionStatus.online,
        currentRoomId: 'room-id',
      );

      // When
      final model = PlayerModel.fromDomain(player);

      // Then
      expect(model.id, equals('test-id'));
      expect(model.name, equals('TestPlayer'));
      expect(model.avatarUrl, equals('http://example.com/avatar.png'));
      expect(model.connectionStatus, equals('online'));
      expect(model.currentRoomId, equals('room-id'));
    });

    test('should convert to domain entity', () {
      // Given
      final model = PlayerModel(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: 'http://example.com/avatar.png',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        lastSeenAt: DateTime(2024, 1, 1),
        connectionStatus: 'online',
        currentRoomId: 'room-id',
      );

      // When
      final player = model.toDomain();

      // Then
      expect(player.id, equals('test-id'));
      expect(player.name, equals('TestPlayer'));
      expect(player.avatarUrl, equals('http://example.com/avatar.png'));
      expect(player.connectionStatus, equals(ConnectionStatus.online));
      expect(player.currentRoomId, equals('room-id'));
    });

    test('should serialize to JSON', () {
      // Given
      final model = PlayerModel(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: null,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        lastSeenAt: DateTime(2024, 1, 1),
        connectionStatus: 'offline',
        currentRoomId: null,
      );

      // When
      final json = model.toJson();

      // Then
      expect(json['id'], equals('test-id'));
      expect(json['name'], equals('TestPlayer'));
      expect(json['avatar_url'], isNull);
      expect(json['connection_status'], equals('offline'));
      expect(json['current_room_id'], isNull);
    });

    test('should deserialize from JSON', () {
      // Given
      final json = {
        'id': 'test-id',
        'name': 'TestPlayer',
        'avatar_url': 'http://example.com/avatar.png',
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
        'last_seen_at': '2024-01-01T00:00:00.000Z',
        'connection_status': 'away',
        'current_room_id': 'room-id',
      };

      // When
      final model = PlayerModel.fromJson(json);

      // Then
      expect(model.id, equals('test-id'));
      expect(model.name, equals('TestPlayer'));
      expect(model.avatarUrl, equals('http://example.com/avatar.png'));
      expect(model.connectionStatus, equals('away'));
      expect(model.currentRoomId, equals('room-id'));
    });

    test('should handle null values correctly', () {
      // Given
      final json = {
        'id': 'test-id',
        'name': 'TestPlayer',
        'avatar_url': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-01-01T00:00:00.000Z',
        'last_seen_at': '2024-01-01T00:00:00.000Z',
        'connection_status': 'online',
        'current_room_id': null,
      };

      // When
      final model = PlayerModel.fromJson(json);

      // Then
      expect(model.avatarUrl, isNull);
      expect(model.currentRoomId, isNull);
    });
  });
}