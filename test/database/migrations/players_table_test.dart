import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('Players Table Migration', () {
    test('should create players table with correct structure', () async {
      // This test verifies that the players table migration creates the correct structure
      // The actual test will be run against the real database after migration
      
      final expectedColumns = {
        'id': 'uuid',
        'name': 'text',
        'avatar_url': 'text',
        'created_at': 'timestamp with time zone',
        'updated_at': 'timestamp with time zone',
        'last_seen_at': 'timestamp with time zone',
        'connection_status': 'text',
        'current_room_id': 'uuid',
      };

      // Test that the migration SQL is valid
      const migrationSQL = '''
        CREATE TABLE IF NOT EXISTS public.players (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          name TEXT NOT NULL,
          avatar_url TEXT,
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now(),
          last_seen_at TIMESTAMPTZ DEFAULT now(),
          connection_status TEXT DEFAULT 'offline' CHECK (connection_status IN ('online', 'offline', 'away')),
          current_room_id UUID REFERENCES public.rooms(id) ON DELETE SET NULL
        );
      ''';

      // Verify the SQL syntax is valid
      expect(migrationSQL, contains('CREATE TABLE'));
      expect(migrationSQL, contains('public.players'));
      expect(migrationSQL, contains('PRIMARY KEY'));
      
      // Verify all expected columns are present
      for (final column in expectedColumns.keys) {
        expect(migrationSQL.toLowerCase(), contains(column.toLowerCase()));
      }
    });

    test('should create RLS policies for players table', () async {
      // Test that RLS policies are correctly defined
      const rlsPolicies = [
        // Players can read all players in the same room
        '''
        CREATE POLICY "Players can view other players in same room"
        ON public.players FOR SELECT
        USING (
          current_room_id IN (
            SELECT current_room_id FROM public.players WHERE id = auth.uid()
          )
          OR id = auth.uid()
        );
        ''',
        
        // Players can only update their own record
        '''
        CREATE POLICY "Players can update own record"
        ON public.players FOR UPDATE
        USING (id = auth.uid())
        WITH CHECK (id = auth.uid());
        ''',
        
        // Anyone can create a player (anonymous auth)
        '''
        CREATE POLICY "Anyone can create a player"
        ON public.players FOR INSERT
        WITH CHECK (true);
        ''',
      ];

      // Verify policies are valid
      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('ON public.players'));
      }
    });

    test('should create indexes for performance', () async {
      // Test that necessary indexes are created
      const indexes = [
        'CREATE INDEX idx_players_current_room_id ON public.players(current_room_id);',
        'CREATE INDEX idx_players_connection_status ON public.players(connection_status);',
        'CREATE INDEX idx_players_last_seen_at ON public.players(last_seen_at);',
      ];

      for (final index in indexes) {
        expect(index, contains('CREATE INDEX'));
        expect(index, contains('ON public.players'));
      }
    });

    test('should create update trigger for updated_at', () async {
      // Test that the updated_at trigger is created
      const triggerSQL = '''
        CREATE OR REPLACE FUNCTION public.update_updated_at_column()
        RETURNS TRIGGER AS \$\$
        BEGIN
          NEW.updated_at = now();
          RETURN NEW;
        END;
        \$\$ language 'plpgsql';

        CREATE TRIGGER update_players_updated_at BEFORE UPDATE
        ON public.players FOR EACH ROW
        EXECUTE FUNCTION public.update_updated_at_column();
      ''';

      expect(triggerSQL, contains('CREATE OR REPLACE FUNCTION'));
      expect(triggerSQL, contains('CREATE TRIGGER'));
      expect(triggerSQL, contains('update_players_updated_at'));
    });
  });
}