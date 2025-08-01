#!/bin/bash

# Script de développement web pour Ojyx
# Lance Flutter web avec les variables d'environnement

# Charger les variables depuis .env si le fichier existe
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Variables par défaut si non définies
SUPABASE_URL=${SUPABASE_URL:-"https://ftvuvpqdrzofnskvlfde.supabase.co"}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0dnV2cHFkcnpvZm5za3ZsZmRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNjI3MDAsImV4cCI6MjA0NjczODcwMH0.YOjECJG0mMbg7C6jjcUBRXHAGfRgRoGYzbfhLOmGrCQ"}
SENTRY_DSN=${SENTRY_DSN:-"https://58e656db87551e84c0cc5f9e87c1f4fa@o4508735570624512.ingest.us.sentry.io/4508735573573632"}

# Port par défaut
PORT=${1:-3000}

echo "🚀 Lancement d'Ojyx Web sur le port $PORT"
echo "📱 Simulator activé pour écrans > 1920px"
echo ""

# Lancer Flutter web avec les variables d'environnement
flutter run -d chrome \
    --web-port=$PORT \
    --dart-define=SUPABASE_URL=$SUPABASE_URL \
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
    --dart-define=SENTRY_DSN=$SENTRY_DSN \
    --dart-define=ENABLE_SIMULATOR=true