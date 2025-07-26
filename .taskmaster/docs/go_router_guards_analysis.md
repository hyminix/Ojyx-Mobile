# Analyse des Guards et Redirections go_router v16

## État Actuel

Le projet utilise go_router v16.0.0 avec une implémentation moderne des guards.

### Guards Implémentés

#### 1. Global Redirect (Auth Guard Principal)
```dart
redirect: (BuildContext context, GoRouterState state) {
  final isAuthenticated = authAsync.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
  
  final isPublicRoute = state.matchedLocation == '/' || 
                       state.matchedLocation == '/join-room';
  
  if (!isAuthenticated && !isPublicRoute) {
    return '/?redirect=${Uri.encodeComponent(state.uri.toString())}';
  }
  
  return null;
}
```

#### 2. Route-Level Guards
- `/create-room` - Vérifie l'authentification
- `/room/:roomId` - Vérifie l'authentification et roomId valide
- `/game/:roomId` - Vérifie l'authentification et roomId valide + TODO: vérifier appartenance

### Patterns Modernes Utilisés

1. **refreshListenable** - Réactivité sur changements auth
2. **Redirections avec paramètres** - Préserve l'URL cible
3. **Guards composables** - Global + route-specific
4. **Validation des paramètres** - roomId non null/empty

### Callbacks onEnter/onExit

**Important**: go_router n'utilise pas les callbacks onEnter/onExit. Ces concepts viennent d'autres frameworks de routing.

Pour go_router v16, les mécanismes équivalents sont:

1. **redirect** - Pour la logique avant navigation (équivalent onEnter)
2. **NavigatorObserver** - Pour les événements de navigation
3. **GoRouterObserver** - Observer spécialisé pour go_router

## Améliorations Possibles

### 1. Implémenter GoRouterObserver
```dart
class AppNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Log navigation, analytics, etc.
    SentryService.trackNavigation(
      from: previousRoute?.settings.name ?? 'unknown',
      to: route.settings.name ?? 'unknown',
    );
  }
}
```

### 2. Middleware Pattern pour Guards Réutilisables
```dart
typedef RouteGuard = FutureOr<String?> Function(
  BuildContext context,
  GoRouterState state,
);

RouteGuard requireAuth(WidgetRef ref) {
  return (context, state) {
    final hasUser = ref.read(authNotifierProvider).valueOrNull != null;
    if (!hasUser) {
      return '/?redirect=${Uri.encodeComponent(state.uri.toString())}';
    }
    return null;
  };
}

RouteGuard requireRoomMembership(WidgetRef ref) {
  return (context, state) async {
    final roomId = state.pathParameters['roomId'];
    // TODO: Vérifier l'appartenance
    return null;
  };
}
```

### 3. Guards Composables
```dart
RouteGuard composeGuards(List<RouteGuard> guards) {
  return (context, state) async {
    for (final guard in guards) {
      final result = await guard(context, state);
      if (result != null) return result;
    }
    return null;
  };
}
```

## Conclusion

Les guards et redirections sont déjà implémentés selon les meilleures pratiques de go_router v16. Les concepts onEnter/onExit ne s'appliquent pas directement, mais les fonctionnalités équivalentes sont disponibles via:

1. **redirect callbacks** - Logique avant navigation
2. **NavigatorObserver** - Événements de navigation
3. **refreshListenable** - Réactivité aux changements d'état

Le code actuel est moderne et n'a pas besoin de migration majeure pour cette partie.