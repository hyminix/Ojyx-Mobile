# Presentation Layer TDD Testing Guide

## Overview

This guide provides patterns and conventions for testing the presentation layer (widgets, screens, providers) following TDD principles in the Ojyx project.

## Test Structure

### 1. Widget Tests

```dart
void main() {
  group('CardWidget', () {
    testWidgets('should_display_card_value_when_card_is_revealed', (tester) async {
      // Arrange
      const testCard = Card(value: 7, isRevealed: true);
      
      // Act
      await tester.pumpTestWidget(
        CardWidget(card: testCard),
      );
      
      // Assert
      expect(find.text('7'), findsOneWidget,
        reason: 'Revealed card should display its value');
      expect(find.byIcon(Icons.help_outline), findsNothing,
        reason: 'Revealed card should not show placeholder icon');
    });
    
    testWidgets('should_show_back_design_when_card_is_hidden', (tester) async {
      // Arrange
      const testCard = Card(value: 7, isRevealed: false);
      
      // Act
      await tester.pumpTestWidget(
        CardWidget(card: testCard),
      );
      
      // Assert
      expect(find.text('7'), findsNothing,
        reason: 'Hidden card should not display value');
      expect(find.byType(BackDesignWidget), findsOneWidget,
        reason: 'Hidden card should show back design');
    });
    
    testWidgets('should_trigger_callback_when_tapped', (tester) async {
      // Arrange
      const testCard = Card(value: 5, isRevealed: false);
      bool wasTapped = false;
      
      // Act
      await tester.pumpTestWidget(
        CardWidget(
          card: testCard,
          onTap: () => wasTapped = true,
        ),
      );
      
      await tester.tapAndSettle(find.byType(CardWidget));
      
      // Assert
      expect(wasTapped, isTrue,
        reason: 'onTap callback should be triggered when card is tapped');
    });
  });
}
```

### 2. Screen Tests

```dart
void main() {
  group('GameScreen', () {
    late MockGameStateNotifier mockGameNotifier;
    late MockGoRouter mockRouter;
    
    setUp(() {
      mockGameNotifier = MockGameStateNotifier();
      mockRouter = WidgetTestUtils.createMockRouter();
    });
    
    testWidgets('should_display_loading_when_game_is_initializing', (tester) async {
      // Arrange
      when(() => mockGameNotifier.state).thenReturn(
        const AsyncValue.loading(),
      );
      
      // Act
      await tester.pumpTestWidget(
        const GameScreen(),
        overrides: [
          gameStateNotifierProvider.overrideWith((ref) => mockGameNotifier),
        ],
        router: mockRouter,
      );
      
      // Assert
      WidgetTestUtils.expectLoading(tester);
    });
    
    testWidgets('should_display_game_board_when_data_is_loaded', (tester) async {
      // Arrange
      final testGameState = GameStateBuilder()
        .withPlayers([
          GamePlayerBuilder().withId('player-1').build(),
          GamePlayerBuilder().withId('player-2').build(),
        ])
        .build();
        
      when(() => mockGameNotifier.state).thenReturn(
        AsyncValue.data(testGameState),
      );
      
      // Act
      await tester.pumpTestWidget(
        const GameScreen(),
        overrides: [
          gameStateNotifierProvider.overrideWith((ref) => mockGameNotifier),
        ],
        router: mockRouter,
      );
      
      // Assert
      expect(find.byType(PlayerGridWidget), findsOneWidget,
        reason: 'Should display player grid when game is loaded');
      expect(find.byType(OpponentsViewWidget), findsOneWidget,
        reason: 'Should display opponents view');
      expect(find.byType(CommonAreaWidget), findsOneWidget,
        reason: 'Should display common area with deck');
    });
    
    testWidgets('should_navigate_to_end_game_when_game_finishes', (tester) async {
      // Arrange
      final gameStateController = StreamController<AsyncValue<GameState>>();
      when(() => mockGameNotifier.stream).thenAnswer(
        (_) => gameStateController.stream,
      );
      
      // Act
      await tester.pumpTestWidget(
        const GameScreen(),
        overrides: [
          gameStateNotifierProvider.overrideWith((ref) => mockGameNotifier),
        ],
        router: mockRouter,
      );
      
      // Emit game finished state
      gameStateController.add(
        AsyncValue.data(
          GameStateBuilder().withStatus(GameStatus.finished).build(),
        ),
      );
      
      await tester.pumpAndSettleWithTimeout();
      
      // Assert
      verify(() => mockRouter.goNamed(
        'end-game',
        extra: any(named: 'extra'),
      )).called(1);
      
      // Cleanup
      await gameStateController.close();
    });
  });
}
```

### 3. Provider Tests

