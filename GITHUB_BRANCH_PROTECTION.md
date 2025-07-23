# Configuration de la Protection des Branches GitHub pour Développeur IA

## 🤖 Configuration Spécifique pour Développement par IA

Ce projet est développé exclusivement par une IA (Claude Code). Les règles ci-dessous sont configurées pour imposer automatiquement le respect strict du TDD et des bonnes pratiques, sans intervention humaine.

## Protection de la Branche `main` - RÈGLES IMMUABLES

### 1. Accéder aux Paramètres
1. Aller sur le repository GitHub
2. Cliquer sur **Settings** (Paramètres)
3. Dans le menu latéral, cliquer sur **Branches**

### 2. Ajouter une Règle de Protection
1. Cliquer sur **Add rule** (Ajouter une règle)
2. Dans **Branch name pattern**, entrer : `main`

### 3. Configurer les Protections OBLIGATOIRES

#### ✅ Checks Requis (TOUS OBLIGATOIRES)
- **Require status checks to pass before merging**
  - **Require branches to be up to date before merging**
  - Sélectionner TOUS les checks suivants :
    - `Test and Analyze`
    - `Build APK`
    - `TDD Compliance Check` (nouveau)
    - `Test Order Verification` (nouveau)
    - `Coverage Minimum 80%` (nouveau)
    - `No Commented Tests` (nouveau)
    - `No Test Summary Files` (nouveau)

#### 🚫 Pull Request Reviews (ADAPTÉ POUR IA)
- **Require a pull request before merging**
  - ❌ **Require approvals** : 0 (pas de review manuelle)
  - ✅ **Dismiss stale pull request approvals when new commits are pushed**
  - ✅ **Require linear history** (empêche les merge commits complexes)

#### 🔒 Restrictions Supplémentaires (CRITIQUES)
- ✅ **Require conversation resolution before merging**
- ✅ **Require signed commits** (l'IA doit signer ses commits)
- ✅ **Include administrators** (AUCUNE exception)
- ✅ **Restrict who can push to matching branches**
  - Ajouter uniquement le token/compte utilisé par l'IA

#### ⚠️ Règles Anti-Contournement
- ✅ **Do not allow bypassing the above settings**
- ✅ **Restrict force pushes** (empêche la réécriture de l'historique)
- ✅ **Restrict deletions** (empêche la suppression de branches)

### 4. Sauvegarder
Cliquer sur **Create** ou **Save changes**

## 🚨 VIOLATIONS AUTOMATIQUEMENT DÉTECTÉES

### Tests Commentés
```bash
# Patterns interdits qui bloquent la PR :
// test(
/* test
skip: true
.skip(
xit(
xtest(
pending(
```

### Fichiers Interdits
```bash
# Noms de fichiers qui bloquent la PR :
*test_summary*
*tests_summary*
*TEST_SUMMARY*
```

### Ordre Test/Code
Le système vérifie automatiquement que :
1. Pour chaque fichier `.dart` créé, un fichier `_test.dart` existe
2. Le fichier de test a été créé AVANT ou EN MÊME TEMPS que le fichier de code
3. Le fichier de test contient au moins un `test()` ou `testWidgets()`

## 📊 Métriques Obligatoires

### Coverage Minimum
- **80%** de couverture de code MINIMUM
- Calculé automatiquement par `lcov`
- Aucune exception permise

### Tests Passants
- **100%** des tests doivent passer
- Aucun test en échec toléré
- Aucun test "flaky" accepté

## 🤖 Workflow pour l'IA

### Création de PR
```bash
# L'IA DOIT TOUJOURS :
1. git checkout -b feat/nouvelle-fonctionnalite
2. Écrire les tests AVANT le code
3. Vérifier localement : flutter test
4. git add . && git commit -m "feat: description"
5. git push origin feat/nouvelle-fonctionnalite
6. Créer la PR via gh CLI
```

### Avant de Merger
L'IA doit vérifier que :
- [ ] Tous les checks GitHub Actions sont verts
- [ ] Aucune violation TDD n'est détectée
- [ ] La couverture est ≥ 80%
- [ ] Tous les tests passent

## 🚫 CONSÉQUENCES DES VIOLATIONS

### PR Automatiquement Fermée Si :
1. Tests commentés détectés
2. Fichiers test_summary présents
3. Code créé avant les tests
4. Coverage < 80%
5. Tests qui échouent

### Message Automatique
```
❌ PR fermée automatiquement : Violation des règles TDD détectée.

Violations trouvées :
- [Liste des violations]

Action requise :
1. Créer une nouvelle branche
2. Corriger TOUTES les violations
3. Soumettre une nouvelle PR

Rappel : Le TDD n'est pas négociable.
```

## 🛠️ Scripts de Vérification

### Pre-commit Hook (local)
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Vérifier les tests commentés
if grep -r "//.*test\|/\*.*test\|skip:\s*true" --include="*.dart" .; then
    echo "❌ Tests commentés détectés. Commit refusé."
    exit 1
fi

# Vérifier que tous les tests passent
if ! flutter test; then
    echo "❌ Des tests échouent. Commit refusé."
    exit 1
fi
```

### GitHub Action de Vérification
Voir `.github/workflows/tdd-enforcement.yml` pour l'implémentation complète.

## 📝 Notes pour l'IA Claude Code

**RAPPEL CRITIQUE** : Ces règles sont IMMUABLES et NON-NÉGOCIABLES. Toute tentative de contournement sera détectée et bloquée automatiquement. Le respect du TDD est la FONDATION de ce projet.

L'IA doit :
1. TOUJOURS écrire les tests en premier
2. JAMAIS commenter ou désactiver des tests
3. JAMAIS créer de fichiers "résumé" de tests
4. TOUJOURS s'assurer que 100% des tests passent
5. MAINTENIR une couverture ≥ 80%

## 🔄 Mise à Jour des Règles

Pour modifier ces règles :
1. Une discussion doit être ouverte dans les Issues
2. Les changements doivent être justifiés techniquement
3. Les nouvelles règles doivent être plus strictes, jamais plus laxistes