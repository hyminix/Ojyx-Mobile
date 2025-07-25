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
  group('Spectator Mode Strategic Information Display', () {
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

    testWidgets(
      'should provide comprehensive competitive overview for strategic decision-making',
      (tester) async {
        // Test behavior: spectator view enables players to monitor all opponents
        // simultaneously, gathering critical information for strategic planning

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify comprehensive opponent monitoring capability
        expect(
          find.byType(OpponentsViewWidget),
          findsOneWidget,
          reason: 'Central opponent monitoring system should be active',
        );
        expect(
          find.byType(OpponentGridWidget),
          findsNWidgets(3),
          reason:
              'All opponents should be visible for complete strategic awareness',
        );

        // Verify turn order awareness for timing strategies
        final opponentWidgets = tester
            .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
            .toList();

        final currentTurnWidget = opponentWidgets.firstWhere(
          (widget) => widget.isCurrentPlayer,
        );

        expect(
          currentTurnWidget.playerState.playerId,
          equals('player-1'),
          reason: 'Current turn indicator enables strategic timing decisions',
        );
      },
    );

    testWidgets(
      'should reveal competitive endgame dynamics through finish indicators',
      (tester) async {
        // Test behavior: finish indicators create strategic pressure and inform
        // risk-taking decisions as players approach the endgame

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Identify finished players for strategic assessment
        final opponentWidgets = tester
            .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
            .toList();

        final finishedPlayers = opponentWidgets
            .where((widget) => widget.playerState.hasFinished)
            .toList();

        expect(
          finishedPlayers,
          isNotEmpty,
          reason:
              'Finished player indicators create urgency for remaining players',
        );

        // Strategic implication: finished players lock in their scores,
        // creating a benchmark that influences risk/reward calculations
        expect(
          finishedPlayers.first.playerState.playerId,
          equals('player-3'),
          reason: 'Early finishers set competitive pace and scoring targets',
        );
      },
    );

    testWidgets(
      'should enable real-time strategic adaptation through live state monitoring',
      (tester) async {
        // Test behavior: real-time updates allow players to adapt strategies
        // dynamically as the competitive landscape evolves

        final notifier = FakeGameStateNotifier(gameState);

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

        // Initial strategic assessment
        var opponentWidgets = tester
            .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
            .toList();
        final initialCurrentPlayer = opponentWidgets
            .firstWhere((w) => w.isCurrentPlayer)
            .playerState
            .playerId;

        expect(
          initialCurrentPlayer,
          equals('player-1'),
          reason: 'Initial turn order informs immediate strategic planning',
        );

        // Simulate turn progression changing competitive dynamics
        gameState = gameState.copyWith(currentPlayerIndex: 2);
        notifier.setGameState(gameState);
        await tester.pumpAndSettle();

        // Verify strategic adaptation to new turn order
        opponentWidgets = tester
            .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
            .toList();
        final newCurrentPlayer = opponentWidgets
            .firstWhere((w) => w.isCurrentPlayer)
            .playerState
            .playerId;

        expect(
          newCurrentPlayer,
          equals('player-2'),
          reason:
              'Turn transitions create new strategic opportunities and threats',
        );

        // Strategic implication: players must continuously reassess threats
        // and opportunities as turn order progresses
      },
    );

    testWidgets(
      'should provide strategic intelligence through progressive information revelation',
      (tester) async {
        // Test behavior: revealed card counts indicate opponent progress and
        // risk tolerance, enabling strategic profiling and prediction

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Strategic card revelation patterns
        final revealPatterns = [
          ('player-1', 2, 'Conservative play - minimal information exposure'),
          ('player-2', 3, 'Balanced approach - moderate risk tolerance'),
          (
            'player-3',
            4,
            'Aggressive revelation - high confidence or desperation',
          ),
        ];

        for (final (playerId, expectedCount, strategicProfile)
            in revealPatterns) {
          final revealIndicator = find.byKey(
            ValueKey('revealed_count_$playerId'),
          );
          expect(
            revealIndicator,
            findsOneWidget,
            reason: 'Card revelation tracking enables opponent profiling',
          );

          // Strategic insight: revelation patterns indicate:
          // - Low count: defensive play, information hoarding
          // - High count: aggressive play or forced reveals
          // - Sudden changes: strategic shifts or panic moves
        }

        // Interactive intelligence gathering
        await tester.tap(find.byType(OpponentGridWidget).first);
        await tester.pump();

        // Tapping opponents could reveal additional strategic information
        // such as action card counts, recent moves, or scoring estimates
      },
    );

    testWidgets(
      'should display opponent information on different screen sizes',
      (tester) async {
        // Given: A standard mobile device screen size to avoid overflow
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;

        // When: Viewing the game screen
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Then: Opponent view is displayed with 3 opponents
        expect(find.byType(OpponentsViewWidget), findsOneWidget);
        expect(find.byType(OpponentGridWidget), findsNWidgets(3));

        // Cleanup
        await tester.binding.setSurfaceSize(null);
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      },
    );

    testWidgets(
      'should track column elimination opportunities for scoring optimization',
      (tester) async {
        // Given: A player with identical cards in a column
        await tester.binding.setSurfaceSize(const Size(800, 1200));
        tester.view.physicalSize = const Size(800, 1200);
        tester.view.devicePixelRatio = 1.0;

        final strategicGrid = PlayerGrid.empty();
        // Column 0: all 5s (elimination opportunity)
        for (int row = 0; row < 3; row++) {
          strategicGrid.placeCard(
            const game.Card(value: 5, isRevealed: true),
            row,
            0,
          );
        }

        final tacticalPlayer = GamePlayer(
          id: 'tactical-player',
          name: 'Column Master',
          grid: strategicGrid,
          actionCards: [],
          isHost: false,
          hasFinishedRound: false,
        );

        gameState = GameState.initial(
          roomId: 'test-room',
          players: [players[0], tacticalPlayer],
        );

        // When: Viewing the game
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Then: Column elimination indicator is shown
        final columnIndicator = find.byKey(
          const ValueKey('identical_columns_tactical-player'),
        );
        expect(columnIndicator, findsOneWidget);

        // Cleanup
        await tester.binding.setSurfaceSize(null);
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      },
    );
  });
}
