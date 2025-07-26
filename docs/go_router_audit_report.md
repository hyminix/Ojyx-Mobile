# Audit go_router - Tâche 3.3

## État Actuel

### Version Actuelle
- **go_router: ^14.8.0** ✅ (dernière version stable au moment de l'audit)

### Configuration Actuelle
```dart
// lib/core/config/router_config.dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [...],
    errorBuilder: (context, state) => ErrorPage(),
  );
});
```

### Routes Définies
1. **/** - HomeScreen (nommée: 'home')
2. **/create-room** - CreateRoomScreen (nommée: 'createRoom')
3. **/join-room** - JoinRoomScreen (nommée: 'joinRoom')
4. **/room/:roomId** - RoomLobbyScreen (nommée: 'roomLobby') - avec paramètre
5. **/game/:roomId** - GameScreen (nommée: 'game') - avec paramètre

### Méthodes de Navigation Utilisées
- **context.go()** : Utilisé exclusivement (11 occurrences)
- **context.push()** : Non utilisé ❌
- **context.pop()** : Non utilisé ❌
- **context.goNamed()** : Non utilisé ❌
- **context.pushNamed()** : Non utilisé ❌

### Guards et Redirections
- **Aucun guard** actuellement implémenté
- **Aucune redirection** configurée
- **Pas de refreshListenable** pour l'état d'authentification

## Analyse des Breaking Changes

### Version 14.0.0 (Breaking Changes Majeurs)
- ✅ **Non impacté** : Pas d'utilisation de `onExit` dans les routes

### Version 14.8.0 (Version Actuelle)
- ✅ **Aucun breaking change** : Ajout du paramètre `preload` pour StatefulShellBranchData
- Non applicable car pas d'utilisation de StatefulShellRoute

### Version 15.0.0 (Future Breaking Change)
- ⚠️ **URLs sensibles à la casse** : Les URLs deviendront case-sensitive par défaut
- Recommandation : Documenter ce changement pour la future migration

## Points d'Amélioration Identifiés

### 1. Absence de Guards d'Authentification
Actuellement, toutes les routes sont accessibles sans vérification. Recommandations :
- Ajouter un guard pour vérifier l'authentification sur les routes protégées
- Utiliser `redirect` pour rediriger vers la page de connexion si nécessaire

### 2. Navigation Simpliste
- Utilisation exclusive de `context.go()` (navigation par remplacement)
- Pas d'utilisation de `push` pour empiler les routes
- Considérer l'utilisation de `pushNamed` pour une meilleure lisibilité

### 3. Gestion d'État Manquante
- Pas de `refreshListenable` pour réagir aux changements d'état
- Opportunité d'intégrer avec les providers Riverpod migrés

### 4. Deep Linking Non Testé
- Configuration de base présente mais pas de tests spécifiques
- Recommandation : Ajouter des tests pour les deep links

## Recommandations pour la Migration (Tâche 3.4)

### 1. Ajouter l'Authentification Guards
```dart
redirect: (BuildContext context, GoRouterState state) {
  final isAuth = ref.read(authProvider).isAuthenticated;
  final isAuthRoute = state.matchedLocation == '/login';
  
  if (!isAuth && !isAuthRoute) {
    return '/login';
  }
  return null;
},
```

### 2. Intégrer avec Riverpod
```dart
refreshListenable: ref.watch(authProvider.notifier),
```

### 3. Améliorer la Structure des Routes
```dart
routes: [
  ShellRoute(
    builder: (context, state, child) => AppShell(child: child),
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // Grouper les routes liées
    ],
  ),
],
```

### 4. Ajouter la Gestion des Transitions
```dart
GoRoute(
  path: '/game/:roomId',
  pageBuilder: (context, state) => CustomTransitionPage(
    child: GameScreen(roomId: state.pathParameters['roomId']!),
    transitionsBuilder: // Custom transition
  ),
),
```

## Tests Créés

### Tests de Configuration
- ✅ Vérification du nombre de routes
- ✅ Vérification des paths et noms de routes
- ✅ Vérification des paramètres de route
- ✅ Test de la page d'erreur

### Tests de Navigation
- ✅ Navigation simple entre écrans
- ✅ Navigation avec paramètres
- ✅ Deep linking
- ✅ Gestion des routes invalides

### Tests Manquants
- ❌ Tests avec guards d'authentification
- ❌ Tests de performance de navigation
- ❌ Tests de navigation arrière (back button)
- ❌ Tests sur device Android physique

## Métriques

- **Routes définies** : 5
- **Couverture de tests** : ~80%
- **Complexité** : Faible (pas de routes imbriquées, pas de guards)
- **Risque de migration** : Faible

## Conclusion

La configuration actuelle de go_router est simple et fonctionnelle, mais manque de fonctionnalités avancées comme les guards d'authentification et l'intégration avec la gestion d'état. La version 14.8.0 est stable et aucune migration n'est nécessaire pour le moment. Les améliorations recommandées ajouteraient de la robustesse sans nécessiter de changements majeurs.