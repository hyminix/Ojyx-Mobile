#!/bin/bash

# Script d'installation des hooks Git pour Ojyx
# Installe automatiquement les hooks pre-commit et commit-msg

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Installation des hooks Git pour Ojyx${NC}"
echo "=========================================="

# Vérifier que nous sommes dans un dépôt Git
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Erreur: Ce n'est pas un dépôt Git${NC}"
    echo -e "${YELLOW}Exécutez ce script depuis la racine du projet Ojyx${NC}"
    exit 1
fi

# Vérifier que nous avons les scripts de hooks
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRE_COMMIT_SCRIPT="$SCRIPT_DIR/pre-commit-hook.sh"
COMMIT_MSG_SCRIPT="$SCRIPT_DIR/commit-msg-hook.sh"

if [ ! -f "$PRE_COMMIT_SCRIPT" ]; then
    echo -e "${RED}❌ Erreur: Script pre-commit non trouvé: $PRE_COMMIT_SCRIPT${NC}"
    exit 1
fi

if [ ! -f "$COMMIT_MSG_SCRIPT" ]; then
    echo -e "${RED}❌ Erreur: Script commit-msg non trouvé: $COMMIT_MSG_SCRIPT${NC}"
    exit 1
fi

# Créer le dossier hooks s'il n'existe pas
HOOKS_DIR=".git/hooks"
mkdir -p "$HOOKS_DIR"

# Installer le hook pre-commit
echo -e "${BLUE}📦 Installation du hook pre-commit...${NC}"
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"

cat > "$PRE_COMMIT_HOOK" << EOF
#!/bin/bash
# Hook pre-commit généré automatiquement pour Ojyx
# Ne pas modifier ce fichier - utilisez scripts/install-hooks.sh pour réinstaller

exec "$PRE_COMMIT_SCRIPT"
EOF

chmod +x "$PRE_COMMIT_HOOK"
echo -e "${GREEN}✅ Hook pre-commit installé${NC}"

# Installer le hook commit-msg
echo -e "${BLUE}📦 Installation du hook commit-msg...${NC}"
COMMIT_MSG_HOOK="$HOOKS_DIR/commit-msg"

cat > "$COMMIT_MSG_HOOK" << EOF
#!/bin/bash
# Hook commit-msg généré automatiquement pour Ojyx
# Ne pas modifier ce fichier - utilisez scripts/install-hooks.sh pour réinstaller

exec "$COMMIT_MSG_SCRIPT" "\$1"
EOF

chmod +x "$COMMIT_MSG_HOOK"
echo -e "${GREEN}✅ Hook commit-msg installé${NC}"

# Vérifier l'installation
echo -e "\n${BLUE}🔍 Vérification de l'installation...${NC}"

if [ -x "$PRE_COMMIT_HOOK" ]; then
    echo -e "${GREEN}✅ Hook pre-commit: Installé et exécutable${NC}"
else
    echo -e "${RED}❌ Hook pre-commit: Problème d'installation${NC}"
    exit 1
fi

if [ -x "$COMMIT_MSG_HOOK" ]; then
    echo -e "${GREEN}✅ Hook commit-msg: Installé et exécutable${NC}"
else
    echo -e "${RED}❌ Hook commit-msg: Problème d'installation${NC}"
    exit 1
fi

# Afficher les informations
echo -e "\n${BLUE}📋 Hooks installés:${NC}"
echo -e "${BLUE}  • Pre-commit: Validation TDD stricte avant chaque commit${NC}"
echo -e "${BLUE}  • Commit-msg: Validation du format des messages de commit${NC}"

echo -e "\n${GREEN}🎉 Installation réussie!${NC}"
echo -e "${YELLOW}Les hooks Git sont maintenant actifs pour ce projet.${NC}"
echo -e "${YELLOW}Ils s'exécuteront automatiquement lors des commits.${NC}"

echo -e "\n${BLUE}ℹ️  Informations utiles:${NC}"
echo -e "${BLUE}  • Pour désactiver temporairement: git commit --no-verify${NC}"
echo -e "${BLUE}  • Pour réinstaller: scripts/install-hooks.sh${NC}"
echo -e "${BLUE}  • Pour tester: scripts/pre-commit-hook.sh${NC}"

echo -e "\n${YELLOW}⚠️  Rappel TDD:${NC}"
echo -e "${YELLOW}  • Tous les tests doivent passer avant commit${NC}"
echo -e "${YELLOW}  • Code correctement formaté requis${NC}"
echo -e "${YELLOW}  • Tests commentés strictement interdits${NC}"
echo -e "${YELLOW}  • Couverture minimum 80% recommandée${NC}"

exit 0