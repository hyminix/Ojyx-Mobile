# Test Helpers Documentation

Ce répertoire contient des utilitaires partagés pour faciliter l'écriture des tests dans le projet Ojyx.

## Vue d'ensemble

Les helpers sont organisés par catégorie pour faciliter leur utilisation :

- **riverpod_test_helpers.dart** - Utilitaires pour tester avec Riverpod
- **go_router_test_helpers.dart** - Mocks et helpers pour la navigation
- **supabase_v2_test_helpers.dart** - Helpers pour les tests Supabase
- **supabase_test_helpers.dart** - Version future pour Supabase v3

## Utilisation

### 1. Tests Riverpod

```dart
import '../helpers/riverpod_test_helpers.dart';

void main() {
  test('should test provider', () {
    // Créer un container de test avec auto-dispose
    final container = createTestContainer(
      overrides: [
        myProvider.overrideWithValue(mockValue),
      ],
    );

    // Le container sera automatiquement disposé après le test
    final result = container.read(myProvider);
    expect(result, expectedValue);
  });

  testWidgets('should test widget with providers', (tester) async {
    await tester.pumpApp(
      MyWidget(),
      overrides: [
        myProvider.overrideWithValue(mockValue),
      ],
    );

    // Test widget behavior
  });
}
```

### 2. Tests Navigation (go_router)

```dart
import '../helpers/go_router_test_helpers.dart';

void main() {
  testWidgets('should navigate correctly', (tester) async {
    final mockRouter = MockGoRouter();
    setupNavigationStubs(mockRouter);

    await tester.pumpWidget(
      createMockRouterApp(
        mockRouter: mockRouter,
        child: MyScreen(),
      ),
    );

    // Trigger navigation
    await tester.tap(find.text('Navigate'));
    await tester.pumpAndSettle();

    // Verify navigation
    mockRouter.verifyGo('/destination');
  });
}
```

### 3. Tests Supabase

```dart
import '../helpers/supabase_v2_test_helpers.dart';

void main() {
  test('should fetch data from Supabase', () async {
    final mockSupabase = createMockSupabaseClient();
    
    // Setup query response
    setupQueryBuilder(
      client: mockSupabase,
      table: 'rooms',
      response: [
        SupabaseTestFixtures.createRoomFixture(code: 'TEST123'),
      ],
    );

    // Execute query
    final result = await repository.getRoomByCode('TEST123');
    
    expect(result.code, 'TEST123');
  });
}
```

## Patterns de Test Recommandés

### 1. Structure AAA (Arrange, Act, Assert)

```dart
test('should perform action', () {
  // Arrange - Préparer les données et mocks
  final mock = MockService();
  when(() => mock.method()).thenReturn(value);

  // Act - Exécuter l'action
  final result = systemUnderTest.performAction();

  // Assert - Vérifier le résultat
  expect(result, expectedValue);
  verify(() => mock.method()).called(1);
});
```

### 2. Test-First Development (TDD)

1. **Écrire le test d'abord** - Définir le comportement attendu
2. **Voir le test échouer** - Vérifier que le test détecte l'absence de l'implémentation
3. **Implémenter** - Écrire le code minimal pour faire passer le test
4. **Refactorer** - Améliorer le code en gardant les tests verts

### 3. Tests d'Intégration

```dart
testWidgets('integration test', (tester) async {
  // Utiliser de vrais providers mais avec des services mockés
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        supabaseClientProvider.overrideWithValue(mockSupabase),
      ],
      child: const MyApp(),
    ),
  );

  // Tester le flow complet
  await tester.tap(find.text('Action'));
  await tester.pumpAndSettle();
  
  expect(find.text('Result'), findsOneWidget);
});
```

## Templates de Test

### Template Test Unitaire

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// Imports spécifiques

void main() {
  group('ClassName', () {
    late SystemUnderTest sut;
    late MockDependency mockDependency;

    setUp(() {
      mockDependency = MockDependency();
      sut = SystemUnderTest(mockDependency);
    });

    test('should do something when condition', () {
      // Arrange
      when(() => mockDependency.method()).thenReturn(value);

      // Act
      final result = sut.doSomething();

      // Assert
      expect(result, expectedValue);
      verify(() => mockDependency.method()).called(1);
    });
  });
}
```

### Template Test Widget

```dart
import 'package:flutter_test/flutter_test.dart';
import '../helpers/riverpod_test_helpers.dart';

void main() {
  group('WidgetName', () {
    testWidgets('should display initial state', (tester) async {
      await tester.pumpApp(
        const WidgetName(),
        overrides: [],
      );

      expect(find.text('Initial'), findsOneWidget);
    });

    testWidgets('should handle user interaction', (tester) async {
      await tester.pumpApp(
        const WidgetName(),
        overrides: [],
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Updated'), findsOneWidget);
    });
  });
}
```

## Conseils et Bonnes Pratiques

1. **Isolation des Tests**
   - Chaque test doit être indépendant
   - Utiliser `setUp()` et `tearDown()` pour l'initialisation/nettoyage
   - Ne pas partager l'état entre les tests

2. **Nommage des Tests**
   - Format : "should [résultat attendu] when [condition]"
   - Être spécifique et descriptif
   - Éviter les noms génériques comme "test1"

3. **Mocking**
   - Mocker uniquement les dépendances externes
   - Utiliser de vraies implémentations quand possible
   - Vérifier les interactions avec `verify()`

4. **Performance des Tests**
   - Éviter les `Future.delayed()` dans les tests
   - Utiliser `pumpAndSettle()` avec parcimonie
   - Grouper les tests liés pour partager le setup

5. **Maintenance**
   - Garder les tests simples et lisibles
   - Refactorer les tests en même temps que le code
   - Supprimer les tests obsolètes

## Dépannage

### Erreur : "Bad state: No ProviderScope found"
Solution : Wrapper le widget avec `ProviderScope` ou utiliser `tester.pumpApp()`

### Erreur : "Timer still running after test"
Solution : Utiliser `tester.pumpAndSettle()` ou `tester.pump(duration)`

### Erreur : "Type 'Null' is not a subtype of type 'X'"
Solution : Vérifier que tous les mocks retournent des valeurs appropriées

## Ressources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [go_router Testing](https://pub.dev/packages/go_router#testing)