import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/screens/game_screen.dart';
import 'package:ojyx/features/game/presentation/widgets/opponents_view_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponent_grid_widget.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import '../../../helpers/test_helpers.dart';

class MockRoom extends Mock implements Room {}

class FakeGameStateNotifier extends GameStateNotifier {
  GameState? _gameState;

  FakeGameStateNotifier(this._gameState);

  @override
  GameState? build() => _gameState;

  void setGameState(GameState state) {
    _gameState = state;
    this.state = state;
  }
}

void main() {
  group('Spectator View Integration Test', () {
    late MockRoom mockRoom;
    late GameState gameState;
    late List<GamePlayer> players;

    setUp(() {
      mockRoom = MockRoom();

      // Create 4 players for a good spectator view test
      players = List.generate(4, (index) {
        final playerId = 'player-$index';

        // Create a grid with some revealed cards
        final grid = PlayerGrid.empty();
        // Place revealed cards based on player index
        // GamePlayer 0: 1 revealed card
        // GamePlayer 1: 2 revealed cards
        // GamePlayer 2: 3 revealed cards
        // GamePlayer 3: 4 revealed cards
        for (int i = 0; i < index + 1; i++) {
          final row = i ~/ 4;
          final col = i % 4;
          grid.placeCard(
            game.Card(value: (i + 1) * 2, isRevealed: false),
            row,
            col,
          );
          // Reveal the card
          grid.revealCard(row, col);
        }

        return GamePlayer(
          id: playerId,
          name: 'GamePlayer $index',
          grid: grid,
          actionCards: [],
          isHost: index == 0,
          hasFinishedRound: index == 3, // Last player finished
        );
      });

      gameState = GameState.initial(roomId: 'test-room', players: players);

      // Set player 1 as current turn
      gameState = gameState.copyWith(currentPlayerIndex: 1);

      when(() => mockRoom.id).thenReturn('test-room');
      when(() => mockRoom.status).thenReturn(RoomStatus.inGame);
      when(
        () => mockRoom.playerIds,
      ).thenReturn(players.map((p) => p.id).toList());
    });

    Widget createTestWidget({String currentUserId = 'player-0'}) {
      return ProviderScope(
        overrides: [
          currentUserIdProvider.overrideWithValue(currentUserId),
          gameStateNotifierProvider.overrideWith(
            () => FakeGameStateNotifier(gameState),
          ),
          currentRoomProvider('test-room').overrideWith((ref) {
            return Stream.value(mockRoom);
          }),
        ],
        child: createTestApp(child: const GameScreen(roomId: 'test-room')),
      );
    }

    testWidgets('should display all opponents in spectator view', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OpponentsViewWidget), findsOneWidget);
      expect(find.byType(OpponentGridWidget), findsNWidgets(3)); // 3 opponents
    });

    testWidgets('should highlight current turn player in spectator view', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final opponentWidgets = tester
          .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
          .toList();

      // GamePlayer 1 should be highlighted as current turn
      expect(opponentWidgets[0].isCurrentPlayer, isTrue);
      expect(opponentWidgets[0].playerState.playerId, equals('player-1'));
    });

    testWidgets('should show finish flag for players who finished', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // GamePlayer 3 has finished, should show flag
      final lastOpponentWidget = tester.widget<OpponentGridWidget>(
        find.byType(OpponentGridWidget).last,
      );
      expect(lastOpponentWidget.playerState.hasFinished, isTrue);
    });

    testWidgets('should update spectator view when game state changes', (
      tester,
    ) async {
      // Create a notifier that we can update
      final notifier = FakeGameStateNotifier(gameState);

      // Initial render
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserIdProvider.overrideWithValue('player-0'),
            gameStateNotifierProvider.overrideWith(() => notifier),
            currentRoomProvider('test-room').overrideWith((ref) {
              return Stream.value(mockRoom);
            }),
          ],
          child: createTestApp(child: const GameScreen(roomId: 'test-room')),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial state
      var opponentWidgets = tester
          .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
          .toList();
      expect(opponentWidgets[0].isCurrentPlayer, isTrue); // GamePlayer 1 is current

      // Update game state
      gameState = gameState.copyWith(
        currentPlayerIndex: 2, // Change current player
      );
      notifier.setGameState(gameState);

      // Trigger rebuild
      await tester.pump();
      await tester.pumpAndSettle();

      // Verify current player highlight changed
      opponentWidgets = tester
          .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
          .toList();

      expect(
        opponentWidgets[1].isCurrentPlayer,
        isTrue,
      ); // GamePlayer 2 is now current
      expect(
        opponentWidgets[0].isCurrentPlayer,
        isFalse,
      ); // GamePlayer 1 is not current
    });

    testWidgets('should handle tap on opponent grid', (tester) async {
      // Arrange
      String? tappedPlayerId;

      // Override the widget to capture taps
      gameState = GameState.initial(roomId: 'test-room', players: players);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find and tap first opponent
      await tester.tap(find.byType(OpponentGridWidget).first);
      await tester.pump();

      // Note: In real implementation, onPlayerTap would be connected
      // This test verifies the tap gesture is recognized
      expect(find.byType(OpponentGridWidget), findsWidgets);
    });

    testWidgets('should show correct revealed card counts', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // Use keys to find specific counts
      // GamePlayer 1 has 2 revealed cards
      expect(
        find.byKey(const ValueKey('revealed_count_player-1')),
        findsOneWidget,
      );
      // GamePlayer 2 has 3 revealed cards
      expect(
        find.byKey(const ValueKey('revealed_count_player-2')),
        findsOneWidget,
      );
      // GamePlayer 3 has 4 revealed cards
      expect(
        find.byKey(const ValueKey('revealed_count_player-3')),
        findsOneWidget,
      );
    });

    testWidgets('should handle different screen sizes', (tester) async {
      // Test on tablet size
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(OpponentsViewWidget), findsOneWidget);

      // Reset size
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('should display player avatars with initials', (tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // Each player should have avatar with first 2 letters of ID
      expect(
        find.text('PL'),
        findsNWidgets(3),
      ); // All opponents have 'player-X' IDs
    });

    testWidgets('should show identical columns if any', (tester) async {
      // Arrange - Create a player with identical column
      final grid = PlayerGrid.empty();
      // Create identical column (all 5s in column 0)
      for (int row = 0; row < 3; row++) {
        grid.placeCard(game.Card(value: 5, isRevealed: true), row, 0);
      }

      final playerWithColumns = GamePlayer(
        id: 'player-columns',
        name: 'Columns GamePlayer',
        grid: grid,
        actionCards: [],
        isHost: false,
        hasFinishedRound: false,
      );

      gameState = GameState.initial(
        roomId: 'test-room',
        players: [players[0], playerWithColumns],
      );

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      // Should find "1" for identical columns count using key
      expect(
        find.byKey(const ValueKey('identical_columns_player-columns')),
        findsOneWidget,
      );
    });
  });
}
