# Git Hooks pour Ojyx - Enforcement TDD

## 🛡️ Protection Automatique du TDD

Ce dossier contient les git hooks qui garantissent le respect strict des règles TDD du projet Ojyx.

## 📦 Installation

```bash
# Installation automatique (RECOMMANDÉ)
./githooks/install-hooks.sh

# OU installation manuelle
git config core.hooksPath .githooks
```

## 🔍 Hooks Disponibles

### pre-commit
Ce hook s'exécute avant chaque commit et vérifie :

1. **Absence de tests commentés**
   - Détecte : `//test(`, `/*test`, `skip:true`, etc.
   - Action : Bloque le commit si trouvé

2. **Absence de fichiers test_summary**
   - Détecte : tout fichier contenant "test_summary"
   - Action : Bloque le commit si trouvé

3. **Présence de tests pour chaque fichier**
   - Vérifie que chaque `.dart` a un `_test.dart`
   - Exclut : fichiers générés, main.dart
   - Action : Bloque le commit si tests manquants

4. **Contenu valide des tests**
   - Vérifie la présence de `test()` ou `testWidgets()`
   - Action : Bloque le commit si tests vides

5. **Tous les tests passent**
   - Exécute `flutter test`
   - Action : Bloque le commit si échec

6. **Coverage minimum 80%**
   - Calcule la couverture avec lcov
   - Action : Bloque le commit si < 80%

## ⚠️ Contournement (NON RECOMMANDÉ)

```bash
# Pour ignorer temporairement les hooks
git commit --no-verify -m "message"
```

**ATTENTION** : Même si vous contournez localement, la CI/CD GitHub détectera et bloquera votre PR.

## 🚨 En Cas de Problème

### Tests qui échouent
1. Corrigez le code jusqu'à ce que les tests passent
2. Ne commentez JAMAIS les tests
3. Si le test est incorrect, corrigez-le

### Coverage insuffisante
1. Ajoutez des tests pour les parties non couvertes
2. Utilisez `flutter test --coverage` pour vérifier
3. Visez 100% sur le nouveau code

### Fichiers sans tests
1. Créez le fichier de test IMMÉDIATEMENT
2. Ajoutez au moins un test qui vérifie le comportement
3. Suivez la convention : `lib/feature.dart` → `test/feature_test.dart`

## 📝 Rappel des Règles TDD

1. **RED** : Écrire un test qui échoue
2. **GREEN** : Écrire le minimum de code pour que le test passe
3. **REFACTOR** : Améliorer le code en gardant les tests verts

**Le TDD n'est pas négociable dans ce projet.**