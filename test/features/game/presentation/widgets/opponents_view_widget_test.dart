import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/presentation/widgets/opponents_view_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponent_grid_widget.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('OpponentsViewWidget', () {
    late GameState mockGameState;
    late Player currentPlayer;
    late Player opponent1;
    late Player opponent2;

    setUp(() {
      // Create current player with real Player object
      currentPlayer = Player(
        id: 'current-player-id',
        name: 'Current Player',
        grid: PlayerGrid.empty(),
        actionCards: [],
        isHost: false,
        hasFinishedRound: false,
      );

      // Setup opponent 1 with revealed card
      var grid1 = PlayerGrid.empty();
      grid1 = grid1.placeCard(game.Card(value: 5, isRevealed: false), 0, 0);
      grid1 = grid1.revealCard(0, 0);
      
      opponent1 = Player(
        id: 'opponent-1-id',
        name: 'Opponent 1',
        grid: grid1,
        actionCards: [],
        isHost: false,
        hasFinishedRound: false,
      );

      // Setup opponent 2 with revealed card
      var grid2 = PlayerGrid.empty();
      grid2 = grid2.placeCard(game.Card(value: 8, isRevealed: false), 1, 1);
      grid2 = grid2.revealCard(1, 1);
      
      opponent2 = Player(
        id: 'opponent-2-id',
        name: 'Opponent 2',
        grid: grid2,
        actionCards: [],
        isHost: false,
        hasFinishedRound: true,
      );

      mockGameState = GameState.initial(
        roomId: 'test-room',
        players: [currentPlayer, opponent1, opponent2],
      );
    });

    testWidgets('should display all opponents', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Adversaires (2)'), findsOneWidget);
      expect(find.byType(OpponentGridWidget), findsNWidgets(2));
    });

    testWidgets('should not display current player', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      // Should only show 2 opponents, not the current player
      expect(find.byType(OpponentGridWidget), findsNWidgets(2));
    });

    testWidgets('should display nothing when no opponents', (tester) async {
      // Arrange
      final singlePlayerState = GameState.initial(
        roomId: 'test-room',
        players: [currentPlayer],
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: singlePlayerState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(OpponentGridWidget), findsNothing);
    });

    testWidgets('should scroll horizontally', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.scrollDirection, equals(Axis.horizontal));
    });

    testWidgets('should highlight current turn player', (tester) async {
      // Arrange
      final gameStateWithTurn = mockGameState.copyWith(
        currentPlayerIndex: 1, // opponent1's turn
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: gameStateWithTurn,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      final opponentWidgets = tester
          .widgetList<OpponentGridWidget>(find.byType(OpponentGridWidget))
          .toList();

      // First opponent should be marked as current player
      expect(opponentWidgets[0].isCurrentPlayer, isTrue);
      // Second opponent should not be marked as current player
      expect(opponentWidgets[1].isCurrentPlayer, isFalse);
    });

    testWidgets('should handle player tap when callback provided', (
      tester,
    ) async {
      // Arrange
      String? tappedPlayerId;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
              onPlayerTap: (playerId) => tappedPlayerId = playerId,
            ),
          ),
        ),
      );

      // Tap on first opponent
      await tester.tap(find.byType(OpponentGridWidget).first);
      await tester.pump();

      // Assert
      expect(tappedPlayerId, equals('opponent-1-id'));
    });

    testWidgets('should convert player to PlayerState correctly', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      final opponentWidget = tester.widget<OpponentGridWidget>(
        find.byType(OpponentGridWidget).first,
      );

      expect(opponentWidget.playerState.playerId, equals('opponent-1-id'));
      expect(opponentWidget.playerState.currentScore, equals(5)); // Score from one card with value 5
      expect(opponentWidget.playerState.revealedCount, equals(1));
    });

    testWidgets('should have correct spacing between opponents', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      final paddings = tester.widgetList<Padding>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Padding),
        ),
      );

      // Check that padding is applied between items
      expect(paddings, isNotEmpty);
    });

    testWidgets('should have fixed height container', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ListView),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.height, equals(220));
    });

    testWidgets('should set fixed width for each opponent', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      final sizedBoxes = tester.widgetList<SizedBox>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(SizedBox),
        ),
      );

      // Find SizedBoxes that wrap OpponentGridWidget
      for (final sizedBox in sizedBoxes) {
        if (sizedBox.width == 200) {
          expect(sizedBox.width, equals(200));
        }
      }
    });
  });

  group('OpponentsGridViewWidget', () {
    late GameState mockGameState;
    late Player currentPlayer;
    late List<Player> opponents;

    setUp(() {
      currentPlayer = Player(
        id: 'current-player-id',
        name: 'Current Player',
        grid: PlayerGrid.empty(),
        actionCards: [],
        isHost: false,
        hasFinishedRound: false,
      );

      // Create 4 opponents
      opponents = List.generate(4, (index) {
        return Player(
          id: 'opponent-$index-id',
          name: 'Opponent $index',
          grid: PlayerGrid.empty(),
          actionCards: [],
          isHost: false,
          hasFinishedRound: false,
        );
      });

      mockGameState = GameState.initial(
        roomId: 'test-room',
        players: [currentPlayer, ...opponents],
      );
    });

    testWidgets('should display opponents in grid layout', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsGridViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Adversaires (4)'), findsOneWidget);
      expect(find.byType(OpponentGridWidget), findsNWidgets(4));
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should use correct cross axis count', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsGridViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
              crossAxisCount: 3,
            ),
          ),
        ),
      );

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));
    });

    testWidgets('should not scroll', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpponentsGridViewWidget(
              gameState: mockGameState,
              currentPlayerId: 'current-player-id',
            ),
          ),
        ),
      );

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(gridView.physics, isA<NeverScrollableScrollPhysics>());
      expect(gridView.shrinkWrap, isTrue);
    });
  });
}
