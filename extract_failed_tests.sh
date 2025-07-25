#!/bin/bash

echo "=== Extraction des tests échoués ==="
echo

# 1. Erreurs de compilation
echo "### Erreurs de compilation ###"
grep -B 2 "Error:" resultats_tests.log | grep -E "(Error:|\.dart)" | sort | uniq

echo
echo "### Tests avec Expected/Actual mismatch ###"
grep -B 5 -A 5 "Expected:" resultats_tests.log | grep -E "(Expected:|Actual:|test\()" | head -50

echo
echo "### Fichiers avec erreurs ###"
grep "Compilation failed" resultats_tests.log | cut -d: -f2 | cut -d' ' -f1 | sort | uniq

echo
echo "### Résumé final ###"
tail -20 resultats_tests.log | grep -E "(passed|failed|Some tests failed)"