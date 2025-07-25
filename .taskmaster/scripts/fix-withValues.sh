#!/bin/bash
# fix-withValues.sh - Corriger les withOpacity vers withValues correctement

set -e

echo "🔧 Correction de withOpacity vers withValues..."

# Fonction pour corriger withValues
fix_withValues() {
    local file=$1
    echo "  Fixing: $file"
    
    # Remplacer .withValues(opacity: x) par .withAlpha((x * 255).round())
    sed -i 's/\.withValues(opacity: \([^)]*\))/.withAlpha((\1 * 255).round())/g' "$file"
}

# Trouver tous les fichiers avec l'erreur
while IFS= read -r file; do
    fix_withValues "$file"
done < <(grep -l "withValues(opacity:" lib test -r 2>/dev/null || true)

echo "✅ Corrections terminées!"