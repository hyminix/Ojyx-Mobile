#!/bin/bash

# Pre-commit hook pour Ojyx - Validation TDD stricte
# Ce script s'exécute automatiquement avant chaque commit
# et bloque le commit si les standards TDD ne sont pas respectés

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables de configuration
MIN_COVERAGE=80
FAILED_CHECKS=0

echo -e "${BLUE}🔍 Ojyx Pre-commit Hook - Validation TDD${NC}"
echo "================================================"

# Fonction de logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((FAILED_CHECKS++))
}

# Fonction de vérification
run_check() {
    local check_name="$1"
    local command="$2"
    local success_msg="$3"
    local error_msg="$4"
    
    log_info "Vérification: $check_name"
    
    if eval "$command" >/dev/null 2>&1; then
        log_success "$success_msg"
        return 0
    else
        log_error "$error_msg"
        return 1
    fi
}

# 1. Vérifier que nous sommes dans un projet Flutter
if [ ! -f "pubspec.yaml" ]; then
    log_error "pubspec.yaml non trouvé. Exécutez ce hook depuis la racine du projet Flutter."
    exit 1
fi

# 2. Vérifier les fichiers stagés
STAGED_DART_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.dart$' || true)

if [ -z "$STAGED_DART_FILES" ]; then
    log_info "Aucun fichier Dart modifié, validation rapide."
    exit 0
fi

echo -e "\n📁 Fichiers Dart modifiés:"
echo "$STAGED_DART_FILES" | sed 's/^/  - /'

# 3. Vérifier le formatage du code
echo -e "\n🎨 Vérification du formatage"
echo "============================="

if ! dart format --set-exit-if-changed . >/dev/null 2>&1; then
    log_error "Code mal formaté détecté!"
    echo -e "${YELLOW}Solution: Exécutez 'dart format .' pour corriger le formatage${NC}"
    ((FAILED_CHECKS++))
else
    log_success "Formatage correct"
fi

# 4. Générer les fichiers build_runner si nécessaire
echo -e "\n🔄 Génération des fichiers"
echo "=========================="

log_info "Vérification des fichiers générés..."
if flutter packages pub run build_runner build --delete-conflicting-outputs >/dev/null 2>&1; then
    log_success "Génération de code réussie"
else
    log_warning "Problème de génération de code (peut être normal)"
fi

# 5. Analyse statique
echo -e "\n🔍 Analyse statique"
echo "=================="

if flutter analyze --no-fatal-infos >/dev/null 2>&1; then
    log_success "Analyse statique réussie"
else
    log_error "Erreurs d'analyse statique détectées"
    echo -e "${YELLOW}Solution: Exécutez 'flutter analyze' pour voir les détails${NC}"
    ((FAILED_CHECKS++))
fi

# 6. Détection de tests commentés (VIOLATION TDD CRITIQUE)
echo -e "\n🧪 Vérification TDD stricte"
echo "=========================="

# Vérifier les tests commentés
COMMENTED_TESTS=$(grep -r "//.*test\|/\*.*test\|skip.*true" test/ 2>/dev/null || true)
if [ ! -z "$COMMENTED_TESTS" ]; then
    log_error "VIOLATION TDD CRITIQUE: Tests commentés détectés!"
    echo -e "${RED}Les tests commentés sont strictement interdits dans ce projet.${NC}"
    echo -e "${YELLOW}Fichiers concernés:${NC}"
    echo "$COMMENTED_TESTS" | sed 's/^/  /'
    echo ""
    echo -e "${YELLOW}Solution: Supprimez les commentaires ou corrigez les tests${NC}"
    ((FAILED_CHECKS++))
else
    log_success "Aucun test commenté détecté"
fi

