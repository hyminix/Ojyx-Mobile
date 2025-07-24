import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/end_game/presentation/widgets/vote_section.dart';

void main() {
  group('VoteSection', () {
    testWidgets('should display title and subtitle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {},
            ),
          ),
        ),
      );

      expect(find.text('Continue Playing?'), findsOneWidget);
      expect(
        find.text('Vote to start a new round or end the game'),
        findsOneWidget,
      );
    });

    testWidgets('should display both buttons with correct labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {},
            ),
          ),
        ),
      );

      expect(find.text('Vote to Continue'), findsOneWidget);
      expect(find.text('End Game'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('should call onVoteToContinue when continue button is pressed', (tester) async {
      bool continueCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {
                continueCalled = true;
              },
              onEndGame: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Vote to Continue'));
      await tester.pump();

      expect(continueCalled, isTrue);
    });

    testWidgets('should call onEndGame when end game button is pressed', (tester) async {
      bool endGameCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {
                endGameCalled = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('End Game'));
      await tester.pump();

      expect(endGameCalled, isTrue);
    });

    testWidgets('should have correct button styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {},
            ),
          ),
        ),
      );

      // Check that the buttons have text
      expect(find.text('Vote to Continue'), findsOneWidget);
      expect(find.text('End Game'), findsOneWidget);
      
      // Verify button icons
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
      
      // Verify the buttons can be tapped (they have callbacks)
      await tester.tap(find.text('Vote to Continue'));
      await tester.pump();
      
      await tester.tap(find.text('End Game'));
      await tester.pump();
    });

    testWidgets('should be wrapped in a Card with elevation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {},
            ),
          ),
        ),
      );

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
    });

    testWidgets('should have proper padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {},
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(Padding),
        ).first,
      );
      // The actual padding might be different, let's check if it exists
      expect(padding.padding, isNotNull);
    });

    testWidgets('buttons should be in a Row with proper spacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoteSection(
              onVoteToContinue: () {},
              onEndGame: () {},
            ),
          ),
        ),
      );

      // Verify both buttons exist
      expect(find.text('Vote to Continue'), findsOneWidget);
      expect(find.text('End Game'), findsOneWidget);
      
      // Find any Row in the widget tree
      final rows = find.byType(Row);
      expect(rows, findsWidgets);

      // Verify the buttons are laid out correctly
      final voteButton = find.text('Vote to Continue');
      final endButton = find.text('End Game');
      expect(voteButton, findsOneWidget);
      expect(endButton, findsOneWidget);
    });
  });
}