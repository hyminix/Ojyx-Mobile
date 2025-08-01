#!/bin/bash

# Lance 2 instances pour tester le multijoueur
# Utilise des ports 3000 et 3001

echo "🎮 Lancement de 2 joueurs Ojyx..."
echo "📱 Joueur 1 : http://localhost:3000"
echo "📱 Joueur 2 : http://localhost:3001"
echo ""

# Charger les variables depuis .env si le fichier existe
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Variables par défaut si non définies
SUPABASE_URL=${SUPABASE_URL:-"https://ftvuvpqdrzofnskvlfde.supabase.co"}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0dnV2cHFkcnpvZm5za3ZsZmRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNjI3MDAsImV4cCI6MjA0NjczODcwMH0.YOjECJG0mMbg7C6jjcUBRXHAGfRgRoGYzbfhLOmGrCQ"}
SENTRY_DSN=${SENTRY_DSN:-"https://58e656db87551e84c0cc5f9e87c1f4fa@o4508735570624512.ingest.us.sentry.io/4508735573573632"}

# Lancer le joueur 1 en arrière-plan
echo "Lancement Joueur 1..."
flutter run -d chrome \
    --web-port=3000 \
    --dart-define=SUPABASE_URL=$SUPABASE_URL \
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
    --dart-define=SENTRY_DSN=$SENTRY_DSN \
    --dart-define=ENABLE_SIMULATOR=true &

# Attendre un peu avant de lancer le second
sleep 5

# Lancer le joueur 2
echo "Lancement Joueur 2..."
flutter run -d chrome \
    --web-port=3001 \
    --dart-define=SUPABASE_URL=$SUPABASE_URL \
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
    --dart-define=SENTRY_DSN=$SENTRY_DSN \
    --dart-define=ENABLE_SIMULATOR=true

# Note: Le second flutter run reste au premier plan
# Pour arrêter les deux instances, utilisez Ctrl+C puis killall flutter