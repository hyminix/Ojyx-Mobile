# TDD Patterns for Ojyx Test Suite

## Overview

This document describes the TDD patterns and conventions used in the Ojyx test suite, established during the migration to modern testing standards.

## Test Naming Convention

All tests follow the `should_[expected_result]_when_[condition]` pattern:

```dart
test('should_return_dark_blue_color_when_card_value_is_negative', () {
  // Test implementation
});
```

## Test Structure (AAA Pattern)

Every test follows the Arrange-Act-Assert pattern with clear section comments:

```dart
test('should_calculate_sum_when_adding_numbers', () {
  // Arrange
  final firstNumber = 5;
  final secondNumber = 3;
  
  // Act
  final result = calculator.add(firstNumber, secondNumber);
  
  // Assert
  expect(
    result,
    equals(8),
    reason: 'Sum should equal the addition of both numbers',
  );
});
```

## Test Data Builders

Use Test Data Builders to create test fixtures instead of direct constructors:

```dart
// Good
final card = CardBuilder()
    .withValue(5)
    .revealed()
    .build();

// Avoid
final card = Card(value: 5, isRevealed: true);
```

### Available Builders

- `CardBuilder` - For creating Card entities
- `PlayerGridBuilder` - For creating PlayerGrid entities
- `GamePlayerBuilder` - For creating GamePlayer entities
- `PlayerStateBuilder` - For creating PlayerState entities
- `GameStateBuilder` - For creating GameState entities
- `ActionCardBuilder` - For creating ActionCard entities
- `RoomBuilder` - For creating Room entities
- `EndGameStateBuilder` - For creating EndGameState entities

## Custom Matchers

Use custom matchers for domain-specific assertions:

```dart
// Card matchers
expect(card, isValidCard);
expect(card, hasCardValue(5));
expect(card, isRevealed);
expect(card, hasCardColor(CardValueColor.green));

// Player matchers
expect(playerState, hasScore(50));
expect(playerState, hasFinished);
expect(playerState, hasRevealedCount(3));

// Game matchers
expect(gameState, isInGameState('playing'));
expect(gameState, hasPlayerCount(4));
```

## Constants Extraction

Extract magic numbers and values into clearly named constants:

```dart
group('Score Calculation', () {
  // Test constants for clarity
  const int NEGATIVE_BONUS_VALUE = -2;
  const int ZERO_VALUE = 0;
  const int LOW_PENALTY_VALUE = 3;
  const int MEDIUM_PENALTY_VALUE = 7;
  const int HIGH_PENALTY_VALUE = 10;
  
  test('should_calculate_bonus_when_card_is_negative', () {
    // Use constants instead of magic numbers
    final card = CardBuilder().withValue(NEGATIVE_BONUS_VALUE).build();
  });
});
```

## Assertion Messages

Always provide meaningful reason messages in assertions:

```dart
expect(
  result,
  equals(expectedValue),
  reason: 'Specific explanation of why this assertion matters',
);
```

## Test Organization

Group related tests logically:

```dart
void main() {
  group('Entity Name', () {
    group('Feature/Aspect 1', () {
      test('should_behave_correctly_when_condition_1', () {});
      test('should_behave_correctly_when_condition_2', () {});
    });
    
    group('Feature/Aspect 2', () {
      test('should_handle_edge_case_when_condition_3', () {});
    });
    
    group('Error Handling', () {
      test('should_throw_error_when_invalid_input', () {});
    });
  });
}
```

## Helper Files Organization

```
test/
├── helpers/
│   ├── test_data_builders_simple.dart    # Simple builders for basic entities
│   ├── test_data_builders.dart          # Full builders (when needed)
│   ├── custom_matchers_simple.dart      # Simple custom matchers
│   ├── custom_matchers.dart             # Full matchers (when needed)
│   ├── riverpod_test_helpers.dart       # Riverpod-specific helpers
│   └── go_router_test_helpers.dart      # go_router-specific helpers
```

## Migration Strategy

When migrating existing tests to TDD patterns:

1. Start with simple entities (Card, Player)
2. Create minimal builders and matchers that work
3. Gradually expand as needed
4. Keep backward compatibility where possible
5. Document any breaking changes

## Common Patterns

### Testing Immutable Objects

```dart
test('should_create_new_instance_when_modifying_immutable_object', () {
  // Arrange
  final original = CardBuilder().withValue(5).hidden().build();
  
  // Act
  final modified = original.reveal();
  
  // Assert
  expect(original, isHidden, reason: 'Original should remain unchanged');
  expect(modified, isRevealed, reason: 'New instance should be modified');
  expect(modified.value, equals(original.value), reason: 'Other properties should be preserved');
});
```

### Testing Collections

```dart
test('should_contain_expected_items_when_filtering_collection', () {
  // Arrange
  final cards = [
    CardBuilder().withValue(-2).build(),
    CardBuilder().withValue(5).build(),
    CardBuilder().withValue(10).build(),
  ];
  
  // Act
  final bonusCards = cards.where((card) => card.value < 0).toList();
  
  // Assert
  expect(bonusCards, hasLength(1), reason: 'Should only contain negative value cards');
  expect(bonusCards.first, hasCardValue(-2), reason: 'Should contain the bonus card');
});
```

### Testing Async Operations

```dart
test('should_return_result_when_async_operation_completes', () async {
  // Arrange
  final useCase = CalculateScores();
  final gameState = GameStateBuilder().build();
  
  // Act
  final result = await useCase(CalculateScoresParams(gameState: gameState));
  
  // Assert
  expect(result.isRight(), true, reason: 'Operation should succeed');
  result.fold(
    (failure) => fail('Should not fail: $failure'),
    (scores) => expect(scores, isNotEmpty, reason: 'Should return scores'),
  );
});
```

## Best Practices

1. **One assertion per concept** - Multiple expects are fine if testing the same concept
2. **Test behavior, not implementation** - Focus on what the code does, not how
3. **Keep tests independent** - Each test should be able to run in isolation
4. **Use descriptive variable names** - Make tests self-documenting
5. **Avoid test logic** - Tests should be simple and linear
6. **Mock at boundaries** - Only mock external dependencies
7. **Prefer real objects** - Use builders over mocks when possible

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/game/domain/entities/card_test.dart

# Run tests matching pattern
flutter test --name "should_return"
```

## Coverage Goals

- Minimum: 80% coverage
- Target: 90%+ for critical business logic
- Exclude: Generated files (*.g.dart, *.freezed.dart)