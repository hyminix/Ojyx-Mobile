# Migration Issues - Ojyx Project

## Migration Summary (Task 13 - Résolution des conflits)

### Environnement
- Flutter: 3.32.6 (stable)
- Dart: 3.8.1 (stable)

### Dependency Overrides - TOUTES RETIRÉES ✅

Les deux overrides ont été retirés avec succès:
- ~~`crypto: any`~~ - Retiré
- ~~`riverpod: any`~~ - Retiré

Aucun dependency_override n'est nécessaire pour la compilation.

## Résolution des Erreurs (Subtask 13.3-13.5)

### Erreurs Résolues

1. **API Supabase v2.9.1**
   - `ChannelResponse` n'existe plus - retourner directement les channels
   - `subscribe()` est maintenant synchrone (pas async)
   - `PostgresChangePayload` nécessite le paramètre `errors`

2. **SentryService**
   - Maintenant une classe statique (pas d'instance)
   - Méthodes renommées: `measurePerformance` → `trackTransaction`
   - Méthodes supprimées: `setUser`, `clearUser`

3. **Tests Provider Migration**
   - `CardSelectionState` a des propriétés différentes
   - `ActionCardState` simplifié avec drawPileCount/discardPileCount
   - `GameAnimationState` utilise direction au lieu d'animatingCards

### Statistiques Finales

- **Erreurs initiales**: 344 issues (99+ compilation errors)
- **Erreurs finales**: 247 issues (40 compilation errors)
- **Réduction**: 71% des erreurs de compilation résolues

### Problèmes Restants

1. **Tests Realtime** (2 erreurs)
   - Type mismatch avec ChannelResponse dans les mocks
   - Nécessite une refonte des tests pour la nouvelle API

2. **Tests manquants/déplacés**
   - Certains tests font référence à des classes non migrées
   - Tests Sentry déplacés de integration/ vers unit/

3. **Warnings Riverpod**
   - Syntaxe dépréciée qui sera supprimée dans v3.0
   - Migration complète vers @riverpod recommandée

## Recommandations

1. **Court terme**
   - Finaliser la correction des 40 erreurs restantes
   - Migrer tous les tests vers les nouvelles APIs

2. **Moyen terme**
   - Migrer vers la syntaxe @riverpod complète
   - Supprimer toute syntaxe dépréciée

3. **Long terme**
   - Implémenter de vrais tests d'intégration Sentry
   - Ajouter des tests E2E pour Supabase Realtime

## Conclusion

La migration est en bonne voie. Les conflits de dépendances ont été résolus sans nécessiter d'overrides. La majorité des erreurs de compilation ont été corrigées en adaptant le code aux nouvelles APIs. Les erreurs restantes sont principalement dans les tests et peuvent être résolues progressivement.