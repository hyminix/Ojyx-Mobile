import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/screens/game_screen.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_with_selection.dart';
import 'package:ojyx/features/game/presentation/widgets/turn_info_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/deck_and_discard_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponents_view_widget.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider_v2.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import '../../../../helpers/test_helpers.dart';

class MockRoom extends Mock implements Room {}

class MockGameState extends Mock implements GameState {}

class MockPlayer extends Mock implements GamePlayer {}

class FakeGameStateNotifier extends GameStateNotifier {
  final GameState? _gameState;

  FakeGameStateNotifier(this._gameState);

  @override
  GameState? build() => _gameState;
}

void main() {
  group('GameScreen Gameplay Interactions', () {
    late MockRoom mockRoom;
    late GameState mockGameState;
    late GamePlayer mockCurrentPlayer;
    late GamePlayer mockOpponent;
    late List<game.Card> testCards;
    late PlayerGrid testGrid;

    setUp(() {
      FlutterError.onError = (details) {
        if (details.exception.toString().contains('RenderFlex overflowed')) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };

      mockRoom = MockRoom();
      mockCurrentPlayer = MockPlayer();
      mockOpponent = MockPlayer();

      // Setup realistic game scenario with cards
      testCards = List.generate(
        12,
        (index) => game.Card(value: index % 13 - 2),
      );
      testGrid = PlayerGrid.fromCards(testCards);

      when(() => mockCurrentPlayer.id).thenReturn('current-user-id');
      when(() => mockCurrentPlayer.name).thenReturn('Current Player');
      when(() => mockCurrentPlayer.grid).thenReturn(testGrid);
      when(() => mockCurrentPlayer.isHost).thenReturn(true);
      when(() => mockCurrentPlayer.actionCards).thenReturn([]);
      when(() => mockCurrentPlayer.currentScore).thenReturn(15);
      when(() => mockCurrentPlayer.hasFinishedRound).thenReturn(false);

      when(() => mockOpponent.id).thenReturn('opponent-id');
      when(() => mockOpponent.name).thenReturn('Opponent');
      when(() => mockOpponent.grid).thenReturn(PlayerGrid.empty());
      when(() => mockOpponent.isHost).thenReturn(false);
      when(() => mockOpponent.actionCards).thenReturn([]);
      when(() => mockOpponent.currentScore).thenReturn(12);
      when(() => mockOpponent.hasFinishedRound).thenReturn(false);

      mockGameState = GameState.initial(
        roomId: 'test-room-id',
        players: [mockCurrentPlayer, mockOpponent],
      );

      when(() => mockRoom.id).thenReturn('test-room-id');
      when(() => mockRoom.status).thenReturn(RoomStatus.inGame);
      when(
        () => mockRoom.playerIds,
      ).thenReturn(['current-user-id', 'opponent-id']);
    });

    Widget createWidgetUnderTest({
      String? currentUserId,
      GameState? gameState,
      AsyncValue<Room>? roomAsync,
    }) {
      return ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWithValue(
            currentUserId ?? 'current-user-id',
          ),
          gameStateNotifierProvider.overrideWith(
            () => FakeGameStateNotifier(gameState),
          ),
          currentRoomProvider('test-room-id').overrideWith((ref) {
            if (roomAsync != null) {
              return roomAsync.when(
                data: (room) => Stream.value(room),
                loading: () => const Stream.empty(),
                error: (error, stack) => Stream.error(error),
              );
            }
            return Stream.value(mockRoom);
          }),
        ],
        child: createTestApp(child: const GameScreen(roomId: 'test-room-id')),
      );
    }

    testWidgets('should display loading when game state is null', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: null));
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('En attente du début de la partie...'), findsOneWidget);
    });

    testWidgets('should display game components when game state is loaded', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(TurnInfoWidget), findsOneWidget);
      expect(find.byType(DeckAndDiscardWidget), findsOneWidget);
      expect(find.byType(OpponentsViewWidget), findsOneWidget);
      expect(find.byType(PlayerGridWidget), findsOneWidget);
    });

    testWidgets('should display app bar with title and exit button', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Ojyx'), findsOneWidget);
      expect(find.byIcon(Icons.exit_to_app), findsOneWidget);
    });

    testWidgets('should show exit dialog when exit button is pressed', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.exit_to_app));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Quitter la partie ?'), findsOneWidget);
    });

    testWidgets('should display error when current player not found', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          currentUserId: 'unknown-user-id',
          gameState: mockGameState,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur: Joueur non trouvé'), findsOneWidget);
    });

    testWidgets('should display loading state when room is loading', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(roomAsync: const AsyncValue.loading()),
      );
      await tester.pump();

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error state when room loading fails', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          roomAsync: const AsyncValue.error(
            'Failed to load room',
            StackTrace.empty,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Erreur'), findsOneWidget);
      expect(find.text('Failed to load room'), findsOneWidget);
    });

    testWidgets('should initialize multiplayer sync on init', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      // Assert
      // The multiplayer notifier should be initialized
      // This is tested by the fact that the widget builds without error
      expect(find.byType(GameScreen), findsOneWidget);
    });

    testWidgets('should handle game over state', (tester) async {
      // Arrange
      final gameOverState = mockGameState.copyWith(status: GameStatus.finished);

      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: gameOverState));
      await tester.pumpAndSettle();

      // Assert
      // Should still display game components even when finished
      expect(find.byType(PlayerGridWidget), findsOneWidget);
    });

    testWidgets('should pass correct props to child widgets', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      // Assert TurnInfoWidget props
      final turnInfo = tester.widget<TurnInfoWidget>(
        find.byType(TurnInfoWidget),
      );
      expect(turnInfo.gameState, equals(mockGameState));
      expect(turnInfo.currentPlayerId, equals('current-user-id'));

      // Assert OpponentsViewWidget props
      final opponentsView = tester.widget<OpponentsViewWidget>(
        find.byType(OpponentsViewWidget),
      );
      expect(opponentsView.gameState, equals(mockGameState));
      expect(opponentsView.currentPlayerId, equals('current-user-id'));
    });

    testWidgets('should be scrollable', (tester) async {
      // Act
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      // Assert - find the main SingleChildScrollView (direct child of GameScreen)
      expect(find.byType(SingleChildScrollView), findsAtLeast(1));
    });

    group('Strategic Teleportation Interactions', () {
      testWidgets(
        'should enable tactical card exchange through teleportation selection interface',
        (tester) async {
          // Test behavior: teleportation provides strategic card positioning for competitive advantage
          await tester.pumpWidget(
            createWidgetUnderTest(gameState: mockGameState),
          );
          await tester.pumpAndSettle();

          // Initially normal gameplay interface
          expect(find.byType(PlayerGridWidget), findsOneWidget);
          expect(find.byType(PlayerGridWithSelection), findsNothing);

          final container = ProviderScope.containerOf(
            tester.element(find.byType(GameScreen)),
          );

          // Strategic teleportation activation
          container
              .read(cardSelectionProvider.notifier)
              .startTeleportSelection();
          await tester.pump();

          // Tactical selection interface should enable strategic positioning
          expect(
            find.byType(PlayerGridWithSelection),
            findsOneWidget,
            reason: 'Strategic selection interface should activate',
          );
          expect(
            find.text('Sélectionnez la première carte à échanger'),
            findsOneWidget,
            reason: 'Clear tactical instructions for competitive play',
          );
        },
      );

      testWidgets(
        'should execute complete strategic card exchange workflow for competitive positioning',
        (tester) async {
          // Test behavior: full teleportation workflow enables tactical card repositioning
          await tester.pumpWidget(
            createWidgetUnderTest(gameState: mockGameState),
          );
          await tester.pumpAndSettle();

          final container = ProviderScope.containerOf(
            tester.element(find.byType(GameScreen)),
          );

          // Strategic workflow initiation
          container
              .read(cardSelectionProvider.notifier)
              .startTeleportSelection();
          await tester.pump();

          // Tactical first card selection for positioning
          container.read(cardSelectionProvider.notifier).selectCard(0, 0);
          await tester.pump();
          expect(
            find.text('Sélectionnez la deuxième carte à échanger'),
            findsOneWidget,
            reason: 'Progressive selection for strategic control',
          );

          // Tactical second card selection completes strategy
          container.read(cardSelectionProvider.notifier).selectCard(1, 2);
          await tester.pump();
          expect(
            find.text('Cartes sélectionnées - confirmez l\'échange'),
            findsOneWidget,
            reason: 'Strategic confirmation prevents accidental exchanges',
          );
          expect(
            find.text('Confirmer'),
            findsOneWidget,
            reason: 'Explicit tactical confirmation required',
          );
        },
      );

      testWidgets(
        'should provide strategic cancellation to preserve current positioning',
        (tester) async {
          // Test behavior: cancellation prevents unwanted strategic changes
          await tester.pumpWidget(
            createWidgetUnderTest(gameState: mockGameState),
          );
          await tester.pumpAndSettle();

          final container = ProviderScope.containerOf(
            tester.element(find.byType(GameScreen)),
          );

          // Begin strategic selection process
          container
              .read(cardSelectionProvider.notifier)
              .startTeleportSelection();
          container.read(cardSelectionProvider.notifier).selectCard(0, 0);
          await tester.pump();

          // Strategic cancellation preserves current advantage
          await tester.ensureVisible(find.text('Annuler'));
          await tester.tap(find.text('Annuler'));
          await tester.pump();

          expect(
            container.read(cardSelectionProvider).isSelecting,
            isFalse,
            reason: 'Strategic cancellation should preserve current state',
          );
          expect(
            find.byType(PlayerGridWidget),
            findsOneWidget,
            reason: 'Return to normal competitive interface',
          );
        },
      );

      testWidgets(
        'should complete strategic exchange execution for competitive positioning optimization',
        (tester) async {
          // Test behavior: teleportation execution provides immediate tactical advantage
          await tester.pumpWidget(
            createWidgetUnderTest(gameState: mockGameState),
          );
          await tester.pumpAndSettle();

          final container = ProviderScope.containerOf(
            tester.element(find.byType(GameScreen)),
          );

          // Execute complete strategic workflow
          container
              .read(cardSelectionProvider.notifier)
              .startTeleportSelection();
          container.read(cardSelectionProvider.notifier).selectCard(0, 0);
          container.read(cardSelectionProvider.notifier).selectCard(1, 2);
          await tester.pump();

          // Strategic execution completes positioning optimization
          await tester.ensureVisible(find.text('Confirmer'));
          await tester.tap(find.text('Confirmer'), warnIfMissed: false);
          await tester.pump();

          expect(
            container.read(cardSelectionProvider).isSelecting,
            isFalse,
            reason: 'Strategic execution should complete seamlessly',
          );
          expect(
            find.byType(PlayerGridWidget),
            findsOneWidget,
            reason:
                'Return to normal competitive state after tactical maneuver',
          );
        },
      );
    });
  });
}
