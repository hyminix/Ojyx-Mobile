import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/end_game/presentation/widgets/player_score_card.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as domain;

void main() {
  group('PlayerScoreCard', () {
    late GamePlayer mockPlayer;

    setUp(() {
      mockPlayer = GamePlayer(
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

    testWidgets('should display player name and score', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 1,
              isPenalized: false,
              hasVoted: false,
            ),
          ),
        ),
      );

      expect(find.text('Test Player'), findsOneWidget);
      expect(find.text('60 points'), findsOneWidget);
    });

    group('rank display', () {
      testWidgets('should display 1st for rank 1', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 1,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        expect(find.text('1st'), findsOneWidget);
      });

      testWidgets('should display 2nd for rank 2', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 2,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        expect(find.text('2nd'), findsOneWidget);
      });

      testWidgets('should display 3rd for rank 3', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 3,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        expect(find.text('3rd'), findsOneWidget);
      });

      testWidgets('should display Nth for rank > 3', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 4,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        expect(find.text('4th'), findsOneWidget);
      });
    });

    testWidgets('should show penalty indicator when penalized', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 1,
              isPenalized: true,
              hasVoted: false,
            ),
          ),
        ),
      );

      expect(find.text('Score doubled!'), findsOneWidget);
    });

    testWidgets('should not show penalty indicator when not penalized', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 1,
              isPenalized: false,
              hasVoted: false,
            ),
          ),
        ),
      );

      expect(find.text('Score doubled!'), findsNothing);
    });

    testWidgets('should show vote indicator when hasVoted is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 1,
              isPenalized: false,
              hasVoted: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
      expect(icon.color, Colors.green);
      expect(icon.size, 32);
    });

    testWidgets('should not show vote indicator when hasVoted is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 1,
              isPenalized: false,
              hasVoted: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('should have higher elevation for rank 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 1,
              isPenalized: false,
              hasVoted: false,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 8);
    });

    testWidgets('should have lower elevation for rank > 1', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: mockPlayer,
              rank: 2,
              isPenalized: false,
              hasVoted: false,
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 2);
    });

    group('rank colors', () {
      testWidgets('should use amber color for rank 1', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 1,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        // Find the rank badge container by its circular shape decoration
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Container),
          ),
        );
        
        Container? rankBadge;
        for (final container in containers) {
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration as BoxDecoration;
            if (decoration.shape == BoxShape.circle) {
              rankBadge = container;
              break;
            }
          }
        }
        
        expect(rankBadge, isNotNull);
        final decoration = rankBadge!.decoration as BoxDecoration;
        expect(decoration.color, Colors.amber.withOpacity(0.2));
        expect(decoration.border?.top.color, Colors.amber);
      });

      testWidgets('should use grey color for rank 2', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 2,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        // Find the rank badge container by its circular shape decoration
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Container),
          ),
        );
        
        Container? rankBadge;
        for (final container in containers) {
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration as BoxDecoration;
            if (decoration.shape == BoxShape.circle) {
              rankBadge = container;
              break;
            }
          }
        }
        
        expect(rankBadge, isNotNull);
        final decoration = rankBadge!.decoration as BoxDecoration;
        expect(decoration.color, Colors.grey[400]!.withOpacity(0.2));
        expect(decoration.border?.top.color, Colors.grey[400]);
      });

      testWidgets('should use brown color for rank 3', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PlayerScoreCard(
                player: mockPlayer,
                rank: 3,
                isPenalized: false,
                hasVoted: false,
              ),
            ),
          ),
        );

        // Find the rank badge container by its circular shape decoration
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(Card),
            matching: find.byType(Container),
          ),
        );
        
        Container? rankBadge;
        for (final container in containers) {
          if (container.decoration is BoxDecoration) {
            final decoration = container.decoration as BoxDecoration;
            if (decoration.shape == BoxShape.circle) {
              rankBadge = container;
              break;
            }
          }
        }
        
        expect(rankBadge, isNotNull);
        final decoration = rankBadge!.decoration as BoxDecoration;
        expect(decoration.color, Colors.brown[400]!.withOpacity(0.2));
        expect(decoration.border?.top.color, Colors.brown[400]);
      });
    });

    testWidgets('should display correct score with multiplier', (tester) async {
      final playerWithMultiplier = mockPlayer.copyWith(scoreMultiplier: 2);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerScoreCard(
              player: playerWithMultiplier,
              rank: 1,
              isPenalized: true,
              hasVoted: false,
            ),
          ),
        ),
      );

      // Score should be doubled (60 * 2 = 120)
      expect(find.text('120 points'), findsOneWidget);
      expect(find.text('Score doubled!'), findsOneWidget);
    });
  });
}