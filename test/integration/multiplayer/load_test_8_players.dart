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
  
  group('Load Test with 8 Players', () {
    test('8 players can join and play simultaneously', () async {
      // Create 8 test users
      final players = <String, SupabaseClient>{};
      final usernames = <String>[];
      
      for (int i = 1; i <= 8; i++) {
        final username = 'player$i';
        usernames.add(username);
        players[username] = await testHelper.createTestUser(username: username);
      }
      
      // Create room with max capacity
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: '8 Player Load Test',
        maxPlayers: 8,
      );
      
      // Measure join time
      final stopwatch = Stopwatch()..start();
      
      // Have all other players join simultaneously
      final joinFutures = <Future>[];
      for (int i = 2; i <= 8; i++) {
        joinFutures.add(
          testHelper.joinRoom(username: 'player$i', roomId: room.id)
        );
      }
      
      await Future.wait(joinFutures);
      stopwatch.stop();
      
      print('Time to join 7 players: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should complete within 5 seconds
      
      // Verify room state
      final roomState = await testHelper.getRoomState(room.id);
      expect(roomState['player_count'], equals(8));
      expect((roomState['player_ids'] as List).length, equals(8));
      
      // Start game
      final game = await testHelper.startGame(roomId: room.id);
      
      // Verify game state created with all players
      final playerGrids = await Supabase.instance.client
          .from('player_grids')
          .select()
          .eq('game_state_id', game.id);
      
      expect(playerGrids.length, equals(8));
    });
    
    test('8 players performing actions concurrently', () async {
      // Create 8 test users and setup game
      final players = <String, SupabaseClient>{};
      for (int i = 1; i <= 8; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: '8 Player Action Test',
        maxPlayers: 8,
      );
      
      // Join all players
      for (int i = 2; i <= 8; i++) {
        await testHelper.joinRoom(username: 'player$i', roomId: room.id);
      }
      
      final game = await testHelper.startGame(roomId: room.id);
      
      // Simulate each player performing an action simultaneously
      final actionFutures = <Future>[];
      final stopwatch = Stopwatch()..start();
      
      for (int i = 1; i <= 8; i++) {
        actionFutures.add(
          Supabase.instance.client.from('game_actions').insert({
            'id': testHelper._uuid.v4(),
            'game_state_id': game.id,
            'player_id': testHelper._userIds['player$i'],
            'action_type': 'reveal_card',
            'action_data': {
              'row': i % 3,
              'col': i % 4,
            },
            'created_at': DateTime.now().toIso8601String(),
          })
        );
      }
      
      await Future.wait(actionFutures);
      stopwatch.stop();
      
      print('Time for 8 concurrent actions: ${stopwatch.elapsedMilliseconds}ms');
      expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // Should complete within 3 seconds
      
      // Verify all actions were recorded
      final actions = await Supabase.instance.client
          .from('game_actions')
          .select()
          .eq('game_state_id', game.id);
      
      expect(actions.length, equals(8));
    });
    
    test('Realtime updates with 8 players', () async {
      // Create 8 test users
      final players = <String, SupabaseClient>{};
      for (int i = 1; i <= 8; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: '8 Player Realtime Test',
        maxPlayers: 8,
      );
      
      // Set up realtime listeners for each player
      final updateCounts = <String, int>{};
      final subscriptions = <RealtimeChannel>[];
      
      for (int i = 1; i <= 8; i++) {
        final username = 'player$i';
        updateCounts[username] = 0;
        
        final channel = players[username]!.realtime.channel('room:${room.id}');
        
        channel.on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(
            event: '*',
            schema: 'public',
            table: 'rooms',
            filter: 'id=eq.${room.id}',
          ),
          (payload, [ref]) {
            updateCounts[username] = updateCounts[username]! + 1;
          },
        );
        
        await channel.subscribe();
        subscriptions.add(channel);
      }
      
      // Have players 2-8 join
      for (int i = 2; i <= 8; i++) {
        await testHelper.joinRoom(username: 'player$i', roomId: room.id);
        await Future.delayed(const Duration(milliseconds: 100)); // Small delay between joins
      }
      
      // Wait for updates to propagate
      await Future.delayed(const Duration(seconds: 2));
      
      // Each player should have received multiple updates
      for (final username in updateCounts.keys) {
        expect(updateCounts[username]!, greaterThan(0));
        print('$username received ${updateCounts[username]} updates');
      }
      
      // Cleanup subscriptions
      for (final channel in subscriptions) {
        await channel.unsubscribe();
      }
    });
    
    test('Stress test: rapid actions from 8 players', () async {
      // Create 8 test users and setup game
      final players = <String, SupabaseClient>{};
      for (int i = 1; i <= 8; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: '8 Player Stress Test',
        maxPlayers: 8,
      );
      
      // Join all players
      for (int i = 2; i <= 8; i++) {
        await testHelper.joinRoom(username: 'player$i', roomId: room.id);
      }
      
      final game = await testHelper.startGame(roomId: room.id);
      
      // Each player performs 10 actions rapidly
      final allActionFutures = <Future>[];
      final totalStopwatch = Stopwatch()..start();
      
      for (int playerNum = 1; playerNum <= 8; playerNum++) {
        for (int actionNum = 0; actionNum < 10; actionNum++) {
          allActionFutures.add(
            Future.delayed(
              Duration(milliseconds: actionNum * 50), // Stagger actions slightly
              () => Supabase.instance.client.from('game_actions').insert({
                'id': testHelper._uuid.v4(),
                'game_state_id': game.id,
                'player_id': testHelper._userIds['player$playerNum'],
                'action_type': 'test_action',
                'action_data': {
                  'action_number': actionNum,
                  'timestamp': DateTime.now().toIso8601String(),
                },
                'created_at': DateTime.now().toIso8601String(),
              }),
            ),
          );
        }
      }
      
      await Future.wait(allActionFutures);
      totalStopwatch.stop();
      
      print('Time for 80 actions (8 players × 10 actions): ${totalStopwatch.elapsedMilliseconds}ms');
      
      // Verify all actions were recorded
      final actions = await Supabase.instance.client
          .from('game_actions')
          .select()
          .eq('game_state_id', game.id);
      
      expect(actions.length, equals(80));
      
      // Check action distribution per player
      final actionsByPlayer = <String, int>{};
      for (final action in actions) {
        final playerId = action['player_id'] as String;
        actionsByPlayer[playerId] = (actionsByPlayer[playerId] ?? 0) + 1;
      }
      
      // Each player should have 10 actions
      for (final count in actionsByPlayer.values) {
        expect(count, equals(10));
      }
    });
    
    test('Mixed operations with 8 players', () async {
      // Create 8 test users
      final players = <String, SupabaseClient>{};
      for (int i = 1; i <= 8; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      // Create multiple rooms
      final room1 = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Room 1',
        maxPlayers: 4,
      );
      
      final room2 = await testHelper.createTestRoom(
        creatorUsername: 'player5',
        roomName: 'Room 2',
        maxPlayers: 4,
      );
      
      // Simulate complex scenario with multiple operations
      final operations = <Future>[];
      
      // Players 2-4 join room1
      operations.add(testHelper.joinRoom(username: 'player2', roomId: room1.id));
      operations.add(testHelper.joinRoom(username: 'player3', roomId: room1.id));
      operations.add(testHelper.joinRoom(username: 'player4', roomId: room1.id));
      
      // Players 6-8 join room2
      operations.add(testHelper.joinRoom(username: 'player6', roomId: room2.id));
      operations.add(testHelper.joinRoom(username: 'player7', roomId: room2.id));
      operations.add(testHelper.joinRoom(username: 'player8', roomId: room2.id));
      
      await Future.wait(operations);
      
      // Start both games
      final game1Future = testHelper.startGame(roomId: room1.id);
      final game2Future = testHelper.startGame(roomId: room2.id);
      
      final games = await Future.wait([game1Future, game2Future]);
      
      // Simulate some players disconnecting
      final disconnectOps = [
        testHelper.simulateDisconnection(username: 'player2'),
        testHelper.simulateDisconnection(username: 'player6'),
      ];
      
      await Future.wait(disconnectOps);
      
      // Other players perform actions
      final actionOps = <Future>[];
      
      // Room 1 actions
      actionOps.add(
        Supabase.instance.client.from('game_actions').insert({
          'id': testHelper._uuid.v4(),
          'game_state_id': games[0].id,
          'player_id': testHelper._userIds['player1'],
          'action_type': 'end_turn',
          'action_data': {},
          'created_at': DateTime.now().toIso8601String(),
        })
      );
      
      // Room 2 actions
      actionOps.add(
        Supabase.instance.client.from('game_actions').insert({
          'id': testHelper._uuid.v4(),
          'game_state_id': games[1].id,
          'player_id': testHelper._userIds['player5'],
          'action_type': 'draw_card',
          'action_data': {'source': 'deck'},
          'created_at': DateTime.now().toIso8601String(),
        })
      );
      
      await Future.wait(actionOps);
      
      // Reconnect disconnected players
      await testHelper.simulateReconnection(username: 'player2');
      await testHelper.simulateReconnection(username: 'player6');
      
      // Verify both games are still active
      final game1State = await testHelper.getGameState(games[0].id);
      final game2State = await testHelper.getGameState(games[1].id);
      
      expect(game1State['status'], equals('playing'));
      expect(game2State['status'], equals('playing'));
      
      // Verify room states
      final room1State = await testHelper.getRoomState(room1.id);
      final room2State = await testHelper.getRoomState(room2.id);
      
      expect(room1State['player_count'], equals(4));
      expect(room2State['player_count'], equals(4));
    });
    
    test('Performance metrics with 8 players', () async {
      // Create 8 test users
      final players = <String, SupabaseClient>{};
      final metrics = <String, List<int>>{
        'join_times': [],
        'action_times': [],
        'query_times': [],
      };
      
      for (int i = 1; i <= 8; i++) {
        players['player$i'] = await testHelper.createTestUser(username: 'player$i');
      }
      
      final room = await testHelper.createTestRoom(
        creatorUsername: 'player1',
        roomName: 'Performance Test',
        maxPlayers: 8,
      );
      
      // Measure individual join times
      for (int i = 2; i <= 8; i++) {
        final joinStopwatch = Stopwatch()..start();
        await testHelper.joinRoom(username: 'player$i', roomId: room.id);
        joinStopwatch.stop();
        metrics['join_times']!.add(joinStopwatch.elapsedMilliseconds);
      }
      
      final game = await testHelper.startGame(roomId: room.id);
      
      // Measure action processing times
      for (int i = 1; i <= 8; i++) {
        final actionStopwatch = Stopwatch()..start();
        await Supabase.instance.client.from('game_actions').insert({
          'id': testHelper._uuid.v4(),
          'game_state_id': game.id,
          'player_id': testHelper._userIds['player$i'],
          'action_type': 'test_action',
          'action_data': {},
          'created_at': DateTime.now().toIso8601String(),
        });
        actionStopwatch.stop();
        metrics['action_times']!.add(actionStopwatch.elapsedMilliseconds);
      }
      
      // Measure query times
      for (int i = 1; i <= 8; i++) {
        final queryStopwatch = Stopwatch()..start();
        await Supabase.instance.client
            .from('player_grids')
            .select()
            .eq('game_state_id', game.id)
            .eq('player_id', testHelper._userIds['player$i']!)
            .single();
        queryStopwatch.stop();
        metrics['query_times']!.add(queryStopwatch.elapsedMilliseconds);
      }
      
      // Print performance report
      print('\n=== Performance Report (8 Players) ===');
      
      for (final entry in metrics.entries) {
        final times = entry.value;
        final avg = times.reduce((a, b) => a + b) / times.length;
        final max = times.reduce((a, b) => a > b ? a : b);
        final min = times.reduce((a, b) => a < b ? a : b);
        
        print('\n${entry.key}:');
        print('  Average: ${avg.toStringAsFixed(2)}ms');
        print('  Min: ${min}ms');
        print('  Max: ${max}ms');
        print('  All: ${times.join(', ')}ms');
      }
      
      // Assert reasonable performance
      expect(metrics['join_times']!.every((t) => t < 2000), isTrue); // Each join < 2s
      expect(metrics['action_times']!.every((t) => t < 1000), isTrue); // Each action < 1s
      expect(metrics['query_times']!.every((t) => t < 500), isTrue); // Each query < 500ms
    });
  });
}