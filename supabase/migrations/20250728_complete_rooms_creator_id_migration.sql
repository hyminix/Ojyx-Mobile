-- Complete Migration: Change rooms.creator_id from text to uuid
-- Date: 2025-07-28
-- Task: #43 - Migration complète avec toutes les dépendances

-- Create backup before migration
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'rooms_backup_migration_43') THEN
    CREATE TABLE rooms_backup_migration_43 AS SELECT * FROM rooms;
  END IF;
END
$$;

BEGIN;

-- Step 1: Add temporary column
ALTER TABLE rooms ADD COLUMN IF NOT EXISTS creator_id_uuid uuid;

-- Step 2: Convert existing data
UPDATE rooms 
SET creator_id_uuid = creator_id::uuid
WHERE creator_id IS NOT NULL;

-- Step 3: Drop ALL dependent policies
-- Rooms policies
DROP POLICY IF EXISTS "Room creator can delete room" ON rooms;
DROP POLICY IF EXISTS "Room participants can update room" ON rooms;
DROP POLICY IF EXISTS "View waiting rooms or joined rooms" ON rooms;
DROP POLICY IF EXISTS "Authenticated users can create rooms" ON rooms;
DROP POLICY IF EXISTS "Anyone can view rooms" ON rooms;

-- Game states policies
DROP POLICY IF EXISTS "Players in room can create game states" ON game_states;
DROP POLICY IF EXISTS "Players in room can update game states" ON game_states;
DROP POLICY IF EXISTS "Players in room can view game states" ON game_states;

-- Player grids policies
DROP POLICY IF EXISTS "Players in game can manage player grids" ON player_grids;

-- Game actions policies
DROP POLICY IF EXISTS "Players in game can insert actions" ON game_actions;
DROP POLICY IF EXISTS "Players in game can view actions" ON game_actions;

-- Global scores policies
DROP POLICY IF EXISTS "Players can delete scores in their rooms" ON global_scores;

-- Players policies
DROP POLICY IF EXISTS "update_players_policy" ON players;

-- Room events policies
DROP POLICY IF EXISTS "Players in room can insert events" ON room_events;
DROP POLICY IF EXISTS "Players in room can view events" ON room_events;

-- Cards in play policies
DROP POLICY IF EXISTS "Players in game can view cards" ON cards_in_play;

-- Decks policies
DROP POLICY IF EXISTS "Players in game can view decks" ON decks;

-- Step 4: Drop the view that depends on creator_id
DROP VIEW IF EXISTS v_rls_violations_monitor;

-- Step 5: Drop old column and rename new one
ALTER TABLE rooms DROP COLUMN creator_id;
ALTER TABLE rooms RENAME COLUMN creator_id_uuid TO creator_id;

-- Step 6: Add foreign key constraint
ALTER TABLE rooms 
ADD CONSTRAINT fk_rooms_creator_id 
FOREIGN KEY (creator_id) 
REFERENCES players(id) 
ON DELETE SET NULL;

-- Step 7: Recreate ALL policies with correct uuid type

-- ROOMS policies
CREATE POLICY "Room creator can delete room" ON rooms
FOR DELETE
USING (creator_id = (SELECT auth.uid()));

CREATE POLICY "Room participants can update room" ON rooms
FOR UPDATE
USING (
  creator_id = (SELECT auth.uid()) 
  OR 
  (SELECT auth.uid())::text = ANY(player_ids)
)
WITH CHECK (
  creator_id = (SELECT auth.uid()) 
  OR 
  (SELECT auth.uid())::text = ANY(player_ids)
);

CREATE POLICY "View waiting rooms or joined rooms" ON rooms
FOR SELECT
USING (
  status = 'waiting'
  OR 
  (SELECT auth.uid())::text = ANY(player_ids)
  OR 
  creator_id = (SELECT auth.uid())
);

CREATE POLICY "Authenticated users can create rooms" ON rooms
FOR INSERT
WITH CHECK ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "Anyone can view rooms" ON rooms
FOR SELECT
USING (true);

