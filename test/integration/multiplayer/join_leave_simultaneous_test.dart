import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../helpers/multiplayer_test_helper.dart';
import 'dart:async';

void main() {
  late MultiplayerTestHelper testHelper;
  
  setUpAll(() async {
    // Initialize Supabase for tests
    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
    
    testHelper = MultiplayerTestHelper(
      supabaseUrl: const String.fromEnvironment('SUPABASE_URL'),
      supabaseAnonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    );
  });
  
  tearDown(() async {
    await testHelper.cleanup();
  });
  
  group('Simultaneous Join/Leave Operations', () {
    test('Multiple players can join a room simultaneously', () async {
      // Create test users
      final creator = await testHelper.createTestUser(username: 'creator');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      final player4 = await testHelper.createTestUser(username: 'player4');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'creator',
        roomName: 'Test Room',
        maxPlayers: 4,
      );
      
      // Join simultaneously
      final joinFutures = [
        testHelper.joinRoom(username: 'player2', roomId: room.id),
        testHelper.joinRoom(username: 'player3', roomId: room.id),
        testHelper.joinRoom(username: 'player4', roomId: room.id),
      ];
      
      // Wait for all joins to complete
      await Future.wait(joinFutures);
      
      // Verify room state
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(4));
      expect((roomState['player_ids'] as List).length, equals(4));
    });
    
    test('Simultaneous join and leave operations are handled correctly', () async {
      // Create test users
      final creator = await testHelper.createTestUser(username: 'creator');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      final player4 = await testHelper.createTestUser(username: 'player4');
      
      // Create room and have all players join
      final room = await testHelper.createTestRoom(
        creatorUsername: 'creator',
        roomName: 'Test Room',
        maxPlayers: 4,
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      await testHelper.joinRoom(username: 'player3', roomId: room.id);
      
      // Simulate simultaneous operations
      final operations = [
        testHelper.leaveRoom(username: 'player2', roomId: room.id),
        testHelper.leaveRoom(username: 'player3', roomId: room.id),
        testHelper.joinRoom(username: 'player4', roomId: room.id),
      ];
      
      await Future.wait(operations);
      
      // Verify final state
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(2)); // creator + player4
      
      final playerIds = List<String>.from(roomState['player_ids']);
      expect(playerIds.contains(testHelper._userIds['creator']), isTrue);
      expect(playerIds.contains(testHelper._userIds['player4']), isTrue);
      expect(playerIds.contains(testHelper._userIds['player2']), isFalse);
      expect(playerIds.contains(testHelper._userIds['player3']), isFalse);
    });
    
    test('Room capacity is respected during simultaneous joins', () async {
      // Create test users
      final creator = await testHelper.createTestUser(username: 'creator');
      final players = <SupabaseClient>[];
      
      for (int i = 1; i <= 5; i++) {
        players.add(await testHelper.createTestUser(username: 'player$i'));
      }
      
      // Create room with max 4 players
      final room = await testHelper.createTestRoom(
        creatorUsername: 'creator',
        roomName: 'Small Room',
        maxPlayers: 4,
      );
      
      // Try to join 5 players simultaneously (should only accept 3)
      final joinFutures = <Future>[];
      for (int i = 1; i <= 5; i++) {
        joinFutures.add(
          testHelper.joinRoom(username: 'player$i', roomId: room.id)
              .catchError((e) => null) // Ignore errors for expected failures
        );
      }
      
      await Future.wait(joinFutures);
      
      // Verify only 4 players total (including creator)
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], lessThanOrEqualTo(4));
      expect((roomState['player_ids'] as List).length, lessThanOrEqualTo(4));
    });
    
    test('Creator leaving during simultaneous operations', () async {
      // Create test users
      final creator = await testHelper.createTestUser(username: 'creator');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'creator',
        roomName: 'Test Room',
        maxPlayers: 4,
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Creator leaves while another player joins
      final operations = [
        testHelper.leaveRoom(username: 'creator', roomId: room.id),
        testHelper.joinRoom(username: 'player3', roomId: room.id),
      ];
      
      await Future.wait(operations);
      
      // Verify room state
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(2)); // player2 + player3
      expect(roomState['creator_id'], equals(testHelper._userIds['creator'])); // Creator ID doesn't change
      
      final playerIds = List<String>.from(roomState['player_ids']);
      expect(playerIds.contains(testHelper._userIds['creator']), isFalse);
      expect(playerIds.contains(testHelper._userIds['player2']), isTrue);
      expect(playerIds.contains(testHelper._userIds['player3']), isTrue);
    });
    
    test('Race condition: same player trying to join multiple times', () async {
      // Create test users
      final creator = await testHelper.createTestUser(username: 'creator');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'creator',
        roomName: 'Test Room',
        maxPlayers: 4,
      );
      
      // Try to join the same player multiple times simultaneously
      final joinFutures = <Future>[];
      for (int i = 0; i < 5; i++) {
        joinFutures.add(
          testHelper.joinRoom(username: 'player2', roomId: room.id)
              .catchError((e) => null) // Some might fail, that's ok
        );
      }
      
      await Future.wait(joinFutures);
      
      // Verify player is only in the room once
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(2)); // creator + player2
      
      final playerIds = List<String>.from(roomState['player_ids']);
      final player2Count = playerIds.where((id) => id == testHelper._userIds['player2']).length;
      expect(player2Count, equals(1)); // Should only appear once
    });
    
    test('Simultaneous operations during game start', () async {
      // Create test users
      final creator = await testHelper.createTestUser(username: 'creator');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      final player4 = await testHelper.createTestUser(username: 'player4');
      
      // Create room and add initial players
      final room = await testHelper.createTestRoom(
        creatorUsername: 'creator',
        roomName: 'Test Room',
        maxPlayers: 4,
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Try to start game while others are joining/leaving
      final operations = [
        testHelper.startGame(roomId: room.id),
        testHelper.joinRoom(username: 'player3', roomId: room.id)
            .catchError((e) => null), // Might fail if game starts first
        testHelper.joinRoom(username: 'player4', roomId: room.id)
            .catchError((e) => null),
      ];
      
      await Future.wait(operations);
      
      // Verify room is in game
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['status'], equals('in_game'));
      expect(roomState['current_game_id'], isNotNull);
      
      // Verify game was created with correct players
      final gameState = await testHelper.getGameState(roomState['current_game_id']);
      expect(gameState['status'], equals('playing'));
      
      // Player count should be at least 2 (minimum to start)
      expect(roomState['player_count'], greaterThanOrEqualTo(2));
    });
  });
}