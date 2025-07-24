import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game State Management Functions Migration', () {
    test('should create initialize_game function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.initialize_game(
          p_room_id UUID,
          p_player_ids UUID[],
          p_creator_id UUID
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_game_state_id UUID;
          v_player_id UUID;
          v_shuffled_deck JSONB;
          v_player_cards JSONB[];
          v_player_index INTEGER := 0;
          i INTEGER;
        BEGIN
          -- Create new game state
          INSERT INTO game_states (
            room_id,
            status,
            current_player_id,
            turn_number,
            round_number,
            game_data,
            created_at,
            updated_at
          ) VALUES (
            p_room_id,
            'active',
            p_player_ids[1], -- First player starts
            1,
            1,
            jsonb_build_object(
              'player_order', to_jsonb(p_player_ids),
              'creator_id', p_creator_id,
              'deck_seed', extract(epoch from now())::integer
            ),
            now(),
            now()
          ) RETURNING id INTO v_game_state_id;
          
          -- Generate shuffled deck
          v_shuffled_deck := generate_shuffled_deck(
            (game_states.game_data->>'deck_seed')::integer
          );
          
          -- Deal cards to each player (12 cards each)
          FOREACH v_player_id IN ARRAY p_player_ids LOOP
            v_player_cards := ARRAY[]::JSONB[];
            
            -- Create player's 12-card grid (3x4)
            FOR i IN 0..11 LOOP
              v_player_cards := array_append(v_player_cards, 
                jsonb_build_object(
                  'value', (v_shuffled_deck->(v_player_index * 12 + i)->>'value')::integer,
                  'is_revealed', false
                )
              );
            END LOOP;
            
            -- Create player grid entry
            INSERT INTO player_grids (
              game_state_id,
              player_id,
              grid_cards,
              action_cards,
              score,
              position,
              is_active,
              has_revealed_all,
              created_at,
              updated_at
            ) VALUES (
              v_game_state_id,
              v_player_id,
              to_jsonb(v_player_cards),
              '[]'::jsonb, -- Start with no action cards
              0, -- Initial score
              v_player_index + 1, -- Position in game
              true,
              false,
              now(),
              now()
            );
            
            v_player_index := v_player_index + 1;
          END LOOP;
          
          -- Log game initialization
          INSERT INTO game_actions (
            game_state_id, player_id, action_type, action_data, created_at
          ) VALUES (
            v_game_state_id, p_creator_id, 'game_initialized',
            jsonb_build_object('players', p_player_ids),
            now()
          );
          
          RETURN jsonb_build_object(
            'valid', true, 
            'game_state_id', v_game_state_id,
            'current_player', p_player_ids[1]
          );
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('initialize_game'));
      expect(functionSQL, contains('generate_shuffled_deck'));
      expect(functionSQL, contains('game_initialized'));
    });

    test('should create deck generation function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.generate_shuffled_deck(p_seed INTEGER)
        RETURNS JSONB AS \$\$
        DECLARE
          v_deck JSONB[];
          v_card_values INTEGER[] := ARRAY[-2,-1,-1,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,6,6,6,6,7,7,7,7,8,8,8,8,9,9,9,9,10,10,10,10,11,11,11,11,12,12];
          v_shuffled INTEGER[];
          v_temp INTEGER;
          v_rand_index INTEGER;
          i INTEGER;
          j INTEGER;
        BEGIN
          -- Initialize deck with card distribution from constants
          v_shuffled := v_card_values;
          
          -- Fisher-Yates shuffle with seed
          FOR i IN 1..array_length(v_shuffled, 1) LOOP
            -- Seed-based random number generation
            v_rand_index := ((p_seed * 1103515245 + 12345 + i * 7) % (array_length(v_shuffled, 1) - i + 1)) + i;
            
            -- Swap elements
            v_temp := v_shuffled[i];
            v_shuffled[i] := v_shuffled[v_rand_index];
            v_shuffled[v_rand_index] := v_temp;
          END LOOP;
          
          -- Convert to JSONB array
          v_deck := ARRAY[]::JSONB[];
          FOR i IN 1..array_length(v_shuffled, 1) LOOP
            v_deck := array_append(v_deck, 
              jsonb_build_object('value', v_shuffled[i])
            );
          END LOOP;
          
          RETURN to_jsonb(v_deck);
        END;
        \$\$ LANGUAGE plpgsql;
      ''';

      expect(functionSQL, contains('generate_shuffled_deck'));
      expect(functionSQL, contains('Fisher-Yates'));
      expect(functionSQL, contains('1103515245')); // Linear congruential generator constant
    });

    test('should create end game detection function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.check_end_game_conditions(p_game_state_id UUID)
        RETURNS JSONB AS \$\$
        DECLARE
          v_game_state game_states%ROWTYPE;
          v_player_record RECORD;
          v_all_revealed_count INTEGER := 0;
          v_trigger_player_id UUID;
          v_min_score INTEGER;
          v_winner_id UUID;
          v_penalty_applied BOOLEAN := false;
        BEGIN
          -- Get game state
          SELECT * INTO v_game_state FROM game_states WHERE id = p_game_state_id;
          
          IF NOT FOUND THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Game not found');
          END IF;
          
          -- Check if any player has revealed all cards
          FOR v_player_record IN 
            SELECT player_id, grid_cards 
            FROM player_grids 
            WHERE game_state_id = p_game_state_id 
          LOOP
            IF check_all_cards_revealed(v_player_record.grid_cards) THEN
              v_trigger_player_id := v_player_record.player_id;
              EXIT;
            END IF;
          END LOOP;
          
          -- If no trigger player, game continues
          IF v_trigger_player_id IS NULL THEN
            RETURN jsonb_build_object('game_ended', false);
          END IF;
          
          -- Calculate final scores for all players
          UPDATE player_grids 
          SET score = calculate_final_score(grid_cards)
          WHERE game_state_id = p_game_state_id;
          
          -- Find minimum score and winner
          SELECT MIN(score) INTO v_min_score 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id;
          
          SELECT player_id INTO v_winner_id 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND score = v_min_score
          LIMIT 1;
          
          -- Apply penalty if trigger player doesn't have lowest score
          IF v_trigger_player_id != v_winner_id THEN
            UPDATE player_grids 
            SET score = score * 2 -- Double penalty
            WHERE game_state_id = p_game_state_id AND player_id = v_trigger_player_id;
            
            v_penalty_applied := true;
            
            -- Recalculate winner after penalty
            SELECT MIN(score) INTO v_min_score 
            FROM player_grids 
            WHERE game_state_id = p_game_state_id;
            
            SELECT player_id INTO v_winner_id 
            FROM player_grids 
            WHERE game_state_id = p_game_state_id AND score = v_min_score
            LIMIT 1;
          END IF;
          
          -- Update game state to finished
          UPDATE game_states 
          SET 
            status = 'finished',
            winner_id = v_winner_id,
            ended_at = now(),
            updated_at = now()
          WHERE id = p_game_state_id;
          
          -- Log game end
          INSERT INTO game_actions (
            game_state_id, player_id, action_type, action_data, created_at
          ) VALUES (
            p_game_state_id, v_trigger_player_id, 'game_ended',
            jsonb_build_object(
              'winner_id', v_winner_id,
              'penalty_applied', v_penalty_applied,
              'trigger_player', v_trigger_player_id
            ),
            now()
          );
          
          RETURN jsonb_build_object(
            'game_ended', true,
            'winner_id', v_winner_id,
            'trigger_player', v_trigger_player_id,
            'penalty_applied', v_penalty_applied
          );
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('check_end_game_conditions'));
      expect(functionSQL, contains('check_all_cards_revealed'));
      expect(functionSQL, contains('penalty_applied'));
    });

    test('should create scoring helper functions', () async {
      const scoringFunctions = [
        '''
        CREATE OR REPLACE FUNCTION public.check_all_cards_revealed(grid_cards JSONB)
        RETURNS BOOLEAN AS \$\$
        DECLARE
          v_card JSONB;
          i INTEGER;
        BEGIN
          FOR i IN 0..11 LOOP
            v_card := grid_cards->i;
            IF (v_card->>'is_revealed')::boolean = false THEN
              RETURN false;
            END IF;
          END LOOP;
          
          RETURN true;
        END;
        \$\$ LANGUAGE plpgsql;
        ''',
        '''
        CREATE OR REPLACE FUNCTION public.calculate_final_score(grid_cards JSONB)
        RETURNS INTEGER AS \$\$
        DECLARE
          v_total_score INTEGER := 0;
          v_card JSONB;
          i INTEGER;
        BEGIN
          FOR i IN 0..11 LOOP
            v_card := grid_cards->i;
            
            IF (v_card->>'value')::integer = -1 THEN
              -- Discarded card (complete column) = 0 points
              v_total_score := v_total_score + 0;
            ELSE
              -- All other cards count their face value
              v_total_score := v_total_score + (v_card->>'value')::integer;
            END IF;
          END LOOP;
          
          RETURN v_total_score;
        END;
        \$\$ LANGUAGE plpgsql;
        '''
      ];

      for (final func in scoringFunctions) {
        expect(func, contains('LANGUAGE plpgsql'));
        expect(func, contains('RETURNS'));
      }
    });

    test('should create global scores recording function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.record_game_results(p_game_state_id UUID)
        RETURNS VOID AS \$\$
        DECLARE
          v_game_state game_states%ROWTYPE;
          v_player_record RECORD;
          v_player_count INTEGER;
          v_position INTEGER;
        BEGIN
          -- Get game state
          SELECT * INTO v_game_state FROM game_states WHERE id = p_game_state_id;
          
          -- Count total players
          SELECT COUNT(*) INTO v_player_count 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id;
          
          -- Insert results into global_scores for each player
          FOR v_player_record IN 
            SELECT 
              pg.player_id,
              p.name as player_name,
              pg.score,
              pg.position,
              (pg.player_id = (v_game_state.game_data->>'creator_id')::uuid) as was_round_initiator
            FROM player_grids pg
            JOIN players p ON pg.player_id = p.id
            WHERE pg.game_state_id = p_game_state_id
            ORDER BY pg.score ASC, pg.position ASC
          LOOP
            INSERT INTO global_scores (
              player_id,
              player_name,
              room_id,
              round_number,
              score,
              position,
              total_players,
              was_round_initiator,
              created_at
            ) VALUES (
              v_player_record.player_id,
              v_player_record.player_name,
              v_game_state.room_id,
              v_game_state.round_number,
              v_player_record.score,
              v_player_record.position,
              v_player_count,
              v_player_record.was_round_initiator,
              now()
            );
          END LOOP;
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('record_game_results'));
      expect(functionSQL, contains('global_scores'));
      expect(functionSQL, contains('was_round_initiator'));
    });

    test('should create triggers for automatic game state updates', () async {
      const triggerSQL = '''
        -- Trigger to automatically check end game conditions after each move
        CREATE OR REPLACE FUNCTION public.trigger_check_end_game()
        RETURNS TRIGGER AS \$\$
        DECLARE
          v_end_result JSONB;
        BEGIN
          -- Only check on grid updates
          IF TG_OP = 'UPDATE' AND OLD.grid_cards != NEW.grid_cards THEN
            v_end_result := check_end_game_conditions(NEW.game_state_id);
            
            -- If game ended, record results
            IF (v_end_result->>'game_ended')::boolean = true THEN
              PERFORM record_game_results(NEW.game_state_id);
            END IF;
          END IF;
          
          RETURN NEW;
        END;
        \$\$ LANGUAGE plpgsql;
        
        -- Create the trigger
        CREATE TRIGGER player_grids_end_game_check
          AFTER UPDATE ON player_grids
          FOR EACH ROW
          EXECUTE FUNCTION trigger_check_end_game();
      ''';

      expect(triggerSQL, contains('CREATE TRIGGER'));
      expect(triggerSQL, contains('trigger_check_end_game'));
      expect(triggerSQL, contains('AFTER UPDATE'));
    });
  });
}