# Configuration de Build Android - Ojyx

## Vue d'ensemble

Ce document décrit la configuration de build Android pour le projet Ojyx, optimisée pour un jeu de cartes multijoueur utilisant Flutter, Supabase et suivant l'architecture Clean Architecture.

## Configuration actuelle

### Versions des outils et SDK

- **Gradle**: 8.12 (gradle-wrapper.properties)
- **Android Gradle Plugin**: Utilise le plugin Flutter moderne
- **Java/Kotlin**: Version 17 (Recommandé pour Android 34)
- **Compile SDK**: Utilise `flutter.compileSdkVersion` (typiquement 34)
- **Target SDK**: Utilise `flutter.targetSdkVersion` (typiquement 34) 
- **Min SDK**: Utilise `flutter.minSdkVersion` (typiquement 21)

### Fonctionnalités activées

✅ **MultiDex**: Activé pour gérer les applications avec plus de 65k méthodes  
✅ **AndroidX**: Migration complète vers AndroidX  
✅ **ProGuard/R8**: Obfuscation et minification pour les builds release  
✅ **Core Library Desugaring**: Support des APIs Java 8+ sur anciens appareils  
✅ **Network Security Config**: Configuration HTTPS stricte pour Supabase  

## Structure des fichiers de configuration

```
android/
├── app/
│   ├── build.gradle.kts          # Configuration principale de l'app
│   ├── proguard-rules.pro        # Règles d'obfuscation ProGuard
│   └── src/main/
│       ├── AndroidManifest.xml   # Manifest avec permissions et config sécurité
│       └── res/xml/
│           └── network_security_config.xml  # Config sécurité réseau
├── build.gradle.kts              # Configuration root du projet
├── gradle.properties             # Propriétés Gradle et optimisations
└── gradle/wrapper/
    └── gradle-wrapper.properties # Version de Gradle
```

## Scripts et commandes essentielles

### Nettoyage complet

```bash
# Utiliser le script automatisé
./clean_build.sh

# Ou manuellement :
flutter clean
cd android && ./gradlew clean && rm -rf .gradle && cd ..
rm -rf build/
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Builds de test

```bash
# Build debug
flutter build apk --debug

# Build release  
flutter build apk --release

# Build App Bundle (pour Google Play)
flutter build appbundle --release

# Analyser la taille de l'APK
flutter build apk --analyze-size
```

### Vérifications de validation

```bash
# Vérifier la configuration Flutter
flutter doctor -v

# Tester les tâches Gradle
cd android && ./gradlew tasks

# Build avec stack trace détaillé
cd android && ./gradlew assembleDebug --stacktrace
```

## Configuration des Build Types

### Debug Build
- **Application ID**: `com.example.ojyx.debug`
- **Debuggable**: Activé
- **Minification**: Désactivée
- **Shrink Resources**: Désactivé

### Release Build  
- **Application ID**: `com.example.ojyx`
- **Debuggable**: Désactivé
- **Minification**: Activée avec ProGuard/R8
- **Shrink Resources**: Activé
- **Core Library Desugaring**: Activé

## Sécurité et permissions

### Permissions déclarées
- `INTERNET`: Requise pour Supabase et le multijoueur

### Configuration de sécurité réseau
- **Cleartext Traffic**: Interdit (HTTPS uniquement)
- **Backup**: Désactivé pour la sécurité
- **Domaines autorisés**: Supabase (*.supabase.co, *.supabase.io)

## Optimisations de performance

### Gradle
- **JVM Args**: `-Xmx8G` pour builds rapides
- **Non-transitive R Class**: Activé
- **Parallel builds**: Supporté
- **Build cache**: Activé

### APK/AAB
- **Architectures supportées**: arm64-v8a, armeabi-v7a, x86_64
- **Resource shrinking**: Activé en release
- **Code obfuscation**: Activé en release

## Résolution des problèmes courants

### Erreur "No Android SDK found"
```bash
# Installer Android Studio et configurer ANDROID_HOME
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Accepter les licences
flutter doctor --android-licenses
```

### Erreurs Gradle de dépendances
```bash
# Nettoyer et regénérer
./clean_build.sh

# Ou forcer le refresh des dépendances
cd android && ./gradlew build --refresh-dependencies
```

### Erreurs MultiDex
- ✅ MultiDex est déjà configuré dans `defaultConfig`
- ✅ Dépendance `androidx.multidex:multidex:2.0.1` ajoutée

### Erreurs ProGuard/R8
- ✅ Règles configurées dans `proguard-rules.pro`
- ✅ Règles spécifiques pour Flutter et Supabase incluses

## Checklist de validation

Avant de considérer la configuration comme complète :

- [ ] `flutter doctor -v` sans erreurs critiques
- [ ] `cd android && ./gradlew tasks` s'exécute sans erreur
- [ ] `flutter build apk --debug` réussit
- [ ] `flutter build apk --release` réussit  
- [ ] APK s'installe sur émulateur/device
- [ ] Application se lance sans crash
- [ ] Connexion Supabase fonctionne (si configurée)

## Maintenance et mises à jour

### Mises à jour régulières recommandées
- Gradle wrapper (vérifier les versions LTS)
- Android Gradle Plugin (suivre les versions Flutter)
- Dépendances AndroidX (vérifier la compatibilité)
- ProGuard rules (adapter aux nouvelles dépendances)

### Monitoring des performances
```bash
# Analyser la taille des APK
flutter build apk --analyze-size

# Profiling des builds
cd android && ./gradlew assembleDebug --profile
```

## Support et dépannage

### Logs utiles
```bash
# Logs de build détaillés
cd android && ./gradlew assembleDebug --info --stacktrace

# Logs d'exécution Android
adb logcat | grep -i flutter
```

### Ressources externes
- [Flutter Android deployment](https://flutter.dev/docs/deployment/android)
- [Android Gradle Plugin releases](https://developer.android.com/studio/releases/gradle-plugin)
- [Supabase Flutter documentation](https://supabase.com/docs/reference/dart)

---

*Dernière mise à jour: 2025-07-26*  
*Configuration validée pour Flutter 3.32.6, Gradle 8.12*