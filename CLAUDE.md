# Mémoire du Projet Ojyx - Règles et Contraintes Techniques

## Vue d'Ensemble du Projet

**Ojyx** est un jeu de cartes stratégique multijoueur (2-8 joueurs) où l'objectif est d'obtenir le score le plus bas. Chaque joueur gère une grille de 12 cartes (3x4) face cachée qu'il révèle progressivement. Le jeu intègre un système innovant de cartes actions permettant des interactions complexes entre joueurs.

## Architecture Obligatoire : Clean Architecture

### Structure de Dossiers
```
lib/
├── features/
│   ├── [nom_feature]/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── use_cases/
│   │   └── data/
│   │       ├── models/
│   │       ├── repositories/
│   │       └── datasources/
├── core/
│   ├── errors/
│   ├── usecases/
│   ├── utils/
│   └── config/
└── main.dart
```

### Séparation des Responsabilités
- **Presentation** : UI, widgets, providers Riverpod
- **Domain** : Logique métier pure, entités, interfaces
- **Data** : Implémentation concrète, API, modèles sérialisables

## Stack Technique Obligatoire

### Versions Actuelles (Mises à jour 2025-07-26)
- **Flutter**: 3.32.6 (stable)
- **Dart**: 3.8.1 (stable)
- **Java**: 17 (requis pour Android 34)
- **Gradle**: 8.12 (dernière version LTS)

### Gestion d'État et DI
- **Riverpod** : OBLIGATOIRE pour toute gestion d'état et injection de dépendances
  - Version : 2.6.1 (dernière mise à jour)
  - Syntaxe moderne avec `@riverpod` et `Notifier` obligatoire
- Convention de nommage stricte :
  - Providers : `[entity]RepositoryProvider`, `[feature]StateNotifierProvider`
  - États : `[Feature]State` avec Freezed

### Modèles de Données
- **Freezed + json_serializable** : OBLIGATOIRE pour TOUS les modèles et états
  - freezed: 2.5.7
  - json_serializable: 6.8.0
- Garantir l'immuabilité de toutes les structures de données
- Utiliser les unions types pour les états complexes

### Navigation
- **go_router** : Toute navigation doit être déclarative
- Configuration centralisée dans `/lib/core/config/router_config.dart`
- Pas de Navigator.push direct

### Backend et Services
- **Supabase** : 
  - Base de données PostgreSQL
  - Auth mode anonyme
  - Realtime via WebSockets pour le multijoueur
  - Storage pour les assets
- **Sentry Flutter** : Tracking des erreurs en production
- **MCP Integrations** : Utilisation obligatoire de Supabase MCP, Context7, et Sentry MCP

## Processus de Développement (NON-NÉGOCIABLE)

### Workflow Git
1. **Protection de main** : Aucun commit direct sur main
2. **Branches dédiées** : 
   - Format : `feat/[description]`, `fix/[description]`, `chore/[description]`
   - Pas de branche develop - PR directement vers main
3. **Pull Requests obligatoires** : Tout code passe par PR
4. **Conditions de merge** :
   - CI/CD au vert (tous les checks passent)
   - Revue de code effectuée
   - Pas de conflits

### CI/CD GitHub Actions (Configuration Moderne 2025)

Le pipeline CI/CD est configuré dans `.github/workflows/ci.yml` avec 5 jobs parallèles :

1. **validate** : Validation de l'environnement Flutter 3.32.6
2. **analyze** : `flutter analyze --no-fatal-infos` - Analyse statique stricte
3. **test** : `flutter test --coverage` avec rapports de couverture
4. **format** : `dart format --set-exit-if-changed .` - Formatage obligatoire
5. **build** : Build Android APK debug/release avec cache optimisé

**Workflows additionnels :**
- **Release** (`.github/workflows/release.yml`) : Génération APK/AAB automatique sur tags
- **Dependabot** (`.github/dependabot.yml`) : Mises à jour automatiques Dart, Actions, Gradle

**Cache optimisé pour performance :**
- Cache Pub dependencies avec clé basée sur pubspec.lock
- Cache Gradle avec distribution et wrapper
- Timeouts configurés (10-20 minutes selon job)

