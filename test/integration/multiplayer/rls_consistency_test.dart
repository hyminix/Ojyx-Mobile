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
  
  group('RLS Policy Consistency Tests', () {
    test('Player cannot change room during active game', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      // Create two rooms
      final room1 = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Room 1',
      );
      
      final room2 = await testHelper.createTestRoom(
        creatorUsername: 'player2',
        roomName: 'Room 2',
      );
      
      // Player1 joins their room and starts game
      await testHelper.joinRoom(username: 'player2', roomId: room1.id);
      await testHelper.startGame(roomId: room1.id);
      
      // Try to change player1's room while in active game
      bool errorThrown = false;
      try {
        await testHelper._testClients['player1']!.from('players').update({
          'current_room_id': room2.id,
        }).eq('id', testHelper._userIds['player1']!);
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('prevent_room_change_during_game'));
      }
      
      expect(errorThrown, isTrue, reason: 'RLS policy should prevent room change during game');
    });
    
    test('Room cannot exceed max_players capacity', () async {
      // Create test users
      final players = <String, SupabaseClient>{};
      for (int i = 1; i <= 5; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      // Create room with capacity 3
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Small Room',
        maxPlayers: 3,
      );
      
      // Add 2 more players (total 3)
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      await testHelper.joinRoom(username: 'player3', roomId: room.id);
      
      // Try to add 4th player - should fail
      bool errorThrown = false;
      try {
        await testHelper.joinRoom(username: 'player4', roomId: room.id);
      } catch (e) {
        errorThrown = true;
        // Either prevent_room_overflow or generic error
      }
      
      // Verify room still has only 3 players
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(3));
      expect((roomState['player_ids'] as List).length, equals(3));
    });
    
    test('Player grids must match room players', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      
      // Create room with player1 and player2
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Start game
      final game = await testHelper.startGame(roomId: room.id);
      
      // Try to create player grid for player3 (not in room)
      bool errorThrown = false;
      try {
        await Supabase.instance.client.from('player_grids').insert({
          'id': testHelper._uuid.v4(),
          'game_state_id': game.id,
          'player_id': testHelper._userIds['player3'],
          'cards': testHelper._generateInitialCards(),
          'revealed_cards': List.filled(12, false),
          'action_cards': [],
        });
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('validate_player_grid_consistency'));
      }
      
      expect(errorThrown, isTrue, reason: 'RLS should prevent grid creation for non-room players');
    });
    
    test('Room status transitions are validated', () async {
      // Create test user and room
      final player1 = await testHelper.createTestUser(username: 'player1');
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      // Try invalid transition: waiting -> finished
      bool errorThrown = false;
      try {
        await testHelper._testClients['player1']!.from('rooms').update({
          'status': 'finished',
        }).eq('id', room.id);
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('validate_room_status_transition'));
      }
      
      expect(errorThrown, isTrue, reason: 'Invalid status transition should be blocked');
      
      // Valid transition: waiting -> in_game
      await testHelper._testClients['player1']!.from('rooms').update({
        'status': 'in_game',
      }).eq('id', room.id);
      
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['status'], equals('in_game'));
    });
    
    test('Minimum players required to start game', () async {
      // Create test user and room
      final player1 = await testHelper.createTestUser(username: 'player1');
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      // Try to start game with only 1 player
      bool errorThrown = false;
      try {
        await testHelper._testClients['player1']!.from('rooms').update({
          'status': 'in_game',
        }).eq('id', room.id);
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('validate_min_players_to_start'));
      }
      
      expect(errorThrown, isTrue, reason: 'Should require minimum 2 players to start');
    });
    
    test('Cancelled room requires reason', () async {
      // Create test user and room
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Try to cancel without reason
      bool errorThrown = false;
      try {
        await testHelper._testClients['player1']!.from('rooms').update({
          'status': 'cancelled',
        }).eq('id', room.id);
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('require_cancelled_reason'));
      }
      
      expect(errorThrown, isTrue, reason: 'Cancellation should require a reason');
      
      // Cancel with reason - should succeed
      await testHelper._testClients['player1']!.from('rooms').update({
        'status': 'cancelled',
        'cancelled_reason': 'Player disconnected',
      }).eq('id', room.id);
      
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['status'], equals('cancelled'));
      expect(roomState['cancelled_reason'], equals('Player disconnected'));
    });
    
    test('Player count is automatically maintained', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      
      // Create room
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      // Verify initial count
      var roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(1));
      
      // Add players
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(2));
      
      await testHelper.joinRoom(username: 'player3', roomId: room.id);
      roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(3));
      
      // Remove player
      await testHelper.leaveRoom(username: 'player2', roomId: room.id);
      roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(2));
    });
    
    test('Current player must be in the game', () async {
      // Create test users
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      final player3 = await testHelper.createTestUser(username: 'player3');
      
      // Create room and game
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      final game = await testHelper.startGame(roomId: room.id);
      
      // Try to set current_player_id to player3 (not in game)
      bool errorThrown = false;
      try {
        await Supabase.instance.client.from('game_states').update({
          'current_player_id': testHelper._userIds['player3'],
        }).eq('id', game.id);
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('validate_current_player_in_game'));
      }
      
      expect(errorThrown, isTrue, reason: 'Current player must be in the game');
    });
    
    test('Archived room cannot be modified', () async {
      // Create test user and room
      final player1 = await testHelper.createTestUser(username: 'player1');
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      // Archive the room
      await testHelper._testClients['player1']!.from('rooms').update({
        'is_archived': true,
      }).eq('id', room.id);
      
      // Try to modify archived room
      bool errorThrown = false;
      try {
        await testHelper._testClients['player1']!.from('rooms').update({
          'name': 'Modified Name',
        }).eq('id', room.id);
      } catch (e) {
        errorThrown = true;
        expect(e.toString(), contains('prevent_archived_room_modification'));
      }
      
      expect(errorThrown, isTrue, reason: 'Archived rooms should not be modifiable');
    });
    
    test('Data consistency monitoring views', () async {
      // Create test scenario with potential inconsistencies
      final player1 = await testHelper.createTestUser(username: 'player1');
      final player2 = await testHelper.createTestUser(username: 'player2');
      
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Test Room',
      );
      
      await testHelper.joinRoom(username: 'player2', roomId: room.id);
      
      // Check monitoring views
      final inconsistencies = await Supabase.instance.client
          .from('v_player_room_inconsistencies')
          .select();
      
      expect(inconsistencies.length, equals(0), 
        reason: 'Should have no player/room inconsistencies');
      
      final counterValidation = await Supabase.instance.client
          .from('v_room_counter_validation')
          .select();
      
      // All rooms should have correct counters
      for (final room in counterValidation) {
        expect(room['player_count'], equals(room['actual_count']),
          reason: 'Player count should match actual count');
      }
      
      // Run full validation
      final validationResult = await Supabase.instance.client
          .rpc('validate_all_data_consistency');
      
      // All checks should pass
      for (final check in validationResult) {
        expect(check['status'], equals('passed'),
          reason: '${check['check_name']} should pass');
      }
    });
  });
}