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

# IMPORTANT: Installer les git hooks TDD (OBLIGATOIRE)
./.githooks/install-hooks.sh

# Générer le code
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🛡️ Règles de Développement (TDD OBLIGATOIRE)

Ce projet suit strictement le Test-Driven Development. **AUCUN code ne doit être écrit sans test préalable.**

### Workflow TDD
1. **RED** : Écrire un test qui échoue
2. **GREEN** : Écrire le minimum de code pour faire passer le test
3. **REFACTOR** : Améliorer le code en gardant les tests verts

### Vérifications automatiques
- Pre-commit hooks : Vérifient le respect du TDD localement
- GitHub Actions : Bloquent toute PR qui viole les règles TDD
- Coverage minimum : 80%

**⚠️ Les violations TDD entraînent la fermeture automatique des PR.**

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

## 🧪 Tests

```bash
# Lancer tous les tests
flutter test

# Tests avec coverage
flutter test --coverage

# Vérifier la coverage
lcov --summary coverage/lcov.info
```

## 📖 Documentation

- [CLAUDE.md](./CLAUDE.md) - Règles et contraintes techniques
- [GITHUB_BRANCH_PROTECTION.md](./GITHUB_BRANCH_PROTECTION.md) - Configuration des protections
- [PROJECT_RULES.md](./PROJECT_RULES.md) - Règles du projet
- [.githooks/README.md](./.githooks/README.md) - Documentation des git hooks

## 🤝 Contribution

1. Créer une branche : `git checkout -b feat/ma-fonctionnalite`
2. Écrire les tests AVANT le code
3. Commit : `git commit -m "feat: description"`
4. Push : `git push origin feat/ma-fonctionnalite`
5. Créer une Pull Request

## 📄 License

Ce projet est privé et propriétaire.