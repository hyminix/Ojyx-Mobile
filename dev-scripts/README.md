# Scripts de Développement Ojyx

## Vue d'ensemble

Ce dossier contient des scripts d'automatisation pour simplifier le développement Ojyx. Tous les scripts sont conçus pour être exécutés depuis n'importe quel endroit et navigueront automatiquement vers le projet.

## Scripts Disponibles

### 🚀 `quick-run.sh`
Lance l'application avec les variables d'environnement.

```bash
./dev-scripts/quick-run.sh
```

**Fonctionnalités** :
- Charge automatiquement `.env`
- Vérifie la présence d'un device/émulateur
- Lance l'émulateur si nécessaire
- Passe les variables via `--dart-define`

### 🧹 `clean-build.sh`
Nettoie et reconstruit complètement le projet.

```bash
./dev-scripts/clean-build.sh
```

**Actions** :
1. Flutter clean
2. Suppression des caches
3. Flutter pub get
4. Build runner

### 🔧 `generate.sh`
Génère le code (Freezed, Riverpod, JSON).

```bash
./dev-scripts/generate.sh
```

**Génère** :
- `*.g.dart` - Sérialisation JSON
- `*.freezed.dart` - Modèles Freezed
- `*.g.dart` - Providers Riverpod

### 🎮 `setup-dev.sh`
Configuration initiale pour nouveaux développeurs.

```bash
./dev-scripts/setup-dev.sh
```

**Setup complet** :
1. Vérifie Flutter
2. Crée `.env` depuis template
3. Installe dépendances
4. Génère code
5. Configure Git
6. Ajoute aliases shell

## Configuration Environnement

### Fichier `.env`

Créez `.env` à la racine du projet :

```env
# Supabase (Obligatoire)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key

# Sentry (Optionnel)
SENTRY_DSN=https://your-sentry-dsn
SENTRY_ENABLED=true

# Debug
DEBUG_MODE=true
```

### Aliases Shell

Après `setup-dev.sh`, utilisez :

```bash
ojyx-run    # Lance l'app
ojyx-clean  # Clean build
ojyx-gen    # Génère code
ojyx-emu    # Lance émulateur
```

## Workflow Recommandé

### Premier Setup

```bash
# 1. Clone le projet
git clone <repo-url>
cd ojyx

# 2. Setup environnement
./dev-scripts/setup-dev.sh

# 3. Configure .env
nano .env  # Ajouter vos clés Supabase

# 4. Lance l'app
./dev-scripts/quick-run.sh
```

### Développement Quotidien

```bash
# Matin : Clean start
ojyx-clean

# Développement
ojyx-run

# Après modifications de modèles
ojyx-gen

# Hot reload automatique avec Ctrl+S
```

### Avant un Commit

```bash
# 1. Génère le code
ojyx-gen

# 2. Formate
dart format .

# 3. Analyse
flutter analyze
```

## Integration VS Code

Les scripts fonctionnent parfaitement avec VS Code :

1. **F5** utilise automatiquement les configs
2. **Tasks** disponibles via `Ctrl+Shift+B`
3. **Terminal intégré** reconnaît les aliases

## Troubleshooting

### "Permission denied"
```bash
chmod +x dev-scripts/*.sh
```

### ".env not found"
```bash
cp .env.example .env
# Éditer avec vos clés
```

### "Command not found: flutter"
```bash
# Ajouter Flutter au PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### Build runner échoue
```bash
# Clean complet
flutter clean
rm -rf .dart_tool
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Variables d'Environnement

### Obligatoires
- `SUPABASE_URL` : URL du projet Supabase
- `SUPABASE_ANON_KEY` : Clé anonyme Supabase

### Optionnelles
- `SENTRY_DSN` : Pour le tracking d'erreurs
- `DEBUG_MODE` : Active les logs debug
- `MOCK_MODE` : Utilise des données mock

## Performance Tips

### Émulateur Rapide
```bash
# Première fois
./scripts/emulator/create-emulator.sh
./scripts/emulator/start-emulator.sh

# Sauvegarder état
./scripts/emulator/save-snapshot.sh ojyx_ready

# Démarrages suivants (5-10s)
ojyx-emu
```

### Build Incrémental
```bash
# Au lieu de clean-build, utilisez :
ojyx-gen  # Seulement la génération
```

### Hot Reload
- Configuré automatiquement
- `Ctrl+S` pour reload instantané
- < 1 seconde en général

## Scripts Avancés

### Reset Base de Données (TODO)
```bash
# Pour tests avec données fraîches
./dev-scripts/reset-db.sh
```

### Build Release
```bash
# APK release signé
./dev-scripts/build-release.sh
```

## Contribution

Pour ajouter un script :

1. Créer dans `dev-scripts/`
2. Ajouter shebang `#!/bin/bash`
3. Utiliser les couleurs standards
4. Naviguer vers root : `cd "$(dirname "$0")/.."`
5. Documenter dans ce README

## Support

- Issues GitHub : Pour bugs
- Discord : Pour questions
- Documentation : `/docs`