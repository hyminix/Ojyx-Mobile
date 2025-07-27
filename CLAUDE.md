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

## Philosophie de Développement Feature-First

### Principes Fondamentaux
- **Livraison rapide de valeur** : Chaque feature doit apporter de la valeur utilisateur rapidement
- **Itération continue** : Implémenter, tester manuellement, améliorer
- **Simplicité avant tout** : Code simple et fonctionnel > code parfait mais complexe
- **Tests pragmatiques** : Écrits après stabilisation, focus sur les parties critiques

### Workflow de Développement
1. **Implémenter** la fonctionnalité de manière directe
2. **Tester manuellement** le comportement utilisateur
3. **Itérer** rapidement selon les retours
4. **Stabiliser** le code une fois la feature validée
5. **Ajouter des tests** de régression sur les parties critiques

### Avantages de l'Approche
- ✅ Vélocité maximale
- ✅ Flexibilité face aux changements
- ✅ Feedback utilisateur rapide
- ✅ Moins de code inutile
- ✅ Focus sur la valeur business

## Stack Technique

### Versions Actuelles (Mises à jour 2025-07-27)
- **Flutter**: 3.32.6 (stable)
- **Dart**: 3.8.1 (stable)
- **Java**: 17 (requis pour Android 34)
- **Gradle**: 8.12 (dernière version LTS)

### Gestion d'État et DI
- **Riverpod** : Pour toute gestion d'état et injection de dépendances
  - flutter_riverpod: 2.6.1
  - riverpod_annotation: 2.6.1
  - riverpod_generator: 2.6.3
  - riverpod_lint: 2.6.1
  - Syntaxe moderne avec `@riverpod` et `Notifier` recommandée
- Convention de nommage :
  - Providers : `[entity]RepositoryProvider`, `[feature]StateNotifierProvider`
  - États : `[Feature]State` avec Freezed

### Modèles de Données
- **Freezed + json_serializable** : Pour les modèles et états
  - freezed: 3.1.0
  - freezed_annotation: 3.1.0
  - json_serializable: 6.9.5
  - json_annotation: 4.9.0
- Garantir l'immuabilité des structures de données
- Utiliser les unions types pour les états complexes

### Navigation
- **go_router** : Navigation déclarative (16.0.0)
- Configuration centralisée dans `/lib/core/config/router_config.dart`
- Pas de Navigator.push direct

### Backend et Services
- **Supabase** : 
  - Base de données PostgreSQL
  - Auth mode anonyme
  - Realtime via WebSockets pour le multijoueur
  - Storage pour les assets
  - supabase_flutter: 2.9.1
- **Sentry Flutter** : Tracking des erreurs en production (9.5.0)
- **MCP Integrations** : Supabase MCP, TaskMaster AI, IDE MCP

### Autres Dépendances
- **Utilities** :
  - flutter_dotenv: 5.2.1
  - path_provider: 2.1.5
  - shared_preferences: 2.5.3
  - connectivity_plus: 6.1.4
- **UI** :
  - cupertino_icons: 1.0.8
- **Linting** :
  - flutter_lints: 6.0.0
- **Build** :
  - build_runner: 2.5.4

## Processus de Développement

### Workflow Git Simple
1. **Branches feature** : `feat/[description]`, `fix/[description]`
2. **Commits directs** sur main autorisés pour les hotfixes
3. **Pull Requests** recommandées pour les features majeures
4. **Merge rapide** dès que fonctionnel

### CI/CD Allégé

Pipeline minimal dans `.github/workflows/ci.yml` :
- **build** : Vérification que l'app compile
- **release** : Génération APK/AAB sur tags

Pas de blocage strict, focus sur la livraison.

### Gestion des Secrets
- Utiliser GitHub Secrets pour CI/CD
- Fichier `.env` local (dans .gitignore)
- Utiliser `--dart-define` pour les builds
- JAMAIS de clés en dur dans le code

## Standards de Qualité Pragmatiques

### Linting
- `flutter_lints` activé mais warnings non bloquants
- Correction progressive des issues

### Génération de Code
- `build_runner` pour Freezed, json_serializable
- Commande : `flutter pub run build_runner build --delete-conflicting-outputs`

### Documentation
- Commenter uniquement les logiques complexes
- README à jour pour l'onboarding
- Ce fichier CLAUDE.md comme référence

### Tests (Post-Implementation)
- Tests de régression sur les features stabilisées
- Focus sur les chemins critiques
- Tests d'intégration pour les flows principaux
- Pas de coverage minimum imposé

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

### Développement Quotidien
```bash
# Installation des dépendances
flutter pub get

# Génération de code
flutter pub run build_runner build --delete-conflicting-outputs

# Analyse du code (non bloquante)
flutter analyze

# Formatage
dart format .

# Lancement rapide
flutter run
```

### Build et Release
```bash
# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release

# Avec variables d'environnement
flutter run --dart-define=SUPABASE_URL=xxx --dart-define=SUPABASE_ANON_KEY=xxx
```

## Checklist Pré-Release (Non Bloquante)
- [ ] Features testées manuellement
- [ ] Pas de crashes évidents
- [ ] Build release fonctionnel
- [ ] Variables d'environnement configurées

## Versioning
- Versionnage Sémantique : MAJOR.MINOR.PATCH
- Incrémentation libre selon l'importance des changements

## Points d'Attention
- Mobile First : UI optimisée pour Android
- Performance : Éviter les rebuilds inutiles avec Riverpod
- Sécurité : Validation côté serveur pour les actions critiques
- UX : Feedback visuel immédiat

## Task Master AI Instructions
**Import Task Master's development workflow commands and guidelines, treat as if import is in the main CLAUDE.md file.**
@./.taskmaster/CLAUDE.md