### Approche Test-First (OBLIGATOIRE ET NON-NÉGOCIABLE)

⚠️ **RÈGLE ABSOLUE** : AUCUN code de production ne doit être écrit sans test préalable. Cette règle s'applique à TOUS les niveaux :

1. **Écrire les tests AVANT le code** - TOUJOURS
   - Si tu oublies, STOP et reviens en arrière
   - Crée d'abord le fichier de test avec des cas qui échouent
   - Définis le comportement attendu via les tests

2. **Tests unitaires obligatoires pour :**
   - Toute logique métier (domain/entities, use_cases)
   - Tous les repositories (avec mocks)
   - Tous les providers Riverpod
   - Toutes les méthodes de conversion/transformation

3. **Tests d'intégration obligatoires pour :**
   - Datasources (avec mocks Supabase)
   - Navigation et routing
   - Synchronisation temps réel

4. **Tests de widgets obligatoires pour :**
   - Tous les écrans (screens)
   - Widgets interactifs (boutons, formulaires)
   - Widgets avec logique d'état

5. **Workflow strict :**
   - RED : Écrire le test qui échoue
   - GREEN : Implémenter le minimum pour que le test passe
   - REFACTOR : Améliorer le code en gardant les tests verts

6. **Coverage minimum : 80%**
   - Vérifier avec `flutter test --coverage`
   - Utiliser `lcov` pour visualiser la couverture

### 🚫 INTERDICTIONS ABSOLUES EN TDD (ZÉRO TOLÉRANCE)

**JAMAIS, SOUS AUCUN PRÉTEXTE :**

1. **NE JAMAIS COMMENTER DE TESTS**
   - Un test qui ne passe pas = le code doit être corrigé
   - Si un test pose problème, il faut le RÉPARER, pas le désactiver
   - Commenter un test = ÉCHEC TOTAL du TDD

2. **NE JAMAIS CRÉER DE FICHIERS "TEST_SUMMARY"**
   - Les tests doivent tester du code réel, pas documenter
   - Pas de fichiers qui "résument" les tests créés
   - Chaque test doit avoir une vraie valeur de vérification

3. **NE JAMAIS IGNORER UN TEST QUI ÉCHOUE**
   - Si un test échoue après implémentation, STOP
   - Corriger l'implémentation ou le test immédiatement
   - Ne JAMAIS passer à la suite avec des tests qui échouent

4. **TOUS LES TESTS DOIVENT PASSER AVANT DE CONTINUER**
   - 100% des tests créés doivent être verts
   - Pas d'exception, pas de "on corrigera plus tard"
   - Si ça prend du temps, ça prend du temps

5. **EN CAS DE PROBLÈME TECHNIQUE**
   - Si un test ne peut pas passer (bug framework), trouver une ALTERNATIVE
   - Réécrire le test différemment
   - Changer l'approche d'implémentation
   - MAIS NE JAMAIS ABANDONNER LE TEST

**⚠️ RAPPEL** : Le TDD n'est pas négociable. C'est la FONDATION du projet. Toute déviation compromet la qualité et la maintenabilité du code.

### 🚨 CONSÉQUENCES DES VIOLATIONS TDD (AUTOMATIQUES)

**Toute violation des règles TDD entraîne des conséquences IMMÉDIATES et AUTOMATIQUES :**

#### 1. Hooks Git Automatiques (scripts/)

**Pre-commit Hook** (`scripts/pre-commit-hook.sh`):
- Détection tests commentés : `grep -r "//.*test\|/\*.*test\|skip.*true"`
- Formatage obligatoire : `dart format --set-exit-if-changed`
- Analyse statique : `flutter analyze --no-fatal-infos`
- Tests passants : `flutter test --coverage --reporter=compact`
- Couverture calculée avec lcov (recommandé 80%+)
- Interdiction fichiers `*test_summary*`

**Commit-msg Hook** (`scripts/commit-msg-hook.sh`):
- Format conventional : `type(scope?): description`
- Types valides : feat|fix|docs|style|refactor|test|chore|perf|ci|build
- Max 50 caractères, minuscule, sans point final

**Installation** (`scripts/install-hooks.sh`):
- Hooks installés dans `.git/hooks/` automatiquement
- Validation permissions et intégrité
- Tests complets avec `scripts/test-hooks.sh`