# Vérifier les fichiers test_summary (INTERDIT)
TEST_SUMMARY_FILES=$(find . -name "*test_summary*" -type f 2>/dev/null || true)
if [ ! -z "$TEST_SUMMARY_FILES" ]; then
    log_error "VIOLATION TDD CRITIQUE: Fichiers test_summary détectés!"
    echo -e "${RED}Les fichiers test_summary sont interdits. Utilisez de vrais tests.${NC}"
    echo -e "${YELLOW}Fichiers concernés:${NC}"
    echo "$TEST_SUMMARY_FILES" | sed 's/^/  /'
    ((FAILED_CHECKS++))
else
    log_success "Aucun fichier test_summary détecté"
fi

# 7. Exécution des tests (TDD STRICT)
echo -e "\n🧪 Exécution des tests"
echo "====================="

log_info "Exécution des tests avec couverture..."
if flutter test --coverage --reporter=compact >/dev/null 2>&1; then
    log_success "Tous les tests passent"
    
    # Vérifier la couverture
    if [ -f "coverage/lcov.info" ]; then
        if command -v lcov >/dev/null 2>&1; then
            COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | grep -o '[0-9.]*%' | head -1 | sed 's/%//')
            if [ ! -z "$COVERAGE" ]; then
                if (( $(echo "$COVERAGE >= $MIN_COVERAGE" | bc -l 2>/dev/null || echo "1") )); then
                    log_success "Couverture de tests: ${COVERAGE}% (≥${MIN_COVERAGE}% requis)"
                else
                    log_warning "Couverture de tests: ${COVERAGE}% (<${MIN_COVERAGE}% recommandé)"
                    echo -e "${YELLOW}Conseil: Ajoutez des tests pour améliorer la couverture${NC}"
                fi
            else
                log_warning "Impossible de calculer la couverture"
            fi
        else
            log_warning "lcov non disponible pour calculer la couverture"
        fi
    else
        log_warning "Fichier de couverture non généré"
    fi
else
    log_error "VIOLATION TDD CRITIQUE: Des tests échouent!"
    echo -e "${RED}Tous les tests doivent passer avant le commit.${NC}"
    echo -e "${YELLOW}Solution: Exécutez 'flutter test' pour voir les détails${NC}"
    ((FAILED_CHECKS++))
fi

# 8. Vérification des bonnes pratiques de commit
echo -e "\n📝 Vérification du message de commit"
echo "===================================="

# Note: Le message de commit n'est pas encore disponible dans pre-commit
# Cette vérification sera faite dans commit-msg hook
log_info "Vérification du message de commit (sera validée lors du commit)"

# 9. Résultats finaux
echo -e "\n📊 Résultats de la validation pre-commit"
echo "========================================"

if [ $FAILED_CHECKS -eq 0 ]; then
    echo -e "${GREEN}🎉 Validation réussie! Le commit peut procéder.${NC}"
    echo -e "${GREEN}✅ Code formaté correctement${NC}"
    echo -e "${GREEN}✅ Analyse statique passée${NC}"
    echo -e "${GREEN}✅ Aucun test commenté${NC}"
    echo -e "${GREEN}✅ Tous les tests passent${NC}"
    echo -e "${GREEN}✅ Standards TDD respectés${NC}"
    exit 0
else
    echo -e "${RED}❌ Validation échouée! Le commit est bloqué.${NC}"
    echo -e "${RED}Nombre de problèmes détectés: $FAILED_CHECKS${NC}"
    echo ""
    echo -e "${YELLOW}Le projet Ojyx applique des standards TDD stricts.${NC}"
    echo -e "${YELLOW}Corrigez les problèmes ci-dessus avant de commiter.${NC}"
    echo ""
    echo -e "${BLUE}Aide:${NC}"
    echo -e "${BLUE}- Formatage: dart format .${NC}"
    echo -e "${BLUE}- Analyse: flutter analyze${NC}"
    echo -e "${BLUE}- Tests: flutter test${NC}"
    echo -e "${BLUE}- Génération: flutter packages pub run build_runner build${NC}"
    exit 1
fi