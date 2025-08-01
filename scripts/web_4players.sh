#!/bin/bash

# Lance 4 instances pour tester le multijoueur avec 4 joueurs
# Utilise des ports 3000 à 3003

echo "🎮 Lancement de 4 joueurs Ojyx..."
echo "📱 Joueur 1 : http://localhost:3000"
echo "📱 Joueur 2 : http://localhost:3001"
echo "📱 Joueur 3 : http://localhost:3002"
echo "📱 Joueur 4 : http://localhost:3003"
echo ""
echo "💡 Astuce : Sur écran 5120x1440, vous pouvez afficher les 4 fenêtres côte à côte !"
echo ""

# Charger les variables depuis .env si le fichier existe
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Variables par défaut si non définies
SUPABASE_URL=${SUPABASE_URL:-"https://ftvuvpqdrzofnskvlfde.supabase.co"}
SUPABASE_ANON_KEY=${SUPABASE_ANON_KEY:-"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0dnV2cHFkcnpvZm5za3ZsZmRlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzExNjI3MDAsImV4cCI6MjA0NjczODcwMH0.YOjECJG0mMbg7C6jjcUBRXHAGfRgRoGYzbfhLOmGrCQ"}
SENTRY_DSN=${SENTRY_DSN:-"https://58e656db87551e84c0cc5f9e87c1f4fa@o4508735570624512.ingest.us.sentry.io/4508735573573632"}

# Fonction pour lancer un joueur
launch_player() {
    local port=$1
    local player_num=$2
    
    echo "Lancement Joueur $player_num sur le port $port..."
    
    flutter run -d chrome \
        --web-port=$port \
        --dart-define=SUPABASE_URL=$SUPABASE_URL \
        --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
        --dart-define=SENTRY_DSN=$SENTRY_DSN \
        --dart-define=ENABLE_SIMULATOR=true &
    
    sleep 3  # Attendre entre chaque lancement
}

# Lancer les 3 premiers joueurs en arrière-plan
launch_player 3000 1
launch_player 3001 2
launch_player 3002 3

# Lancer le 4ème joueur au premier plan
echo "Lancement Joueur 4 sur le port 3003..."
flutter run -d chrome \
    --web-port=3003 \
    --dart-define=SUPABASE_URL=$SUPABASE_URL \
    --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
    --dart-define=SENTRY_DSN=$SENTRY_DSN \
    --dart-define=ENABLE_SIMULATOR=true

# Pour arrêter toutes les instances : Ctrl+C puis killall flutter