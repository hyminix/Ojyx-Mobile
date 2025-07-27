# Guide du Développeur Ojyx

## 🚀 Quick Start

```bash
# 1. Setup initial
./dev-scripts/setup-dev.sh

# 2. Configurer .env
cp .env.example .env
# Éditer .env avec vos clés Supabase

# 3. Lancer l'app
./dev-scripts/quick-run.sh
```

## 📁 Structure du Projet

```
ojyx/
├── .vscode/              # Configuration VS Code
│   ├── settings.json     # Paramètres projet
│   ├── launch.json       # Configurations de lancement
│   ├── tasks.json        # Tâches automatisées
│   └── ojyx.code-snippets # Snippets personnalisés
├── dev-scripts/          # Scripts d'automatisation
│   ├── quick-run.sh      # Lancement rapide
│   ├── clean-build.sh    # Clean + rebuild
│   ├── generate.sh       # Génération de code
│   └── setup-dev.sh      # Setup initial
├── scripts/
│   └── emulator/         # Gestion émulateur Android
├── lib/                  # Code source Flutter
│   ├── core/            # Configuration, services
│   └── features/        # Clean Architecture
└── .env.example         # Template variables
```

## 🛠️ Environnement de Développement

### VS Code (Recommandé)

1. **Extensions requises** :
   - Flutter
   - Dart
   - Awesome Flutter Snippets
   - Error Lens

2. **Raccourcis configurés** :
   - `F5` : Lancer en debug
   - `Ctrl+S` : Save + Format + Hot Reload
   - `Ctrl+Shift+R` : Hot Restart
   - `Alt+W` : Wrap with Widget

3. **Snippets Ojyx** :
   - `riverpod-provider` : Provider moderne
   - `freezed-model` : Modèle avec JSON
   - `ojyx-screen` : Écran complet
   - `game-state` : État de jeu

### Émulateur Android Optimisé

```bash
# Créer l'émulateur (une fois)
./scripts/emulator/create-emulator.sh

# Démarrer (5-10s avec snapshot)
./scripts/emulator/start-emulator.sh

# Sauvegarder état
./scripts/emulator/save-snapshot.sh ojyx_ready
```

## 🔄 Workflow de Développement

### Feature-First Approach

1. **Implémenter** directement la fonctionnalité
2. **Tester** manuellement le comportement
3. **Itérer** selon les retours
4. **Stabiliser** une fois validé
5. **Ajouter tests** sur parties critiques

### Commandes Quotidiennes

```bash
# Développement
ojyx-run          # Lance avec hot reload
ojyx-gen          # Génère code (Freezed, Riverpod)

# Maintenance
ojyx-clean        # Clean build complet
flutter analyze   # Vérifier le code

# Git
git add .
git commit -m "feat: description"
git push
```

### Génération de Code

Après modification de :
- Modèles `@freezed`
- Providers `@riverpod`
- Classes avec `@JsonSerializable`

Exécuter :
```bash
./dev-scripts/generate.sh
```

## 🔧 Configuration

### Variables d'Environnement (.env)

```env
# Obligatoire
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=xxx

# Optionnel
SENTRY_DSN=https://xxx@sentry.io/xxx
DEBUG_MODE=true
```

### Launch Modes

- **Debug** : Hot reload, DevTools, logs complets
- **Profile** : Performance analysis
- **Release** : Build optimisé production

## 📱 Architecture

### Clean Architecture
```
feature/
├── presentation/     # UI, Widgets, Providers
├── domain/          # Logique métier, Entities
└── data/            # API, Modèles, Repositories
```

### État avec Riverpod
```dart
// Provider moderne
@riverpod
GameState gameState(GameStateRef ref) {
  return GameState();
}

// Notifier
@riverpod
class GameNotifier extends _$GameNotifier {
  @override
  GameState build() => GameState();
}
```

### Modèles avec Freezed
```dart
@freezed
class Player with _$Player {
  factory Player({
    required String id,
    required String name,
  }) = _Player;
  
  factory Player.fromJson(Map<String, dynamic> json) =>
      _$PlayerFromJson(json);
}
```

## 🐛 Debug & Performance

### Flutter DevTools
```bash
# Via VS Code
Ctrl+Shift+D

# Ou terminal
flutter pub global run devtools
```

### Outils disponibles :
- **Inspector** : Arbre de widgets
- **Performance** : Timeline, FPS
- **Network** : Requêtes Supabase
- **Memory** : Fuites mémoire

### Logs & Monitoring
```dart
// Debug logs
debugPrint('Game state: $state');

// Sentry (production)
Sentry.captureException(error, stackTrace);
```

## 🚀 Build & Release

### Build Debug
```bash
flutter build apk --debug
```

### Build Release
```bash
flutter build apk --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

## 💡 Tips & Best Practices

### Performance
- Hot reload < 1s configuré
- Utiliser `const` widgets
- Éviter rebuilds inutiles
- Profiler avec DevTools

### Code Quality
- Format automatique à la sauvegarde
- Linting non bloquant
- Génération de code pour boilerplate
- Feature-First : livrer vite, itérer

### Git
- Branches feature : `feat/nom`
- Commits conventionnels
- PR pour features majeures
- Merge dès que fonctionnel

## 🆘 Troubleshooting

### "Cannot find Flutter SDK"
```bash
export PATH="$PATH:/path/to/flutter/bin"
flutter doctor
```

### Build Runner erreurs
```bash
flutter clean
rm -rf .dart_tool
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Émulateur lent
- Vérifier accélération matérielle
- Utiliser snapshots
- Désactiver animations

### Hot Reload ne fonctionne pas
- Vérifier `Ctrl+S` sauvegarde
- Relancer avec `flutter run`
- Vérifier pas d'erreurs compilation

## 📚 Ressources

- [Documentation Flutter](https://flutter.dev/docs)
- [Riverpod 2.0](https://riverpod.dev)
- [Freezed](https://pub.dev/packages/freezed)
- [Supabase Flutter](https://supabase.com/docs/guides/with-flutter)

## 🤝 Contribution

1. Créer branche feature
2. Développer avec hot reload
3. Tester manuellement
4. Commit et push
5. Créer PR si besoin

---

*Happy coding! 🎮*