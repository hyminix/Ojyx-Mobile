#!/bin/bash

# Script de test des hooks Git pour Ojyx
# Teste les hooks sans faire de vrais commits

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Test des hooks Git pour Ojyx${NC}"
echo "================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRE_COMMIT_SCRIPT="$SCRIPT_DIR/pre-commit-hook.sh"
COMMIT_MSG_SCRIPT="$SCRIPT_DIR/commit-msg-hook.sh"

# Test 1: Hook pre-commit
echo -e "\n${BLUE}1. Test du hook pre-commit${NC}"
echo "=========================="

if [ -x "$PRE_COMMIT_SCRIPT" ]; then
    echo -e "${BLUE}Exécution du hook pre-commit...${NC}"
    if "$PRE_COMMIT_SCRIPT"; then
        echo -e "${GREEN}✅ Hook pre-commit: SUCCÈS${NC}"
        PRE_COMMIT_STATUS="success"
    else
        echo -e "${RED}❌ Hook pre-commit: ÉCHEC${NC}"
        PRE_COMMIT_STATUS="failed"
    fi
else
    echo -e "${RED}❌ Script pre-commit non trouvé ou non exécutable${NC}"
    PRE_COMMIT_STATUS="missing"
fi

# Test 2: Hook commit-msg avec différents messages
echo -e "\n${BLUE}2. Test du hook commit-msg${NC}"
echo "=========================="

# Messages de test
TEST_MESSAGES=(
    "feat: add new game feature"                    # Valide
    "fix(ui): correct button alignment"             # Valide avec scope
    "invalid message format"                        # Invalide
    "feat: Add New Feature"                         # Majuscule (warning)
    "docs: update documentation."                   # Point final (warning)
    "chore(deps): update flutter dependencies"      # Valide
    "test: add unit tests for game logic"          # Valide
)

COMMIT_MSG_RESULTS=()

for msg in "${TEST_MESSAGES[@]}"; do
    echo -e "\n${BLUE}Test du message: \"$msg\"${NC}"
    
    # Créer un fichier temporaire pour le message
    TEMP_MSG_FILE=$(mktemp)
    echo "$msg" > "$TEMP_MSG_FILE"
    
    if "$COMMIT_MSG_SCRIPT" "$TEMP_MSG_FILE" >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅ Accepté${NC}"
        COMMIT_MSG_RESULTS+=("✅ \"$msg\"")
    else
        echo -e "  ${RED}❌ Rejeté${NC}"
        COMMIT_MSG_RESULTS+=("❌ \"$msg\"")
    fi
    
    rm -f "$TEMP_MSG_FILE"
done

# Test 3: Vérification de l'installation des hooks
echo -e "\n${BLUE}3. Vérification de l'installation${NC}"
echo "=================================="

HOOKS_DIR=".git/hooks"
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"
COMMIT_MSG_HOOK="$HOOKS_DIR/commit-msg"

if [ -x "$PRE_COMMIT_HOOK" ]; then
    echo -e "${GREEN}✅ Hook pre-commit installé et exécutable${NC}"
    INSTALL_PRE_COMMIT="installed"
else
    echo -e "${YELLOW}⚠️  Hook pre-commit non installé${NC}"
    echo -e "${YELLOW}   Exécutez: scripts/install-hooks.sh${NC}"
    INSTALL_PRE_COMMIT="missing"
fi

if [ -x "$COMMIT_MSG_HOOK" ]; then
    echo -e "${GREEN}✅ Hook commit-msg installé et exécutable${NC}"
    INSTALL_COMMIT_MSG="installed"
else
    echo -e "${YELLOW}⚠️  Hook commit-msg non installé${NC}"
    echo -e "${YELLOW}   Exécutez: scripts/install-hooks.sh${NC}"
    INSTALL_COMMIT_MSG="missing"
fi

# Résumé des résultats
echo -e "\n${BLUE}📊 Résumé des tests${NC}"
echo "=================="

echo -e "\n${BLUE}Pre-commit Hook:${NC}"
case $PRE_COMMIT_STATUS in
    "success")
        echo -e "  ${GREEN}✅ Fonctionne correctement${NC}"
        ;;
    "failed")
        echo -e "  ${RED}❌ A échoué (normal si le code a des problèmes)${NC}"
        ;;
    "missing")
        echo -e "  ${RED}❌ Script manquant${NC}"
        ;;
esac

echo -e "\n${BLUE}Commit-msg Hook - Résultats des tests:${NC}"
for result in "${COMMIT_MSG_RESULTS[@]}"; do
    echo "  $result"
done

echo -e "\n${BLUE}Installation:${NC}"
if [ "$INSTALL_PRE_COMMIT" = "installed" ] && [ "$INSTALL_COMMIT_MSG" = "installed" ]; then
    echo -e "  ${GREEN}✅ Tous les hooks sont installés${NC}"
    OVERALL_STATUS="success"
elif [ "$INSTALL_PRE_COMMIT" = "missing" ] || [ "$INSTALL_COMMIT_MSG" = "missing" ]; then
    echo -e "  ${YELLOW}⚠️  Certains hooks ne sont pas installés${NC}"
    echo -e "  ${YELLOW}   Solution: scripts/install-hooks.sh${NC}"
    OVERALL_STATUS="partial"
fi

# Conclusion
echo -e "\n${BLUE}🎯 Conclusion${NC}"
echo "============"

if [ "$OVERALL_STATUS" = "success" ]; then
    echo -e "${GREEN}🎉 Tous les hooks fonctionnent correctement!${NC}"
    echo -e "${GREEN}Le système de qualité de code est opérationnel.${NC}"
elif [ "$OVERALL_STATUS" = "partial" ]; then
    echo -e "${YELLOW}⚠️  Configuration partielle${NC}"
    echo -e "${YELLOW}Installez les hooks manquants avec: scripts/install-hooks.sh${NC}"
else
    echo -e "${RED}❌ Problèmes détectés${NC}"
    echo -e "${RED}Vérifiez la configuration des hooks${NC}"
fi

echo -e "\n${BLUE}ℹ️  Commandes utiles:${NC}"
echo -e "${BLUE}  • Installer les hooks: scripts/install-hooks.sh${NC}"
echo -e "${BLUE}  • Tester pre-commit: scripts/pre-commit-hook.sh${NC}"
echo -e "${BLUE}  • Tester ce script: scripts/test-hooks.sh${NC}"

exit 0