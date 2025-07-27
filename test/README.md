# Ojyx Test Suite Documentation

## Overview

This document describes the testing standards, patterns, and conventions used in the Ojyx project. All tests follow Test-Driven Development (TDD) principles and clean architecture patterns.

## Table of Contents

1. [Test Organization](#test-organization)
2. [TDD Principles](#tdd-principles)
3. [Naming Conventions](#naming-conventions)
4. [Test Patterns by Layer](#test-patterns-by-layer)
5. [Helper Utilities](#helper-utilities)
6. [Running Tests](#running-tests)
7. [Code Coverage](#code-coverage)
8. [CI/CD Integration](#cicd-integration)
9. [Review Checklist](#review-checklist)

## Test Organization

```
test/
├── core/                    # Core functionality tests
├── features/               # Feature-specific tests (mirrors lib/features)
│   ├── game/
│   │   ├── domain/        # Business logic tests
│   │   ├── data/          # Repository and data source tests
│   │   └── presentation/  # Widget and provider tests
│   └── [other features]
├── helpers/                # Shared test utilities
│   ├── test_data_builders.dart
│   ├── widget_test_helpers.dart
│   ├── riverpod_test_helpers.dart
│   └── data_layer_test_helpers.dart
├── goldens/               # Golden test images
├── integration/           # Integration tests
├── validate_tdd_compliance.dart
└── README.md             # This file
```

## TDD Principles

### 1. Red-Green-Refactor Cycle

1. **RED**: Write a failing test first
2. **GREEN**: Write minimal code to make the test pass
3. **REFACTOR**: Improve the code while keeping tests green

### 2. Test-First Development

- **NEVER** write production code without a failing test
- **NEVER** comment out or skip tests
- **ALWAYS** ensure all tests pass before committing

### 3. One Assertion Per Test (When Possible)

Tests should ideally verify one behavior. Multiple related assertions are acceptable when testing a single logical concept.

## Naming Conventions

### Test Names

All tests MUST follow the `should_[expected behavior]_when_[condition]` pattern:

```dart
test('should_return_negative_score_when_card_value_is_negative', () {
  // test implementation
});

testWidgets('should_display_loading_indicator_when_data_is_loading', (tester) async {
  // test implementation
});
```

### Group Names

Groups should describe the component or functionality being tested:

```dart
group('CardWidget', () {
  group('Revealed state', () {
    // tests for revealed cards
  });
  
  group('Hidden state', () {
    // tests for hidden cards
  });
});
```

### File Names

Test files must end with `_test.dart` and mirror the source file structure:

- Source: `lib/features/game/domain/entities/card.dart`
- Test: `test/features/game/domain/entities/card_test.dart`

## Test Patterns by Layer

### Domain Layer Tests

Focus on business logic and entity behavior:

```dart
group('Card Entity', () {
  test('should_calculate_correct_color_when_value_is_negative', () {
    // Arrange
    final card = CardBuilder().withValue(-2).build();
    
    // Act
    final color = card.color;
    
    // Assert
    expect(
      color,
      equals(CardValueColor.darkBlue),
      reason: 'Negative values should display as dark blue',
    );
  });
});
```

**Key Points:**
- Use Test Data Builders for creating test objects
- Test business rules and validations
- Verify entity behavior and transformations
- Use custom matchers for domain-specific assertions

### Data Layer Tests

Focus on external integrations and data transformations:

```dart
group('GameStateDataSource', () {
  late MockSupabaseClient mockClient;
  late GameStateDataSourceImpl dataSource;
  
  setUp(() {
    mockClient = DataLayerTestUtils.createMockSupabaseClient();
    dataSource = GameStateDataSourceImpl(client: mockClient);
  });
  
  test('should_fetch_game_state_when_id_is_valid', () async {
    // Arrange
    DataLayerTestUtils.setupSuccessfulQuery(
      client: mockClient,
      table: 'game_states',
      response: testGameStateJson,
    );
    
    // Act
    final result = await dataSource.fetchGameState('game-123');
    
    // Assert
    expect(result, isA<GameStateModel>());
    verify(() => mockClient.from('game_states')).called(1);
  });
});
```

**Key Points:**
- Mock external dependencies (Supabase, HTTP, etc.)
- Test error handling and edge cases
- Verify data transformation (JSON ↔ Model ↔ Entity)
- Test repository pattern implementation

### Presentation Layer Tests

#### Widget Tests

```dart
testWidgets('should_display_card_value_when_revealed', (tester) async {
  // Arrange
  final card = CardBuilder().withValue(7).revealed().build();
  
  // Act
  await tester.pumpTestWidget(
    CardWidget(card: card),
  );
  
  // Assert
  expect(
    find.text('7'),
    findsOneWidget,
    reason: 'Revealed card should display its value',
  );
});
```

#### Provider Tests

```dart
test('should_emit_loading_then_data_when_initialization_succeeds', () async {
  // Arrange
  when(() => mockRepository.getGameState(any()))
    .thenAnswer((_) async => Right(testGameState));
  
  final states = <AsyncValue<GameState>>[];
  container.listen(
    gameStateNotifierProvider,
    (previous, next) => states.add(next),
  );
  
  // Act
  await container.read(gameStateNotifierProvider.notifier).loadGame('123');
  
  // Assert
  expect(states, [
    isA<AsyncLoading>(),
    isA<AsyncData>(),
  ]);
});
```

**Key Points:**
- Use TestWrapper for consistent widget setup
- Test user interactions and visual states
- Mock providers and navigation
- Test responsive behavior on different screen sizes
- Verify accessibility (semantics)

## Helper Utilities

### Test Data Builders

Located in `test/helpers/test_data_builders.dart`:

```dart
// Create test objects with fluent API
final card = CardBuilder()
  .withValue(10)
  .revealed()
  .build();

final player = GamePlayerBuilder()
  .withId('player-1')
  .withName('Test Player')
  .asHost()
  .build();
```

### Widget Test Helpers

Located in `test/helpers/widget_test_helpers.dart`:

```dart
// Pump widget with all dependencies
await tester.pumpTestWidget(
  MyWidget(),
  overrides: [...],
  router: mockRouter,
);

// Common finders
final button = CommonFinders.findButtonByText('Submit');

// Screen size testing
await tester.setScreenSize(TestScreenSizes.tablet);
```

### Custom Matchers

```dart
// Domain matchers
expect(card, isValidCard);
expect(card, hasCardValue(5));

// Widget matchers
expect(button, WidgetMatchers.isEnabled);

// Exception matchers
expect(
  () => dataSource.fetchData(),
  throwsServerException(withMessage: 'Network error'),
);
```

## Running Tests

### All Tests
```bash
flutter test
```

### Specific Test File
```bash
flutter test test/features/game/domain/entities/card_test.dart
```

### With Coverage
```bash
flutter test --coverage
lcov --summary coverage/lcov.info
```

### Watch Mode
```bash
flutter test --watch
```

### TDD Compliance Check
```bash
dart test/validate_tdd_compliance.dart
```

## Code Coverage

### Minimum Requirements
- Overall: 80%
- Domain layer: 95%
- Data layer: 85%
- Presentation layer: 75%

### Viewing Coverage Report
```bash
# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html
```

## CI/CD Integration

### Pre-commit Hooks

The project uses Git hooks to ensure test quality:

1. **Format check**: `dart format --set-exit-if-changed`
2. **Static analysis**: `flutter analyze --no-fatal-infos`
3. **Tests**: `flutter test --coverage`
4. **TDD compliance**: `dart test/validate_tdd_compliance.dart`

### GitHub Actions

Tests run automatically on:
- Pull requests
- Pushes to main
- Tagged releases

See `.github/workflows/ci.yml` for configuration.

## Review Checklist

### For Test Authors

- [ ] Test follows `should_when` naming convention
- [ ] Test has clear Arrange-Act-Assert structure
- [ ] All assertions include `reason` parameter
- [ ] Test uses appropriate test data builders
- [ ] No tests are commented out or skipped
- [ ] Test covers both happy path and edge cases
- [ ] Mock usage is appropriate for the layer

### For Reviewers

- [ ] Test name clearly describes the behavior
- [ ] Test is focused on a single behavior
- [ ] Test would fail if the implementation was broken
- [ ] Test doesn't test implementation details
- [ ] Test is maintainable and readable
- [ ] Coverage is adequate for the feature

## Common Patterns and Examples

### Testing Async Operations

```dart
test('should_handle_timeout_when_api_is_slow', () async {
  // Arrange
  when(() => mockApi.fetchData())
    .thenAnswer((_) async {
      await Future.delayed(Duration(seconds: 35));
      return testData;
    });
  
  // Act & Assert
  await expectLater(
    dataSource.fetchWithTimeout(),
    throwsA(isA<TimeoutException>()),
  );
});
```

### Testing Streams

```dart
test('should_emit_updates_when_data_changes', () async {
  // Arrange
  final controller = StreamController<int>();
  when(() => mockSource.watchValue()).thenAnswer((_) => controller.stream);
  
  // Act
  final emitted = <int>[];
  final subscription = repository.watchValue().listen(emitted.add);
  
  controller.add(1);
  controller.add(2);
  controller.add(3);
  
  await Future.delayed(Duration(milliseconds: 100));
  
  // Assert
  expect(emitted, equals([1, 2, 3]));
  
  // Cleanup
  await subscription.cancel();
  await controller.close();
});
```

### Testing Navigation

```dart
testWidgets('should_navigate_to_home_when_login_succeeds', (tester) async {
  // Arrange
  final mockRouter = WidgetTestUtils.createMockRouter();
  when(() => mockAuth.login(any(), any()))
    .thenAnswer((_) async => Right(unit));
  
  // Act
  await tester.pumpTestWidget(
    LoginScreen(),
    router: mockRouter,
    overrides: [authProvider.overrideWith(() => mockAuth)],
  );
  
  await tester.enterTextAndSettle(
    find.byKey(Key('email_field')),
    'test@example.com',
  );
  await tester.enterTextAndSettle(
    find.byKey(Key('password_field')),
    'password123',
  );
  await tester.tapAndSettle(find.text('Login'));
  
  // Assert
  verify(() => mockRouter.goNamed('home')).called(1);
});
```

## Troubleshooting

### Common Issues

1. **Flaky Tests**: Use `pumpAndSettleWithTimeout` instead of `pumpAndSettle`
2. **Mock Setup**: Ensure all mock methods are stubbed before use
3. **Async Issues**: Always await async operations and use proper tearDown
4. **Provider Tests**: Remember to dispose containers in tearDown

### Debug Tips

```dart
// Print widget tree
debugDumpApp();

// Print render tree
debugDumpRenderTree();

// Find widgets by type with predicate
find.byWidgetPredicate(
  (widget) => widget is Container && widget.color == Colors.red,
);

// Take screenshot during test
await expectLater(
  find.byType(MyWidget),
  matchesGoldenFile('goldens/my_widget.png'),
);
```

## Additional Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Mockito Documentation](https://pub.dev/packages/mockito)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- Project-specific guides:
  - [TDD Patterns](./TDD_PATTERNS.md)
  - [Data Layer Testing](./DATA_LAYER_TDD_GUIDE.md)
  - [Presentation Layer Testing](./PRESENTATION_LAYER_TDD_GUIDE.md)

---

Remember: **Good tests are an investment in code quality and team productivity!**