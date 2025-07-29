-- Migration: Change rooms.creator_id from text to uuid
-- Date: 2025-07-28
-- Task: #43 - Migration de rooms.creator_id de text vers uuid

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

-- Step 2: Convert existing data (all existing values are valid UUIDs)
UPDATE rooms 
SET creator_id_uuid = creator_id::uuid
WHERE creator_id IS NOT NULL;

-- Step 3: Drop existing policies that use creator_id
DROP POLICY IF EXISTS "Room creator can delete room" ON rooms;
DROP POLICY IF EXISTS "Room participants can update room" ON rooms;
DROP POLICY IF EXISTS "View waiting rooms or joined rooms" ON rooms;
DROP POLICY IF EXISTS "Authenticated users can create rooms" ON rooms;
DROP POLICY IF EXISTS "Anyone can view rooms" ON rooms;

-- Step 4: Drop old column and rename new one
ALTER TABLE rooms DROP COLUMN creator_id;
ALTER TABLE rooms RENAME COLUMN creator_id_uuid TO creator_id;

-- Step 5: Add foreign key constraint
ALTER TABLE rooms 
ADD CONSTRAINT fk_rooms_creator_id 
FOREIGN KEY (creator_id) 
REFERENCES players(id) 
ON DELETE SET NULL;

-- Step 6: Recreate policies with correct uuid comparisons
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

-- Step 7: Update other policies that might reference rooms.creator_id
-- Update game_states policies
DROP POLICY IF EXISTS "Players in room can create game states" ON game_states;
DROP POLICY IF EXISTS "Players in room can update game states" ON game_states;
DROP POLICY IF EXISTS "Players in room can view game states" ON game_states;

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

COMMIT;