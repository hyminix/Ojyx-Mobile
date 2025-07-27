# Mutation Testing Guide for Ojyx

## What is Mutation Testing?

Mutation testing is a technique to evaluate the quality of your test suite by introducing small changes (mutations) to your code and checking if your tests detect these changes. If a mutation survives (tests still pass), it indicates a gap in your test coverage.

## Common Mutations to Test

### 1. Boundary Mutations

**Original Code:**
```dart
if (card.value >= 0) {
  return CardValueColor.green;
}
```

**Mutations to Try:**
- Change `>=` to `>`
- Change `>=` to `==`
- Change `0` to `1` or `-1`

**Expected Result:** Tests should fail, indicating they properly test boundary conditions.

### 2. Logical Operator Mutations

**Original Code:**
```dart
if (isPlayerTurn && hasPerformedAction) {
  showEndTurnButton();
}
```

**Mutations to Try:**
- Change `&&` to `||`
- Remove one condition
- Negate a condition (`!isPlayerTurn`)

### 3. Return Value Mutations

**Original Code:**
```dart
bool get isValid => value >= minValue && value <= maxValue;
```

**Mutations to Try:**
- Return `true` always
- Return `false` always
- Return `!result`

### 4. Collection Mutations

**Original Code:**
```dart
final revealedCards = cards.where((c) => c.isRevealed).toList();
```

**Mutations to Try:**
- Change `c.isRevealed` to `!c.isRevealed`
- Return empty list
- Return all cards without filtering

### 5. Numeric Mutations

**Original Code:**
```dart
final score = baseScore * multiplier + bonus;
```

**Mutations to Try:**
- Change `*` to `+`
- Change `+` to `-`
- Change values to 0 or 1

## Manual Mutation Testing Process

### Step 1: Select Target Code

Choose a critical piece of business logic:

```dart
// lib/features/game/domain/entities/card.dart
CardValueColor get color {
  if (value < 0) return CardValueColor.darkBlue;
  if (value == 0) return CardValueColor.lightBlue;
  if (value <= 5) return CardValueColor.green;
  if (value <= 9) return CardValueColor.yellow;
  return CardValueColor.red;
}
```

### Step 2: Apply Mutations

Create a temporary mutation:

```dart
// Mutation 1: Change boundary
if (value <= 0) return CardValueColor.darkBlue;  // Was: value < 0

// Mutation 2: Wrong color
if (value < 0) return CardValueColor.red;  // Was: darkBlue

// Mutation 3: Remove condition
// if (value == 0) return CardValueColor.lightBlue;  // Commented out
```

### Step 3: Run Tests

```bash
flutter test test/features/game/domain/entities/card_test.dart
```

### Step 4: Analyze Results

- **GOOD**: Tests fail (mutation killed) ✅
- **BAD**: Tests pass (mutation survived) ❌

### Step 5: Improve Tests

If a mutation survives, add a test case:

```dart
test('should_return_dark_blue_when_value_is_exactly_negative_one', () {
  final card = CardBuilder().withValue(-1).build();
  expect(card.color, equals(CardValueColor.darkBlue));
});
```

## Mutation Testing Checklist

### Domain Layer Mutations

- [ ] Boundary conditions in validations
- [ ] Business rule calculations
- [ ] State transitions
- [ ] Comparison operators
- [ ] Default values

### Data Layer Mutations

- [ ] Query parameters
- [ ] Error handling conditions
- [ ] Null checks
- [ ] Type conversions
- [ ] Response mapping

### Presentation Layer Mutations

- [ ] UI state conditions
- [ ] User interaction handlers
- [ ] Navigation conditions
- [ ] Loading/error states
- [ ] Visibility conditions

## Automated Mutation Script

