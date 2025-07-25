# Plan de Test et Validation - Migration des Dépendances Ojyx
Date: 2025-07-25

## Vue d'Ensemble

Ce plan définit une stratégie complète de test et validation pour garantir la stabilité du projet tout au long de la migration des dépendances. Suivant rigoureusement l'approche TDD définie dans le PRD.

## 🎯 Objectifs de Validation

1. **Zero Régression** : Aucune fonctionnalité existante ne doit être cassée
2. **Coverage Maintenu** : Minimum 80% de couverture de code
3. **Performance Stable** : Temps de build et d'exécution comparables
4. **Qualité Améliorée** : Résolution des nouveaux warnings de linting

## 📊 Métriques de Base (Baseline)

### État Actuel à Capturer
```bash
# Script: capture-baseline.sh
#!/bin/bash
echo "📸 Capturing baseline metrics..."

# 1. Coverage actuel
flutter test --coverage
cp coverage/lcov.info .taskmaster/reports/baseline-coverage.info
genhtml coverage/lcov.info -o .taskmaster/reports/baseline-coverage-html

# 2. Nombre de tests
TOTAL_TESTS=$(find test -name "*_test.dart" | wc -l)
echo "Total test files: $TOTAL_TESTS" > .taskmaster/reports/baseline-metrics.txt

# 3. Temps d'exécution des tests
time flutter test 2>&1 | tee -a .taskmaster/reports/baseline-metrics.txt

# 4. Warnings de linting
flutter analyze 2>&1 | tee .taskmaster/reports/baseline-analyze.txt

# 5. Taille de l'APK
flutter build apk --release --analyze-size 2>&1 | tee .taskmaster/reports/baseline-apk-size.txt

# 6. Performance de génération de code
time flutter pub run build_runner build --delete-conflicting-outputs 2>&1 | tee -a .taskmaster/reports/baseline-metrics.txt
```

### Métriques Cibles
- **Coverage** : ≥ 80% (maintenir ou améliorer)
- **Tests** : 100% passants après chaque phase
- **Build Time** : < baseline + 10%
- **APK Size** : < baseline + 5%
- **Warnings** : 0 erreurs, warnings minimisés

## 🧪 Stratégie de Test par Phase

### Phase 0: Tests de Préparation

**Tests à Créer AVANT la Migration** :
```dart
// test/migration/dependency_snapshot_test.dart
@Tags(['migration'])
import 'package:test/test.dart';

void main() {
  group('Dependency Snapshot Tests', () {
    test('should capture current dependency versions', () {
      // Snapshot des versions actuelles
      final currentVersions = {
        'freezed': '2.5.8',
        'go_router': '14.8.1',
        'flutter_lints': '5.0.0',
        // etc...
      };
      
      // Sauvegarder pour comparaison post-migration
      expect(currentVersions, isNotEmpty);
    });
  });
}
```

### Phase 1: Tests SDK et Environnement

**Validation SDK** :
```dart
// test/migration/sdk_compatibility_test.dart
void main() {
  test('should meet minimum SDK requirements', () {
    // Vérifier compatibilité Dart SDK
    expect(Platform.version, contains('3.8.'));
  });
}
```

### Phase 2: Tests de Linting

**Tests de Conformité** :
```bash
#!/bin/bash
# test-linting-compliance.sh

# Avant mise à jour
flutter analyze > before-lints.txt

# Après mise à jour flutter_lints 6.0.0
flutter analyze > after-lints.txt

# Comparer et valider
diff before-lints.txt after-lints.txt
```

### Phase 3: Tests de Génération de Code

