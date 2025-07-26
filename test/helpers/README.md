# Test Helpers Documentation

## Overview

This directory contains utilities and helpers to facilitate writing tests for the Ojyx project following TDD principles and Clean Architecture patterns.

## Available Helpers

### `freezed_test_utils.dart`

Provides Test Data Builders and Custom Matchers for Freezed models.

#### Test Data Builders

**CardBuilder**
```dart
// Create a card with default values
final card = CardBuilder().build();

// Create a custom card
final card = CardBuilder()
    .withValue(10)
    .revealed()
    .build();
```

**PlayerGridBuilder**
```dart
// Create an empty grid
final grid = PlayerGridBuilder().build();

// Create a grid with specific cards
final grid = PlayerGridBuilder()
    .withCard(0, 0, card1)
    .withCard(1, 1, card2)
    .build();

// Create a full grid
final grid = PlayerGridBuilder()
    .withFullGrid()
    .build();
```

**GamePlayerBuilder**
```dart
// Create a player with defaults
final player = GamePlayerBuilder().build();

// Create a custom player
final player = GamePlayerBuilder()
    .withId('player-123')
    .withName('Alice')
    .asHost()
    .withScoreMultiplier(2)
    .build();
```

#### Custom Matchers

**isValidCard**
```dart
// Verify a card has valid values
expect(card, isValidCard);
```

**hasCurrentScore**
```dart
// Verify a player's current score
expect(player, hasCurrentScore(42));
```

#### Helper Functions

**createTestCard**
```dart
final card = createTestCard(
  value: 8,
  isRevealed: true,
);
```

**createTestGrid**
```dart
// Empty grid
final emptyGrid = createTestGrid(filled: false);

// Filled grid
final filledGrid = createTestGrid(filled: true);
```

**createTestPlayer**
```dart
final player = createTestPlayer(
  id: 'test-player',
  name: 'Test Player',
  withFullGrid: true,
);
```

## Best Practices

1. **Use Builders for Complex Objects**: Instead of creating Freezed objects directly, use the builders to maintain flexibility and readability.

2. **Leverage Custom Matchers**: Custom matchers provide better error messages and make tests more readable.

3. **Follow AAA Pattern**: Structure your tests with Arrange, Act, Assert sections:
   ```dart
   test('should calculate score correctly', () {
     // Arrange
     final grid = PlayerGridBuilder()
         .withCard(0, 0, createTestCard(value: 10))
         .build();
     final player = GamePlayerBuilder()
         .withGrid(grid)
         .build();
     
     // Act
     final score = player.currentScore;
     
     // Assert
     expect(score, equals(10));
   });
   ```

4. **Use Descriptive Test Names**: Follow the pattern `should_[expected]_when_[condition]`

5. **Keep Tests Independent**: Each test should be able to run in isolation

## Adding New Helpers

When adding new test helpers:

1. Create builders for complex domain objects
2. Add custom matchers for common assertions
3. Include helper functions for repetitive tasks
4. Document the new helpers in this file
5. Write tests for the helpers themselves

## Migration Notes

These helpers have been designed to work with:
- Freezed 2.5.7
- Flutter 3.32.6
- Dart 3.8.1

When updating dependencies, ensure the helpers remain compatible and update this documentation accordingly.