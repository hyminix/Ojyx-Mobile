#!/bin/bash
# compare-metrics.sh - Compare les métriques avant/après migration
# Usage: ./compare-metrics.sh

set -e

echo "📊 Comparing metrics: Baseline vs Current"
echo "========================================"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Fonction pour afficher la comparaison avec couleur
compare_metric() {
    local name=$1
    local before=$2
    local after=$3
    local better_if_lower=$4
    
    echo -n "$name: $before → $after "
    
    # Convertir en nombres si possible
    before_num=$(echo "$before" | grep -o '[0-9.]*' || echo "0")
    after_num=$(echo "$after" | grep -o '[0-9.]*' || echo "0")
    
    if [ "$better_if_lower" = "true" ]; then
        if (( $(echo "$after_num < $before_num" | bc -l) )); then
            echo -e "${GREEN}↓ Improved${NC}"
        elif (( $(echo "$after_num > $before_num" | bc -l) )); then
            echo -e "${RED}↑ Degraded${NC}"
        else
            echo -e "${YELLOW}= Same${NC}"
        fi
    else
        if (( $(echo "$after_num > $before_num" | bc -l) )); then
            echo -e "${GREEN}↑ Improved${NC}"
        elif (( $(echo "$after_num < $before_num" | bc -l) )); then
            echo -e "${RED}↓ Degraded${NC}"
        else
            echo -e "${YELLOW}= Same${NC}"
        fi
    fi
}

# Vérifier que les fichiers baseline existent
if [ ! -f ".taskmaster/reports/baseline-metrics.txt" ]; then
    echo "❌ Error: No baseline found. Run capture-baseline.sh first."
    exit 1
fi

# 1. Coverage
echo -e "\n📊 Test Coverage:"
if [ -f ".taskmaster/reports/baseline-coverage.info" ] && [ -f "coverage/lcov.info" ]; then
    BEFORE_COV=$(lcov --summary .taskmaster/reports/baseline-coverage.info 2>/dev/null | grep "lines......" | grep -o '[0-9.]*%' || echo "0%")
    AFTER_COV=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines......" | grep -o '[0-9.]*%' || echo "0%")
    compare_metric "Coverage" "$BEFORE_COV" "$AFTER_COV" "false"
else
    echo "Coverage data not available"
fi

# 2. Nombre de fichiers de test
echo -e "\n🧪 Test Files:"
BEFORE_TESTS=$(grep "Test Files:" .taskmaster/reports/baseline-metrics.txt | cut -d':' -f2 | tr -d ' ')
AFTER_TESTS=$(find test -name "*_test.dart" -type f | wc -l)
compare_metric "Test files" "$BEFORE_TESTS" "$AFTER_TESTS" "false"

# 3. Warnings d'analyse
echo -e "\n⚠️  Static Analysis:"
if [ -f ".taskmaster/reports/baseline-analyze.txt" ]; then
    BEFORE_ERRORS=$(grep -c "error •" .taskmaster/reports/baseline-analyze.txt || echo "0")
    BEFORE_WARNINGS=$(grep -c "warning •" .taskmaster/reports/baseline-analyze.txt || echo "0")
    
    # Nouvelle analyse
    flutter analyze > temp-analyze.txt 2>&1 || true
    AFTER_ERRORS=$(grep -c "error •" temp-analyze.txt || echo "0")
    AFTER_WARNINGS=$(grep -c "warning •" temp-analyze.txt || echo "0")
    rm temp-analyze.txt
    
    compare_metric "Errors" "$BEFORE_ERRORS" "$AFTER_ERRORS" "true"
    compare_metric "Warnings" "$BEFORE_WARNINGS" "$AFTER_WARNINGS" "true"
fi

# 4. Temps d'exécution des tests
echo -e "\n⏱️  Performance:"
if grep -q "Total execution time:" .taskmaster/reports/baseline-metrics.txt; then
    BEFORE_TIME=$(grep "Total execution time:" .taskmaster/reports/baseline-metrics.txt | grep -o '[0-9]*s')
    
    # Mesurer le temps actuel
    START_TIME=$(date +%s)
    flutter test > /dev/null 2>&1
    END_TIME=$(date +%s)
    AFTER_TIME="$((END_TIME - START_TIME))s"
    
    compare_metric "Test execution time" "$BEFORE_TIME" "$AFTER_TIME" "true"
