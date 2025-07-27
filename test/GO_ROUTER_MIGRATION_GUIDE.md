# Guide de Migration des Tests go_router v16

Ce guide documente la migration des tests de navigation pour go_router v16 dans le projet Ojyx.

## Vue d'ensemble

La migration se concentre sur l'amélioration de la testabilité et l'utilisation de patterns modernes pour les tests de navigation.

## Changements principaux

### 1. Nouveaux Helpers de Test

#### `go_router_test_helpers.dart`

Nouveaux helpers créés pour simplifier les tests :

- **`MockGoRouter`** : Mock principal pour go_router
- **`MockGoRouterProvider`** : Widget pour injecter le mock dans l'arbre
- **`createTestRouter`** : Création rapide de router pour tests
- **`createMockRouterApp`** : App complète avec mock router
- **`setupNavigationStubs`** : Configuration des stubs de navigation

### 2. Patterns de Test

#### Avant (Pattern basique)
```dart
testWidgets('navigation test', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp.router(
        routerConfig: GoRouter(
          routes: [...],
        ),
      ),
    ),
  );
  
  // Test navigation
});
```

#### Après (Avec MockGoRouter)
```dart
testWidgets('navigation test', (tester) async {
  final mockRouter = MockGoRouter();
  setupNavigationStubs(mockRouter);
  
  await tester.pumpWidget(
    createMockRouterApp(
      mockRouter: mockRouter,
      child: YourWidget(),
    ),
  );
  
  // Test navigation
  await tester.tap(find.text('Navigate'));
  
  // Verify navigation
  mockRouter.verifyGo('/destination');
});
```

### 3. Extensions de Vérification

Nouvelles extensions pour simplifier les assertions :

```dart
// Vérifier navigation simple
mockRouter.verifyGo('/path');

// Vérifier navigation nommée avec paramètres
mockRouter.verifyGoNamed(
  'routeName',
  pathParameters: {'id': '123'},
);

// Vérifier aucune navigation
mockRouter.verifyNoNavigation();
```

### 4. Test des Deep Links

Helper dédié pour tester les deep links :

```dart
final deepLinkHelper = DeepLinkTestHelper(router);

// Simuler un deep link
await deepLinkHelper.simulateDeepLink('/room/123?invite=ABC');

// Vérifier la location
expect(deepLinkHelper.currentLocation, '/room/123');
expect(deepLinkHelper.isAtRoute('/room/123'), isTrue);
```

### 5. Observateurs de Navigation

Support amélioré pour les observateurs :

```dart
final observer = TestNavigatorObserver();

final router = createTestRouter(
  initialLocation: '/',
  routes: [...],
  observers: [observer],
);

// Après navigation
expect(observer.pushedRoutes.length, greaterThan(0));
```

## Checklist de Migration

Pour chaque fichier de test de navigation :

- [ ] Importer `go_router_test_helpers.dart`
- [ ] Remplacer `ProviderContainer()` par `createTestContainer()`
- [ ] Utiliser `MockGoRouter` pour les tests unitaires de navigation
- [ ] Utiliser `createTestRouter` pour les tests d'intégration
- [ ] Remplacer les assertions manuelles par les extensions de vérification
- [ ] Ajouter des tests pour les query parameters si nécessaire
- [ ] Tester les guards de navigation avec des mocks appropriés

## Exemples de Migration

### Test de Navigation Simple

**Avant :**
```dart
await tester.tap(find.text('Navigate'));
await tester.pumpAndSettle();
expect(find.text('Destination Screen'), findsOneWidget);
```

**Après :**
```dart
await tester.tap(find.text('Navigate'));
await tester.pumpAndSettle();
mockRouter.verifyGo('/destination');
```

### Test avec Paramètres

**Avant :**
```dart
context.go('/room/$roomId');
// Vérifier manuellement que la navigation s'est produite
```

**Après :**
```dart
context.goNamed('roomLobby', pathParameters: {'roomId': roomId});
mockRouter.verifyGoNamed('roomLobby', pathParameters: {'roomId': roomId});
```

### Test de Guards

**Avant :**
```dart
// Tests complexes avec états d'authentification
```

**Après :**
```dart
testWidgets('should redirect unauthenticated users', (tester) async {
  bool isAuthenticated = false;
  
  final router = createTestRouter(
    initialLocation: '/protected',
    routes: [...],
    redirect: (context, state) {
      if (!isAuthenticated) return '/login';
      return null;
    },
  );
  
  // Test que la redirection fonctionne
});
```

## Bonnes Pratiques

1. **Séparer les tests unitaires et d'intégration**
   - Unitaires : Utiliser `MockGoRouter`
   - Intégration : Utiliser `createTestRouter`

2. **Toujours initialiser les stubs**
   ```dart
   setUp(() {
     mockRouter = MockGoRouter();
     setupNavigationStubs(mockRouter);
   });
   ```

3. **Utiliser les helpers pour la création d'apps**
   - `createMockRouterApp` pour les tests avec mocks
   - `createRouterApp` pour les tests d'intégration

4. **Tester les cas d'erreur**
   - Routes invalides
   - Paramètres manquants
   - Guards de navigation

5. **Documenter les comportements complexes**
   - Deep links avec query parameters
   - Navigation avec état préservé
   - Redirections conditionnelles

## Fichiers Migrés

- [x] `test/helpers/go_router_test_helpers.dart` - Créé
- [x] `test/navigation/router_config_test_migrated.dart` - Exemple de migration
- [ ] `test/navigation/router_with_guards_test.dart`
- [ ] `test/navigation/router_v2_simple_test.dart`
- [ ] `test/integration/deep_links_test.dart`
- [ ] `test/integration/state_management_navigation_test.dart`

## Notes de Compatibilité

- go_router v16 est rétrocompatible avec v15
- Les nouveaux patterns sont optionnels mais recommandés
- `InheritedGoRouter` est maintenant exporté par défaut
- Support amélioré pour les `StatefulShellRoute`