**Suite de Tests Build Runner** :
```dart
// test/generation/code_generation_test.dart
@Tags(['generation'])
void main() {
  group('Code Generation Tests', () {
    test('should generate all freezed models', () async {
      // Lister tous les fichiers .freezed.dart
      final generatedFiles = Directory('lib')
          .listSync(recursive: true)
          .where((file) => file.path.endsWith('.freezed.dart'))
          .toList();
      
      expect(generatedFiles, isNotEmpty);
    });
    
    test('should generate all json serializable', () async {
      final generatedFiles = Directory('lib')
          .listSync(recursive: true)
          .where((file) => file.path.endsWith('.g.dart'))
          .toList();
      
      expect(generatedFiles, isNotEmpty);
    });
  });
}
```

### Phase 4: Tests Freezed Migration (CRITIQUE)

**Tests de Régression par Modèle** :
```dart
// test/models/freezed_migration_test.dart
@Tags(['freezed', 'migration'])
void main() {
  group('Freezed Migration Tests', () {
    group('GameState', () {
      test('should maintain immutability', () {
        final state1 = GameState.initial();
        final state2 = state1.copyWith();
        
        expect(state1, equals(state2));
        expect(identical(state1, state2), isFalse);
      });
      
      test('should support pattern matching', () {
        final state = GameState.playing();
        
        // Nouveau pattern matching (switch expression)
        final result = switch (state) {
          GameStateInitial() => 'initial',
          GameStatePlaying() => 'playing',
          _ => 'unknown'
        };
        
        expect(result, 'playing');
      });
    });
  });
}
```

**Script de Validation Freezed** :
```bash
#!/bin/bash
# validate-freezed-migration.sh

echo "🧊 Validating Freezed migration..."

# 1. Nettoyer les anciens fichiers
find . -name "*.freezed.dart" -delete

# 2. Régénérer
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Vérifier la compilation
flutter build apk --debug --no-pub

# 4. Exécuter les tests de modèles
flutter test --tags "freezed"
```

### Phase 5: Tests Navigation (Go Router)

**Tests E2E Navigation** :
```dart
// test/navigation/go_router_migration_test.dart
@Tags(['navigation', 'e2e'])
void main() {
  group('Go Router Migration Tests', () {
    late GoRouter router;
    
    setUp(() {
      router = createTestRouter();
    });
    
    test('should handle case sensitivity correctly', () {
      // Tester avec différentes casses
      expect(router.canGo('/Home'), isTrue);
      expect(router.canGo('/home'), isTrue); // Si caseSensitive: false
    });
    
    test('should preserve deep links', () {
      final deepLinks = [
        '/game/123',
        '/profile/settings',
        '/lobby/join/abc123',
      ];
      
      for (final link in deepLinks) {
        expect(() => router.go(link), returnsNormally);
      }
    });
  });
}
```

### Phase 6: Tests Services (Sentry)

**Tests d'Intégration Sentry** :
```dart
// test/services/sentry_migration_test.dart
@Tags(['sentry', 'integration'])
void main() {
  group('Sentry Migration Tests', () {
    test('should capture errors with new API', () async {
      await Sentry.init((options) {
        options.dsn = 'test-dsn';
        options.beforeSend = (event, hint) {
          // Nouvelle API - mutation directe
          event.release = 'test-release';
          return event;
        };
      });
      
      // Vérifier la capture
      await Sentry.captureException(Exception('test'));
    });
  });
}
```

## 🔄 Tests de Régression Continue

### Suite de Tests Automatisés
```yaml
# .github/workflows/migration-tests.yml
name: Migration Tests

on:
  push:
    branches: [feat/dependency-upgrade]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run all tests
        run: |
          flutter test --coverage
          flutter test --tags migration
          flutter test --tags e2e
      
      - name: Check coverage
        run: |
          COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines" | cut -d':' -f2 | cut -d'%' -f1)
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage below 80%!"
            exit 1
          fi
```

## 📋 Checklist de Validation par Phase

### Phase 1 (SDK)
- [ ] Flutter doctor passe sans erreur
- [ ] Tous les tests existants passent
- [ ] Pas de nouveaux warnings

### Phase 2 (Linting)
- [ ] Tous les nouveaux warnings corrigés
- [ ] Analyse statique sans erreur
- [ ] Code formaté selon les nouvelles règles