```dart
// test/mutation_test_runner.dart
import 'dart:io';

class MutationTest {
  final String filePath;
  final int line;
  final String original;
  final String mutation;
  final String testPath;
  
  MutationTest({
    required this.filePath,
    required this.line,
    required this.original,
    required this.mutation,
    required this.testPath,
  });
}

final commonMutations = [
  MutationTest(
    filePath: 'lib/features/game/domain/entities/card.dart',
    line: 45,
    original: 'if (value < 0)',
    mutation: 'if (value <= 0)',
    testPath: 'test/features/game/domain/entities/card_test.dart',
  ),
  // Add more mutations here
];

void main() async {
  print('🧬 Running Mutation Tests...\n');
  
  int survived = 0;
  int killed = 0;
  
  for (final mutation in commonMutations) {
    print('Testing mutation in ${mutation.filePath}:${mutation.line}');
    print('  Original: ${mutation.original}');
    print('  Mutation: ${mutation.mutation}');
    
    // Apply mutation
    final file = File(mutation.filePath);
    final content = await file.readAsString();
    final mutated = content.replaceFirst(mutation.original, mutation.mutation);
    await file.writeAsString(mutated);
    
    // Run tests
    final result = await Process.run('flutter', ['test', mutation.testPath]);
    
    // Restore original
    await file.writeAsString(content);
    
    if (result.exitCode == 0) {
      print('  ❌ SURVIVED - Tests still pass!\n');
      survived++;
    } else {
      print('  ✅ KILLED - Tests detected the mutation\n');
      killed++;
    }
  }
  
  print('Summary:');
  print('  Killed: $killed');
  print('  Survived: $survived');
  print('  Mutation Score: ${(killed / (killed + survived) * 100).toStringAsFixed(1)}%');
}
```

## Best Practices

### 1. Focus on Critical Code

Prioritize mutation testing for:
- Business logic calculations
- Security validations
- State management
- Data transformations

### 2. Start Small

Begin with:
- Simple boolean conditions
- Numeric boundaries
- Collection operations

### 3. Document Survivors

When a mutation survives legitimately:

```dart
// Mutation: changing >= to > survives because 
// business requirement explicitly includes boundary
if (score >= minimumScore) {  // Do not mutate: documented requirement
  qualifyForBonus();
}
```

### 4. Regular Testing

- Run mutations during refactoring
- Test new features thoroughly
- Check critical bug fixes

## Example Mutation Testing Session

### Target: Player Score Calculation

```dart
// Original implementation
int calculateScore(List<Card> cards) {
  return cards
    .where((card) => card.isRevealed)
    .fold(0, (sum, card) => sum + card.value);
}
```

### Mutations Applied:

1. **Remove filter** (Survived ❌)
   ```dart
   return cards.fold(0, (sum, card) => sum + card.value);
   ```
   **Fix**: Add test for mixed revealed/hidden cards

2. **Change operation** (Killed ✅)
   ```dart
   .fold(0, (sum, card) => sum - card.value);
   ```
   **Good**: Tests verify correct addition

3. **Wrong initial value** (Survived ❌)
   ```dart
   .fold(10, (sum, card) => sum + card.value);
   ```
   **Fix**: Add test for empty card list

### Resulting Improved Tests:

```dart
test('should_only_sum_revealed_cards_when_grid_has_mixed_states', () {
  final cards = [
    CardBuilder().withValue(5).revealed().build(),
    CardBuilder().withValue(10).hidden().build(),
    CardBuilder().withValue(3).revealed().build(),
  ];
  
  expect(calculateScore(cards), equals(8));
});

test('should_return_zero_when_no_cards_provided', () {
  expect(calculateScore([]), equals(0));
});
```

## Mutation Testing Report Template

```markdown
## Mutation Testing Report - [Date]

### Summary
- Files tested: X
- Mutations applied: Y
- Mutations killed: Z
- Mutation score: XX%

### Survived Mutations
1. **File**: `path/to/file.dart`
   - **Line**: 123
   - **Original**: `if (x > 0)`
   - **Mutation**: `if (x >= 0)`
   - **Impact**: Boundary condition not tested
   - **Fix**: Added test case for x = 0

### Recommendations
- Increase boundary condition testing
- Add negative test cases
- Improve error condition coverage
```

## Tools and Resources

### Dart Mutation Testing Tools
- Currently limited automated tools for Dart
- Manual process recommended for critical code
- Consider contributing to open-source mutation testing tools

### Further Reading
- [Mutation Testing on Wikipedia](https://en.wikipedia.org/wiki/Mutation_testing)
- [PITest (Java) for inspiration](https://pitest.org/)
- [Stryker Mutator](https://stryker-mutator.io/) (multi-language)

Remember: **If your tests don't fail when the code is broken, they're not good tests!**