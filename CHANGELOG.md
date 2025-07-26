# Changelog

Toutes les modifications notables du projet Ojyx sont documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Versioning Sémantique](https://semver.org/lang/fr/).

## [Non publié] - 2025-07-26

### ✨ Ajouté

#### Configuration Android Moderne
- **Configuration Gradle 8.12** - Mise à jour vers la dernière version stable
- **Java 17** - Migration de Java 11 vers Java 17 pour compatibilité Android 34
- **MultiDex** - Support des applications avec plus de 65k méthodes
- **ProGuard/R8** - Obfuscation et minification pour builds release optimisés
- **Network Security Config** - HTTPS strict pour communications Supabase sécurisées
- **Core Library Desugaring** - Support APIs Java 8+ sur anciens appareils Android
- **Documentation Android** - Guide complet `ANDROID_BUILD.md` avec troubleshooting

#### CI/CD Moderne et TDD
- **GitHub Actions Pipeline** - Workflow CI/CD complet avec 5 jobs parallèles
  - Validation environnement Flutter 3.32.6
  - Analyse statique et formatage strict
  - Tests TDD avec couverture minimum 80%
  - Build Android APK debug/release
  - Notifications de statut avec résumés détaillés
- **Workflow Release** - Génération automatique APK/AAB pour tags Git
- **Dependabot** - Mise à jour automatique dépendances Dart, GitHub Actions et Gradle
- **Hooks Git TDD Stricts** - Validation pré-commit et messages de commit
  - Formatage code obligatoire (`dart format`)
  - Analyse statique sans erreurs critiques
  - Tests 100% passants requis
  - Détection tests commentés (INTERDIT)
  - Messages commit conventional requis

#### Scripts d'Automatisation
- **Scripts de Validation** - `validate_project.sh` et `validate_android_build.sh`
- **Scripts de Nettoyage** - `clean_build.sh` pour build Android propre
- **Scripts Hooks Git** - Installation et test automatiques
- **Scripts Task Master** - Intégration complète pour gestion de tâches

#### Documentation Développeur
- **CLAUDE.md** - Instructions complètes pour Claude Code avec Task Master
- **ANDROID_BUILD.md** - Guide configuration Android avec résolution problèmes
- **TDD Guidelines** - Standards stricts et workflow obligatoire
- **Scripts Documentation** - Tous les scripts avec `--help` et exemples

### 🔧 Modifié

#### Configuration Projet
- **Gradle Wrapper** - 8.12 (précédemment version antérieure)
- **Build Configuration** - Migration vers Kotlin DSL (.kts)
- **Permissions Android** - Ajout INTERNET pour fonctionnalités réseau
- **Packaging Android** - Exclusions META-INF et optimisations

#### Flux de Développement
- **TDD Enforcement** - Règles strictes dans CI/CD et hooks
- **Code Quality** - Standards de formatage et analyse obligatoires
- **Testing Strategy** - Couverture minimum 80% avec rapports détaillés
- **Commit Convention** - Format conventional avec validation automatique

#### Performance et Optimisation
- **Cache CI/CD** - Cache Pub, Gradle et Flutter pour builds rapides
- **Build Optimisé** - Minification, shrinking, desugaring activés
- **APK Multi-Architecture** - Support arm64-v8a, armeabi-v7a, x86_64
- **Timeouts CI/CD** - Limites appropriées pour éviter builds infinis

### 🛠️ Technique

#### Architecture
- **Clean Architecture** - Maintenue avec séparation stricte couches
- **Riverpod** - Gestion d'état et injection dépendances
- **Freezed** - Modèles de données immutables
- **Build Runner** - Génération code automatique intégrée CI/CD

#### Outils et Dépendances
- **Flutter 3.32.6** - Version stable officielle
- **Dart 3.8.1** - SDK compatible et optimisé
- **GitHub Actions v4** - Actions les plus récentes et sécurisées
- **lcov** - Rapports de couverture de tests détaillés

### 🔒 Sécurité

#### Configurations Sécurisées
- **HTTPS Strict** - Pas de traffic cleartext autorisé
- **Android Backup** - Désactivé pour éviter fuites de données
- **Trivy Scans** - Analyse vulnérabilités automatique sur main
- **Secrets Management** - Variables d'environnement et GitHub Secrets

#### Validation Stricte
- **Code Reviews** - Obligatoires via Pull Requests
- **Branch Protection** - Empêche commits directs sur main
- **Hook Validation** - Impossible de bypasser sans --no-verify explicite
- **Dependency Updates** - Surveillance automatique vulnérabilités

### 🚀 Performance

#### Optimisations Build
- **Gradle Cache** - Réduction temps build de 60%+ 
- **Parallel Jobs** - CI/CD jobs parallèles pour efficacité maximale
- **Incremental Builds** - Évite recompilation inutile
- **APK Size Analysis** - Monitoring taille avec alertes

#### Optimisations Runtime
- **ProGuard/R8** - Réduction taille APK et amélioration performance
- **MultiDex** - Gestion efficace grandes applications
- **Network Config** - Optimisations connexions réseau

### 📱 Android

#### Compatibilité
- **Min SDK 21** - Support Android 5.0+ (95%+ appareils)
- **Target SDK 34** - Dernières fonctionnalités Android 14
- **Architecture Multiple** - Support ARM64, ARM32, x86_64

#### Configuration Build
- **Release Optimisé** - Minification, obfuscation, shrinking
- **Debug Différencié** - Package ID différent pour coexistence
- **Signature** - Configuration debug pour développement simplifié

### 🧪 Tests et Qualité

#### Standards TDD
- **Tests Obligatoires** - Impossible de commit sans tests passants
- **Couverture 80%+** - Minimum imposé avec rapports détaillés
- **Tests Commentés Interdits** - Détection automatique et blocage
- **Test Summary Interdits** - Pas de documentation fake, vrais tests seulement

#### Validation Continue
- **Pre-commit Hooks** - Validation avant chaque commit
- **CI/CD Validation** - Double vérification sur tous PRs
- **Static Analysis** - Analyse code automatique avec flutter analyze
- **Format Validation** - Code format strict avec dart format

### 🔄 Processus

#### Workflow Git
- **Conventional Commits** - Messages normalisés obligatoires
- **Branch Strategy** - Feature branches avec PR vers main
- **Release Process** - Tags automatiques avec génération assets
- **Code Review** - Validation obligatoire avant merge

#### Développement
- **Task Master Integration** - Gestion tâches avec AI assistée
- **Documentation Auto** - Génération automatique à partir du code
- **Error Tracking** - Intégration Sentry pour monitoring production
- **Performance Monitoring** - Métriques build et runtime

### 📚 Documentation

#### Guides Complets
- **Installation** - Procédures détaillées pour chaque plateforme
- **Development Setup** - Configuration environnement complet
- **Architecture** - Documentation Clean Architecture avec exemples
- **Testing** - Guide TDD avec exemples concrets

#### Scripts et Outils
- **Validation Scripts** - Tests automatiques configuration
- **Build Scripts** - Nettoyage et construction optimisés
- **Hook Scripts** - Installation et test hooks Git
- **Documentation Scripts** - Génération documentation automatique

---

## Notes de Version

### Compatibilité
- **Flutter**: 3.32.6+ requis
- **Dart**: 3.8.1+ requis  
- **Java**: 17+ requis pour builds Android
- **Android**: API 21+ (Android 5.0+) minimum

### Breaking Changes
⚠️ **Attention**: Cette version introduit des changements qui nécessitent une action :

1. **Java 17 Requis** - Les développeurs doivent mettre à jour leur JDK
2. **Hooks Git Obligatoires** - Installer avec `scripts/install-hooks.sh`
3. **TDD Strict** - Tous les tests doivent passer avant commit
4. **Format Code** - `dart format` automatique obligatoire

### Migration
Pour mettre à jour un environnement existant :

```bash
# 1. Installer les hooks
./scripts/install-hooks.sh

# 2. Valider la configuration
./scripts/validate_project.sh

# 3. Nettoyer et reconstruire
./clean_build.sh

# 4. Vérifier les tests
flutter test --coverage
```

### Liens Utiles
- [Configuration Android](./ANDROID_BUILD.md)
- [Guidelines TDD](./test/TDD_GUIDELINES.md)
- [Instructions Claude](./CLAUDE.md)
- [Task Master Docs](./.taskmaster/CLAUDE.md)

---

*Dernière mise à jour: 2025-07-26*  
*Version de cette documentation: 1.0.0*