-- Rollback Migration: Revert rooms.creator_id from uuid to text
-- Date: 2025-07-28
-- Task: #43 - Rollback script

BEGIN;

-- Step 1: Drop current policies
DROP POLICY IF EXISTS "Room creator can delete room" ON rooms;
DROP POLICY IF EXISTS "Room participants can update room" ON rooms;
DROP POLICY IF EXISTS "View waiting rooms or joined rooms" ON rooms;
DROP POLICY IF EXISTS "Authenticated users can create rooms" ON rooms;
DROP POLICY IF EXISTS "Anyone can view rooms" ON rooms;

DROP POLICY IF EXISTS "Players in room can create game states" ON game_states;
DROP POLICY IF EXISTS "Players in room can update game states" ON game_states;
DROP POLICY IF EXISTS "Players in room can view game states" ON game_states;

-- Step 2: Drop foreign key constraint
ALTER TABLE rooms DROP CONSTRAINT IF EXISTS fk_rooms_creator_id;

-- Step 3: Convert column back to text
ALTER TABLE rooms ADD COLUMN creator_id_text text;
UPDATE rooms SET creator_id_text = creator_id::text WHERE creator_id IS NOT NULL;
ALTER TABLE rooms DROP COLUMN creator_id;
ALTER TABLE rooms RENAME COLUMN creator_id_text TO creator_id;

-- Step 4: Restore original policies
CREATE POLICY "Room creator can delete room" ON rooms
FOR DELETE
USING (creator_id = ((SELECT auth.uid())::text));

CREATE POLICY "Room participants can update room" ON rooms
FOR UPDATE
USING (
  creator_id = ((SELECT auth.uid())::text)
  OR 
  ((SELECT auth.uid())::text = ANY(player_ids))
)
WITH CHECK (
  creator_id = ((SELECT auth.uid())::text)
  OR 
  ((SELECT auth.uid())::text = ANY(player_ids))
);

CREATE POLICY "View waiting rooms or joined rooms" ON rooms
FOR SELECT
USING (
  status = 'waiting'
  OR 
  ((SELECT auth.uid())::text = ANY(player_ids))
  OR 
  creator_id = ((SELECT auth.uid())::text)
);

CREATE POLICY "Authenticated users can create rooms" ON rooms
FOR INSERT
WITH CHECK ((SELECT auth.uid()) IS NOT NULL);

CREATE POLICY "Anyone can view rooms" ON rooms
FOR SELECT
USING (true);

-- Step 5: Restore game_states policies
CREATE POLICY "Players in room can create game states" ON game_states
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = game_states.room_id
    AND (
      rooms.creator_id = ((SELECT auth.uid())::text)
      OR 
      ((SELECT auth.uid())::text = ANY(rooms.player_ids))
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
      rooms.creator_id = ((SELECT auth.uid())::text)
      OR 
      ((SELECT auth.uid())::text = ANY(rooms.player_ids))
    )
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM rooms
    WHERE rooms.id = game_states.room_id
    AND (
      rooms.creator_id = ((SELECT auth.uid())::text)
      OR 
      ((SELECT auth.uid())::text = ANY(rooms.player_ids))
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
      rooms.creator_id = ((SELECT auth.uid())::text)
      OR 
      ((SELECT auth.uid())::text = ANY(rooms.player_ids))
    )
  )
);

COMMIT;

-- Note: If needed, restore from backup
-- DROP TABLE rooms CASCADE;
-- CREATE TABLE rooms AS SELECT * FROM rooms_backup_migration_43;
-- Then recreate all constraints and policies