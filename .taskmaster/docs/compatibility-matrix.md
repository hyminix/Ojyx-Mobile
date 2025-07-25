# Matrice de Compatibilité des Dépendances - Projet Ojyx
Date: 2025-07-25

## Matrice de Compatibilité Détaillée

### Légende
- ✅ Compatible
- ⚠️ Compatible avec contraintes
- ❌ Incompatible
- ❓ Non testé/Inconnu

## Tableau de Compatibilité Principal

| Package | freezed 3.x | go_router 16.x | flutter_lints 6.x | sentry 9.x | build_runner 2.6 | Riverpod 2.6 | Supabase 2.9 |
|---------|------------|----------------|-------------------|------------|------------------|--------------|--------------|
| **freezed 3.x** | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ |
| **go_router 16.x** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **flutter_lints 6.x** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **sentry_flutter 9.x** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **build_runner 2.6** | ⚠️ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **riverpod 2.6** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **supabase_flutter 2.9** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Contraintes de Versions SDK

### Requirements Minimum par Package

| Package | Dart Min | Flutter Min | Notes |
|---------|----------|-------------|-------|
| freezed 3.2.0 | 3.0.0 | - | Utilise les nouvelles features Dart 3 |
| freezed_annotation 3.1.0 | 3.0.0 | - | - |
| go_router 16.0.0 | 3.6.0 | 3.27.0 | - |
| flutter_lints 6.0.0 | **3.8.0** | **3.32.0** | ⚠️ Plus restrictif |
| sentry_flutter 9.5.0 | 3.5.0 | 3.24.0 | - |
| build_runner 2.6.0 | 2.19.0 | - | - |
| json_serializable 6.10.0 | 3.5.0 | - | - |
| riverpod 2.6.1 | 3.0.0 | 3.10.0 | - |
| supabase_flutter 2.9.1 | 2.19.0 | 3.7.0 | - |

### Contraintes Globales Résultantes
```yaml
environment:
  sdk: ^3.8.0  # Imposé par flutter_lints 6.0.0
  flutter: ^3.32.0  # Imposé par flutter_lints 6.0.0
```

## Dépendances Transitives Critiques

### Chaîne analyzer
```
build_runner 2.6.0
  └── analyzer ^7.6.0 (contrainte)
       └── _fe_analyzer_shared ^85.0.0
       
freezed 3.2.0
  └── analyzer ^8.0.0 (requiert)  ⚠️ CONFLIT POTENTIEL
```

**Résolution** : build_runner 2.6.0 pourrait nécessiter dependency_overrides

### Chaîne build
```
build_runner 2.6.0
  └── build ^2.5.4
  
json_serializable 6.10.0
  └── build ^2.5.0 (compatible)
  
freezed 3.2.0
  └── build ^2.5.0 (compatible)
```

### Chaîne source_gen
```
json_serializable 6.10.0
  └── source_gen ^2.0.0
  
freezed 3.2.0
  └── source_gen ^2.0.0 (compatible)
  
riverpod_generator 2.6.5
  └── source_gen ^1.5.0 (⚠️ version plus ancienne)
```

## Conflits Identifiés et Résolutions

### 1. Conflit analyzer
**Problème** : freezed 3.x requiert analyzer ^8.0.0, mais build_runner 2.6.0 utilise ^7.6.0

**Solutions possibles** :
```yaml
# Option 1: Forcer la version avec dependency_overrides
dependency_overrides:
  analyzer: ^8.0.0
  _fe_analyzer_shared: ^86.0.0

# Option 2: Attendre build_runner 3.0.0 (si disponible)
```

### 2. Conflit lints
**Problème** : flutter_lints 6.0.0 apporte lints 6.0.0, mais d'autres packages peuvent dépendre de lints 5.x

**Solution** : Généralement résolu automatiquement par pub

### 3. Compatibilité Riverpod Generator
**Problème** : riverpod_generator utilise une version plus ancienne de source_gen

**Solution** : Vérifier les mises à jour de riverpod_generator

## Ordre de Migration Optimisé

### Phase 1: SDK et Linting (Jour 1)
1. Mettre à jour pubspec.yaml avec SDK constraints
2. flutter_lints 6.0.0
3. Corriger tous les warnings

### Phase 2: Build Tools (Jour 2)
1. build_runner 2.6.0
2. json_serializable 6.10.0
3. Vérifier la génération de code

### Phase 3: Freezed Migration (Jours 3-4)
1. freezed_annotation 3.1.0
2. freezed 3.2.0
3. Ajouter dependency_overrides si nécessaire
4. Migrer tous les modèles
5. Régénérer le code

### Phase 4: Navigation (Jour 5)
1. go_router 16.0.0
2. Tester toutes les routes
3. Vérifier la sensibilité à la casse

### Phase 5: Services (Jour 6)
1. sentry_flutter 9.5.0
2. Adapter la configuration
3. Tester le monitoring

## Scripts de Validation

### Vérification des Contraintes
```bash
# Vérifier les contraintes actuelles
flutter pub deps --style=tree

# Tester la résolution avec les nouvelles versions
flutter pub upgrade --dry-run

# Vérifier les conflits
flutter pub deps --no-dev --executables
```

### Test de Compatibilité
```bash
# Créer une branche de test
git checkout -b test-compatibility

# Mettre à jour une dépendance à la fois
flutter pub upgrade flutter_lints
flutter analyze
flutter test

# Si succès, continuer avec la suivante
```

## Risques et Mitigations

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|---------|------------|
| Conflit analyzer | Élevée | Élevé | dependency_overrides prêt |
| Breaking changes freezed | Certaine | Élevé | Tests exhaustifs |
| Régression navigation | Moyenne | Moyen | Tests E2E |
| Incompatibilité Android | Faible | Élevé | Vérifier Kotlin version |

## Checklist de Validation

- [ ] SDK Dart >= 3.8.0
- [ ] Flutter >= 3.32.0
- [ ] Tous les tests passent après chaque phase
- [ ] Génération de code fonctionne
- [ ] Navigation testée exhaustivement
- [ ] Monitoring Sentry opérationnel
- [ ] CI/CD passe sur la branche
- [ ] Documentation mise à jour

## Recommandations Finales

1. **Créer une branche dédiée** pour chaque phase
2. **Tester après chaque package** mis à jour
3. **Utiliser dependency_overrides** si nécessaire pour analyzer
4. **Ne pas forcer** les mises à jour si des conflits persistent
5. **Documenter** tous les changements et workarounds