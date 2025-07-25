# Guide des Bonnes Pratiques TDD - Projet Ojyx

## Les 5 Principes Fondamentaux du TDD

### 1. 🎯 Tester le Comportement, pas l'Implémentation

**❌ Mauvais :** Tester comment quelque chose est fait
```dart
test('should call repository.fetchData()', () {
  // Vérifie les appels internes
  verify(() => mockRepository.fetchData()).called(1);
});
```

**✅ Bon :** Tester ce qui est observable
```dart
test('should enable strategic card exchange for competitive advantage', () {
  // Test behavior: card exchange creates new strategic opportunities
  final result = useCase.exchangeCards(position1, position2);
  expect(result.strategicValue, greaterThan(previousValue));
});
```

### 2. 🔄 Éliminer la Redondance

**❌ Mauvais :** Tests répétitifs avec légères variations
```dart
test('should handle 2 players', () { /* ... */ });
test('should handle 3 players', () { /* ... */ });
test('should handle 4 players', () { /* ... */ });
```

**✅ Bon :** Tests paramétrés avec scénarios significatifs
```dart
test('should scale competitive dynamics across different player counts', () {
  final scenarios = [
    (players: 2, dynamics: 'intense duel', complexity: 'low'),
    (players: 4, dynamics: 'strategic alliances', complexity: 'medium'),
    (players: 8, dynamics: 'chaotic competition', complexity: 'high'),
  ];
  
  for (final scenario in scenarios) {
    // Test the behavioral differences at each scale
  }
});
```

### 3. 🛡️ Isoler le Code avec des Mocks

**❌ Mauvais :** Mocks qui répliquent l'implémentation
```dart
when(() => mockRepository.save(any())).thenAnswer((_) async {
  // Logique complexe qui duplique l'implémentation réelle
});
```

**✅ Bon :** Mocks qui simulent des comportements externes
```dart
when(() => mockNetworkService.isConnected).thenReturn(false);
// Test how the system behaves when network is unavailable
```

### 4. 📏 Assurer une Bonne Granularité

**❌ Mauvais :** Tests triviaux sans valeur
```dart
test('should create instance', () {
  final obj = MyClass();
  expect(obj, isNotNull);
});
```

**✅ Bon :** Tests qui vérifient des comportements métier
```dart
test('should prevent card selection during opponent turn for fair play', () {
  final gameState = TestGameStateBuilder()
    .withCurrentPlayer('opponent-id')
    .build();
    
  final canSelect = selectionPolicy.canSelectCard(gameState, 'my-id');
  expect(canSelect, isFalse, reason: 'Turn-based fairness must be enforced');
});
```

### 5. 📖 Favoriser la Lisibilité et la Clarté

**❌ Mauvais :** Noms techniques et setup complexe
```dart
test('test_draw_card_with_empty_deck_throws_exception', () {
  // 50 lignes de setup incompréhensible
});
```

**✅ Bon :** Noms expressifs et données métier
```dart
test('should trigger strategic reshuffle when deck exhausted mid-game', () {
  // Given: A competitive game nearing deck exhaustion
  final gameState = TestGameStateBuilder()
    .inLastRound()
    .withPartialDeck(2)
    .build();
    
  // When: Player attempts to draw with insufficient cards
  final result = drawCardUseCase(gameState);
  
  // Then: System maintains game continuity through reshuffle
  expect(result.deck, hasLength(greaterThan(2)));
  expect(result.continuityMaintained, isTrue);
});
```

## Format Standard des Tests

### Nomenclature
```dart
'should [expected behavior] when [condition/context]'
```

Exemples :
- `'should enable strategic positioning when teleportation card is activated'`
- `'should preserve turn order integrity when player disconnects mid-turn'`
- `'should calculate competitive scores when round ends with column eliminations'`

### Structure AAA (Arrange-Act-Assert)
```dart
test('should [behavior] when [condition]', () {
  // Arrange (Given): Setup competitive scenario
  final scenario = TestScenarioBuilder()
    .withCompetitiveSetup()
    .build();
  
  // Act (When): Execute strategic action
  final result = gameAction.execute(scenario);
  
  // Assert (Then): Verify behavioral outcome
  expect(result, producesStrategicAdvantage());
  expect(result, maintainsGameIntegrity());
});
```

## Utilisation des Test Builders

### ❌ Éviter la duplication
```dart
// NE PAS répéter cette configuration partout
final player = GamePlayer(
  id: 'player-1',
  name: 'Test Player',
  grid: PlayerGrid.empty(),
  actionCards: [],
  isHost: true,
);
```

### ✅ Utiliser les builders
```dart
final player = TestGamePlayerBuilder()
  .withId('strategic-player')
  .withRevealedGrid(revealedCount: 6)
  .withActionCards([
    TestActionCardBuilder().asTeleport().build(),
    TestActionCardBuilder().asSwap().build(),
  ])
  .asHost()
  .build();
```

## Custom Matchers Métier

### ❌ Assertions techniques
```dart
expect(gameState.status, equals('playing'));
expect(gameState.players.length, equals(4));
```

