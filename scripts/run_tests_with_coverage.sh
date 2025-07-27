#!/bin/bash

# Script pour exécuter tous les tests avec couverture de code

echo "🧪 Exécution des tests avec couverture..."
echo "======================================"

# Nettoyer les rapports de couverture précédents
rm -rf coverage/

# Exécuter les tests unitaires avec couverture
echo "📊 Tests unitaires..."
flutter test --coverage --test-randomize-ordering-seed random

# Vérifier si lcov est installé
if command -v lcov &> /dev/null; then
    echo "📈 Génération du rapport de couverture HTML..."
    
    # Générer le rapport HTML
    genhtml coverage/lcov.info -o coverage/html
    
    # Afficher un résumé de la couverture
    echo "📊 Résumé de la couverture:"
    lcov --summary coverage/lcov.info
    
    echo "✅ Rapport HTML généré dans coverage/html/index.html"
else
    echo "⚠️  lcov n'est pas installé. Installer avec: sudo apt-get install lcov"
fi

# Exécuter les tests d'intégration si disponibles
if [ -d "integration_test" ]; then
    echo ""
    echo "🔄 Tests d'intégration..."
    echo "========================"
    
    # Note: Les tests d'intégration nécessitent un émulateur ou appareil
    echo "ℹ️  Pour exécuter les tests d'intégration:"
    echo "   1. Démarrer un émulateur Android ou connecter un appareil"
    echo "   2. Exécuter: flutter test integration_test"
fi

# Afficher les statistiques finales
echo ""
echo "📊 Statistiques des tests:"
echo "========================="

# Compter les fichiers de test
TEST_COUNT=$(find test -name "*_test.dart" -type f | wc -l)
echo "📁 Nombre de fichiers de test: $TEST_COUNT"

# Compter les fichiers source
SOURCE_COUNT=$(find lib -name "*.dart" -type f | wc -l)
echo "📁 Nombre de fichiers source: $SOURCE_COUNT"

# Calculer le ratio
if [ $SOURCE_COUNT -gt 0 ]; then
    RATIO=$(awk "BEGIN {printf \"%.2f\", $TEST_COUNT/$SOURCE_COUNT}")
    echo "📊 Ratio test/source: $RATIO"
fi

echo ""
echo "✅ Tests terminés!"

# Ouvrir le rapport de couverture si demandé
if [ "$1" = "--open" ] && [ -f "coverage/html/index.html" ]; then
    echo "🌐 Ouverture du rapport de couverture..."
    if command -v xdg-open &> /dev/null; then
        xdg-open coverage/html/index.html
    elif command -v open &> /dev/null; then
        open coverage/html/index.html
    else
        echo "⚠️  Impossible d'ouvrir automatiquement. Ouvrir manuellement: coverage/html/index.html"
    fi
fi