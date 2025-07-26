# Log de suppression des tests triviaux

## Date: 2025-07-26

## Tests supprimés

### 1. Tests de migration obsolètes
Ces tests étaient temporaires pour valider les migrations et ne sont plus nécessaires :

- `test/providers/card_selection_provider_migration_test.dart` - Migration terminée
- `test/providers/card_selection_provider_v2_test.dart` - Version v2 adoptée
- `test/providers/game_animation_provider_v2_test.dart` - Version v2 adoptée
- `test/navigation/router_v2_test.dart` - Router v2 adopté
- `test/integration/complete_migration_test.dart` - Migration complétée

### 2. Tests très petits sans valeur
- `test/core/providers/supabase_provider_test.dart` (23 lignes) - Test trivial qui vérifie seulement qu'une erreur est lancée
- `test/features/game/presentation/widgets/player_grid_with_selection_test.dart` (13 lignes) - Vide
- `test/features/global_scores/data/datasources/supabase_global_score_datasource_test.dart` (13 lignes) - Vide
- `test/unit/sentry_service_test.dart` (26 lignes) - Redondant avec core/services/sentry_service_test.dart

### 3. Dossiers vides
- `test/database/migrations/` - Tous les tests de migration SQL supprimés (tests d'intégration appropriés)

## Justifications

1. **Tests de migration** : La migration est terminée, ces tests n'apportent plus de valeur
2. **Tests triviaux** : Tests qui vérifient seulement des types ou null sans logique métier
3. **Tests vides** : Fichiers avec seulement des imports et groupes vides

## Impact sur la couverture

La suppression de ces tests n'affecte pas la couverture car :
- Les tests de migration testaient du code temporaire
- Les tests triviaux ne testaient pas de logique métier
- Les fonctionnalités sont couvertes par d'autres tests plus complets