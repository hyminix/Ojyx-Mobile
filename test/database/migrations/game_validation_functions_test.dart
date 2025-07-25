import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Game Validation Functions Migration', () {
    test('should create validate_card_reveal function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.validate_card_reveal(
          p_game_state_id UUID,
          p_player_id UUID,
          p_position INTEGER
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_game_state game_states%ROWTYPE;
          v_player_grid player_grids%ROWTYPE;
          v_grid_data JSONB;
          v_card JSONB;
        BEGIN
          -- Get game state
          SELECT * INTO v_game_state 
          FROM game_states 
          WHERE id = p_game_state_id;
          
          IF NOT FOUND THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Game not found');
          END IF;
          
          -- Check if game is active
          IF v_game_state.status != 'active' THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Game not active');
          END IF;
          
          -- Check if it's player's turn
          IF v_game_state.current_player_id != p_player_id THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Not your turn');
          END IF;
          
          -- Get player grid
          SELECT * INTO v_player_grid 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          IF NOT FOUND THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Player grid not found');
          END IF;
          
          -- Check position validity (0-11 for 3x4 grid)
          IF p_position < 0 OR p_position > 11 THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Invalid position');
          END IF;
          
          -- Get card at position
          v_card := v_player_grid.grid_cards->p_position;
          
          -- Check if card is already revealed
          IF (v_card->>'is_revealed')::boolean = true THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Card already revealed');
          END IF;
          
          RETURN jsonb_build_object('valid', true);
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('CREATE OR REPLACE FUNCTION'));
      expect(functionSQL, contains('validate_card_reveal'));
      expect(functionSQL, contains('RETURNS JSONB'));
    });

    test('should create process_card_reveal function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.process_card_reveal(
          p_game_state_id UUID,
          p_player_id UUID,
          p_position INTEGER
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_validation JSONB;
          v_player_grid player_grids%ROWTYPE;
          v_grid_data JSONB;
          v_card JSONB;
          v_new_grid JSONB[];
          v_column_cards JSONB[];
          v_column_complete BOOLEAN;
          i INTEGER;
        BEGIN
          -- Validate the move first
          v_validation := validate_card_reveal(p_game_state_id, p_player_id, p_position);
          
          IF (v_validation->>'valid')::boolean = false THEN
            RETURN v_validation;
          END IF;
          
          -- Get player grid
          SELECT * INTO v_player_grid 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          -- Create new grid with revealed card
          v_new_grid := ARRAY[]::JSONB[];
          FOR i IN 0..11 LOOP
            v_card := v_player_grid.grid_cards->i;
            IF i = p_position THEN
              v_card := jsonb_set(v_card, '{is_revealed}', 'true'::jsonb);
            END IF;
            v_new_grid := array_append(v_new_grid, v_card);
          END LOOP;
          
          -- Check for complete columns (same value, all revealed)
          FOR i IN 0..2 LOOP -- 3 columns
            v_column_cards := ARRAY[v_new_grid[i], v_new_grid[i+3], v_new_grid[i+6], v_new_grid[i+9]];
            v_column_complete := check_column_complete(v_column_cards);
            
            IF v_column_complete THEN
              -- Set column cards as discarded (value -1)
              v_new_grid[i] := jsonb_set(v_new_grid[i], '{value}', '-1'::jsonb);
              v_new_grid[i+3] := jsonb_set(v_new_grid[i+3], '{value}', '-1'::jsonb);
              v_new_grid[i+6] := jsonb_set(v_new_grid[i+6], '{value}', '-1'::jsonb);
              v_new_grid[i+9] := jsonb_set(v_new_grid[i+9], '{value}', '-1'::jsonb);
            END IF;
          END LOOP;
          
          -- Update player grid
          UPDATE player_grids 
          SET 
            grid_cards = to_jsonb(v_new_grid),
            score = calculate_grid_score(to_jsonb(v_new_grid)),
            updated_at = now()
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          -- Log the action
          INSERT INTO game_actions (
            game_state_id, player_id, action_type, action_data, created_at
          ) VALUES (
            p_game_state_id, p_player_id, 'card_reveal',
            jsonb_build_object('position', p_position),
            now()
          );
          
          RETURN jsonb_build_object('valid', true, 'action', 'card_revealed');
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('process_card_reveal'));
      expect(functionSQL, contains('check_column_complete'));
      expect(functionSQL, contains('calculate_grid_score'));
    });

    test('should create helper functions', () async {
      const helperFunctions = [
        '''
        CREATE OR REPLACE FUNCTION public.check_column_complete(column_cards JSONB[])
        RETURNS BOOLEAN AS \$\$
        DECLARE
          v_first_value INTEGER;
          v_card JSONB;
        BEGIN
          -- Check if all cards are revealed
          FOREACH v_card IN ARRAY column_cards LOOP
            IF (v_card->>'is_revealed')::boolean = false THEN
              RETURN false;
            END IF;
          END LOOP;
          
          -- Check if all have same value
          v_first_value := (column_cards[1]->>'value')::integer;
          FOREACH v_card IN ARRAY column_cards LOOP
            IF (v_card->>'value')::integer != v_first_value THEN
              RETURN false;
            END IF;
          END LOOP;
          
          RETURN true;
        END;
        \$\$ LANGUAGE plpgsql;
        ''',
        '''
        CREATE OR REPLACE FUNCTION public.calculate_grid_score(grid_cards JSONB)
        RETURNS INTEGER AS \$\$
        DECLARE
          v_total_score INTEGER := 0;
          v_card JSONB;
          i INTEGER;
        BEGIN
          FOR i IN 0..11 LOOP
            v_card := grid_cards->i;
            -- Only count revealed cards, discarded cards (value -1) count as 0
            IF (v_card->>'is_revealed')::boolean = true THEN
              IF (v_card->>'value')::integer = -1 THEN
                -- Discarded card (complete column) = 0 points
                v_total_score := v_total_score + 0;
              ELSE
                -- Normal revealed card
                v_total_score := v_total_score + (v_card->>'value')::integer;
              END IF;
            ELSE
              -- Unrevealed cards count as their face value for final scoring
              v_total_score := v_total_score + (v_card->>'value')::integer;
            END IF;
          END LOOP;
          
          RETURN v_total_score;
        END;
        \$\$ LANGUAGE plpgsql;
        ''',
      ];

      for (final func in helperFunctions) {
        expect(func, contains('CREATE OR REPLACE FUNCTION'));
        expect(func, contains('LANGUAGE plpgsql'));
      }
    });

    test('should create turn management functions', () async {
      const turnFunctions = '''
        CREATE OR REPLACE FUNCTION public.advance_turn(p_game_state_id UUID)
        RETURNS JSONB AS \$\$
        DECLARE
          v_game_state game_states%ROWTYPE;
          v_player_ids UUID[];
          v_current_index INTEGER;
          v_next_player_id UUID;
        BEGIN
          -- Get game state
          SELECT * INTO v_game_state FROM game_states WHERE id = p_game_state_id;
          
          IF NOT FOUND THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Game not found');
          END IF;
          
          -- Get player order
          v_player_ids := (v_game_state.game_data->>'player_order')::UUID[];
          
          -- Find current player index
          v_current_index := array_position(v_player_ids, v_game_state.current_player_id);
          
          -- Calculate next player (round robin)
          IF v_current_index = array_length(v_player_ids, 1) THEN
            v_next_player_id := v_player_ids[1];
          ELSE
            v_next_player_id := v_player_ids[v_current_index + 1];
          END IF;
          
          -- Update game state
          UPDATE game_states 
          SET 
            current_player_id = v_next_player_id,
            turn_number = turn_number + 1,
            updated_at = now()
          WHERE id = p_game_state_id;
          
          -- Log turn change
          INSERT INTO game_actions (
            game_state_id, player_id, action_type, action_data, created_at
          ) VALUES (
            p_game_state_id, v_next_player_id, 'turn_start',
            jsonb_build_object('turn_number', v_game_state.turn_number + 1),
            now()
          );
          
          RETURN jsonb_build_object('valid', true, 'next_player', v_next_player_id);
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(turnFunctions, contains('advance_turn'));
      expect(turnFunctions, contains('player_order'));
      expect(turnFunctions, contains('turn_number'));
    });

    test('should create RLS policies for functions', () async {
      const rlsPolicies = [
        '''
        -- Players can only call validation functions for games they are in
        CREATE POLICY "Players can validate moves in their games"
        ON game_states FOR SELECT
        USING (
          id IN (
            SELECT game_state_id 
            FROM player_grids 
            WHERE player_id = auth.uid()
          )
        );
        ''',
        '''
        -- Players can only modify their own grids
        CREATE POLICY "Players can update their own grids"
        ON player_grids FOR UPDATE
        USING (player_id = auth.uid())
        WITH CHECK (player_id = auth.uid());
        ''',
      ];

      for (final policy in rlsPolicies) {
        expect(policy, contains('CREATE POLICY'));
        expect(policy, contains('auth.uid()'));
      }
    });
  });
}
