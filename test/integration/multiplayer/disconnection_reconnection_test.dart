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
  
  group('Disconnection and Reconnection Tests', () {
    test('Player disconnection updates status correctly', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      // Create and join room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Simulate disconnection
      await testHelper.simulateDisconnection(username: 'player2');
      
      // Wait a bit for status to update
      await Future.delayed(const Duration(seconds: 1));
      
      // Check player status
      final playerData = await Supabase.instance.client
          .from('players')
          .select()
          .eq('id', testHelper._userIds['player2']!)
          .single();
      
      expect(playerData['connection_status'], equals('offline'));
      expect(playerData['last_seen'], isNotNull);
    });
    
    test('Player reconnection restores status', () async {
      // Create test user
      final player1 = await testHelper.createTestUser(username: 'player1');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      // Simulate disconnection
      await testHelper.simulateDisconnection(username: 'player1');
      await Future.delayed(const Duration(seconds: 1));
      
      // Verify offline status
      var playerData = await Supabase.instance.client
          .from('players')
          .select()
          .eq('id', testHelper._userIds['player1']!)
          .single();
      
      expect(playerData['connection_status'], equals('offline'));
      
      // Simulate reconnection
      await testHelper.simulateReconnection(username: 'player1');
      await Future.delayed(const Duration(seconds: 1));
      
      // Verify online status
      playerData = await Supabase.instance.client
          .from('players')
          .select()
          .eq('id', testHelper._userIds['player1']!)
          .single();
      
      expect(playerData['connection_status'], equals('online'));
    });
    
    test('Player remains in room during temporary disconnection', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      // Create and join room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Start game
      final game = await testHelper.startGame(roomId: room.id);
      
      // Simulate player2 disconnection
      await testHelper.simulateDisconnection(username: 'player2');
      
      // Wait less than 2 minutes (timeout period)
      await Future.delayed(const Duration(seconds: 30));
      
      // Check room state - player should still be in room
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(2));
      expect((roomState['player_ids'] as List).contains(testHelper._userIds['player2']), isTrue);
      
      // Game should still be active
      final gameState = await testHelper.getGameState(game.id);
      expect(gameState['status'], equals('playing'));
    });
    
    test('Multiple players disconnecting simultaneously', () async {
      // Create test users
      final players = <String, SupabaseClient>{};
      for (int i = 1; i <= 4; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      // Create room and have all join
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
        maxPlayers: 4,
      );
      
      for (int i = 2; i <= 4; i++) {
        await testHelper.joinRoom(username: 'player$i', roomId: room.id);
      }
      
      // Start game
      await testHelper.startGame(roomId: room.id);
      
      // Simulate multiple disconnections
      final disconnectFutures = [
        testHelper.simulateDisconnection(username: 'player2'),
        testHelper.simulateDisconnection(username: 'player3'),
        testHelper.simulateDisconnection(username: 'player4'),
      ];
      
      await Future.wait(disconnectFutures);
      await Future.delayed(const Duration(seconds: 2));
      
      // Check all players are offline except player1
      for (int i = 2; i <= 4; i++) {
        final playerData = await Supabase.instance.client
            .from('players')
            .select()
            .eq('id', testHelper._userIds['player$i']!)
            .single();
        
        expect(playerData['connection_status'], equals('offline'));
      }
      
      // Room should still have all players
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(4));
    });
    
    test('Reconnection during another player\'s turn', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      
      // Create room and start game
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      await testHelper.joinRoom(username: 'player3', roomId: room.id);
      
      final game = await testHelper.startGame(roomId: room.id);
      
      // Player2 disconnects
      await testHelper.simulateDisconnection(username: 'player2');
      await Future.delayed(const Duration(seconds: 1));
      
      // Advance turn (simulate player1 ending turn)
      await Supabase.instance.client.from('game_states').update({
        'current_player_index': 1, // Now player2's turn (who is disconnected)
        'turn_number': 2,
      }).eq('id', game.id);
      
      // Player2 reconnects during their turn
      await testHelper.simulateReconnection(username: 'player2');
      await Future.delayed(const Duration(seconds: 1));
      
      // Verify game state
      final gameState = await testHelper.getGameState(game.id);
      expect(gameState['current_player_index'], equals(1));
      expect(gameState['status'], equals('playing'));
      
      // Player2 should be back online
      final playerData = await Supabase.instance.client
          .from('players')
          .select()
          .eq('id', testHelper._userIds['player2']!)
          .single();
      
      expect(playerData['connection_status'], equals('online'));
    });
    
    test('Disconnection and reconnection with pending actions', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      // Create room and start game
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      final game = await testHelper.startGame(roomId: room.id);
      
      // Create a pending action (e.g., draw card event)
      await Supabase.instance.client.from('game_actions').insert({
        'id': testHelper._uuid.v4(),
        'game_state_id': game.id,
        'player_id': testHelper._userIds['player1'],
        'action_type': 'draw_card',
        'action_data': {'source': 'deck'},
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Player1 disconnects
      await testHelper.simulateDisconnection(username: 'player1');
      await Future.delayed(const Duration(seconds: 2));
      
      // Player1 reconnects
      await testHelper.simulateReconnection(username: 'player1');
      await Future.delayed(const Duration(seconds: 1));
      
      // Verify pending actions are still there
      final actions = await Supabase.instance.client
          .from('game_actions')
          .select()
          .eq('game_state_id', game.id)
          .eq('player_id', testHelper._userIds['player1']!);
      
      expect(actions.length, greaterThan(0));
      expect(actions.first['action_type'], equals('draw_card'));
    });
    
    test('Room cleanup after extended disconnection', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Both players disconnect
      await testHelper.simulateDisconnection(username: 'player1');
      await testHelper.simulateDisconnection(username: 'player2');
      
      // Simulate timeout by updating last_seen to > 2 minutes ago
      final timeoutTime = DateTime.now().subtract(const Duration(minutes: 3));
      
      await Supabase.instance.client.from('players').update({
        'last_seen': timeoutTime.toIso8601String(),
      }).in_('id', [testHelper._userIds['player1']!, testHelper._userIds['player2']!]);
      
      // Check if cleanup policies would trigger
      // In a real scenario, a scheduled job would handle this
      final playersData = await Supabase.instance.client
          .from('players')
          .select()
          .in_('id', [testHelper._userIds['player1']!, testHelper._userIds['player2']!]);
      
      // Verify both players have old last_seen times
      for (final player in playersData) {
        final lastSeen = DateTime.parse(player['last_seen']);
        expect(
          DateTime.now().difference(lastSeen).inMinutes,
          greaterThan(2),
        );
      }
    });
    
    test('Concurrent reconnection attempts', () async {
      // Create test user
      final player1 = await testHelper.createTestUser(username: 'player1');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      // Disconnect
      await testHelper.simulateDisconnection(username: 'player1');
      await Future.delayed(const Duration(seconds: 1));
      
      // Try multiple reconnection attempts simultaneously
      final reconnectFutures = <Future>[];
      for (int i = 0; i < 3; i++) {
        reconnectFutures.add(
          testHelper.simulateReconnection(username: 'player1')
              .catchError((e) => null) // Some might fail, that's ok
        );
      }
      
      await Future.wait(reconnectFutures);
      await Future.delayed(const Duration(seconds: 1));
      
      // Verify final state is online
      final playerData = await Supabase.instance.client
          .from('players')
          .select()
          .eq('id', testHelper._userIds['player1']!)
          .single();
      
      expect(playerData['connection_status'], equals('online'));
    });
  });
}