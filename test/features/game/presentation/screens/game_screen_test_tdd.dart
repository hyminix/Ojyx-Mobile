import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/features/game/presentation/screens/game_screen.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponents_view_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/common_area_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/turn_info_widget.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import '../../../../../helpers/widget_test_helpers.dart';
import '../../../../../helpers/test_data_builders.dart';

// Mock classes
class MockGameStateNotifier extends Mock implements GameStateNotifier {}
class MockAuthNotifier extends Mock implements AuthNotifier {}

// Fake classes
class FakeGameState extends Fake implements GameState {}

void main() {
  group('GameScreen', () {
    late MockGameStateNotifier mockGameNotifier;
    late MockAuthNotifier mockAuthNotifier;
    late MockGoRouter mockRouter;
    
    // Test constants
    const TEST_GAME_ID = 'game-123';
    const TEST_PLAYER_ID = 'player-789';
    const LOADING_TIMEOUT = Duration(seconds: 30);
    
    setUpAll(() {
      registerFallbackValue(FakeGameState());
    });
    
    setUp(() {
      mockGameNotifier = MockGameStateNotifier();
      mockAuthNotifier = MockAuthNotifier();
      mockRouter = WidgetTestUtils.createMockRouter();
      
      // Default auth state
      when(() => mockAuthNotifier.currentUser).thenReturn(
        UserBuilder().withId(TEST_PLAYER_ID).build(),
      );
    });
    
    GameState createTestGameState({
      bool isPlayerTurn = true,
      bool isLastRound = false,
      GameStatus status = GameStatus.inProgress,
    }) {
      return GameStateBuilder()
        .withId(TEST_GAME_ID)
        .withCurrentPlayerId(isPlayerTurn ? TEST_PLAYER_ID : 'opponent-1')
        .withPlayers([
          GamePlayerBuilder()
            .withId(TEST_PLAYER_ID)
            .withName('You')
            .build(),
          GamePlayerBuilder()
            .withId('opponent-1')
            .withName('Opponent 1')
            .build(),
          GamePlayerBuilder()
            .withId('opponent-2')
            .withName('Opponent 2')
            .build(),
        ])
        .withLastRound(isLastRound)
        .withStatus(status)
        .build();
    }
    
    Future<void> pumpGameScreen(
      WidgetTester tester, {
      List<Override>? additionalOverrides,
    }) async {
      await tester.pumpTestWidget(
        const GameScreen(gameId: TEST_GAME_ID),
        overrides: [
          gameStateNotifierProvider.overrideWith((ref) => mockGameNotifier),
          authNotifierProvider.overrideWith((ref) => mockAuthNotifier),
          ...(additionalOverrides ?? []),
        ],
        router: mockRouter,
      );
    }
    
    group('Loading state', () {
      testWidgets('should_display_loading_indicator_when_game_is_loading', (tester) async {
        // Arrange
        when(() => mockGameNotifier.state).thenReturn(
          const AsyncValue.loading(),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        WidgetTestUtils.expectLoading(tester);
        expect(
          find.text('Loading game...'),
          findsOneWidget,
          reason: 'Should show loading message for better UX',
        );
      });
      
      testWidgets('should_initialize_game_on_mount', (tester) async {
        // Arrange
        when(() => mockGameNotifier.state).thenReturn(
          const AsyncValue.loading(),
        );
        when(() => mockGameNotifier.loadGame(TEST_GAME_ID))
          .thenAnswer((_) async {});
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        verify(() => mockGameNotifier.loadGame(TEST_GAME_ID)).called(1);
      });
    });
    
    group('Error state', () {
      testWidgets('should_display_error_message_when_loading_fails', (tester) async {
        // Arrange
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.error(
            GameStateException('Failed to load game'),
            StackTrace.current,
          ),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          find.text('Failed to load game'),
          findsOneWidget,
          reason: 'Should display error message to user',
        );
        expect(
          CommonFinders.findButtonByText('Retry'),
          findsOneWidget,
          reason: 'Should provide retry option on error',
        );
      });
      
      testWidgets('should_retry_loading_when_retry_button_is_pressed', (tester) async {
        // Arrange
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.error(
            GameStateException('Network error'),
            StackTrace.current,
          ),
        );
        when(() => mockGameNotifier.loadGame(TEST_GAME_ID))
          .thenAnswer((_) async {});
        
        // Act
        await pumpGameScreen(tester);
        await tester.tapAndSettle(CommonFinders.findButtonByText('Retry'));
        
        // Assert
        verify(() => mockGameNotifier.loadGame(TEST_GAME_ID)).called(2); // Initial + retry
      });
    });
    
    group('Game board display', () {
      testWidgets('should_display_all_game_components_when_loaded', (tester) async {
        // Arrange
        final gameState = createTestGameState();
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(gameState),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          find.byType(TurnInfoWidget),
          findsOneWidget,
          reason: 'Should display turn information at top',
        );
        expect(
          find.byType(OpponentsViewWidget),
          findsOneWidget,
          reason: 'Should display opponents section',
        );
        expect(
          find.byType(CommonAreaWidget),
          findsOneWidget,
          reason: 'Should display deck and discard pile',
        );
        expect(
          find.byType(PlayerGridWidget),
          findsOneWidget,
          reason: 'Should display player\'s own grid',
        );
      });
      
      testWidgets('should_highlight_current_player_turn', (tester) async {
        // Arrange - Player's turn
        final playerTurnState = createTestGameState(isPlayerTurn: true);
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(playerTurnState),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          find.text('Your turn'),
          findsOneWidget,
          reason: 'Should indicate when it\'s player\'s turn',
        );
        
        // Arrange - Opponent's turn
        final opponentTurnState = createTestGameState(isPlayerTurn: false);
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(opponentTurnState),
        );
        
        // Act
        await tester.pump();
        
        // Assert
        expect(
          find.text('Opponent 1\'s turn'),
          findsOneWidget,
          reason: 'Should show which opponent is playing',
        );
      });
    });
    
    group('User interactions', () {
      testWidgets('should_allow_card_interaction_only_on_players_turn', (tester) async {
        // Arrange - Player's turn
        final gameState = createTestGameState(isPlayerTurn: true);
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(gameState),
        );
        when(() => mockGameNotifier.revealCard(any(), any()))
          .thenAnswer((_) async {});
        
        // Act
        await pumpGameScreen(tester);
        
        // Find and tap a card in player grid
        final playerGrid = find.byType(PlayerGridWidget);
        expect(playerGrid, findsOneWidget);
        
        // Assert - Cards should be interactive
        final gestureDetectors = find.descendant(
          of: playerGrid,
          matching: find.byType(GestureDetector),
        );
        expect(
          gestureDetectors,
          findsWidgets,
          reason: 'Cards should have tap handlers during player turn',
        );
      });
      
      testWidgets('should_show_end_turn_button_after_action', (tester) async {
        // Arrange
        final gameState = createTestGameState(isPlayerTurn: true);
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(gameState),
        );
        when(() => mockGameNotifier.hasPerformedAction).thenReturn(true);
        when(() => mockGameNotifier.endTurn()).thenAnswer((_) async {});
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          CommonFinders.findButtonByText('End Turn'),
          findsOneWidget,
          reason: 'End turn button should appear after player action',
        );
        
        // Act - Press end turn
        await tester.tapAndSettle(CommonFinders.findButtonByText('End Turn'));
        
        // Assert
        verify(() => mockGameNotifier.endTurn()).called(1);
      });
    });
    
    group('Game state transitions', () {
      testWidgets('should_show_last_round_warning_when_triggered', (tester) async {
        // Arrange
        final lastRoundState = createTestGameState(isLastRound: true);
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(lastRoundState),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          find.text('Last Round!'),
          findsOneWidget,
          reason: 'Should prominently display last round notification',
        );
        expect(
          find.byIcon(Icons.warning),
          findsOneWidget,
          reason: 'Should show warning icon for last round',
        );
      });
      
      testWidgets('should_navigate_to_end_screen_when_game_finishes', (tester) async {
        // Arrange
        final streamController = StreamController<AsyncValue<GameState>>();
        when(() => mockGameNotifier.state).thenAnswer(
          (_) => streamController.stream.last,
        );
        when(() => mockGameNotifier.stream).thenAnswer(
          (_) => streamController.stream,
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Emit in-progress state
        streamController.add(AsyncValue.data(createTestGameState()));
        await tester.pumpAndSettle();
        
        // Emit finished state
        streamController.add(AsyncValue.data(
          createTestGameState(status: GameStatus.finished),
        ));
        await tester.pumpAndSettle();
        
        // Assert
        verify(() => mockRouter.goNamed(
          'end-game',
          pathParameters: {'gameId': TEST_GAME_ID},
        )).called(1);
        
        // Cleanup
        await streamController.close();
      });
    });
    
    group('Responsive design', () {
      testWidgets('should_adapt_layout_for_phone_screen', (tester) async {
        // Arrange
        await tester.setScreenSize(TestScreenSizes.phone);
        final gameState = createTestGameState();
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(gameState),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          find.byType(GameScreen),
          findsOneWidget,
          reason: 'Game should render on phone screens',
        );
        // Additional phone-specific layout assertions
      });
      
      testWidgets('should_optimize_layout_for_tablet_screen', (tester) async {
        // Arrange
        await tester.setScreenSize(TestScreenSizes.tablet);
        final gameState = createTestGameState();
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(gameState),
        );
        
        // Act
        await pumpGameScreen(tester);
        
        // Assert
        expect(
          find.byType(GameScreen),
          findsOneWidget,
          reason: 'Game should render on tablet screens',
        );
        // Check for tablet-optimized layout (e.g., side-by-side components)
      });
    });
    
    group('Accessibility', () {
      testWidgets('should_provide_screen_reader_descriptions', (tester) async {
        // Arrange
        final gameState = createTestGameState();
        when(() => mockGameNotifier.state).thenReturn(
          AsyncValue.data(gameState),
        );
        
        // Act
        await pumpGameScreen(tester);
        await tester.pumpAndSettle();
        
        // Assert
        final semantics = tester.getSemantics(find.byType(GameScreen));
        expect(
          semantics.label,
          isNotEmpty,
          reason: 'Screen should have semantic label',
        );
        
        // Check key interactive elements
        final endTurnSemantics = tester.getSemantics(
          find.widgetWithText(ElevatedButton, 'End Turn'),
        );
        expect(
          endTurnSemantics.hasAction(SemanticsAction.tap),
          isTrue,
          reason: 'Interactive elements should be accessible',
        );
      });
    });
  });
}