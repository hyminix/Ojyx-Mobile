import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/multiplayer/domain/entities/lobby_player.dart';

void main() {
  group('LobbyPlayer Entity', () {
    test('should create lobby player with required fields', () {
      // Given
      final createdAt = DateTime(2024, 1, 1);
      final updatedAt = DateTime(2024, 1, 1);
      final lastSeenAt = DateTime(2024, 1, 1);

      // When
      final player = LobbyPlayer(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSeenAt: lastSeenAt,
        connectionStatus: ConnectionStatus.online,
        currentRoomId: null,
      );

      // Then
      expect(player.id, equals('test-id'));
      expect(player.name, equals('TestPlayer'));
      expect(player.avatarUrl, isNull);
      expect(player.createdAt, equals(createdAt));
      expect(player.updatedAt, equals(updatedAt));
      expect(player.lastSeenAt, equals(lastSeenAt));
      expect(player.connectionStatus, equals(ConnectionStatus.online));
      expect(player.currentRoomId, isNull);
    });

    test('should support all connection status values', () {
      // Given
      const expectedStatuses = [
        ConnectionStatus.online,
        ConnectionStatus.offline,
        ConnectionStatus.away,
      ];

      // When & Then
      for (final status in expectedStatuses) {
        final player = LobbyPlayer(
          id: 'test-id',
          name: 'TestPlayer',
          avatarUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          lastSeenAt: DateTime.now(),
          connectionStatus: status,
          currentRoomId: null,
        );

        expect(player.connectionStatus, equals(status));
      }
    });

    test('should be immutable', () {
      // Given
      final player = LobbyPlayer(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: null,
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        lastSeenAt: DateTime(2024, 1, 1),
        connectionStatus: ConnectionStatus.online,
        currentRoomId: null,
      );

      // When
      final updatedPlayer = player.copyWith(name: 'UpdatedPlayer');

      // Then
      expect(player.name, equals('TestPlayer'));
      expect(updatedPlayer.name, equals('UpdatedPlayer'));
      expect(player.id, equals(updatedPlayer.id));
    });

    test('should support copyWith for all fields', () {
      // Given
      final originalDate = DateTime(2024, 1, 1);
      final newDate = DateTime(2024, 1, 2);
      
      final player = LobbyPlayer(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: null,
        createdAt: originalDate,
        updatedAt: originalDate,
        lastSeenAt: originalDate,
        connectionStatus: ConnectionStatus.online,
        currentRoomId: null,
      );

      // When
      final updatedPlayer = player.copyWith(
        name: 'NewName',
        avatarUrl: 'new-avatar.png',
        updatedAt: newDate,
        lastSeenAt: newDate,
        connectionStatus: ConnectionStatus.away,
        currentRoomId: 'new-room-id',
      );

      // Then
      expect(updatedPlayer.name, equals('NewName'));
      expect(updatedPlayer.avatarUrl, equals('new-avatar.png'));
      expect(updatedPlayer.updatedAt, equals(newDate));
      expect(updatedPlayer.lastSeenAt, equals(newDate));
      expect(updatedPlayer.connectionStatus, equals(ConnectionStatus.away));
      expect(updatedPlayer.currentRoomId, equals('new-room-id'));
      expect(updatedPlayer.id, equals('test-id')); // ID should remain unchanged
      expect(updatedPlayer.createdAt, equals(originalDate)); // createdAt should remain unchanged
    });

    test('should have equality based on all fields', () {
      // Given
      final date = DateTime(2024, 1, 1);
      
      final player1 = LobbyPlayer(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: 'avatar.png',
        createdAt: date,
        updatedAt: date,
        lastSeenAt: date,
        connectionStatus: ConnectionStatus.online,
        currentRoomId: 'room-id',
      );

      final player2 = LobbyPlayer(
        id: 'test-id',
        name: 'TestPlayer',
        avatarUrl: 'avatar.png',
        createdAt: date,
        updatedAt: date,
        lastSeenAt: date,
        connectionStatus: ConnectionStatus.online,
        currentRoomId: 'room-id',
      );

      final player3 = player1.copyWith(name: 'DifferentName');

      // Then
      expect(player1, equals(player2));
      expect(player1, isNot(equals(player3)));
      expect(player1.hashCode, equals(player2.hashCode));
    });
  });

  group('ConnectionStatus', () {
    test('should have correct string representations', () {
      expect(ConnectionStatus.online.name, equals('online'));
      expect(ConnectionStatus.offline.name, equals('offline'));
      expect(ConnectionStatus.away.name, equals('away'));
    });

    test('should parse from string correctly', () {
      expect(ConnectionStatus.values.firstWhere((s) => s.name == 'online'), 
             equals(ConnectionStatus.online));
      expect(ConnectionStatus.values.firstWhere((s) => s.name == 'offline'), 
             equals(ConnectionStatus.offline));
      expect(ConnectionStatus.values.firstWhere((s) => s.name == 'away'), 
             equals(ConnectionStatus.away));
    });
  });
}