### ✅ Assertions métier expressives
```dart
expect(gameState, isPlaying);
expect(gameState, hasPlayerCount(4));
expect(player.grid, hasAllCardsRevealed);
expect(gameState, isInLastRound(initiatedBy: 'player-1'));
```

## Organisation des Tests

### Structure des dossiers
```
test/
├── unit/                      # Tests unitaires purs
│   ├── entities/             # Logique métier pure
│   ├── use_cases/            # Cas d'usage isolés
│   └── utils/                # Utilitaires
├── integration/              # Tests d'intégration
│   ├── game_flow/           # Flux de jeu complets
│   ├── multiplayer/         # Synchronisation réseau
│   └── persistence/         # Sauvegarde/chargement
├── helpers/                 # Outils de test réutilisables
│   ├── test_builders.dart   # Builders pour entités
│   ├── test_matchers.dart   # Custom matchers
│   └── test_scenarios.dart  # Scénarios prédéfinis
└── features/               # Tests par feature (structure miroir)
```

## Anti-patterns à Éviter

### 1. ❌ Ne JAMAIS commenter des tests
```dart
// test('should handle edge case', () {
//   // Test commenté car il échoue
// });
```
**Solution :** Corriger ou supprimer, jamais commenter

### 2. ❌ Ne pas créer de fichiers "test_summary"
Les tests doivent tester du code réel, pas documenter

### 3. ❌ Éviter les tests qui testent le framework
```dart
test('should call setState when button pressed', () {
  // Test l'implémentation Flutter, pas votre logique
});
```

### 4. ❌ Ne pas mocker les entités métier
```dart
final mockCard = MockCard(); // NON!
```
**Solution :** Utiliser les builders pour créer de vraies entités

## Scénarios de Test Recommandés

### 1. Gameplay Compétitif
- Début de partie avec distribution équitable
- Mi-partie avec décisions stratégiques
- Fin de partie avec calcul des scores
- Gestion des égalités et cas limites

### 2. Actions Stratégiques
- Cartes actions avec timing immédiat
- Cartes actions optionnelles stockables  
- Interactions entre joueurs (swap, steal)
- Chaînes d'actions et combos

### 3. Robustesse Multijoueur
- Déconnexions et reconnexions
- Synchronisation des états
- Gestion des timeouts
- Intégrité des données

### 4. Règles Spéciales
- Élimination de colonnes identiques
- Dernier tour avec pénalités
- Pioche avec deck vide
- Validation des coups légaux

## Checklist Pré-Commit

- [ ] Tous les tests suivent la nomenclature standard
- [ ] Utilisation des test builders pour réduire la duplication  
- [ ] Custom matchers pour les assertions métier
- [ ] Tests organisés par comportement, pas par méthode
- [ ] Aucun test commenté ou fichier _summary
- [ ] Coverage minimum de 80% sur le nouveau code
- [ ] Les tests racontent l'histoire du comportement métier

## Exemple Complet

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/test/helpers/test_helpers.dart';

void main() {
  group('Teleportation Card Strategic Behavior', () {
    test('should enable positional optimization when teleportation activates', () {
      // Given: A player with suboptimal card positioning
      final gameState = TestGameStateBuilder()
        .withTwoPlayers()
        .asPlaying()
        .build();
        
      final player = gameState.currentPlayer;
      final grid = player.grid;
      
      // Assume high-value cards are poorly positioned
      expect(grid.getColumnScore(0), greaterThan(10));
      
      // When: Teleportation card is used strategically
      final result = teleportUseCase.execute(
        gameState: gameState,
        position1: CardPosition(0, 0), // High value
        position2: CardPosition(2, 3), // Low value
      );
      
      // Then: Strategic repositioning improves competitive position
      expect(result, isSuccess);
      expect(result.value.updatedPlayer.grid.getColumnScore(0), lessThan(5));
      expect(result.value, maintainsGameIntegrity);
      expect(result.value.strategicValueGained, isPositive);
    });
    
    test('should prevent illegal teleportation maintaining fair play', () {
      // Given: Attempt to teleport opponent's cards
      final gameState = TestGameStateBuilder()
        .withTwoPlayers()
        .asPlaying()
        .build();
        
      // When: Invalid teleportation attempted
      final result = teleportUseCase.execute(
        gameState: gameState,
        position1: CardPosition(0, 0), // Own card
        position2: OpponentPosition(1, 0, 0), // Opponent's card
      );
      
      // Then: System enforces game rules
      expect(result, isFailure);
      expect(result.failure, isGameRuleViolation);
      expect(result.failure.message, contains('own grid'));
    });
  });
}
```

## Ressources

- [Test Driven Development: By Example](https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530) - Kent Beck
- [Growing Object-Oriented Software, Guided by Tests](https://www.amazon.com/Growing-Object-Oriented-Software-Guided-Tests/dp/0321503627) - Freeman & Pryce
- [Flutter Testing Documentation](https://flutter.dev/docs/testing)

---

**Rappel :** Le TDD n'est pas une contrainte, c'est un outil pour créer du code maintenable, documenté et fiable. Chaque test raconte une histoire sur le comportement attendu du système.