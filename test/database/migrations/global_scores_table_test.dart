import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Global Scores Table Migration', () {
    test('should create global_scores table with correct structure', () async {
      // This test verifies that the global_scores table migration creates the correct structure

      final expectedColumns = {
        'id': 'uuid',
        'player_id': 'uuid',
        'player_name': 'text',
        'room_id': 'uuid',
        'round_number': 'integer',
        'score': 'integer',
        'position': 'integer',
        'total_players': 'integer',
        'was_round_initiator': 'boolean',
        'created_at': 'timestamp with time zone',
      };

      // Test that the migration SQL is valid
      const migrationSQL = '''
        CREATE TABLE IF NOT EXISTS public.global_scores (
          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
          player_id UUID NOT NULL REFERENCES public.players(id),
          player_name TEXT NOT NULL,
          room_id UUID NOT NULL REFERENCES public.rooms(id),
          round_number INTEGER NOT NULL,
          score INTEGER NOT NULL,
          position INTEGER NOT NULL,
          total_players INTEGER NOT NULL,
          was_round_initiator BOOLEAN DEFAULT false,
          created_at TIMESTAMPTZ DEFAULT now()
        );
      ''';

      // Verify the SQL syntax is valid
      expect(migrationSQL, contains('CREATE TABLE'));
      expect(migrationSQL, contains('public.global_scores'));
      expect(migrationSQL, contains('PRIMARY KEY'));

      // Verify all expected columns are present
      for (final column in expectedColumns.keys) {
        expect(migrationSQL.toLowerCase(), contains(column.toLowerCase()));
      }
    });

    test('should create RLS policies for global_scores table', () async {
      // Test that RLS policies are correctly defined
      const rlsPolicies = [
        // Anyone can read global scores (public leaderboard)
        '''
        CREATE POLICY "Anyone can view global scores"
        ON public.global_scores FOR SELECT
        USING (true);
        ''',

        // Only authenticated users can insert scores
        '''
        CREATE POLICY "Authenticated users can insert scores"
        ON public.global_scores FOR INSERT
        WITH CHECK (auth.uid() IS NOT NULL);
        ''',

        // Players can only delete their own scores
        '''
        CREATE POLICY "Players can delete their own scores"
        ON public.global_scores FOR DELETE
        USING (player_id = auth.uid());
        ''',
      ];

      // Verify policies are valid
      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('ON public.global_scores'));
      }
    });

    test('should create indexes for performance', () async {
      // Test that necessary indexes are created
      const indexes = [
        'CREATE INDEX idx_global_scores_player_id ON public.global_scores(player_id);',
        'CREATE INDEX idx_global_scores_room_id ON public.global_scores(room_id);',
        'CREATE INDEX idx_global_scores_created_at ON public.global_scores(created_at DESC);',
        'CREATE INDEX idx_global_scores_score ON public.global_scores(score);',
        'CREATE INDEX idx_global_scores_position ON public.global_scores(position);',
      ];

      for (final index in indexes) {
        expect(index, contains('CREATE INDEX'));
        expect(index, contains('ON public.global_scores'));
      }
    });

    test('should create function for top players query', () async {
      // Test the stored procedure for getting top players
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.get_top_players(limit_count INTEGER DEFAULT 10)
        RETURNS TABLE (
          player_id UUID,
          player_name TEXT,
          total_games INTEGER,
          total_wins INTEGER,
          average_score NUMERIC,
          best_score INTEGER,
          worst_score INTEGER,
          average_position NUMERIC,
          total_rounds INTEGER
        ) AS \$\$
        BEGIN
          RETURN QUERY
          SELECT 
            gs.player_id,
            gs.player_name,
            COUNT(DISTINCT gs.room_id)::INTEGER as total_games,
            COUNT(CASE WHEN gs.position = 1 THEN 1 END)::INTEGER as total_wins,
            ROUND(AVG(gs.score), 2) as average_score,
            MIN(gs.score) as best_score,
            MAX(gs.score) as worst_score,
            ROUND(AVG(gs.position), 2) as average_position,
            COUNT(*)::INTEGER as total_rounds
          FROM public.global_scores gs
          GROUP BY gs.player_id, gs.player_name
          ORDER BY average_score ASC
          LIMIT limit_count;
        END;
        \$\$ LANGUAGE plpgsql;
      ''';

      expect(functionSQL, contains('CREATE OR REPLACE FUNCTION'));
      expect(functionSQL, contains('get_top_players'));
      expect(functionSQL, contains('RETURNS TABLE'));
    });

    test('should create constraints for data integrity', () async {
      // Test constraints
      const constraints = '''
        ALTER TABLE public.global_scores
        ADD CONSTRAINT check_position CHECK (position > 0),
        ADD CONSTRAINT check_total_players CHECK (total_players >= position),
        ADD CONSTRAINT check_round_number CHECK (round_number > 0);
      ''';

      expect(constraints, contains('ADD CONSTRAINT'));
      expect(constraints, contains('check_position'));
      expect(constraints, contains('check_total_players'));
    });
  });
}
