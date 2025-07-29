# Rapport d'Optimisation des RLS Policies

## Résumé

Date: 2025-07-28
Tâche: #52 - Optimisation des RLS policies PostgreSQL

## Optimisations Réalisées

### 1. Optimisation des appels auth.uid()

**Problème**: Les policies appelaient `auth.uid()` plusieurs fois dans la même requête, causant des appels répétés à la fonction.

**Solution**: Remplacé tous les appels `auth.uid()` par `(SELECT auth.uid())` pour forcer PostgreSQL à mettre en cache le résultat.

**Tables impactées**:
- rooms (3 policies)
- game_states (2 policies)
- players (1 policy)
- player_grids (1 policy)
- game_actions (1 policy)
- cards_in_play (1 policy)
- decks (1 policy)
- room_events (1 policy)
- global_scores (1 policy)
- event_participations (1 policy)

### 2. Correction des problèmes de types

**Problème**: Comparaisons entre UUID et text nécessitant des casts coûteux.

**Solution**: Maintenu les casts `::text` nécessaires pour comparer avec les arrays `player_ids[]` qui sont de type text[].

### 3. Création d'index optimisés

**Index créés**:
```sql
-- Index sur les clés primaires et étrangères
idx_rooms_creator_id ON rooms(creator_id)
idx_rooms_status ON rooms(status) WHERE status = 'waiting'
idx_rooms_player_ids ON rooms USING GIN(player_ids)
idx_game_states_room_id ON game_states(room_id)
idx_players_id ON players(id)
idx_players_current_room_id ON players(current_room_id)
idx_player_grids_game_state_id ON player_grids(game_state_id)
idx_game_actions_game_state_id ON game_actions(game_state_id)
idx_cards_in_play_game_state_id ON cards_in_play(game_state_id)
idx_decks_game_state_id ON decks(game_state_id)
idx_room_events_room_id ON room_events(room_id)
idx_global_scores_room_id ON global_scores(room_id)

-- Index composite pour optimiser les jointures
idx_rooms_id_creator_status ON rooms(id, creator_id, status)
idx_players_id_room ON players(id, current_room_id)
```

### 4. Vues de monitoring créées

1. **v_policy_optimization_status**: Analyse l'état d'optimisation de chaque policy
2. **v_index_usage_stats**: Statistiques d'utilisation des index
3. **v_policy_performance_indicators**: Indicateurs de complexité des policies
4. **v_rls_performance_dashboard**: Tableau de bord global
5. **v_optimization_recommendations**: Recommandations automatiques

## Métriques de Performance

### Avant optimisation
- 13 policies non optimisées (appels multiples à auth.uid())
- 10 policies avec problèmes de cast de types
- 0 index spécifiques aux RLS policies

### Après optimisation
- Toutes les policies optimisées avec `(SELECT auth.uid())`
- Casts de types maintenus mais nécessaires pour la logique métier
- 15 nouveaux index créés
- 5 vues de monitoring pour suivi continu

## Bénéfices Attendus

1. **Réduction des appels de fonction**: auth.uid() appelé une seule fois par requête
2. **Amélioration des performances de jointure**: Index sur toutes les colonnes utilisées dans les policies
3. **Monitoring proactif**: Vues permettant de détecter les futures dégradations
4. **Maintenance simplifiée**: Recommandations automatiques via v_optimization_recommendations

## Requêtes de Monitoring

### Vérifier le statut global
```sql
SELECT * FROM v_rls_performance_dashboard;
```

### Identifier les policies à optimiser
```sql
SELECT * FROM v_optimization_recommendations 
WHERE priority = 'high';
```

### Analyser l'utilisation des index
```sql
SELECT * FROM v_index_usage_stats 
WHERE usage_category = 'unused';
```

### Mesurer la complexité des policies
```sql
SELECT * FROM v_policy_performance_indicators
WHERE complexity_category = 'high_complexity';
```

## Recommandations

1. **Monitoring régulier**: Exécuter les vues de monitoring hebdomadairement
2. **Nettoyage des index**: Supprimer les index non utilisés après 30 jours
3. **Tests de performance**: Mesurer les temps de réponse avant/après en production
4. **Documentation**: Maintenir ce document à jour avec les futures optimisations

## Notes Techniques

- Les policies avec `( SELECT auth.uid() AS uid)` utilisent déjà une forme d'optimisation via l'alias
- Les casts `::text` sont nécessaires car `player_ids` est un array de text, pas d'UUID
- Les index GIN sont essentiels pour la performance des recherches dans les arrays
- Les index partiels (WHERE clause) réduisent la taille et améliorent les performances