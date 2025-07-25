#!/bin/bash
# check-conflicts.sh - Script de détection des conflits de dépendances
# Usage: ./check-conflicts.sh

set -e

echo "🔍 Ojyx - Dependency Conflict Checker"
echo "===================================="
echo ""

# Couleurs pour output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour vérifier une dépendance transitive
check_transitive() {
    local package=$1
    echo -e "\n📦 Checking $package versions:"
    
    # Obtenir toutes les versions du package
    versions=$(flutter pub deps --style=tree | grep -E "$package\s+[0-9]" | awk '{print $2}' | sort | uniq)
    
    count=$(echo "$versions" | wc -l)
    
    if [ $count -gt 1 ]; then
        echo -e "${RED}❌ CONFLICT DETECTED!${NC}"
        echo "Multiple versions found:"
        echo "$versions"
        return 1
    else
        echo -e "${GREEN}✅ OK - Single version: $versions${NC}"
        return 0
    fi
}

# Fonction pour vérifier les contraintes
check_constraints() {
    echo -e "\n🔧 Checking version constraints..."
    
    # Vérifier si dependency_overrides existe
    if grep -q "dependency_overrides:" pubspec.yaml; then
        echo -e "${YELLOW}⚠️  dependency_overrides detected in pubspec.yaml${NC}"
        echo "Current overrides:"
        sed -n '/dependency_overrides:/,/^[^ ]/p' pubspec.yaml | grep -E "^\s+\w+:" || true
    else
        echo -e "${GREEN}✅ No dependency_overrides found${NC}"
    fi
}

# Fonction pour simuler les mises à jour
simulate_updates() {
    echo -e "\n🧪 Simulating dependency updates..."
    
    # Créer un backup temporaire
    cp pubspec.yaml pubspec.yaml.temp
    
    # Packages à tester
    declare -A updates=(
        ["flutter_lints"]="^6.0.0"
        ["build_runner"]="^2.6.0"
        ["freezed"]="^3.2.0"
        ["freezed_annotation"]="^3.1.0"
        ["go_router"]="^16.0.0"
        ["sentry_flutter"]="^9.5.0"
    )
    
    for package in "${!updates[@]}"; do
        echo -e "\nTesting update: $package → ${updates[$package]}"
        
        # Restaurer pubspec
        cp pubspec.yaml.temp pubspec.yaml
        
        # Appliquer la mise à jour
        if grep -q "^\s*$package:" pubspec.yaml; then
            sed -i "s/^\s*$package:.*/$package: ${updates[$package]}/" pubspec.yaml
        elif grep -q "^\s\s$package:" pubspec.yaml; then
            sed -i "s/^\s\s$package:.*$/  $package: ${updates[$package]}/" pubspec.yaml
        fi
        
        # Tester la résolution
        if flutter pub get --dry-run &>/dev/null; then
            echo -e "${GREEN}✅ Update compatible${NC}"
        else
            echo -e "${RED}❌ Update causes conflicts${NC}"
            
            # Si c'est freezed, tester avec overrides
            if [ "$package" == "freezed" ] || [ "$package" == "freezed_annotation" ]; then
                echo "Testing with analyzer override..."
                
                # Ajouter overrides
                echo -e "\ndependency_overrides:\n  analyzer: ^8.0.0\n  _fe_analyzer_shared: ^86.0.0" >> pubspec.yaml
                
                if flutter pub get --dry-run &>/dev/null; then
                    echo -e "${GREEN}✅ Works with overrides${NC}"
                else
                    echo -e "${RED}❌ Still fails with overrides${NC}"
                fi
            fi
        fi
    done
    
    # Restaurer l'original
    mv pubspec.yaml.temp pubspec.yaml
}

# Fonction principale
main() {
    # Vérifier l'environnement
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}Error: Flutter not found in PATH${NC}"
        exit 1
    fi
    
    # Obtenir les dépendances actuelles
    echo "📊 Fetching current dependencies..."
    flutter pub get > /dev/null 2>&1
    
    # Vérifier les packages critiques
    CRITICAL_PACKAGES=("analyzer" "source_gen" "build" "lints" "_fe_analyzer_shared")
    
    conflicts=0
    for package in "${CRITICAL_PACKAGES[@]}"; do
        if ! check_transitive "$package"; then
            ((conflicts++))
        fi
    done
    
    # Vérifier les contraintes
    check_constraints
    
    # Simuler les mises à jour
    read -p "Do you want to simulate updates? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        simulate_updates
    fi
    
    # Résumé
    echo -e "\n📋 Summary"
    echo "========="
    if [ $conflicts -eq 0 ]; then
        echo -e "${GREEN}✅ No conflicts detected in current dependencies${NC}"
    else
        echo -e "${RED}❌ Found $conflicts conflict(s) in transitive dependencies${NC}"
    fi
    
    # Recommandations
    echo -e "\n💡 Recommendations:"
    echo "1. Update packages in the order specified in migration-strategy.md"
    echo "2. Use dependency_overrides for analyzer when updating freezed"
    echo "3. Run 'flutter pub deps --style=tree > deps.txt' before each phase"
    echo "4. Test generation after each update: 'flutter pub run build_runner build'"
}

# Exécuter le script
main