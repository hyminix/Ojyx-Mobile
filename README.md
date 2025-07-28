# Ojyx Mobile

Un jeu de cartes stratégique multijoueur développé avec Flutter.

## 🎯 À propos

Ojyx est un jeu de cartes où l'objectif est d'obtenir le score le plus bas. Chaque joueur gère une grille de 12 cartes (3x4) face cachée qu'il révèle progressivement au cours de la partie.

## 🚀 Installation

### Prérequis
- Flutter 3.x
- Dart 3.x
- Android Studio ou VS Code

### Configuration initiale

```bash
# Cloner le repository
git clone https://github.com/hyminix/Ojyx-Mobile.git
cd Ojyx-Mobile

# Installer les dépendances
flutter pub get

# Installer les git hooks (optionnel)
./scripts/install-hooks.sh

# Générer le code
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🚀 Philosophie de Développement Feature-First

Ce projet suit une approche Feature-First pour maximiser la livraison de valeur :

### Principes
- **Livraison rapide** : Focus sur les fonctionnalités utilisateur
- **Code simple** : Éviter la sur-ingénierie
- **Tests pragmatiques** : Tests de régression après stabilisation
- **Itération continue** : Améliorer progressivement

### Workflow
1. Implémenter la fonctionnalité
2. Tester manuellement
3. Ajouter des tests de régression si nécessaire
4. Refactoriser si besoin

## 📁 Architecture

Le projet suit la Clean Architecture :

```
lib/
├── features/          # Fonctionnalités par domaine
│   ├── game/         # Logique de jeu
│   ├── auth/         # Authentification
│   └── multiplayer/  # Fonctionnalités multijoueur
├── core/             # Code partagé
└── main.dart         # Point d'entrée
```

## 🧪 Tests de Régression

Dans l'esprit Feature-First, les tests sont écrits après l'implémentation pour verrouiller les comportements critiques.

```bash
# Lancer les tests
flutter test

# Note : Un simple smoke test vérifie que l'app démarre
```

## 🔍 Monitoring & Debugging

### Sentry Integration
L'application intègre Sentry pour le tracking des erreurs en production :
- Capture automatique des erreurs Flutter, Dart et Platform
- Monitoring des performances et transactions
- Breadcrumbs personnalisés pour tracer le contexte
- Dashboard : https://ojyx.sentry.io

### Supabase Monitoring
Requêtes SQL de monitoring disponibles dans `.taskmaster/docs/supabase-monitoring-queries.sql` :
- Détection des violations RLS
- Analyse des performances
- Métriques des parties actives
- Détection des requêtes N+1

### Services de Monitoring
- `SentryMonitoringService` : Service centralisé pour enrichir le contexte Sentry
- Monitoring views dans Supabase : `v_rls_violations_monitor`, `v_active_games_stats`, etc.

## 📖 Documentation

- [CLAUDE.md](./CLAUDE.md) - Règles et contraintes techniques
- [GITHUB_BRANCH_PROTECTION.md](./GITHUB_BRANCH_PROTECTION.md) - Configuration des protections
- [PROJECT_RULES.md](./PROJECT_RULES.md) - Règles du projet
- [.githooks/README.md](./.githooks/README.md) - Documentation des git hooks
- [.taskmaster/docs/sentry-supabase-fixes.md](./.taskmaster/docs/sentry-supabase-fixes.md) - Post-mortem des erreurs corrigées

## 🤝 Contribution

1. Créer une branche : `git checkout -b feat/ma-fonctionnalite`
2. Écrire les tests AVANT le code
3. Commit : `git commit -m "feat: description"`
4. Push : `git push origin feat/ma-fonctionnalite`
5. Créer une Pull Request

## 📄 License

Ce projet est privé et propriétaire.