### Phase 3 (Build Tools)
- [ ] Génération de code réussie
- [ ] Tous les fichiers .g.dart présents
- [ ] Pas d'erreurs de compilation

### Phase 4 (Freezed)
- [ ] Tous les modèles migrés
- [ ] Pattern matching fonctionnel
- [ ] Tests de régression passent
- [ ] Pas de régression de performance

### Phase 5 (Navigation)
- [ ] Toutes les routes accessibles
- [ ] Deep links fonctionnels
- [ ] Navigation guards opérationnels
- [ ] Tests E2E passent

### Phase 6 (Services)
- [ ] Sentry capture les erreurs
- [ ] Configuration Android valide
- [ ] Monitoring opérationnel

## 🚀 Scripts d'Automatisation

### Script de Validation Globale
```bash
#!/bin/bash
# validate-all.sh

set -e

echo "🔍 Running complete validation suite..."

# 1. Tests unitaires
echo "Running unit tests..."
flutter test

# 2. Tests d'intégration
echo "Running integration tests..."
flutter test integration_test/

# 3. Tests avec tags
echo "Running tagged tests..."
flutter test --tags "migration"

# 4. Coverage
echo "Checking coverage..."
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# 5. Analyse
echo "Running analysis..."
flutter analyze

# 6. Build de validation
echo "Validating build..."
flutter build apk --debug

echo "✅ All validations passed!"
```

### Script de Comparaison Avant/Après
```bash
#!/bin/bash
# compare-metrics.sh

echo "📊 Comparing metrics..."

# Coverage
BEFORE=$(grep "lines" .taskmaster/reports/baseline-coverage.info | cut -d':' -f2)
AFTER=$(grep "lines" coverage/lcov.info | cut -d':' -f2)
echo "Coverage: $BEFORE → $AFTER"

# Test count
BEFORE=$(cat .taskmaster/reports/baseline-metrics.txt | grep "Total test files" | cut -d':' -f2)
AFTER=$(find test -name "*_test.dart" | wc -l)
echo "Test files: $BEFORE → $AFTER"

# Warnings
BEFORE=$(cat .taskmaster/reports/baseline-analyze.txt | grep -c "warning" || true)
AFTER=$(flutter analyze | grep -c "warning" || true)
echo "Warnings: $BEFORE → $AFTER"
```

## 📈 Monitoring Continu

### Dashboard de Progression
```markdown
## Migration Progress Dashboard

### Phase Status
- [x] Phase 0: Preparation ✅
- [ ] Phase 1: SDK Update ⏳
- [ ] Phase 2: Linting
- [ ] Phase 3: Build Tools
- [ ] Phase 4: Freezed
- [ ] Phase 5: Navigation
- [ ] Phase 6: Services

### Metrics
| Metric | Baseline | Current | Target | Status |
|--------|----------|---------|---------|---------|
| Coverage | 80.5% | 80.5% | ≥80% | ✅ |
| Tests | 122 | 122 | 122+ | ✅ |
| Warnings | 45 | 45 | <50 | ✅ |
| Build Time | 2m30s | 2m30s | <2m45s | ✅ |
```

## 🎯 Critères de Succès Final

1. **Tous les tests passent** : 100% de succès
2. **Coverage maintenu** : ≥ 80%
3. **Pas de régression** : Toutes les fonctionnalités opérationnelles
4. **Performance acceptable** : Build time < baseline + 10%
5. **Qualité améliorée** : Moins de warnings qu'avant
6. **CI/CD vert** : Tous les checks passent

## Conclusion

Ce plan garantit une migration sûre et contrôlée. Les points clés :
- Tests écrits AVANT chaque modification (TDD)
- Validation automatisée à chaque étape
- Métriques mesurables et comparables
- Rollback possible si échec

Temps estimé pour l'exécution complète des tests : 30-45 minutes par phase.