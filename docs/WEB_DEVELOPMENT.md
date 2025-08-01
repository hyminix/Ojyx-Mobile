# Guide de Développement Web Ojyx

## 🚀 Configuration Rapide

### 1. Première utilisation
```bash
# Activer le support web (déjà fait)
flutter config --enable-web

# Créer la plateforme web (déjà fait)
flutter create --platforms=web .
```

### 2. Lancement rapide
```bash
# Un seul joueur (port 3000)
./scripts/web_dev.sh

# Deux joueurs (ports 3000 et 3001)
./scripts/web_2players.sh

# Quatre joueurs (ports 3000 à 3003)
./scripts/web_4players.sh
```

## 📱 Mobile Simulator

Sur les écrans larges (> 1920px), l'application s'affiche automatiquement dans un simulateur de Google Pixel 9 :
- **Dimensions** : 580 x 1300 pixels
- **Adapté pour écran 5120x1440** : Peut afficher jusqu'à 8 instances côte à côte !
- **Désactivation** : Ajouter `--dart-define=ENABLE_SIMULATOR=false`

## 🎮 Test Multijoueur

### Workflow optimal sur écran ultra-wide (5120x1440)

1. **Lancer 4 joueurs simultanés** :
```bash
./scripts/web_4players.sh
```

2. **Organiser les fenêtres** :
   - Joueur 1 : http://localhost:3000 (coin supérieur gauche)
   - Joueur 2 : http://localhost:3001 (coin supérieur droit)
   - Joueur 3 : http://localhost:3002 (coin inférieur gauche)
   - Joueur 4 : http://localhost:3003 (coin inférieur droit)

3. **Arrêter toutes les instances** :
```bash
# Ctrl+C dans le terminal, puis :
killall flutter
```

## 🔧 Variables d'Environnement

Les variables sont automatiquement chargées depuis `.env` ou peuvent être overridées :

```bash
# Avec variables custom
SUPABASE_URL=https://your-project.supabase.co \
SUPABASE_ANON_KEY=your-key \
./scripts/web_dev.sh
```

## 🏗️ Build Production

```bash
# Build optimisé avec injection des variables
./scripts/web_build.sh

# Tester le build localement
cd build/web
python3 -m http.server 8000
# Ouvrir http://localhost:8000
```

## 📊 Avantages du Développement Web

| Aspect | Android | Web |
|--------|---------|-----|
| Hot Reload | 5-10s | < 1s |
| Build APK | 50s | N/A |
| Installation | 30s par device | 0s |
| Multi-joueur | 2 téléphones max | 8+ onglets |
| Debug | adb logcat | Console Chrome |
| Network | Difficile | Network tab |

## 🎯 Cas d'Usage

### Développement Feature
```bash
# Lancer un seul joueur pour développer
./scripts/web_dev.sh

# Hot reload instantané avec 'r' dans le terminal
# Hot restart avec 'R'
```

### Test Multijoueur
```bash
# Tester une partie à 2
./scripts/web_2players.sh

# Créer une room dans le premier onglet
# Rejoindre avec le code dans le second
```

### Debug Realtime
```bash
# Lancer avec logs détaillés
flutter run -d chrome --web-port=3000 -v

# Ouvrir Chrome DevTools (F12)
# Onglet Network → WS pour voir les WebSockets Supabase
```

## ⚠️ Limitations Web

- **Path Provider** : Pas de système de fichiers local
- **Vibrations** : Non supportées sur web
- **Permissions** : Pas de demande de permissions
- **Performance** : Légèrement moins performant qu'Android natif

## 🔍 Troubleshooting

### Port déjà utilisé
```bash
# Trouver le processus
lsof -i :3000
# Tuer le processus
kill -9 <PID>
```

### Variables non chargées
```bash
# Vérifier le fichier .env
cat .env

# Lancer avec --dart-define explicite
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

### Simulator ne s'affiche pas
- Vérifier la largeur d'écran (doit être > 1920px)
- Vérifier que `ENABLE_SIMULATOR=true`
- Inspecter avec Chrome DevTools

## 📈 Workflow Recommandé

1. **Développement** : Web avec hot reload
2. **Test multijoueur** : 2-4 instances web
3. **Validation** : Test sur vrais devices Android
4. **Release** : Build APK optimisé

## 🚦 Commandes Utiles

```bash
# Lister les devices disponibles
flutter devices

# Nettoyer le cache
flutter clean

# Mettre à jour les dépendances
flutter pub get

# Analyser le code
flutter analyze

# Formatter le code
dart format .
```

## 💡 Tips & Tricks

1. **Multi-écrans** : Utilisez des bureaux virtuels pour plus de joueurs
2. **Profiles Chrome** : Créez des profils séparés pour éviter les conflits de cache
3. **Raccourcis** : Ajoutez les scripts dans votre IDE pour lancement rapide
4. **Performance** : Fermez les onglets inutiles pour de meilleures performances

---

*Dernière mise à jour : 2025-08-01*