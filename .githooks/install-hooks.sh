#!/bin/bash

# Script d'installation des git hooks pour Ojyx

echo "📦 Installation des git hooks pour Ojyx..."

# Configurer Git pour utiliser le dossier .githooks
git config core.hooksPath .githooks

echo "✅ Git hooks installés avec succès!"
echo ""
echo "Les hooks suivants sont maintenant actifs:"
echo "  - pre-commit: Vérifie le respect des règles TDD avant chaque commit"
echo ""
echo "Pour désactiver temporairement les hooks (NON RECOMMANDÉ):"
echo "  git commit --no-verify"
echo ""
echo "⚠️  ATTENTION: Le contournement des règles TDD est détecté par la CI/CD"