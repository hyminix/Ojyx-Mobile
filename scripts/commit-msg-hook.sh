#!/bin/bash

# Commit-msg hook pour Ojyx - Validation des messages de commit
# Ce script valide le format des messages de commit selon les conventions

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

echo -e "${BLUE}📝 Validation du message de commit${NC}"
echo "=================================="

# Ignorer les messages de merge et de revert
if echo "$COMMIT_MSG" | grep -q "^Merge\|^Revert"; then
    echo -e "${GREEN}✅ Message de merge/revert accepté${NC}"
    exit 0
fi

# Format attendu: type(scope?): description
# Exemples valides:
# feat: add new game feature
# fix(ui): correct button alignment
# test(game): add unit tests for card logic
# docs: update README
# chore(deps): update dependencies

VALID_TYPES="feat|fix|docs|style|refactor|test|chore|perf|ci|build"
PATTERN="^($VALID_TYPES)(\(.+\))?: .{1,50}$"

if echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
    echo -e "${GREEN}✅ Format de message valide${NC}"
    
    # Vérifications supplémentaires
    TYPE=$(echo "$COMMIT_MSG" | sed -E "s/^($VALID_TYPES)(\(.+\))?: .*/\1/")
    DESCRIPTION=$(echo "$COMMIT_MSG" | sed -E "s/^($VALID_TYPES)(\(.+\))?: (.*)/\3/")
    
    # Vérifier que la description commence par une minuscule
    if echo "$DESCRIPTION" | grep -q "^[A-Z]"; then
        echo -e "${YELLOW}⚠️  Recommandation: La description devrait commencer par une minuscule${NC}"
    fi
    
    # Vérifier que la description ne finit pas par un point
    if echo "$DESCRIPTION" | grep -q "\.$"; then
        echo -e "${YELLOW}⚠️  Recommandation: La description ne devrait pas finir par un point${NC}"
    fi
    
    echo -e "${BLUE}Type: $TYPE${NC}"
    echo -e "${BLUE}Description: $DESCRIPTION${NC}"
    exit 0
else
    echo -e "${RED}❌ Format de message invalide!${NC}"
    echo ""
    echo -e "${YELLOW}Format attendu:${NC}"
    echo -e "${YELLOW}  type(scope?): description${NC}"
    echo ""
    echo -e "${YELLOW}Types valides:${NC}"
    echo -e "${YELLOW}  • feat: nouvelle fonctionnalité${NC}"
    echo -e "${YELLOW}  • fix: correction de bug${NC}"
    echo -e "${YELLOW}  • docs: documentation${NC}"
    echo -e "${YELLOW}  • style: formatage, style${NC}"
    echo -e "${YELLOW}  • refactor: refactoring${NC}"
    echo -e "${YELLOW}  • test: ajout/modification de tests${NC}"
    echo -e "${YELLOW}  • chore: tâches de maintenance${NC}"
    echo -e "${YELLOW}  • perf: amélioration de performance${NC}"
    echo -e "${YELLOW}  • ci: configuration CI/CD${NC}"
    echo -e "${YELLOW}  • build: configuration de build${NC}"
    echo ""
    echo -e "${YELLOW}Exemples valides:${NC}"
    echo -e "${YELLOW}  feat: add multiplayer game mode${NC}"
    echo -e "${YELLOW}  fix(ui): correct card animation${NC}"
    echo -e "${YELLOW}  test(game): add unit tests for scoring${NC}"
    echo -e "${YELLOW}  docs: update installation guide${NC}"
    echo ""
    echo -e "${YELLOW}Votre message:${NC}"
    echo -e "${RED}  $COMMIT_MSG${NC}"
    
    exit 1
fi