```dart
void main() {
  group('GameStateNotifier', () {
    late ProviderContainer container;
    late MockGameRepository mockRepository;
    late MockSupabaseClient mockSupabase;
    
    setUp(() {
      mockRepository = MockGameRepository();
      mockSupabase = MockSupabaseClient();
      
      container = ProviderContainer(
        overrides: [
          gameRepositoryProvider.overrideWithValue(mockRepository),
          supabaseClientProvider.overrideWithValue(mockSupabase),
        ],
      );
    });
    
    tearDown(() {
      container.dispose();
    });
    
    test('should_emit_loading_then_data_when_initialization_succeeds', () async {
      // Arrange
      final testGameState = GameStateBuilder()
        .withId('game-123')
        .build();
        
      when(() => mockRepository.getGameState('game-123'))
        .thenAnswer((_) async => Right(testGameState));
      
      // Act
      final notifier = container.read(gameStateNotifierProvider.notifier);
      final states = <AsyncValue<GameState>>[];
      
      container.listen(
        gameStateNotifierProvider,
        (previous, next) => states.add(next),
      );
      
      await notifier.initializeGame('game-123');
      await Future.delayed(Duration(milliseconds: 100));
      
      // Assert
      expect(states.length, greaterThanOrEqualTo(2),
        reason: 'Should emit at least loading and data states');
      expect(states.first, isA<AsyncLoading>(),
        reason: 'First state should be loading');
      expect(states.last, isA<AsyncData>(),
        reason: 'Final state should be data');
      expect(states.last.valueOrNull?.id, equals('game-123'),
        reason: 'Should load correct game state');
    });
    
    test('should_emit_error_when_initialization_fails', () async {
      // Arrange
      when(() => mockRepository.getGameState('game-123'))
        .thenAnswer((_) async => Left(ServerFailure('Network error')));
      
      // Act
      final notifier = container.read(gameStateNotifierProvider.notifier);
      final states = <AsyncValue<GameState>>[];
      
      container.listen(
        gameStateNotifierProvider,
        (previous, next) => states.add(next),
      );
      
      await notifier.initializeGame('game-123');
      await Future.delayed(Duration(milliseconds: 100));
      
      // Assert
      expect(states.last, isA<AsyncError>(),
        reason: 'Should emit error state when initialization fails');
      expect(
        states.last.error.toString(),
        contains('Network error'),
        reason: 'Error should contain failure message',
      );
    });
    
    test('should_update_state_when_player_reveals_card', () async {
      // Arrange
      final initialState = GameStateBuilder()
        .withPlayers([
          GamePlayerBuilder()
            .withId('player-1')
            .withGrid(
              PlayerGridBuilder()
                .withCards([
                  CardBuilder().hidden().build(),
                  CardBuilder().hidden().build(),
                ])
                .build(),
            )
            .build(),
        ])
        .build();
        
      container.read(gameStateNotifierProvider.notifier).state = 
        AsyncValue.data(initialState);
      
      when(() => mockRepository.revealCard(any(), any(), any()))
        .thenAnswer((_) async => Right(unit));
      
      // Act
      await container.read(gameStateNotifierProvider.notifier)
        .revealCard('player-1', CardPosition(row: 0, col: 0));
      
      // Assert
      final state = container.read(gameStateNotifierProvider);
      expect(state.valueOrNull?.players.first.grid.cards[0][0]?.isRevealed, isTrue,
        reason: 'Card should be revealed in local state');
      
      verify(() => mockRepository.revealCard(
        any(),
        'player-1',
        CardPosition(row: 0, col: 0),
      )).called(1);
    });
  });
}
```

## Key Patterns

### 1. Widget Test Patterns

- **Always use TestWrapper**: Provides necessary dependencies (Theme, Localizations, Router)
- **Test user interactions**: Tap, drag, enter text, scroll
- **Test visual states**: Loading, error, empty, data
- **Test responsive behavior**: Different screen sizes
- **Use semantic finders**: For accessibility testing

### 2. Screen Test Patterns

- **Mock navigation**: Always provide MockGoRouter
- **Test screen flows**: Loading → Data → Actions → Navigation
- **Test error handling**: Network errors, validation errors
- **Test edge cases**: Empty lists, max limits, concurrent actions

### 3. Provider Test Patterns

- **Use ProviderContainer**: Isolate provider testing
- **Test state transitions**: Initial → Loading → Data/Error
- **Test side effects**: API calls, navigation, storage
- **Mock dependencies**: Repository, network, storage
- **Test error recovery**: Retry logic, fallbacks

## Best Practices

### 1. Use Helper Methods

```dart
// Good
await tester.pumpTestWidget(
  MyWidget(),
  overrides: [/* ... */],
);

// Bad
await tester.pumpWidget(
  ProviderScope(
    overrides: [/* ... */],
    child: MaterialApp(
      home: MyWidget(),
    ),
  ),
);
```

### 2. Descriptive Assertions

```dart
// Good
expect(
  find.text('Submit'),
  findsOneWidget,
  reason: 'Submit button should be visible when form is valid',
);

// Bad
expect(find.text('Submit'), findsOneWidget);
```

