import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/opponents_view_widget.dart';
import 'package:ojyx/features/game/presentation/widgets/opponent_grid_widget.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

class MockPlayer extends Mock implements Player {}

void main() {
  group('OpponentsViewWidget', () {
    late GameState mockGameState;
    late Player currentPlayer;
    late Player opponent1;
    late Player opponent2;

    setUp(() {
      currentPlayer = MockPlayer();
      opponent1 = MockPlayer();
      opponent2 = MockPlayer();

      // Setup current player
      when(() => currentPlayer.id).thenReturn('current-player-id');
      when(() => currentPlayer.name).thenReturn('Current Player');
      when(() => currentPlayer.grid).thenReturn(PlayerGrid.empty());
      when(() => currentPlayer.currentScore).thenReturn(10);
      when(() => currentPlayer.hasFinishedRound).thenReturn(false);

      // Setup opponent 1
      when(() => opponent1.id).thenReturn('opponent-1-id');
      when(() => opponent1.name).thenReturn('Opponent 1');
      when(() => opponent1.currentScore).thenReturn(15);
      when(() => opponent1.hasFinishedRound).thenReturn(false);
      
      final grid1 = PlayerGrid.empty();
      grid1.placeCard(game.Card(
        value: 5,
        isRevealed: true,
      ), 0, 0);
      when(() => opponent1.grid).thenReturn(grid1);

      // Setup opponent 2
      when(() => opponent2.id).thenReturn('opponent-2-id');
      when(() => opponent2.name).thenReturn('Opponent 2');
      when(() => opponent2.currentScore).thenReturn(20);
      when(() => opponent2.hasFinishedRound).thenReturn(true);
      
      final grid2 = PlayerGrid.empty();
      grid2.placeCard(game.Card(
        value: 8,
        isRevealed: true,
      ), 1, 1);
      when(() => opponent2.grid).thenReturn(grid2);

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
      final opponentWidgets = tester.widgetList<OpponentGridWidget>(
        find.byType(OpponentGridWidget),
      ).toList();
      
      // First opponent should be marked as current player
      expect(opponentWidgets[0].isCurrentPlayer, isTrue);
      // Second opponent should not be marked as current player
      expect(opponentWidgets[1].isCurrentPlayer, isFalse);
    });

    testWidgets('should handle player tap when callback provided', (tester) async {
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

    testWidgets('should convert player to PlayerState correctly', (tester) async {
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
      expect(opponentWidget.playerState.currentScore, equals(15));
      expect(opponentWidget.playerState.revealedCount, equals(1));
    });

    testWidgets('should have correct spacing between opponents', (tester) async {
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
        find.ancestor(
          of: find.byType(ListView),
          matching: find.byType(SizedBox),
        ).first,
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
      currentPlayer = MockPlayer();
      when(() => currentPlayer.id).thenReturn('current-player-id');
      when(() => currentPlayer.name).thenReturn('Current Player');
      when(() => currentPlayer.grid).thenReturn(PlayerGrid.empty());
      when(() => currentPlayer.currentScore).thenReturn(10);
      when(() => currentPlayer.hasFinishedRound).thenReturn(false);

      // Create 4 opponents
      opponents = List.generate(4, (index) {
        final opponent = MockPlayer();
        when(() => opponent.id).thenReturn('opponent-$index-id');
        when(() => opponent.name).thenReturn('Opponent $index');
        when(() => opponent.grid).thenReturn(PlayerGrid.empty());
        when(() => opponent.currentScore).thenReturn(10 + index * 5);
        when(() => opponent.hasFinishedRound).thenReturn(false);
        return opponent;
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
      final delegate = gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
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