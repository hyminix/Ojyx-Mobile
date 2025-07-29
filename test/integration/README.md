# Tests d'Intégration Multijoueur - Ojyx

## Vue d'ensemble

Cette suite de tests d'intégration vérifie le bon fonctionnement du système multijoueur d'Ojyx, incluant la synchronisation réseau, la gestion des déconnexions, et la cohérence des données.

## Structure des Tests

### 1. Infrastructure (`helpers/multiplayer_test_helper.dart`)
- Classe helper pour créer et gérer des utilisateurs de test
- Simulation de connexions/déconnexions
- Création et gestion de salles et parties
- Nettoyage automatique des données de test

### 2. Tests Join/Leave Simultanés (`multiplayer/join_leave_simultaneous_test.dart`)
- Jointures multiples simultanées
- Opérations concurrentes join/leave
- Respect de la capacité maximale
- Gestion du créateur qui quitte
- Conditions de course

### 3. Tests Déconnexion/Reconnexion (`multiplayer/disconnection_reconnection_test.dart`)
- Mise à jour du statut de connexion
- Maintien dans la salle pendant déconnexion temporaire
- Reconnexion pendant le tour d'un joueur
- Timeout après 2 minutes
- Actions en attente après reconnexion

### 4. Tests de Charge 8 Joueurs (`multiplayer/load_test_8_players.dart`)
- 8 joueurs simultanés
- Actions concurrentes
- Mises à jour temps réel
- Test de stress (80 actions)
- Métriques de performance

### 5. Tests de Cohérence RLS (`multiplayer/rls_consistency_test.dart`)
- Empêcher changement de salle pendant partie
- Respect capacité maximale
- Validation des transitions d'état
- Maintenance automatique des compteurs
- Vues de monitoring

## Exécution des Tests

### Prérequis
```bash
# Variables d'environnement requises
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### Lancer tous les tests
```bash
flutter test test/integration/run_multiplayer_tests.dart \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

### Lancer un test spécifique
```bash
# Tests join/leave
flutter test test/integration/multiplayer/join_leave_simultaneous_test.dart \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# Tests déconnexion
flutter test test/integration/multiplayer/disconnection_reconnection_test.dart \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# Tests de charge
flutter test test/integration/multiplayer/load_test_8_players.dart \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

# Tests RLS
flutter test test/integration/multiplayer/rls_consistency_test.dart \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
```

### Mode verbose
```bash
flutter test test/integration/run_multiplayer_tests.dart \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
  --reporter expanded
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Integration Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  integration-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Run integration tests
      run: |
        flutter test test/integration/run_multiplayer_tests.dart \
          --dart-define=SUPABASE_URL=${{ secrets.SUPABASE_URL }} \
          --dart-define=SUPABASE_ANON_KEY=${{ secrets.SUPABASE_ANON_KEY }}
      env:
        SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
        SUPABASE_ANON_KEY: ${{ secrets.SUPABASE_ANON_KEY }}
```

## Métriques de Performance Attendues

### Temps de Réponse
- Join room: < 2 secondes
- Action individuelle: < 1 seconde
- Query simple: < 500ms
- Synchronisation 8 joueurs: < 5 secondes

### Capacité
- 8 joueurs simultanés sans dégradation
- 80 actions en < 10 secondes
- Reconnexion en < 2 secondes

## Debugging

### Logs détaillés
Les tests incluent des `print` statements pour tracer l'exécution:
- Temps d'exécution des opérations
- Nombre d'updates reçus
- Métriques de performance

### Erreurs courantes
1. **Timeout**: Augmenter les durées d'attente dans `waitForCondition`
2. **RLS errors**: Vérifier les policies dans Supabase Dashboard
3. **Connection errors**: Vérifier les credentials et la connexion réseau

## Maintenance

### Nettoyage des données
Le helper nettoie automatiquement:
- Game states et player grids
- Rooms créées
- Users de test
- Connexions realtime

### Ajout de nouveaux tests
1. Créer un nouveau fichier dans `multiplayer/`
2. Utiliser `MultiplayerTestHelper` pour la configuration
3. Importer dans `run_multiplayer_tests.dart`
4. Suivre les patterns existants

## Notes importantes

- Les tests créent de vraies données dans Supabase
- Utiliser une instance de test/staging si possible
- Le cleanup est automatique mais vérifier occasionnellement
- Les tests peuvent être affectés par la latence réseau