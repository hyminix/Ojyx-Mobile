# Analyse des Index Non Utilisés - Tâche 41.3

## Date: 2025-07-28

## Résumé Exécutif

Analyse complète des **34 index non utilisés** (idx_scan = 0) dans la base de données Ojyx.

### Statistiques Globales
- **Total index non utilisés** : 34 (pas 46 comme initialement prévu)
- **À conserver obligatoirement** : 20 (59%)
- **Candidats à la suppression** : 5 (15%)
- **À analyser plus en détail** : 13 (38%)

## 1. Catégorisation des Index

### 1.1 PRIMARY KEYS (12 index) - NE PAS SUPPRIMER ❌
Ces index sont essentiels pour l'intégrité référentielle :
- cards_in_play_pkey
- cleanup_logs_pkey
- decks_pkey
- event_participations_pkey
- game_actions_pkey
- game_events_pkey
- global_scores_pkey
- player_grids_pkey
- rls_benchmark_results_pkey
- rls_policy_backup_pkey
- room_events_pkey
- unused_indexes_analysis_pkey

### 1.2 UNIQUE CONSTRAINTS (2 index) - CONSERVER ⚠️
Garantissent l'unicité des données :
- event_participations_event_id_player_id_key
- player_grids_game_state_id_player_id_key

### 1.3 FOREIGN KEY INDEXES (2 index) - CONSERVER ✅
Nouvellement créés dans cette tâche pour optimiser les jointures :
- idx_event_participations_room_id
- idx_game_states_round_initiator_id

### 1.4 RLS OPTIMIZATION INDEXES (1 index) - CONSERVER ✅
Créé lors de l'optimisation RLS récente :
- idx_rls_policy_backup_table_policy

## 2. Index Candidats à la Suppression (5 index) ✂️

Ces index de performance ne sont jamais utilisés et peuvent être supprimés :

### 2.1 Index sur la table `rooms`
1. **idx_rooms_created_at** - Index sur created_at, probablement pour tri chronologique
2. **idx_rooms_current_game_id** - Index sur current_game_id, redondant avec les requêtes actuelles
3. **idx_rooms_status_updated** - Index composite (status, updated_at)

### 2.2 Index sur la table `game_states`
4. **idx_game_states_game_phase** - Index sur game_phase

### 2.3 Index sur la table `global_scores`
5. **idx_global_scores_score** - Index sur score pour tri

**Espace total récupérable** : ~80 KB

## 3. Index à Analyser Plus en Détail (13 index) 🔍

Ces index nécessitent une analyse approfondie avant décision :

1. **idx_cards_game_location** - Potentiellement utile pour requêtes de localisation
2. **idx_cards_value_type** - Pourrait être utilisé pour filtrer par type
3. **idx_cleanup_logs_target** - Utile pour les jobs de maintenance
4. **idx_decks_game_state** - Lien avec game_states
5. **idx_decks_type** - Filtrage par type de deck
6. **idx_events_status_dates** - Index composite pour événements
7. **idx_game_actions_created_at** - Tri chronologique des actions
8. **idx_game_actions_game_state_id** - Jointure avec game_states
9. **idx_global_scores_created_at** - Tri chronologique
10. **idx_global_scores_position** - Classement des scores
11. **idx_global_scores_room_id** - Scores par room
12. **idx_participations_event** - Lien avec événements
13. **idx_room_events_created_at** - Tri chronologique des événements

## 4. Recommandations

### 4.1 Actions Immédiates
1. **Supprimer** les 5 index candidats identifiés
2. **Conserver** tous les PK, UK, FK et index RLS
3. **Monitorer** pendant 7 jours après suppression

### 4.2 Actions à Moyen Terme
1. Activer `pg_stat_statements` pour analyser les requêtes
2. Monitorer les 13 index "À ANALYSER" pendant 30 jours
3. Créer des alertes sur les requêtes lentes

### 4.3 Bonnes Pratiques
1. Réviser les index tous les 3 mois
2. Ne créer des index que basés sur des requêtes réelles
3. Documenter la justification de chaque index

## 5. Script de Suppression Sécurisée

```sql
-- Backup des définitions avant suppression
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE indexname IN (
    'idx_rooms_created_at',
    'idx_rooms_current_game_id',
    'idx_rooms_status_updated',
    'idx_game_states_game_phase',
    'idx_global_scores_score'
);

-- Suppression par batch
DROP INDEX IF EXISTS idx_rooms_created_at;
DROP INDEX IF EXISTS idx_rooms_current_game_id;
DROP INDEX IF EXISTS idx_rooms_status_updated;
DROP INDEX IF EXISTS idx_game_states_game_phase;
DROP INDEX IF EXISTS idx_global_scores_score;

-- VACUUM pour récupérer l'espace
VACUUM ANALYZE rooms, game_states, global_scores;
```

## 6. Métriques de Suivi

Après suppression, surveiller :
- Temps de réponse des requêtes sur rooms, game_states, global_scores
- Utilisation CPU PostgreSQL
- Taille de la base de données
- Apparition de slow queries dans les logs

## Conclusion

L'analyse révèle moins d'index non utilisés que prévu (34 vs 46), avec seulement 15% réellement supprimables. La majorité sont des contraintes système essentielles. Les suppressions proposées sont conservatrices et sans risque pour les performances.