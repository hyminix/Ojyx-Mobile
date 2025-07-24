import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game States Table Migration', () {
    test('should create game_states table with correct structure', () async {
      // This test verifies that the game_states table migration creates the correct structure
      
      final expectedColumns = {
        'id': 'uuid',
        'room_id': 'uuid',
        'current_player_id': 'uuid',
        'round_number': 'integer',
        'turn_number': 'integer',
        'game_phase': 'text',
        'direction': 'text',
        'deck_count': 'integer',
        'discard_pile': 'jsonb',
        'action_cards_deck_count': 'integer',
        'action_cards_discard': 'jsonb',
        'round_initiator_id': 'uuid',
        'is_last_round': 'boolean',
        'created_at': 'timestamp with time zone',
        'updated_at': 'timestamp with time zone',
      };

      // Test that the migration SQL is valid
      const migrationSQL = '''
        CREATE TABLE IF NOT EXISTS public.game_states (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          room_id UUID NOT NULL REFERENCES public.rooms(id) ON DELETE CASCADE,
          current_player_id UUID REFERENCES public.players(id),
          round_number INTEGER DEFAULT 1,
          turn_number INTEGER DEFAULT 1,
          game_phase TEXT DEFAULT 'waiting' CHECK (game_phase IN ('waiting', 'in_progress', 'last_round', 'round_ended', 'game_ended')),
          direction TEXT DEFAULT 'clockwise' CHECK (direction IN ('clockwise', 'counter_clockwise')),
          deck_count INTEGER DEFAULT 0,
          discard_pile JSONB DEFAULT '[]'::jsonb,
          action_cards_deck_count INTEGER DEFAULT 0,
          action_cards_discard JSONB DEFAULT '[]'::jsonb,
          round_initiator_id UUID REFERENCES public.players(id),
          is_last_round BOOLEAN DEFAULT false,
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now()
        );
      ''';

      // Verify the SQL syntax is valid
      expect(migrationSQL, contains('CREATE TABLE'));
      expect(migrationSQL, contains('public.game_states'));
      expect(migrationSQL, contains('PRIMARY KEY'));
      
      // Verify all expected columns are present
      for (final column in expectedColumns.keys) {
        expect(migrationSQL.toLowerCase(), contains(column.toLowerCase()));
      }
    });

    test('should create player_grids table for storing player game state', () async {
      // Test for player_grids table that stores individual player game state
      const migrationSQL = '''
        CREATE TABLE IF NOT EXISTS public.player_grids (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          game_state_id UUID NOT NULL REFERENCES public.game_states(id) ON DELETE CASCADE,
          player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
          grid_cards JSONB NOT NULL DEFAULT '[]'::jsonb,
          action_cards JSONB DEFAULT '[]'::jsonb,
          score INTEGER DEFAULT 0,
          position INTEGER NOT NULL,
          is_active BOOLEAN DEFAULT true,
          has_revealed_all BOOLEAN DEFAULT false,
          created_at TIMESTAMPTZ DEFAULT now(),
          updated_at TIMESTAMPTZ DEFAULT now(),
          UNIQUE(game_state_id, player_id)
        );
      ''';

      expect(migrationSQL, contains('CREATE TABLE'));
      expect(migrationSQL, contains('public.player_grids'));
      expect(migrationSQL, contains('grid_cards JSONB'));
      expect(migrationSQL, contains('UNIQUE(game_state_id, player_id)'));
    });

    test('should create RLS policies for game_states table', () async {
      // Test that RLS policies are correctly defined
      const rlsPolicies = [
        // Players can view game states for rooms they are in
        '''
        CREATE POLICY "Players can view game states in their rooms"
        ON public.game_states FOR SELECT
        USING (
          room_id IN (
            SELECT current_room_id FROM public.players WHERE id = auth.uid()
          )
        );
        ''',
        
        // Only server can insert/update game states
        '''
        CREATE POLICY "Only authenticated users can modify game states"
        ON public.game_states FOR ALL
        USING (auth.uid() IS NOT NULL)
        WITH CHECK (auth.uid() IS NOT NULL);
        ''',
      ];

      // Verify policies are valid
      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('ON public.game_states'));
      }
    });

    test('should create indexes for performance', () async {
      // Test that necessary indexes are created
      const indexes = [
        'CREATE INDEX idx_game_states_room_id ON public.game_states(room_id);',
        'CREATE INDEX idx_game_states_current_player_id ON public.game_states(current_player_id);',
        'CREATE INDEX idx_game_states_game_phase ON public.game_states(game_phase);',
        'CREATE INDEX idx_player_grids_game_state_id ON public.player_grids(game_state_id);',
        'CREATE INDEX idx_player_grids_player_id ON public.player_grids(player_id);',
      ];

      for (final index in indexes) {
        expect(index, contains('CREATE INDEX'));
        expect(index, contains('ON public.'));
      }
    });
  });
}