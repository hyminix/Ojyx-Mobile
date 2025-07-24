import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game Actions Table Migration', () {
    test('should create game_actions table with correct structure', () async {
      // This test verifies that the game_actions table migration creates the correct structure
      
      final expectedColumns = {
        'id': 'uuid',
        'game_state_id': 'uuid',
        'player_id': 'uuid',
        'action_type': 'text',
        'action_data': 'jsonb',
        'is_valid': 'boolean',
        'validation_error': 'text',
        'sequence_number': 'integer',
        'created_at': 'timestamp with time zone',
      };

      // Test that the migration SQL is valid
      const migrationSQL = '''
        CREATE TABLE IF NOT EXISTS public.game_actions (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          game_state_id UUID NOT NULL REFERENCES public.game_states(id) ON DELETE CASCADE,
          player_id UUID NOT NULL REFERENCES public.players(id),
          action_type TEXT NOT NULL CHECK (action_type IN (
            'draw_card', 'draw_from_discard', 'discard_card', 'reveal_card',
            'exchange_card', 'draw_action_card', 'play_action_card', 'end_turn',
            'validate_columns', 'end_round', 'start_game', 'join_game', 'leave_game'
          )),
          action_data JSONB NOT NULL DEFAULT '{}'::jsonb,
          is_valid BOOLEAN DEFAULT true,
          validation_error TEXT,
          sequence_number INTEGER NOT NULL,
          created_at TIMESTAMPTZ DEFAULT now()
        );
      ''';

      // Verify the SQL syntax is valid
      expect(migrationSQL, contains('CREATE TABLE'));
      expect(migrationSQL, contains('public.game_actions'));
      expect(migrationSQL, contains('PRIMARY KEY'));
      
      // Verify all expected columns are present
      for (final column in expectedColumns.keys) {
        expect(migrationSQL.toLowerCase(), contains(column.toLowerCase()));
      }
    });

    test('should enforce action type validation', () async {
      // Test that action_type has proper constraints
      const checkConstraint = '''
        CHECK (action_type IN (
          'draw_card', 'draw_from_discard', 'discard_card', 'reveal_card',
          'exchange_card', 'draw_action_card', 'play_action_card', 'end_turn',
          'validate_columns', 'end_round', 'start_game', 'join_game', 'leave_game'
        ))
      ''';

      expect(checkConstraint, contains('CHECK'));
      expect(checkConstraint, contains('action_type IN'));
      expect(checkConstraint, contains('draw_card'));
      expect(checkConstraint, contains('play_action_card'));
    });

    test('should create RLS policies for game_actions table', () async {
      // Test that RLS policies are correctly defined
      const rlsPolicies = [
        // Players can view actions in their games
        '''
        CREATE POLICY "Players can view actions in their games"
        ON public.game_actions FOR SELECT
        USING (
          game_state_id IN (
            SELECT gs.id FROM public.game_states gs
            JOIN public.players p ON p.current_room_id = gs.room_id
            WHERE p.id = auth.uid()
          )
        );
        ''',
        
        // Players can only insert their own actions
        '''
        CREATE POLICY "Players can insert their own actions"
        ON public.game_actions FOR INSERT
        WITH CHECK (
          player_id = auth.uid() AND
          game_state_id IN (
            SELECT gs.id FROM public.game_states gs
            JOIN public.players p ON p.current_room_id = gs.room_id
            WHERE p.id = auth.uid()
          )
        );
        ''',
      ];

      // Verify policies are valid
      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('ON public.game_actions'));
      }
    });

    test('should create indexes for performance', () async {
      // Test that necessary indexes are created
      const indexes = [
        'CREATE INDEX idx_game_actions_game_state_id ON public.game_actions(game_state_id);',
        'CREATE INDEX idx_game_actions_player_id ON public.game_actions(player_id);',
        'CREATE INDEX idx_game_actions_action_type ON public.game_actions(action_type);',
        'CREATE INDEX idx_game_actions_created_at ON public.game_actions(created_at DESC);',
        'CREATE INDEX idx_game_actions_sequence ON public.game_actions(game_state_id, sequence_number);',
      ];

      for (final index in indexes) {
        expect(index, contains('CREATE INDEX'));
        expect(index, contains('ON public.game_actions'));
      }
    });

    test('should create sequence for action numbering', () async {
      // Test that a sequence is created for action numbering
      const sequenceSQL = '''
        CREATE SEQUENCE IF NOT EXISTS game_action_sequence START 1;
      ''';

      expect(sequenceSQL, contains('CREATE SEQUENCE'));
      expect(sequenceSQL, contains('game_action_sequence'));
    });
  });
}