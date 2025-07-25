import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/end_game/presentation/widgets/winner_announcement.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as domain;

void main() {
  group('WinnerAnnouncement', () {
    late GamePlayer mockWinner;

    setUp(() {
      mockWinner = GamePlayer(
        id: '1',
        name: 'Test Player',
        grid: PlayerGrid.fromCards(
          List.generate(
            12,
            (index) => const domain.Card(value: 5, isRevealed: true),
          ),
        ),
      );
    });

    testWidgets('should display winner name and score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WinnerAnnouncement(winner: mockWinner)),
        ),
      );

      // Verify winner name is displayed
      expect(find.text('🏆 Test Player wins!'), findsOneWidget);

      // Verify score is displayed (12 cards * 5 points each = 60)
      expect(find.text('Score: 60 points'), findsOneWidget);
    });

    testWidgets('should display trophy icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WinnerAnnouncement(winner: mockWinner)),
        ),
      );

      // Verify trophy icon is displayed
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);

      // Verify icon has correct color
      final icon = tester.widget<Icon>(find.byIcon(Icons.emoji_events));
      expect(icon.color, Colors.amber);
      expect(icon.size, 64);
    });

    testWidgets('should have animated container with amber styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: WinnerAnnouncement(winner: mockWinner)),
        ),
      );

      // Find the AnimatedContainer
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      expect(animatedContainer.duration, const Duration(milliseconds: 500));
      expect(animatedContainer.padding, const EdgeInsets.all(20));

      // Verify decoration
      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, Colors.amber.withOpacity(0.2));
      expect(decoration.borderRadius, BorderRadius.circular(16));
      expect(decoration.border, isNotNull);
    });

    testWidgets('should display correct score with multiplier', (tester) async {
      final winnerWithMultiplier = mockWinner.copyWith(scoreMultiplier: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WinnerAnnouncement(winner: winnerWithMultiplier),
          ),
        ),
      );

      // Score should be doubled (60 * 2 = 120)
      expect(find.text('Score: 120 points'), findsOneWidget);
    });

    testWidgets('should handle long names properly', (tester) async {
      final winnerWithLongName = mockWinner.copyWith(
        name: 'This is a very long player name that should wrap',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: WinnerAnnouncement(winner: winnerWithLongName),
            ),
          ),
        ),
      );

      expect(
        find.text('🏆 This is a very long player name that should wrap wins!'),
        findsOneWidget,
      );

      // Verify text is centered
      final text = tester.widget<Text>(
        find.text('🏆 This is a very long player name that should wrap wins!'),
      );
      expect(text.textAlign, TextAlign.center);
    });
  });
}
