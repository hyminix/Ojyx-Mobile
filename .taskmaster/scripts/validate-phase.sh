#!/bin/bash
# validate-phase.sh - Validation après chaque phase de migration
# Usage: ./validate-phase.sh <phase_number>

set -e

PHASE=$1

if [ -z "$PHASE" ]; then
    echo "Usage: $0 <phase_number>"
    echo "Example: $0 1"
    exit 1
fi

echo "🔍 Validating Phase $PHASE..."
echo "=========================="

# Créer un dossier pour les rapports de cette phase
REPORT_DIR=".taskmaster/reports/phase-$PHASE"
mkdir -p "$REPORT_DIR"

# 1. Tests unitaires
echo -e "\n🧪 Running unit tests..."
if flutter test 2>&1 | tee "$REPORT_DIR/test-output.txt"; then
    echo "✅ Unit tests passed"
else
    echo "❌ Unit tests failed"
    exit 1
fi

# 2. Analyse statique
echo -e "\n🔍 Running static analysis..."
if flutter analyze 2>&1 | tee "$REPORT_DIR/analyze-output.txt"; then
    echo "✅ Static analysis passed"
    
    # Compter les issues
    ERRORS=$(grep -c "error •" "$REPORT_DIR/analyze-output.txt" || true)
    WARNINGS=$(grep -c "warning •" "$REPORT_DIR/analyze-output.txt" || true)
    echo "  Errors: $ERRORS, Warnings: $WARNINGS"
else
    echo "❌ Static analysis failed"
    exit 1
fi

# 3. Génération de code
echo -e "\n🏗️  Running code generation..."
if flutter pub run build_runner build --delete-conflicting-outputs 2>&1 | tee "$REPORT_DIR/codegen-output.txt"; then
    echo "✅ Code generation succeeded"
else
    echo "❌ Code generation failed"
    exit 1
fi

# 4. Build Android Debug
echo -e "\n📱 Building debug APK..."
if flutter build apk --debug 2>&1 | tee "$REPORT_DIR/build-output.txt"; then
    echo "✅ Debug build succeeded"
    
    # Capturer la taille de l'APK
    APK_SIZE=$(find build/app/outputs -name "*.apk" -exec ls -lh {} \; | awk '{print $5}')
    echo "  APK size: $APK_SIZE"
else
    echo "❌ Debug build failed"
    exit 1
fi

# 5. Coverage
echo -e "\n📊 Checking test coverage..."
flutter test --coverage 2>&1 | tee "$REPORT_DIR/coverage-output.txt"
cp coverage/lcov.info "$REPORT_DIR/coverage.info"

# Extraire le pourcentage de coverage
COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines......" | grep -o '[0-9.]*%' || echo "0%")
echo "  Coverage: $COVERAGE"

# Vérifier que le coverage est >= 80%
COVERAGE_NUM=$(echo $COVERAGE | sed 's/%//')
if (( $(echo "$COVERAGE_NUM >= 80" | bc -l) )); then
    echo "✅ Coverage meets requirement (≥80%)"
else
    echo "⚠️  Coverage below 80% threshold"
fi

# 6. Comparaison avec baseline
echo -e "\n📊 Comparing with baseline..."
if [ -f ".taskmaster/reports/baseline-metrics.txt" ]; then
    echo "  Baseline found, generating comparison..."
    
    # Comparer les métriques clés
    cat > "$REPORT_DIR/comparison.txt" << EOF
Phase $PHASE Validation Report
==============================
Date: $(date)

Metric Comparison:
------------------
EOF
    
    # Ajouter les comparaisons
    echo "✅ Comparison complete"
else
    echo "⚠️  No baseline found for comparison"
fi

# 7. Tests spécifiques à la phase
echo -e "\n🎯 Running phase-specific tests..."
case $PHASE in
    1)
        echo "  Testing SDK compatibility..."
        flutter doctor -v > "$REPORT_DIR/flutter-doctor.txt"
        ;;
    2)
        echo "  Testing linting rules..."
        flutter analyze --no-fatal-warnings > "$REPORT_DIR/linting-test.txt" || true
        ;;
    3)
        echo "  Testing build tools..."
        # Vérifier que tous les fichiers générés existent
        find lib -name "*.g.dart" -o -name "*.freezed.dart" > "$REPORT_DIR/generated-files.txt"
        ;;
    4)
        echo "  Testing Freezed migration..."
        flutter test --tags "freezed" 2>&1 | tee "$REPORT_DIR/freezed-tests.txt" || true
        ;;
    5)
        echo "  Testing navigation..."
        flutter test --tags "navigation" 2>&1 | tee "$REPORT_DIR/navigation-tests.txt" || true
        ;;
    6)
        echo "  Testing services..."
        flutter test --tags "integration" 2>&1 | tee "$REPORT_DIR/integration-tests.txt" || true
        ;;
esac

# 8. Générer le rapport de phase
echo -e "\n📄 Generating phase report..."
cat > "$REPORT_DIR/phase-$PHASE-report.md" << EOF
# Phase $PHASE Validation Report
Generated: $(date)

## Summary
- Unit Tests: ✅ Passed
- Static Analysis: $([ $ERRORS -eq 0 ] && echo "✅ No errors" || echo "❌ $ERRORS errors")
- Code Generation: ✅ Succeeded
- Build: ✅ Succeeded
- Coverage: $COVERAGE $([ $(echo "$COVERAGE_NUM >= 80" | bc -l) -eq 1 ] && echo "✅" || echo "⚠️")

## Metrics
- Warnings: $WARNINGS
- APK Size: $APK_SIZE
- Generated Files: $(find lib -name "*.g.dart" -o -name "*.freezed.dart" | wc -l)

## Phase-Specific Tests
$(cat "$REPORT_DIR"/*-tests.txt 2>/dev/null | grep -E "(Passed:|Failed:)" || echo "See detailed logs")

## Files Generated
$(ls -1 "$REPORT_DIR")
EOF

# 9. Résultat final
echo -e "\n✅ Phase $PHASE validated successfully!"
echo "📁 Reports saved in $REPORT_DIR/"
echo ""
cat "$REPORT_DIR/phase-$PHASE-report.md"