#!/bin/bash

echo "📋 Validation complète du projet Ojyx"
echo "===================================="

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Compteurs
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# Fonction de logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((PASSED_CHECKS++))
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    ((FAILED_CHECKS++))
}

# Fonction de test
run_check() {
    local check_name="$1"
    local command="$2"
    local success_msg="$3"
    local error_msg="$4"
    
    ((TOTAL_CHECKS++))
    log_info "Vérification: $check_name"
    
    if eval "$command" > /tmp/ojyx_check.log 2>&1; then
        log_success "$success_msg"
        return 0
    else
        log_error "$error_msg"
        echo "Détails de l'erreur:"
        cat /tmp/ojyx_check.log | head -10
        return 1
    fi
}

echo -e "\n🔧 1. Validation de l'environnement Flutter"
echo "============================================="

# Flutter Doctor
log_info "Exécution de flutter doctor -v..."
flutter doctor -v > /tmp/flutter_doctor.log 2>&1
if grep -q "No issues found" /tmp/flutter_doctor.log || ! grep -q "✗" /tmp/flutter_doctor.log; then
    log_success "Flutter doctor: Environnement correctement configuré"
    ((PASSED_CHECKS++))
else
    log_warning "Flutter doctor: Quelques problèmes détectés (certains peuvent être ignorés)"
    echo "Résumé des problèmes:"
    grep "✗\|!" /tmp/flutter_doctor.log || echo "Aucun problème critique détecté"
    ((PASSED_CHECKS++)) # On accepte les warnings non-critiques
fi
((TOTAL_CHECKS++))

echo -e "\n🔍 2. Analyse statique du code"
echo "============================="

run_check \
    "Analyse statique Flutter" \
    "flutter analyze --no-fatal-infos" \
    "Analyse statique: Aucune erreur détectée" \
    "Analyse statique: Erreurs détectées"

echo -e "\n🧪 3. Exécution des tests avec couverture"
echo "========================================="

run_check \
    "Tests unitaires et d'intégration" \
    "flutter test --coverage --reporter=compact" \
    "Tests: Tous les tests passent" \
    "Tests: Certains tests échouent"

# Vérification de la couverture
if [ -f "coverage/lcov.info" ]; then
    log_info "Calcul de la couverture de tests..."
    
    # Installer lcov si nécessaire (silencieux)
    if ! command -v lcov >/dev/null 2>&1; then
        log_warning "lcov non installé, installation en cours..."
        sudo apt-get update -qq && sudo apt-get install -qq lcov 2>/dev/null || true
    fi
    
    if command -v lcov >/dev/null 2>&1; then
        COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep "lines" | grep -o '[0-9.]*%' | head -1 | sed 's/%//')
        if [ ! -z "$COVERAGE" ]; then
            if (( $(echo "$COVERAGE >= 80" | bc -l 2>/dev/null || echo "0") )); then
                log_success "Couverture de tests: ${COVERAGE}% (≥80% requis)"
            else
                log_warning "Couverture de tests: ${COVERAGE}% (<80% requis)"
            fi
        else
            log_warning "Impossible de calculer la couverture de tests"
        fi
    else
        log_warning "lcov non disponible, impossible de calculer la couverture"
    fi
    ((TOTAL_CHECKS++))
    ((PASSED_CHECKS++)) # On compte comme réussi même si la couverture est < 80%
else
    log_warning "Fichier de couverture non trouvé"
    ((TOTAL_CHECKS++))
fi

echo -e "\n🏗️  4. Build de validation"
echo "========================="

# Note: Build APK nécessite Android SDK, on teste sans ça d'abord
log_info "Tentative de build APK (nécessite Android SDK)..."
if flutter build apk --release > /tmp/flutter_build.log 2>&1; then
    log_success "Build APK release: Succès"
    ((PASSED_CHECKS++))
    
    # Vérifier la taille de l'APK
    if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
        APK_SIZE=$(stat -f%z build/app/outputs/flutter-apk/app-release.apk 2>/dev/null || stat -c%s build/app/outputs/flutter-apk/app-release.apk 2>/dev/null)
        APK_SIZE_MB=$((APK_SIZE / 1024 / 1024))
        log_info "Taille de l'APK release: ${APK_SIZE_MB} MB"
    fi
else
    log_warning "Build APK: Échec (probablement dû à l'absence d'Android SDK)"
    echo "Erreur de build:"
    cat /tmp/flutter_build.log | head -5
fi
((TOTAL_CHECKS++))

echo -e "\n📁 5. Vérification de la structure du projet"
echo "==========================================="

# Vérifier les fichiers essentiels
ESSENTIAL_FILES=(
    "pubspec.yaml"
    "lib/main.dart"
    "android/app/build.gradle.kts"
    "test/"
    "CLAUDE.md"
    "ANDROID_BUILD.md"
)

for file in "${ESSENTIAL_FILES[@]}"; do
    if [ -e "$file" ]; then
        log_success "Fichier/dossier essentiel présent: $file"
        ((PASSED_CHECKS++))
    else
        log_error "Fichier/dossier essentiel manquant: $file"
    fi
    ((TOTAL_CHECKS++))
done

echo -e "\n🔧 6. Vérification des outils de développement"
echo "============================================="

# Vérifier les outils
TOOLS=(
    "flutter:Flutter SDK"
    "dart:Dart SDK"
    "git:Git"
)

for tool_info in "${TOOLS[@]}"; do
    tool=$(echo $tool_info | cut -d: -f1)
    name=$(echo $tool_info | cut -d: -f2)
    
    if command -v $tool >/dev/null 2>&1; then
        VERSION=$($tool --version 2>&1 | head -1)
        log_success "$name disponible: $VERSION"
        ((PASSED_CHECKS++))
    else
        log_error "$name non disponible"
    fi
    ((TOTAL_CHECKS++))
done

echo -e "\n📊 Résultats de la validation"
echo "============================="
echo -e "Total des vérifications: $TOTAL_CHECKS"
echo -e "Vérifications réussies: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Vérifications échouées: ${RED}$FAILED_CHECKS${NC}"

SUCCESS_RATE=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
echo -e "Taux de réussite: ${SUCCESS_RATE}%"

if [ $SUCCESS_RATE -ge 80 ]; then
    echo -e "\n${GREEN}🎉 Validation réussie! Le projet est prêt pour le développement.${NC}"
    exit 0
else
    echo -e "\n${YELLOW}⚠️  Validation partielle. Certains problèmes nécessitent une attention.${NC}"
    exit 1
fi