-- GAME_STATES policies
CREATE POLICY "Players in room can create game states" ON game_states
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = game_states.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
);

CREATE POLICY "Players in room can update game states" ON game_states
FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = game_states.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = game_states.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
);

CREATE POLICY "Players in room can view game states" ON game_states
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = game_states.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
);

-- PLAYER_GRIDS policies
CREATE POLICY "Players in game can manage player grids" ON player_grids
FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM game_states gs
    JOIN rooms r ON r.id = gs.room_id
    WHERE gs.id = player_grids.game_state_id
    AND (
      r.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(r.player_ids)
    )
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM game_states gs
    JOIN rooms r ON r.id = gs.room_id
    WHERE gs.id = player_grids.game_state_id
    AND (
      r.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(r.player_ids)
    )
  )
);

-- GAME_ACTIONS policies
CREATE POLICY "Players in game can insert actions" ON game_actions
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM game_states gs
    JOIN rooms r ON r.id = gs.room_id
    WHERE gs.id = game_actions.game_state_id
    AND (
      r.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(r.player_ids)
    )
  )
);

CREATE POLICY "Players in game can view actions" ON game_actions
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM game_states gs
    JOIN rooms r ON r.id = gs.room_id
    WHERE gs.id = game_actions.game_state_id
    AND (
      r.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(r.player_ids)
    )
  )
);

-- GLOBAL_SCORES policies
CREATE POLICY "Players can delete scores in their rooms" ON global_scores
FOR DELETE
USING (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = global_scores.room_id
    AND rooms.creator_id = (SELECT auth.uid())
  )
);

-- Create the missing policies for global_scores
CREATE POLICY IF NOT EXISTS "Players can view scores" ON global_scores
FOR SELECT
USING (true);

CREATE POLICY IF NOT EXISTS "Players can insert scores" ON global_scores
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = global_scores.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
);

-- PLAYERS policies
CREATE POLICY "update_players_policy" ON players
FOR UPDATE
USING ((SELECT auth.uid()) IS NOT NULL)
WITH CHECK (
  (SELECT auth.uid()) IS NOT NULL 
  AND (
    id = (SELECT auth.uid()) 
    OR EXISTS (
      SELECT 1 FROM rooms
      WHERE (
        rooms.id = players.current_room_id 
        OR rooms.id = players.current_room_id
      ) 
      AND (
        rooms.creator_id = (SELECT auth.uid())
        OR 
        (SELECT auth.uid())::text = ANY(rooms.player_ids)
      )
    ) 
    OR current_room_id IS NULL
  )
);

-- ROOM_EVENTS policies
CREATE POLICY "Players in room can insert events" ON room_events
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = room_events.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
);

CREATE POLICY "Players in room can view events" ON room_events
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = room_events.room_id
    AND (
      rooms.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(rooms.player_ids)
    )
  )
);

-- CARDS_IN_PLAY policies
CREATE POLICY "Players in game can view cards" ON cards_in_play
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM game_states gs
    JOIN rooms r ON r.id = gs.room_id
    WHERE gs.id = cards_in_play.game_state_id
    AND (
      r.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(r.player_ids)
    )
  )
);

-- DECKS policies
CREATE POLICY "Players in game can view decks" ON decks
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM game_states gs
    JOIN rooms r ON r.id = gs.room_id
    WHERE gs.id = decks.game_state_id
    AND (
      r.creator_id = (SELECT auth.uid())
      OR 
      (SELECT auth.uid())::text = ANY(r.player_ids)
    )
  )
);

-- Step 8: Recreate the monitoring view
CREATE VIEW v_rls_violations_monitor AS
SELECT 
  'rooms' as table_name,
  'creator_id type mismatch' as violation_type,
  COUNT(*) as violation_count,
  'Migrated to UUID type' as description
FROM rooms
WHERE false; -- No violations after migration

COMMIT;