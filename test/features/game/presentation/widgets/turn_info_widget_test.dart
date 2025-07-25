import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/widgets/turn_info_widget.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game_card;

class MockPlayer extends Mock implements GamePlayer {}

void main() {
  group('TurnInfoWidget', () {
    late GamePlayer mockCurrentPlayer;
    late GamePlayer mockOpponent;
    late GameState mockGameState;

    setUp(() {
      mockCurrentPlayer = MockPlayer();
      mockOpponent = MockPlayer();

      when(() => mockCurrentPlayer.id).thenReturn('current-user-id');
      when(() => mockCurrentPlayer.name).thenReturn('Current GamePlayer');
      when(() => mockCurrentPlayer.grid).thenReturn(PlayerGrid.empty());
      when(() => mockCurrentPlayer.isHost).thenReturn(true);

      when(() => mockOpponent.id).thenReturn('opponent-id');
      when(() => mockOpponent.name).thenReturn('Opponent GamePlayer');
      when(() => mockOpponent.grid).thenReturn(PlayerGrid.empty());
      when(() => mockOpponent.isHost).thenReturn(false);

      mockGameState = GameState.initial(
        roomId: 'test-room',
        players: [mockCurrentPlayer, mockOpponent],
      );
    });

    testWidgets('should display current player turn', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(
        currentPlayerIndex: 0, // Current player's turn
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Votre tour'), findsOneWidget);
      expect(
        find.byIcon(Icons.rotate_right),
        findsOneWidget,
      ); // Default is clockwise
    });

    testWidgets('should display opponent turn', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(
        currentPlayerIndex: 1, // Opponent's turn
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Tour de Opponent GamePlayer'), findsOneWidget);
      expect(
        find.byIcon(Icons.rotate_right),
        findsOneWidget,
      ); // Default is clockwise
    });

    testWidgets('should show last round indicator when lastRound is true', (
      tester,
    ) async {
      // Arrange
      final gameState = mockGameState.copyWith(
        lastRound: true,
        status: GameStatus.lastRound,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Dernier tour'), findsOneWidget);
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });

    testWidgets('should show draw phase status', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(status: GameStatus.drawPhase);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Phase de pioche'), findsOneWidget);
    });

    testWidgets('should show playing status with drawn card', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(
        status: GameStatus.playing,
        drawnCard: const game_card.Card(value: 5),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Phase de défausse'), findsOneWidget);
    });

    testWidgets('should show finished status', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(status: GameStatus.finished);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Partie terminée'), findsOneWidget);
    });

    testWidgets('should show counterclockwise direction', (tester) async {
      // Arrange
      final gameState = mockGameState.copyWith(
        turnDirection: TurnDirection.counterClockwise,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.rotate_left), findsOneWidget);
    });

    testWidgets('should apply correct styling for current player turn', (
      tester,
    ) async {
      // Arrange
      final gameState = mockGameState.copyWith(currentPlayerIndex: 0);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: Scaffold(
            body: TurnInfoWidget(
              gameState: gameState,
              currentPlayerId: 'current-user-id',
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isNotNull);
    });
  });
}
