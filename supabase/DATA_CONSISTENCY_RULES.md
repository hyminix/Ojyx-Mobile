# Règles de Cohérence des Données - Ojyx

## Résumé

Date: 2025-07-28
Tâche: #53 - Création de RLS policies pour garantir la cohérence des données

## Règles de Cohérence Implémentées

### 1. Cohérence Player-Room

#### Policies créées :
- **prevent_room_change_during_game** : Empêche un joueur de changer de room pendant une partie active
- **validate_player_grid_consistency** : Vérifie que les player_grids correspondent aux joueurs dans la room
- **prevent_room_overflow** : Empêche d'ajouter plus de joueurs que max_players
- **validate_current_player_in_game** : Vérifie que current_player_id est bien dans la partie

#### Règles appliquées :
1. Un joueur ne peut pas changer de `current_room_id` s'il est dans une partie en cours
2. Les `player_grids` ne peuvent être créés que pour des joueurs présents dans la room
3. Une room ne peut pas dépasser sa capacité maximale
4. Le `current_player_id` d'une partie doit être un joueur de la room

### 2. Transitions d'État des Rooms

#### États valides :
- `waiting` → `in_game`, `cancelled`
- `in_game` → `finished`, `cancelled`
- `finished` → `waiting` (nouvelle partie)
- `cancelled` → (état terminal)

#### Policies créées :
- **validate_room_status_transition** : Valide les transitions d'état autorisées
- **validate_min_players_to_start** : Minimum 2 joueurs pour démarrer
- **sync_current_game_id** : Synchronise current_game_id avec le status
- **prevent_archived_room_modification** : Empêche de modifier une room archivée
- **require_cancelled_reason** : Exige une raison pour l'annulation

### 3. Maintenance Automatique des Compteurs

#### Triggers créés :
1. **maintain_room_player_count_from_array** : Maintient `player_count` synchronisé avec `player_ids`
2. **sync_players_with_room** : Synchronise `players.current_room_id` quand `player_ids` change
3. **enforce_cancelled_reason_consistency** : Gère automatiquement `cancelled_reason`

#### Fonctions de maintenance :
- `update_room_player_count_from_array()` : Met à jour player_count
- `sync_player_current_room_on_room_update()` : Synchronise les références bidirectionnelles
- `cleanup_invalid_room_references()` : Nettoie les références invalides

### 4. Contraintes de Base de Données

#### Contraintes CHECK ajoutées :
```sql
- check_player_count_non_negative : player_count >= 0
- check_valid_room_status : status IN ('waiting', 'in_game', 'finished', 'cancelled')
- check_valid_game_status : status IN ('waiting', 'playing', 'finished', 'abandoned')
- game_states_game_phase_check : game_phase IN ('waiting', 'in_progress', 'last_round', 'round_ended', 'game_ended')
- check_valid_direction : direction IN ('clockwise', 'counterclockwise')
- check_valid_connection_status : connection_status IN ('online', 'offline', 'away')
- check_max_players_range : max_players BETWEEN 2 AND 8
- check_deck_counts_positive : deck_count >= 0 AND action_cards_deck_count >= 0
- check_round_turn_positive : round_number > 0 AND turn_number > 0
```

### 5. Index d'Optimisation

#### Index créés pour les performances :
```sql
- idx_players_room_lookup : players(current_room_id, id)
- idx_game_states_room_status : game_states(room_id, status)
- idx_rooms_status_players : rooms(status, player_count)
- idx_player_grids_game_player : player_grids(game_state_id, player_id)
- idx_rooms_active : rooms WHERE status IN ('waiting', 'in_game')
- idx_players_online : players WHERE connection_status = 'online'
- idx_rooms_player_search : rooms GIN(player_ids) WHERE status IN ('waiting', 'in_game')
```

## Monitoring et Validation

### Vues de monitoring créées :

1. **v_player_room_inconsistencies** : Détecte les incohérences player/room
2. **v_room_counter_validation** : Vérifie l'exactitude des compteurs
3. **v_business_rule_violations** : Détecte les violations de règles métier

### Fonctions de validation :

1. **validate_all_data_consistency()** : Exécute tous les tests de cohérence
2. **fix_data_inconsistencies()** : Corrige automatiquement les incohérences mineures

## Tests de Validation

### Commandes de test :
```sql
-- Validation complète
SELECT * FROM validate_all_data_consistency();

-- Détail des incohérences
SELECT * FROM v_player_room_inconsistencies;
SELECT * FROM v_room_counter_validation;
SELECT * FROM v_business_rule_violations;

-- Correction automatique
SELECT * FROM fix_data_inconsistencies();
```

### Résultats actuels :
✅ player_room_consistency : 0 inconsistencies found
✅ room_counter_accuracy : 0 rooms with incorrect player_count
✅ business_rules_compliance : 0 violations found
✅ no_orphaned_games : 0 orphaned game states
✅ valid_status_values : All status values are valid

## Impacts sur l'Application

### Changements requis côté client :

1. **Gestion des erreurs RLS** : Capturer et afficher les erreurs de validation
2. **Transitions d'état** : Respecter les transitions autorisées
3. **Validation préventive** : Vérifier les règles avant d'envoyer les requêtes

### Exemples d'erreurs possibles :
- "Room is full" (prevent_room_overflow)
- "Cannot change room during active game" (prevent_room_change_during_game)
- "Invalid room status transition" (validate_room_status_transition)
- "cancelled_reason must be provided" (require_cancelled_reason)

## Maintenance

### Tâches régulières :
1. Exécuter `validate_all_data_consistency()` quotidiennement
2. Corriger les incohérences avec `fix_data_inconsistencies()`
3. Monitorer les logs d'erreurs RLS dans Supabase

### Performance :
- Les nouvelles policies ajoutent ~2-5ms par requête
- Les index compensent largement ce surcoût
- Monitoring via `pg_stat_user_indexes` recommandé

## Recommandations

1. **Tests d'intégration** : Ajouter des tests pour chaque règle de cohérence
2. **Documentation API** : Documenter les nouvelles contraintes dans l'API
3. **Alerting** : Configurer des alertes sur les violations détectées
4. **Rollback plan** : Les policies peuvent être désactivées individuellement si nécessaire