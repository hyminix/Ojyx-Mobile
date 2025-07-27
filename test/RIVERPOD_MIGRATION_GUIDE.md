# Guide de Migration des Tests Riverpod 2.6.1

## Vue d'ensemble

Ce guide documente la migration des tests Riverpod vers la version 2.6.1. Les changements principaux concernent l'utilisation des helpers de test et des bonnes pratiques.

## Changements Principaux

### 1. Utilisation des Helpers de Test

Un nouveau fichier `test/helpers/riverpod_test_helpers.dart` a été créé avec des utilitaires pour simplifier les tests :

#### Création de Container

**Avant :**
```dart
setUp(() {
  container = ProviderContainer(
    overrides: [/* ... */],
  );
});

tearDown(() {
  container.dispose();
});
```

**Après :**
```dart
setUp(() {
  // createTestContainer gère automatiquement la disposal
  container = createTestContainer(
    overrides: [/* ... */],
  );
});
// Plus besoin de tearDown pour dispose
```

#### Tests de Widgets

**Avant :**
```dart
await tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: MyWidget(),
      ),
    ),
  ),
);

// Accès au container
final container = ProviderScope.containerOf(
  tester.element(find.byType(MyWidget)),
);
```

**Après :**
```dart
// Utilisation du helper
await tester.pumpRiverpodApp(
  child: Scaffold(
    body: MyWidget(),
  ),
);

// Accès simplifié au container
final container = tester.container();
```

### 2. Test des AsyncValue

Les helpers incluent des extensions pour tester les `AsyncValue` :

```dart
test('should handle async states', () async {
  final stateListener = createStateListener<AsyncValue<User?>>();
  
  container.listen(
    authNotifierProvider,
    stateListener,
    fireImmediately: true,
  );
  
  await container.read(authNotifierProvider.future);
  
  // Utilisation des extensions
  expect(stateListener.states.first.isLoading, isTrue);
  expect(stateListener.states.last.hasValue, isTrue);
  expect(stateListener.states.last.valueOrNull, equals(mockUser));
  expect(stateListener.states.last.errorOrNull, isNull);
});
```

### 3. Mocks Simplifiés

Des mocks de base sont fournis pour les patterns courants :

```dart
// Mock StateNotifier
final mockNotifier = MockStateNotifier<MyState>(initialState);

// Mock Notifier
final mockNotifier = MockNotifier<MyState>(initialState);

// Mock AsyncNotifier
final mockAsyncNotifier = MockAsyncNotifier<MyData>(
  AsyncValue.data(initialData),
);
```

### 4. Test avec Timeout

Pour éviter les tests qui bloquent :

```dart
test('should complete within timeout', () async {
  final result = await expectLater(
    () async => await container.read(myAsyncProvider.future),
    timeout: const Duration(seconds: 3),
  );
  
  expect(result, isNotNull);
});
```

## Patterns de Migration

### Pattern 1 : Tests Unitaires de Providers

```dart
// Version migrée
void main() {
  group('MyProvider', () {
    test('should provide correct value', () {
      final container = createTestContainer(
        overrides: [
          dependencyProvider.overrideWithValue(mockValue),
        ],
      );
      
      final value = container.read(myProvider);
      expect(value, equals(expectedValue));
    });
  });
}
```

### Pattern 2 : Tests de Widgets avec État

```dart
// Version migrée
testWidgets('should update UI on state change', (tester) async {
  await tester.pumpRiverpodApp(
    child: MyStatefulWidget(),
  );
  
  final container = tester.container();
  
  // Modifier l'état
  container.read(myStateProvider.notifier).updateState();
  await tester.pump();
  
  // Vérifier l'UI
  expect(find.text('Updated'), findsOneWidget);
});
```

### Pattern 3 : Tests d'Intégration

```dart
// Version migrée
testWidgets('should handle complete flow', (tester) async {
  final mockService = MockService();
  
  await tester.pumpRiverpodApp(
    child: MyApp(),
    overrides: [
      serviceProvider.overrideWithValue(mockService),
    ],
  );
  
  // Simuler interaction utilisateur
  await tester.tap(find.byKey(Key('action_button')));
  await tester.pumpAndSettle();
  
  // Vérifier les appels
  verify(() => mockService.performAction()).called(1);
});
```

## Checklist de Migration

Pour chaque fichier de test :

- [ ] Remplacer la création manuelle de `ProviderContainer` par `createTestContainer()`
- [ ] Retirer les `tearDown` qui ne font que `container.dispose()`
- [ ] Utiliser `tester.pumpRiverpodApp()` pour les widget tests
- [ ] Remplacer `ProviderScope.containerOf()` par `tester.container()`
- [ ] Utiliser les extensions `AsyncValue` pour les assertions
- [ ] Implémenter `StateListener` pour observer les changements d'état
- [ ] Ajouter des timeouts aux tests asynchrones si nécessaire
- [ ] Utiliser les mocks helpers pour les notifiers

## Fichiers à Migrer

### Priorité Haute (Tests critiques)
- [x] `auth_provider_test.dart` → `auth_provider_test_v2.dart`
- [x] `player_grid_selection_test.dart` → `player_grid_selection_test_v2.dart`
- [ ] `game_state_notifier_test.dart`
- [ ] `card_selection_provider_test.dart`
- [ ] `action_card_providers_test.dart`

### Priorité Moyenne
- [ ] `game_animation_provider_test.dart`
- [ ] `end_game_provider_test.dart`
- [ ] `global_score_providers_test.dart`
- [ ] `supabase_provider_test.dart`

### Priorité Basse
- [ ] Tous les tests d'intégration
- [ ] Tests de navigation
- [ ] Tests de widgets simples

## Notes Importantes

1. **Pas de package séparé** : Les utilitaires de test sont intégrés dans `flutter_riverpod`
2. **Disposal automatique** : `createTestContainer()` utilise `addTearDown` pour la disposal
3. **Extensions pratiques** : Les extensions sur `WidgetTester` simplifient l'accès au container
4. **Mocks réutilisables** : Les mocks de base couvrent la plupart des cas d'usage

## Prochaines Étapes

1. Migrer tous les tests par ordre de priorité
2. Supprimer les anciens fichiers de test après validation
3. Mettre à jour la documentation des tests
4. Former l'équipe sur les nouveaux patterns