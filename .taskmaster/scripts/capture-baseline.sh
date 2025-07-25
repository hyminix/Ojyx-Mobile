#!/bin/bash
# capture-baseline.sh - Capture des métriques de base avant migration
# Usage: ./capture-baseline.sh

set -e

echo "📸 Capturing baseline metrics for Ojyx project..."
echo "=============================================="

# Créer le dossier de rapports s'il n'existe pas
mkdir -p .taskmaster/reports

# 1. Coverage actuel
echo -e "\n📊 Capturing test coverage..."
flutter test --coverage
cp coverage/lcov.info .taskmaster/reports/baseline-coverage.info

# Générer le rapport HTML si genhtml est disponible
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o .taskmaster/reports/baseline-coverage-html --quiet
    echo "HTML coverage report generated"
fi

# 2. Métriques des tests
echo -e "\n🧪 Capturing test metrics..."
TOTAL_TEST_FILES=$(find test -name "*_test.dart" -type f | wc -l)
TOTAL_TEST_DIRS=$(find test -type d | wc -l)

cat > .taskmaster/reports/baseline-metrics.txt << EOF
Baseline Metrics - $(date)
================================

Test Files: $TOTAL_TEST_FILES
Test Directories: $TOTAL_TEST_DIRS

Test Execution Time:
EOF

# 3. Temps d'exécution des tests
echo -e "\n⏱️  Running tests to measure execution time..."
START_TIME=$(date +%s)
flutter test 2>&1 | tee -a .taskmaster/reports/baseline-test-output.txt
END_TIME=$(date +%s)
EXECUTION_TIME=$((END_TIME - START_TIME))
echo "Total execution time: ${EXECUTION_TIME}s" >> .taskmaster/reports/baseline-metrics.txt

# 4. Analyse statique
echo -e "\n🔍 Running static analysis..."
flutter analyze 2>&1 | tee .taskmaster/reports/baseline-analyze.txt

# Compter les warnings et erreurs
ERRORS=$(grep -c "error •" .taskmaster/reports/baseline-analyze.txt || true)
WARNINGS=$(grep -c "warning •" .taskmaster/reports/baseline-analyze.txt || true)
INFOS=$(grep -c "info •" .taskmaster/reports/baseline-analyze.txt || true)

echo -e "\nStatic Analysis Results:" >> .taskmaster/reports/baseline-metrics.txt
echo "Errors: $ERRORS" >> .taskmaster/reports/baseline-metrics.txt
echo "Warnings: $WARNINGS" >> .taskmaster/reports/baseline-metrics.txt
echo "Info: $INFOS" >> .taskmaster/reports/baseline-metrics.txt

# 5. Dépendances actuelles
echo -e "\n📦 Capturing dependency tree..."
flutter pub deps --style=tree > .taskmaster/reports/baseline-deps-tree.txt
flutter pub deps --json > .taskmaster/reports/baseline-deps.json

# 6. Performance de génération de code
echo -e "\n🏗️  Measuring code generation performance..."
START_TIME=$(date +%s)
flutter pub run build_runner build --delete-conflicting-outputs 2>&1 | tee .taskmaster/reports/baseline-codegen.txt
END_TIME=$(date +%s)
CODEGEN_TIME=$((END_TIME - START_TIME))
echo -e "\nCode generation time: ${CODEGEN_TIME}s" >> .taskmaster/reports/baseline-metrics.txt

# 7. Tentative de build APK (si possible)
echo -e "\n📱 Attempting APK build for size metrics..."
if flutter build apk --debug 2>&1 | tee .taskmaster/reports/baseline-build.txt; then
    APK_SIZE=$(find build/app/outputs -name "*.apk" -exec ls -lh {} \; | awk '{print $5}')
    echo -e "\nDebug APK size: $APK_SIZE" >> .taskmaster/reports/baseline-metrics.txt
else
    echo -e "\nAPK build failed (expected if dependencies are outdated)" >> .taskmaster/reports/baseline-metrics.txt
fi

# 8. Résumé
echo -e "\n📋 Generating summary..."
cat > .taskmaster/reports/baseline-summary.md << EOF
# Baseline Metrics Summary
Generated: $(date)

## Test Metrics
- Test Files: $TOTAL_TEST_FILES
- Test Execution Time: ${EXECUTION_TIME}s
- Coverage: $(grep "lines......" .taskmaster/reports/baseline-coverage.info 2>/dev/null | grep -o '[0-9.]*%' || echo "N/A")

## Code Quality
- Errors: $ERRORS
- Warnings: $WARNINGS
- Info: $INFOS

## Build Performance
- Code Generation Time: ${CODEGEN_TIME}s
- Debug APK Size: ${APK_SIZE:-"Build failed"}

## Files Generated
- baseline-coverage.info
- baseline-metrics.txt
- baseline-analyze.txt
- baseline-deps-tree.txt
- baseline-deps.json
- baseline-test-output.txt
- baseline-codegen.txt
EOF

echo -e "\n✅ Baseline capture complete!"
echo "📁 All reports saved in .taskmaster/reports/"
cat .taskmaster/reports/baseline-summary.md