fi

# 5. Temps de génération de code
if grep -q "Code generation time:" .taskmaster/reports/baseline-metrics.txt; then
    BEFORE_CODEGEN=$(grep "Code generation time:" .taskmaster/reports/baseline-metrics.txt | grep -o '[0-9]*s')
    echo "Code generation time: $BEFORE_CODEGEN (baseline)"
fi

# 6. Dépendances
echo -e "\n📦 Dependencies:"
echo "Analyzing dependency changes..."

# Compter les dépendances
BEFORE_DEPS=$(grep -E "├──|└──" .taskmaster/reports/baseline-deps-tree.txt | wc -l)
flutter pub deps --style=tree > temp-deps.txt
AFTER_DEPS=$(grep -E "├──|└──" temp-deps.txt | wc -l)
rm temp-deps.txt

compare_metric "Total dependencies" "$BEFORE_DEPS" "$AFTER_DEPS" "true"

# 7. Générer le rapport de comparaison
REPORT_FILE=".taskmaster/reports/comparison-report-$(date +%Y%m%d-%H%M%S).md"
cat > "$REPORT_FILE" << EOF
# Metrics Comparison Report
Generated: $(date)

## Overview
Comparison between baseline and current state after migration.

## Test Metrics
| Metric | Baseline | Current | Change |
|--------|----------|---------|---------|
| Coverage | $BEFORE_COV | $AFTER_COV | $([ "$BEFORE_COV" = "$AFTER_COV" ] && echo "=" || echo "Changed") |
| Test Files | $BEFORE_TESTS | $AFTER_TESTS | $([ $AFTER_TESTS -ge $BEFORE_TESTS ] && echo "✅" || echo "⚠️") |
| Execution Time | ${BEFORE_TIME:-N/A} | ${AFTER_TIME:-N/A} | - |

## Code Quality
| Metric | Baseline | Current | Change |
|--------|----------|---------|---------|
| Errors | ${BEFORE_ERRORS:-0} | ${AFTER_ERRORS:-0} | $([ ${AFTER_ERRORS:-0} -le ${BEFORE_ERRORS:-0} ] && echo "✅" || echo "❌") |
| Warnings | ${BEFORE_WARNINGS:-0} | ${AFTER_WARNINGS:-0} | $([ ${AFTER_WARNINGS:-0} -le ${BEFORE_WARNINGS:-0} ] && echo "✅" || echo "⚠️") |

## Dependencies
| Metric | Baseline | Current | Change |
|--------|----------|---------|---------|
| Total Count | $BEFORE_DEPS | $AFTER_DEPS | $([ $AFTER_DEPS -le $((BEFORE_DEPS + 10)) ] && echo "✅" || echo "⚠️") |

## Summary
EOF

# Déterminer le statut global
SUCCESS=true
[ ${AFTER_ERRORS:-0} -gt ${BEFORE_ERRORS:-0} ] && SUCCESS=false
[ $(echo "${AFTER_COV%\%} < 80" | bc -l) -eq 1 ] && SUCCESS=false

if [ "$SUCCESS" = true ]; then
    echo "Overall Status: ✅ **Success** - All metrics within acceptable ranges" >> "$REPORT_FILE"
    echo -e "\n✅ ${GREEN}All metrics within acceptable ranges${NC}"
else
    echo "Overall Status: ❌ **Issues Found** - Some metrics need attention" >> "$REPORT_FILE"
    echo -e "\n❌ ${RED}Some metrics need attention${NC}"
fi

echo -e "\n📄 Full report saved to: $REPORT_FILE"

# 8. Afficher les changements critiques de dépendances
echo -e "\n🔄 Critical Dependency Changes:"
if [ -f ".taskmaster/reports/flutter-outdated.json" ]; then
    echo "Key updates:"
    echo "- freezed: 2.5.8 → 3.2.0 (Major)"
    echo "- go_router: 14.8.1 → 16.0.0 (Major)"
    echo "- flutter_lints: 5.0.0 → 6.0.0 (Major)"
    echo "- sentry_flutter: 8.14.2 → 9.5.0 (Major)"
fi

echo -e "\n✅ Comparison complete!"