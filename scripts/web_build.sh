#!/bin/bash

# Script de build web pour production
# Remplace les placeholders dans index.html avec les vraies valeurs

echo "🔨 Build de production Ojyx Web..."

# Charger les variables depuis .env si le fichier existe
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Variables par défaut si non définies
SUPABASE_URL=${SUPABASE_URL:-"https://ftvuvpqdrzofnskvlfde.supabase.co"}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0dnV2cHFkcnpvZm5za3ZsZmRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNjI3MDAsImV4cCI6MjA0NjczODcwMH0.YOjECJG0mMbg7C6jjcUBRXHAGfRgRoGYzbfhLOmGrCQ"}
SENTRY_DSN=${SENTRY_DSN:-"https://58e656db87551e84c0cc5f9e87c1f4fa@o4508735570624512.ingest.us.sentry.io/4508735573573632"}

# Build Flutter web
echo "Building Flutter web..."
flutter build web --release \
    --dart-define=SUPABASE_URL=$SUPABASE_URL \
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
    --dart-define=SENTRY_DSN=$SENTRY_DSN \
    --dart-define=ENABLE_SIMULATOR=false

# Remplacer les placeholders dans index.html
echo "Injecting environment variables..."
if [ -f build/web/index.html ]; then
    # Créer une copie de sauvegarde
    cp build/web/index.html build/web/index.html.bak
    
    # Remplacer les placeholders
    sed -i "s|%SUPABASE_URL%|$SUPABASE_URL|g" build/web/index.html
    sed -i "s|%SUPABASE_ANON_KEY%|$SUPABASE_ANON_KEY|g" build/web/index.html
    sed -i "s|%SENTRY_DSN%|$SENTRY_DSN|g" build/web/index.html
    
    echo "✅ Build completed successfully!"
    echo "📁 Output: build/web/"
    echo ""
    echo "Pour tester le build localement :"
    echo "  cd build/web && python3 -m http.server 8000"
    echo ""
    echo "Puis ouvrir : http://localhost:8000"
else
    echo "❌ Erreur : build/web/index.html non trouvé"
    exit 1
fi