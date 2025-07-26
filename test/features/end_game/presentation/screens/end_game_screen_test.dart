import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/end_game/presentation/screens/end_game_screen.dart';
import 'package:ojyx/features/end_game/presentation/providers/end_game_provider.dart';
import 'package:ojyx/features/end_game/domain/entities/end_game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game_card;
import 'package:mocktail/mocktail.dart';

class MockEndGameState extends Mock implements EndGameState {}

class MockEndGameStateNotifier extends EndGameStateNotifier {
  MockEndGameStateNotifier(this._state);

  final EndGameState? _state;

  @override
  EndGameState? build() => _state;
}

class MockEndGameAction extends EndGameAction {
  MockEndGameAction(this.onEndGame);

  final VoidCallback onEndGame;

  @override
  void build() {}

  @override
  Future<void> endGame() async {
    onEndGame();
  }
}

void main() {
  group('EndGameScreen', () {
    late EndGameState mockEndGameState;
    late List<GamePlayer> testPlayers;

    PlayerGrid createGridWithScore(int totalScore) {
      final cards = <game_card.Card>[];
      var remainingScore = totalScore;

      for (int i = 0; i < 12; i++) {
        int cardValue;
        if (remainingScore > 12) {
          cardValue = 12;
          remainingScore -= 12;
        } else if (remainingScore < -2) {
          cardValue = -2;
          remainingScore -= -2;
        } else {
          cardValue = remainingScore;
          remainingScore = 0;
        }
        cards.add(game_card.Card(value: cardValue, isRevealed: true));
      }

      var grid = PlayerGrid.empty();
      for (int i = 0; i < cards.length; i++) {
        final row = i ~/ 4;
        final col = i % 4;
        grid = grid.setCard(row, col, cards[i]);
      }
      return grid;
    }

    setUp(() {
      testPlayers = [
        GamePlayer(
          id: 'player1',
          name: 'Alice',
          grid: createGridWithScore(25),
          hasFinishedRound: true,
        ),
        GamePlayer(
          id: 'player2',
          name: 'Bob',
          grid: createGridWithScore(30),
          hasFinishedRound: true,
        ),
        GamePlayer(
          id: 'player3',
          name: 'Charlie',
          grid: createGridWithScore(20),
          hasFinishedRound: true,
        ),
      ];

      mockEndGameState = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player3',
        roundNumber: 1,
      );
    });

    Widget createTestWidget({EndGameState? overrideState}) {
      return ProviderScope(
        overrides: [
          endGameProvider.overrideWith(
            () => MockEndGameStateNotifier(overrideState ?? mockEndGameState),
          ),
        ],
        child: const MaterialApp(home: EndGameScreen()),
      );
    }

    testWidgets('should display no game data when state is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            endGameProvider.overrideWith(() => MockEndGameStateNotifier(null)),
          ],
          child: const MaterialApp(home: EndGameScreen()),
        ),
      );

      expect(find.text('No game data available'), findsOneWidget);
    });

    // Test removed - EndGameScreen no longer handles AsyncError states directly

    testWidgets(
      'should display all required UI elements with correct content',
      (tester) async {
        await tester.pumpWidget(createTestWidget());

        // Verify round information display
        expect(find.text('Round 1 Results'), findsOneWidget);

        // Verify winner announcement
        expect(find.text('🏆 Charlie wins!'), findsOneWidget);

        // Verify ranked player display
        final rank1 = find.text('1st');
        final rank2 = find.text('2nd');
        final rank3 = find.text('3rd');

        expect(rank1, findsOneWidget);
        expect(rank2, findsOneWidget);
        expect(rank3, findsOneWidget);

        // Verify player names are in correct order
        expect(find.text('Charlie'), findsOneWidget);
        expect(find.text('Alice'), findsOneWidget);
        expect(find.text('Bob'), findsOneWidget);

        // Verify scores are displayed correctly
        expect(find.text('20 points'), findsOneWidget);
        expect(find.text('25 points'), findsOneWidget);
        expect(find.text('30 points'), findsOneWidget);

        // Verify voting section display
        expect(find.text('Continue Playing?'), findsOneWidget);
        expect(find.text('Vote to Continue'), findsOneWidget);
        expect(find.text('End Game'), findsOneWidget);
      },
    );

    testWidgets('should highlight round initiator with penalty', (
      tester,
    ) async {
      // Create state where initiator has penalty
      final stateWithPenalty = EndGameState(
        players: testPlayers,
        roundInitiatorId: 'player1', // Alice doesn't have lowest score
        roundNumber: 1,
      );

      await tester.pumpWidget(
        createTestWidget(overrideState: stateWithPenalty),
      );

      // Should show penalty indicator for Alice
      expect(find.text('Score doubled!'), findsOneWidget);
      expect(find.text('50 points'), findsOneWidget); // 25 * 2
    });

    testWidgets('should handle vote to continue tap', (tester) async {
      bool voteToContinueCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            endGameProvider.overrideWith(
              () => MockEndGameStateNotifier(mockEndGameState),
            ),
            voteToContineProvider('player1').overrideWith((ref) {
              voteToContinueCalled = true;
            }),
          ],
          child: const MaterialApp(home: EndGameScreen()),
        ),
      );

      // Scroll to make the button visible
      await tester.ensureVisible(find.text('Vote to Continue'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Vote to Continue'));
      await tester.pumpAndSettle();

      expect(voteToContinueCalled, isTrue);
    });

    testWidgets('should handle end game tap', (tester) async {
      bool endGameCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            endGameProvider.overrideWith(
              () => MockEndGameStateNotifier(mockEndGameState),
            ),
            endGameActionProvider.overrideWith(
              () => MockEndGameAction(() {
                endGameCalled = true;
              }),
            ),
          ],
          child: const MaterialApp(home: EndGameScreen()),
        ),
      );

      // Scroll to make the button visible
      await tester.ensureVisible(find.text('End Game'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('End Game'));
      await tester.pumpAndSettle();

      expect(endGameCalled, isTrue);
    });

    testWidgets('should show vote status for players', (tester) async {
      final stateWithVotes = mockEndGameState
          .updatePlayerVote('player1', true)
          .updatePlayerVote('player2', false);

      await tester.pumpWidget(createTestWidget(overrideState: stateWithVotes));

      // Should show vote indicators
      expect(find.byIcon(Icons.check_circle), findsAtLeastNWidgets(1));
    });

    testWidgets('should animate winner card', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Should have animated container for winner
      expect(find.byType(AnimatedContainer), findsAtLeastNWidgets(1));
    });

    testWidgets('should be scrollable on small screens', (tester) async {
      // Set small screen size
      tester.view.physicalSize = const Size(300, 400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      // Reset
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
