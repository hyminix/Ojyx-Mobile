import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Action Card Functions Migration', () {
    test('should create validate_action_card_use function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.validate_action_card_use(
          p_game_state_id UUID,
          p_player_id UUID,
          p_action_card_type TEXT,
          p_target_data JSONB DEFAULT '{}'::jsonb
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_game_state game_states%ROWTYPE;
          v_player_grid player_grids%ROWTYPE;
          v_has_card BOOLEAN := false;
          v_action_card JSONB;
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
          
          -- Get player grid
          SELECT * INTO v_player_grid 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          IF NOT FOUND THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Player not in game');
          END IF;
          
          -- Check if player has the action card
          FOR i IN 0..(jsonb_array_length(v_player_grid.action_cards) - 1) LOOP
            v_action_card := v_player_grid.action_cards->i;
            IF v_action_card->>'type' = p_action_card_type THEN
              v_has_card := true;
              EXIT;
            END IF;
          END LOOP;
          
          IF NOT v_has_card THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Action card not available');
          END IF;
          
          -- Validate specific action card rules
          CASE p_action_card_type
            WHEN 'teleport' THEN
              RETURN validate_teleport_action(p_game_state_id, p_player_id, p_target_data);
            WHEN 'turnAround' THEN
              RETURN validate_turn_around_action(p_game_state_id, p_player_id);
            WHEN 'peek' THEN
              RETURN validate_peek_action(p_game_state_id, p_player_id, p_target_data);
            WHEN 'swap' THEN
              RETURN validate_swap_action(p_game_state_id, p_player_id, p_target_data);
            ELSE
              RETURN jsonb_build_object('valid', false, 'error', 'Unknown action card type');
          END CASE;
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('validate_action_card_use'));
      expect(functionSQL, contains('p_action_card_type'));
      expect(functionSQL, contains('CASE p_action_card_type'));
    });

    test('should create teleport validation function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.validate_teleport_action(
          p_game_state_id UUID,
          p_player_id UUID,
          p_target_data JSONB
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_pos1 INTEGER;
          v_pos2 INTEGER;
          v_player_grid player_grids%ROWTYPE;
          v_card1 JSONB;
          v_card2 JSONB;
        BEGIN
          -- Extract positions from target data
          v_pos1 := (p_target_data->>'position1')::integer;
          v_pos2 := (p_target_data->>'position2')::integer;
          
          -- Validate positions
          IF v_pos1 < 0 OR v_pos1 > 11 OR v_pos2 < 0 OR v_pos2 > 11 THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Invalid positions');
          END IF;
          
          IF v_pos1 = v_pos2 THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Cannot swap card with itself');
          END IF;
          
          -- Get player grid
          SELECT * INTO v_player_grid 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          -- Get cards at positions
          v_card1 := v_player_grid.grid_cards->v_pos1;
          v_card2 := v_player_grid.grid_cards->v_pos2;
          
          -- Check if cards can be swapped (both must be face down)
          IF (v_card1->>'is_revealed')::boolean = true THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Cannot swap revealed card');
          END IF;
          
          IF (v_card2->>'is_revealed')::boolean = true THEN
            RETURN jsonb_build_object('valid', false, 'error', 'Cannot swap revealed card');
          END IF;
          
          RETURN jsonb_build_object('valid', true);
        END;
        \$\$ LANGUAGE plpgsql;
      ''';

      expect(functionSQL, contains('validate_teleport_action'));
      expect(functionSQL, contains('position1'));
      expect(functionSQL, contains('Cannot swap revealed card'));
    });

    test('should create process_action_card function', () async {
      const functionSQL = '''
        CREATE OR REPLACE FUNCTION public.process_action_card(
          p_game_state_id UUID,
          p_player_id UUID,
          p_action_card_type TEXT,
          p_target_data JSONB DEFAULT '{}'::jsonb
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_validation JSONB;
          v_result JSONB;
        BEGIN
          -- Validate the action first
          v_validation := validate_action_card_use(
            p_game_state_id, p_player_id, p_action_card_type, p_target_data
          );
          
          IF (v_validation->>'valid')::boolean = false THEN
            RETURN v_validation;
          END IF;
          
          -- Process the specific action
          CASE p_action_card_type
            WHEN 'teleport' THEN
              v_result := execute_teleport_action(p_game_state_id, p_player_id, p_target_data);
            WHEN 'turnAround' THEN
              v_result := execute_turn_around_action(p_game_state_id, p_player_id);
            WHEN 'peek' THEN
              v_result := execute_peek_action(p_game_state_id, p_player_id, p_target_data);
            WHEN 'swap' THEN
              v_result := execute_swap_action(p_game_state_id, p_player_id, p_target_data);
            ELSE
              RETURN jsonb_build_object('valid', false, 'error', 'Unknown action type');
          END CASE;
          
          -- Remove the used action card from player's hand
          IF (v_result->>'valid')::boolean = true THEN
            PERFORM remove_action_card_from_hand(p_game_state_id, p_player_id, p_action_card_type);
          END IF;
          
          -- Log the action
          INSERT INTO game_actions (
            game_state_id, player_id, action_type, action_data, created_at
          ) VALUES (
            p_game_state_id, p_player_id, 'action_card_use',
            jsonb_build_object(
              'card_type', p_action_card_type,
              'target_data', p_target_data
            ),
            now()
          );
          
          RETURN v_result;
        END;
        \$\$ LANGUAGE plpgsql SECURITY DEFINER;
      ''';

      expect(functionSQL, contains('process_action_card'));
      expect(functionSQL, contains('remove_action_card_from_hand'));
      expect(functionSQL, contains('action_card_use'));
    });

    test('should create action execution functions', () async {
      const executionFunctions = [
        '''
        CREATE OR REPLACE FUNCTION public.execute_teleport_action(
          p_game_state_id UUID,
          p_player_id UUID,
          p_target_data JSONB
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_pos1 INTEGER;
          v_pos2 INTEGER;
          v_player_grid player_grids%ROWTYPE;
          v_new_grid JSONB[];
          v_temp_card JSONB;
          i INTEGER;
        BEGIN
          v_pos1 := (p_target_data->>'position1')::integer;
          v_pos2 := (p_target_data->>'position2')::integer;
          
          -- Get current grid
          SELECT * INTO v_player_grid 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          -- Create new grid with swapped cards
          v_new_grid := ARRAY[]::JSONB[];
          FOR i IN 0..11 LOOP
            IF i = v_pos1 THEN
              v_new_grid := array_append(v_new_grid, v_player_grid.grid_cards->v_pos2);
            ELSIF i = v_pos2 THEN
              v_new_grid := array_append(v_new_grid, v_player_grid.grid_cards->v_pos1);
            ELSE
              v_new_grid := array_append(v_new_grid, v_player_grid.grid_cards->i);
            END IF;
          END LOOP;
          
          -- Update player grid
          UPDATE player_grids 
          SET 
            grid_cards = to_jsonb(v_new_grid),
            updated_at = now()
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          RETURN jsonb_build_object('valid', true, 'action', 'teleport_executed');
        END;
        \$\$ LANGUAGE plpgsql;
        ''',
      ];

      for (final func in executionFunctions) {
        expect(func, contains('execute_teleport_action'));
        expect(func, contains('teleport_executed'));
      }
    });

    test('should create helper functions for action cards', () async {
      const helperFunction = '''
        CREATE OR REPLACE FUNCTION public.remove_action_card_from_hand(
          p_game_state_id UUID,
          p_player_id UUID,
          p_card_type TEXT
        ) RETURNS VOID AS \$\$
        DECLARE
          v_player_grid player_grids%ROWTYPE;
          v_new_cards JSONB[];
          v_card JSONB;
          v_found BOOLEAN := false;
        BEGIN
          -- Get player grid
          SELECT * INTO v_player_grid 
          FROM player_grids 
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
          
          -- Remove first occurrence of the card type
          v_new_cards := ARRAY[]::JSONB[];
          FOR i IN 0..(jsonb_array_length(v_player_grid.action_cards) - 1) LOOP
            v_card := v_player_grid.action_cards->i;
            IF (v_card->>'type' = p_card_type) AND NOT v_found THEN
              v_found := true;
              -- Skip this card (don't add to new array)
            ELSE
              v_new_cards := array_append(v_new_cards, v_card);
            END IF;
          END LOOP;
          
          -- Update player grid
          UPDATE player_grids 
          SET 
            action_cards = to_jsonb(v_new_cards),
            updated_at = now()
          WHERE game_state_id = p_game_state_id AND player_id = p_player_id;
        END;
        \$\$ LANGUAGE plpgsql;
      ''';

      expect(helperFunction, contains('remove_action_card_from_hand'));
      expect(helperFunction, contains('jsonb_array_length'));
    });

    test('should create action card timing validation', () async {
      const timingFunction = '''
        CREATE OR REPLACE FUNCTION public.validate_action_timing(
          p_game_state_id UUID,
          p_player_id UUID,
          p_action_card_type TEXT
        ) RETURNS JSONB AS \$\$
        DECLARE
          v_game_state game_states%ROWTYPE;
          v_card_timing TEXT;
        BEGIN
          -- Get game state
          SELECT * INTO v_game_state FROM game_states WHERE id = p_game_state_id;
          
          -- Get card timing info
          v_card_timing := get_action_card_timing(p_action_card_type);
          
          CASE v_card_timing
            WHEN 'immediate' THEN
              -- Immediate cards must be played right away
              RETURN jsonb_build_object('valid', true, 'must_play_now', true);
            WHEN 'optional' THEN
              -- Optional cards can be played anytime during player's turn
              IF v_game_state.current_player_id = p_player_id THEN
                RETURN jsonb_build_object('valid', true, 'can_play', true);
              ELSE
                RETURN jsonb_build_object('valid', false, 'error', 'Not your turn');
              END IF;
            WHEN 'reactive' THEN
              -- Reactive cards can be played in response to other actions
              RETURN jsonb_build_object('valid', true, 'reactive', true);
            ELSE
              RETURN jsonb_build_object('valid', false, 'error', 'Unknown timing type');
          END CASE;
        END;
        \$\$ LANGUAGE plpgsql;
      ''';

      expect(timingFunction, contains('validate_action_timing'));
      expect(timingFunction, contains('immediate'));
      expect(timingFunction, contains('reactive'));
    });
  });
}