### 3. Test Accessibility

```dart
testWidgets('should_have_proper_semantics_for_screen_readers', (tester) async {
  // Act
  await tester.pumpTestWidget(MyWidget());
  
  // Assert
  final semantics = tester.getSemantics(find.byType(ElevatedButton));
  expect(semantics.label, contains('Submit form'),
    reason: 'Button should have semantic label for screen readers');
  expect(semantics.hasAction(SemanticsAction.tap), isTrue,
    reason: 'Button should be tappable');
});
```

### 4. Golden Tests for Critical UI

```dart
testWidgets('should_match_design_specifications', (tester) async {
  // Arrange
  await tester.setScreenSize(TestScreenSizes.phone);
  
  // Act
  await tester.pumpTestWidget(
    CardWidget(
      card: Card(value: 10, isRevealed: true),
    ),
  );
  
  // Assert
  await expectLater(
    find.byType(CardWidget),
    matchesGoldenFile('goldens/card_widget_revealed.png'),
  );
});
```

### 5. Test Different Screen Sizes

```dart
for (final screenSize in [TestScreenSizes.phone, TestScreenSizes.tablet]) {
  testWidgets('should_be_responsive_on_${screenSize.width}x${screenSize.height}', 
    (tester) async {
    // Arrange
    await tester.setScreenSize(screenSize);
    
    // Act
    await tester.pumpTestWidget(GameScreen());
    
    // Assert
    expect(find.byType(GameScreen), findsOneWidget,
      reason: 'Screen should render on all sizes');
    // Additional responsive-specific assertions
  });
}
```

## Common Test Scenarios

### 1. Testing Forms

```dart
testWidgets('should_validate_input_when_form_is_submitted', (tester) async {
  // Arrange
  await tester.pumpTestWidget(LoginForm());
  
  // Act - Submit empty form
  await tester.tapAndSettle(CommonFinders.findButtonByText('Login'));
  
  // Assert
  expect(find.text('Email is required'), findsOneWidget,
    reason: 'Should show validation error for empty email');
  
  // Act - Enter valid data
  await tester.enterTextAndSettle(
    CommonFinders.findTextFieldByLabel('Email'),
    'test@example.com',
  );
  await tester.enterTextAndSettle(
    CommonFinders.findTextFieldByLabel('Password'),
    'password123',
  );
  
  // Assert - Button should be enabled
  final button = tester.widget<ElevatedButton>(
    CommonFinders.findButtonByText('Login'),
  );
  expect(button, WidgetMatchers.isEnabled,
    reason: 'Login button should be enabled with valid input');
});
```

### 2. Testing Lists

```dart
testWidgets('should_display_empty_state_when_list_is_empty', (tester) async {
  // Arrange
  when(() => mockProvider.getItems()).thenReturn([]);
  
  // Act
  await tester.pumpTestWidget(ItemListScreen());
  
  // Assert
  expect(find.text('No items found'), findsOneWidget,
    reason: 'Should show empty state message');
  expect(find.byIcon(Icons.inbox), findsOneWidget,
    reason: 'Should show empty state icon');
});

testWidgets('should_load_more_items_when_scrolled_to_bottom', (tester) async {
  // Arrange
  final items = List.generate(20, (i) => Item(id: i, name: 'Item $i'));
  when(() => mockProvider.getItems()).thenReturn(items);
  
  // Act
  await tester.pumpTestWidget(ItemListScreen());
  await tester.scrollUntilVisible(
    find.text('Item 19'),
    delta: 300,
  );
  
  // Assert
  verify(() => mockProvider.loadMore()).called(1);
});
```

### 3. Testing Animations

```dart
testWidgets('should_animate_card_flip_when_revealed', (tester) async {
  // Arrange
  final animationController = AnimationController(
    vsync: tester,
    duration: Duration(milliseconds: 300),
  );
  
  // Act
  await tester.pumpTestWidget(
    AnimatedCardWidget(
      controller: animationController,
      card: Card(value: 5, isRevealed: false),
    ),
  );
  
  // Start animation
  animationController.forward();
  
  // Assert - Check mid-animation
  await tester.pump(Duration(milliseconds: 150));
  expect(animationController.value, closeTo(0.5, 0.1),
    reason: 'Animation should be halfway through');
  
  // Complete animation
  await tester.pumpAndSettle();
  expect(animationController.value, equals(1.0),
    reason: 'Animation should be complete');
  
  // Cleanup
  animationController.dispose();
});
```

## Testing Checklist

- [ ] Widget renders correctly
- [ ] User interactions work as expected  
- [ ] Loading states display properly
- [ ] Error states are handled
- [ ] Empty states show appropriate UI
- [ ] Navigation works correctly
- [ ] Accessibility is maintained
- [ ] Responsive on different screen sizes
- [ ] Animations complete successfully
- [ ] Memory leaks are prevented (dispose controllers)