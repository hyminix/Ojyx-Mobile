import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/screens/game_screen.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/player_grid_with_selection.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import '../../../../helpers/test_helpers.dart';

class MockRoom extends Mock implements Room {}

class MockGameState extends Mock implements GameState {}

class MockPlayer extends Mock implements Player {}

class FakeGameStateNotifier extends GameStateNotifier {
  final GameState? _gameState;

  FakeGameStateNotifier(this._gameState);

  @override
  GameState? build() => _gameState;
}

void main() {
  group('GameScreen - Basic Teleportation Setup', () {
    late MockRoom mockRoom;
    late GameState mockGameState;
    late Player mockCurrentPlayer;
    late Player mockOpponent;
    late List<game.Card> testCards;
    late PlayerGrid testGrid;

    setUp(() {
      mockRoom = MockRoom();
      mockCurrentPlayer = MockPlayer();
      mockOpponent = MockPlayer();

      // Setup test cards and grid
      testCards = List.generate(12, (index) => game.Card(value: index));
      testGrid = PlayerGrid.fromCards(testCards);

      // Setup players
      when(() => mockCurrentPlayer.id).thenReturn('current-user-id');
      when(() => mockCurrentPlayer.name).thenReturn('Current Player');
      when(() => mockCurrentPlayer.grid).thenReturn(testGrid);
      when(() => mockCurrentPlayer.isHost).thenReturn(true);
      when(() => mockCurrentPlayer.actionCards).thenReturn([]);
      when(() => mockCurrentPlayer.currentScore).thenReturn(0);
      when(() => mockCurrentPlayer.hasFinishedRound).thenReturn(false);

      when(() => mockOpponent.id).thenReturn('opponent-id');
      when(() => mockOpponent.name).thenReturn('Opponent');
      when(() => mockOpponent.grid).thenReturn(PlayerGrid.empty());
      when(() => mockOpponent.isHost).thenReturn(false);
      when(() => mockOpponent.actionCards).thenReturn([]);
      when(() => mockOpponent.currentScore).thenReturn(0);
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

    testWidgets(
      'should show PlayerGridWithSelection when teleport mode is active',
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          createWidgetUnderTest(gameState: mockGameState),
        );
        await tester.pumpAndSettle();

        // Initially should show normal PlayerGridWidget (not in selection mode)
        expect(find.byType(PlayerGridWidget), findsOneWidget);
        expect(find.byType(PlayerGridWithSelection), findsNothing);

        // Get the provider container
        final container = ProviderScope.containerOf(
          tester.element(find.byType(GameScreen)),
        );

        // Start teleportation selection
        container.read(cardSelectionProvider.notifier).startTeleportSelection();
        await tester.pump();

        // Now it should show PlayerGridWithSelection which contains PlayerGridWidget
        expect(find.byType(PlayerGridWithSelection), findsOneWidget);
        expect(find.byType(PlayerGridWidget), findsOneWidget);
      },
    );

    testWidgets('should show selection instructions during teleportation', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameScreen)),
      );

      // Act - Start teleportation
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Assert
      expect(
        find.text('Sélectionnez la première carte à échanger'),
        findsOneWidget,
      );
    });

    testWidgets('should handle complete teleportation selection flow', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameScreen)),
      );

      // Start teleportation
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      await tester.pump();

      // Select first card
      container.read(cardSelectionProvider.notifier).selectCard(0, 0);
      await tester.pump();

      // Should update instruction
      expect(
        find.text('Sélectionnez la deuxième carte à échanger'),
        findsOneWidget,
      );

      // Select second card
      container.read(cardSelectionProvider.notifier).selectCard(1, 2);
      await tester.pump();

      // Should show confirmation
      expect(
        find.text('Cartes sélectionnées - confirmez l\'échange'),
        findsOneWidget,
      );
      expect(find.text('Confirmer'), findsOneWidget);
      expect(find.text('Annuler'), findsOneWidget);
    });

    testWidgets('should cancel teleportation when cancel is pressed', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameScreen)),
      );

      // Start selection
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      container.read(cardSelectionProvider.notifier).selectCard(0, 0);
      await tester.pump();

      // Act - Scroll to cancel button and tap it
      await tester.ensureVisible(find.text('Annuler'));
      await tester.tap(find.text('Annuler'));
      await tester.pump();

      // Assert - Should go back to normal grid
      expect(container.read(cardSelectionProvider).isSelecting, isFalse);
      expect(find.byType(PlayerGridWidget), findsOneWidget);
      expect(find.byType(PlayerGridWithSelection), findsNothing);
    });

    testWidgets('should handle teleportation callback', (tester) async {
      // Arrange
      Map<String, dynamic>? receivedData;

      await tester.pumpWidget(createWidgetUnderTest(gameState: mockGameState));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameScreen)),
      );

      // Complete selection
      container.read(cardSelectionProvider.notifier).startTeleportSelection();
      container.read(cardSelectionProvider.notifier).selectCard(0, 0);
      container.read(cardSelectionProvider.notifier).selectCard(1, 2);
      await tester.pump();

      // Find and tap confirm button (with scrolling to make it visible)
      await tester.ensureVisible(find.text('Confirmer'));
      await tester.tap(find.text('Confirmer'), warnIfMissed: false);
      await tester.pump();

      // Assert - Selection should be cleared and back to normal grid
      expect(container.read(cardSelectionProvider).isSelecting, isFalse);
      expect(find.byType(PlayerGridWidget), findsOneWidget);
      expect(find.byType(PlayerGridWithSelection), findsNothing);
    });
  });
}
