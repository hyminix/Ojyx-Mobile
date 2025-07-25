#!/bin/bash
# fix-linting-issues.sh - Corrige automatiquement certains problèmes de linting

set -e

echo "🔧 Correction automatique des problèmes de linting..."
echo "===================================================="

# 1. Corriger les imports inutilisés
echo -e "\n📦 Suppression des imports inutilisés..."
dart fix --apply --code=unused_import

# 2. Ajouter const où nécessaire
echo -e "\n🔒 Ajout des const manquants..."
dart fix --apply --code=prefer_const_constructors

# 3. Corriger les variables locales finales
echo -e "\n📌 Correction des variables locales finales..."
dart fix --apply --code=prefer_final_locals

# 4. Corriger les deprecated APIs
echo -e "\n⚠️  Mise à jour des APIs dépréciées..."
# withOpacity -> withValues
find lib test -name "*.dart" -type f -exec sed -i 's/\.withOpacity(\([^)]*\))/.withValues(opacity: \1)/g' {} +

# 5. Corriger surfaceVariant -> surfaceContainerHighest
find lib test -name "*.dart" -type f -exec sed -i 's/surfaceVariant/surfaceContainerHighest/g' {} +

# 6. Corriger background -> surface, onBackground -> onSurface
find lib test -name "*.dart" -type f -exec sed -i 's/\.background/.surface/g' {} +
find lib test -name "*.dart" -type f -exec sed -i 's/\.onBackground/.onSurface/g' {} +

# 7. Corriger unnecessary_underscores (remplacer __ par _)
echo -e "\n🔤 Correction des underscores multiples..."
find test -name "*.dart" -type f -exec sed -i 's/__/_/g' {} +

# 8. Appliquer tous les fixes disponibles
echo -e "\n🔨 Application de tous les fixes automatiques..."
dart fix --apply

# 9. Formater le code
echo -e "\n💅 Formatage du code..."
dart format .

echo -e "\n✅ Corrections automatiques terminées!"
echo "   Exécutez 'flutter analyze' pour voir les problèmes restants."