#### 2. Pipeline CI/CD Strict
- Double validation de TOUS les checks pre-commit
- Jobs parallèles avec cache optimisé
- Labels automatiques sur violations
- Blocage merge si un job échoue

#### 3. Aucune Exception Possible
- Contournement avec `--no-verify` découragé
- Protection main empêche force push
- Logs détaillés pour debugging

**RAPPEL POUR L'IA** : Ces mécanismes sont en place pour VOUS aider à maintenir la qualité. Les violations ne sont pas des "erreurs" mais des garde-fous pour garantir le succès du projet.

### Gestion des Secrets
- Utiliser GitHub Secrets pour CI/CD
- Fichier `.env` local (dans .gitignore)
- Utiliser `--dart-define` pour les builds
- JAMAIS de clés en dur dans le code

## Standards de Qualité

### Linting
- `flutter_lints` avec règles strictes activées
- Pas de warnings autorisés

### Génération de Code
- `build_runner` pour Freezed, json_serializable
- Commande : `flutter pub run build_runner build --delete-conflicting-outputs`

### Documentation
- Commenter les logiques complexes
- Documenter les APIs publiques
- Maintenir ce fichier CLAUDE.md à jour

## Règles Métier Spécifiques

### Gestion des Cartes Actions
- **Stock maximum** : 3 cartes par joueur
- **Cartes obligatoires** : S'activent immédiatement sans entrer dans le stock (ex: "Demi-tour")
- **Cartes optionnelles** : Peuvent être stockées ou jouées immédiatement
- **Défausse forcée** : Si stock plein lors de l'ajout d'une carte optionnelle

### Gestion des Déconnexions
- **Timeout** : 2 minutes pour se reconnecter
- **Après timeout** : Joueur considéré comme ayant abandonné, score figé
- **Synchronisation** : Via Supabase Realtime uniquement (pas de cache local pour MVP)

### Validation des Colonnes
- 3 cartes identiques révélées dans une colonne = colonne défaussée (0 points)
- Vérification automatique à chaque révélation

### Fin de Manche
- Déclenchée quand un joueur révèle sa 12ème carte
- Dernier tour pour tous les autres joueurs
- Pénalité double si l'initiateur n'a pas le score le plus bas

## Commandes Essentielles

### Configuration Initiale
```bash
# Installation des hooks Git (OBLIGATOIRE après clone)
./scripts/install-hooks.sh

# Validation complète du projet
./scripts/validate_project.sh

# Test des hooks installés
./scripts/test-hooks.sh
```

### Développement Quotidien
```bash
# Installation des dépendances
flutter pub get

# Génération de code (hooks l'exécutent aussi)
flutter pub run build_runner build --delete-conflicting-outputs

# Tests avec couverture
flutter test --coverage

# Analyse du code
flutter analyze --no-fatal-infos

# Formatage (obligatoire avant commit)
dart format .

# Nettoyage complet Android
./scripts/clean_build.sh
```

### Build et Lancement
```bash
# Lancement avec variables d'environnement
flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx

# Build APK release
flutter build apk --release

# Validation build Android
./scripts/validate_android_build.sh
```

## Checklist Pré-Commit
- [ ] Tests écrits et passants
- [ ] Code formaté (`dart format .`)
- [ ] Pas de warnings (`flutter analyze`)
- [ ] Génération de code à jour
- [ ] Documentation des nouvelles fonctionnalités

## Versioning
- Suivre le Versionnage Sémantique : MAJOR.MINOR.PATCH
- MAJOR : Changements incompatibles
- MINOR : Nouvelles fonctionnalités rétrocompatibles
- PATCH : Corrections de bugs

## Points d'Attention
- Mobile First : Toutes les UI doivent être optimisées pour Android
- Performance : Attention aux rebuilds inutiles avec Riverpod
- Sécurité : Validation côté serveur pour toutes les actions de jeu
- UX : Feedback visuel immédiat pour toutes les actions

## Task Master AI Instructions
**Import Task Master's development workflow commands and guidelines, treat as if import is in the main CLAUDE.md file.**
@./.taskmaster/CLAUDE.md
