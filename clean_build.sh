#!/bin/bash

echo "🧹 Nettoyage complet du build Android pour Ojyx..."

# Nettoyer Flutter
echo "📦 Nettoyage Flutter..."
flutter clean

# Nettoyer Gradle
echo "🔧 Nettoyage Gradle..."
cd android
./gradlew clean
rm -rf .gradle
cd ..

# Supprimer les dossiers de build
echo "🗑️ Suppression des dossiers de build..."
rm -rf build/
rm -rf android/app/build/
rm -rf android/.gradle/

# Réinstaller les dépendances
echo "📥 Réinstallation des dépendances..."
flutter pub get

# Regenerer les fichiers Dart
echo "🔄 Régénération des fichiers Dart..."
flutter pub run build_runner build --delete-conflicting-outputs

# Build Gradle avec refresh des dépendances
echo "🔨 Build Gradle avec refresh des dépendances..."
cd android
./gradlew build --refresh-dependencies --no-daemon
cd ..

echo "✅ Nettoyage terminé!"
echo "💡 Vous pouvez maintenant tenter : flutter build apk --debug"