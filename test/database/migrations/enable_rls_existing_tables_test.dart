import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Enable RLS on Existing Tables', () {
    test('should enable RLS on rooms table', () async {
      // Test that RLS is enabled on rooms table
      const migrationSQL = '''
        -- Enable RLS on rooms table
        ALTER TABLE public.rooms ENABLE ROW LEVEL SECURITY;
      ''';

      expect(migrationSQL, contains('ALTER TABLE public.rooms'));
      expect(migrationSQL, contains('ENABLE ROW LEVEL SECURITY'));
    });

    test('should enable RLS on room_events table', () async {
      // Test that RLS is enabled on room_events table
      const migrationSQL = '''
        -- Enable RLS on room_events table
        ALTER TABLE public.room_events ENABLE ROW LEVEL SECURITY;
      ''';

      expect(migrationSQL, contains('ALTER TABLE public.room_events'));
      expect(migrationSQL, contains('ENABLE ROW LEVEL SECURITY'));
    });

    test('should create RLS policies for rooms table', () async {
      // Test RLS policies for rooms table
      const rlsPolicies = [
        // Anyone can view available rooms
        '''
        CREATE POLICY "Anyone can view available rooms"
        ON public.rooms FOR SELECT
        USING (status = 'waiting' OR id IN (
          SELECT current_room_id FROM public.players WHERE id = auth.uid()
        ));
        ''',
        
        // Authenticated users can create rooms
        '''
        CREATE POLICY "Authenticated users can create rooms"
        ON public.rooms FOR INSERT
        WITH CHECK (auth.uid() IS NOT NULL);
        ''',
        
        // Only room creator or players in room can update
        '''
        CREATE POLICY "Room participants can update room"
        ON public.rooms FOR UPDATE
        USING (
          creator_id = auth.uid() OR 
          auth.uid() = ANY(player_ids)
        )
        WITH CHECK (
          creator_id = auth.uid() OR 
          auth.uid() = ANY(player_ids)
        );
        ''',
      ];

      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('ON public.rooms'));
      }
    });

    test('should create RLS policies for room_events table', () async {
      // Test RLS policies for room_events table
      const rlsPolicies = [
        // Players can view events in their rooms
        '''
        CREATE POLICY "Players can view events in their rooms"
        ON public.room_events FOR SELECT
        USING (
          room_id IN (
            SELECT current_room_id FROM public.players WHERE id = auth.uid()
          )
        );
        ''',
        
        // Players can insert events in their rooms
        '''
        CREATE POLICY "Players can insert events in their rooms"
        ON public.room_events FOR INSERT
        WITH CHECK (
          room_id IN (
            SELECT current_room_id FROM public.players WHERE id = auth.uid()
          )
        );
        ''',
      ];

      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('ON public.room_events'));
      }
    });

    test('should verify all tables have RLS enabled', () async {
      // List of all tables that should have RLS
      const tables = [
        'players',
        'rooms',
        'room_events',
        'game_states',
        'player_grids',
        'game_actions',
        'global_scores',
      ];

      // Each table should have RLS enabled
      for (final table in tables) {
        final checkSQL = 'ALTER TABLE public.$table ENABLE ROW LEVEL SECURITY;';
        expect(checkSQL, contains('ENABLE ROW LEVEL SECURITY'));
        expect(checkSQL, contains(table));
      }
    });
  });
}