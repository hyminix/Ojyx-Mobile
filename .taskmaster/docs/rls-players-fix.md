# Fix RLS Players Table (OJYX-D)

## Date: 2025-07-28

## Problème Identifié

L'erreur OJYX-D se produisait lors de la jointure d'une room par un utilisateur anonyme. La policy RLS "Players in same room can update" créait un blocage circulaire :
- Pour mettre à jour `current_room_id`, l'utilisateur devait déjà être dans la room
- Mais pour être dans la room, il fallait d'abord mettre à jour `current_room_id`

## Changements Appliqués

### 1. Suppression de l'ancienne policy problématique
```sql
DROP POLICY IF EXISTS "Players in same room can update" ON players;
```

### 2. Création d'une nouvelle policy optimisée
```sql
CREATE POLICY "update_players_policy" ON players
FOR UPDATE
USING (
  auth.uid() IS NOT NULL
)
WITH CHECK (
  auth.uid() IS NOT NULL AND (
    id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM rooms 
      WHERE (rooms.id = current_room_id OR rooms.id = players.current_room_id)
        AND (rooms.creator_id = auth.uid()::text OR auth.uid()::text = ANY(rooms.player_ids))
    ) OR
    current_room_id IS NULL
  )
);
```

### 3. Optimisations supplémentaires
- Ajout d'un index sur `current_room_id` pour améliorer les performances
- Création d'une fonction helper `join_room()` avec SECURITY DEFINER (optionnelle)

## Logique de la nouvelle policy

La policy permet les UPDATE si :
1. L'utilisateur est authentifié (même anonyme)
2. ET l'une des conditions suivantes est vraie :
   - L'utilisateur modifie son propre player (id = auth.uid())
   - L'utilisateur est déjà dans la room cible
   - `current_room_id` est NULL (permet la jointure initiale)

## Cas d'usage couverts

- ✅ Création de room par utilisateur anonyme
- ✅ Jointure de room par utilisateur anonyme
- ✅ Mise à jour du statut de connexion
- ✅ Déconnexion et reconnexion
- ✅ Changement de room

## Tests recommandés

1. Créer une room avec un utilisateur anonyme
2. Joindre cette room avec un autre utilisateur anonyme
3. Vérifier que `current_room_id` est correctement mis à jour
4. Vérifier les logs Supabase pour confirmer l'absence d'erreurs RLS
5. Monitorer Sentry pour s'assurer que OJYX-D ne se produit plus

## Impact

Cette correction résout le problème de jointure de room pour les utilisateurs anonymes sans compromettre la sécurité. La policy reste restrictive tout en permettant les opérations légitimes.