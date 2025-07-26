# Guide de Build Ojyx - Windows & WSL2

## Solution de Cohabitation Windows/WSL2

Ce projet peut être compilé depuis Windows (Android Studio) et WSL2 sans modifications manuelles constantes.

### 🚀 Démarrage Rapide

#### Sur Windows (Android Studio)
1. **Double-cliquez** sur `scripts\windows_build.bat`
2. **OU** dans Android Studio, cliquez sur le bouton Play ▶️

#### Sur WSL2
```bash
./scripts/flutter_cross_platform.sh build
```

### 📁 Structure des Scripts

- **`scripts/windows_build.bat`** - Script Windows qui configure automatiquement l'environnement Windows
- **`scripts/flutter_cross_platform.sh`** - Script Linux/WSL2 intelligent qui gère les deux environnements
- **`scripts/setup_flutter_env.sh`** - Script basique de configuration d'environnement

### 🔧 Configuration Détaillée

#### Première Utilisation

**Sur Windows:**
1. Modifiez `scripts/windows_build.bat` si votre Flutter n'est pas dans `D:\dev\flutter\flutter`
2. Lancez le script - il configurera tout automatiquement

**Sur WSL2:**
```bash
./scripts/flutter_cross_platform.sh setup
```

#### Changement d'Environnement

Le script `flutter_cross_platform.sh` sauvegarde automatiquement votre configuration:

```bash
# Passer à Windows
./scripts/flutter_cross_platform.sh switch windows

# Passer à WSL2
./scripts/flutter_cross_platform.sh switch wsl2

# Vérifier l'état actuel
./scripts/flutter_cross_platform.sh status
```

### 🎯 Workflow Recommandé

1. **Développement principal** : Utilisez votre environnement préféré
2. **Tests cross-platform** : Les scripts gèrent automatiquement les changements
3. **CI/CD** : GitHub Actions utilise une configuration Linux similaire à WSL2

### 🛠️ Commandes Utiles

```bash
# WSL2 - Build debug
./scripts/flutter_cross_platform.sh build debug

# WSL2 - Build release
./scripts/flutter_cross_platform.sh build release

# WSL2 - Nettoyer le projet
./scripts/flutter_cross_platform.sh clean

# WSL2 - Voir l'état
./scripts/flutter_cross_platform.sh status
```

### ⚠️ Points d'Attention

1. **Ne committez jamais** `android/local.properties` (déjà dans .gitignore)
2. **Les paths sont différents** entre Windows et WSL2 - c'est normal
3. **En cas de problème**, utilisez la commande `clean` puis rebuild

### 🐛 Résolution de Problèmes

#### "Package does not exist" sur Windows
```batch
scripts\windows_build.bat
```

#### Erreurs de mémoire sur WSL2
Le script configure automatiquement des paramètres mémoire réduits pour WSL2.

#### Build échoue après changement d'environnement
```bash
./scripts/flutter_cross_platform.sh clean
./scripts/flutter_cross_platform.sh setup
./scripts/flutter_cross_platform.sh build
```

### 📝 Notes Techniques

- Les fichiers `.flutter-plugins` et `local.properties` sont générés automatiquement
- Chaque environnement maintient sa propre configuration
- Les états sont sauvegardés dans `.flutter_env_states/` (ignoré par git)
- Android Studio détecte automatiquement les changements

### 🎉 C'est tout!

Vous pouvez maintenant développer sur Windows avec Android Studio ET compiler depuis WSL2 sans avoir à modifier des fichiers manuellement à chaque fois!