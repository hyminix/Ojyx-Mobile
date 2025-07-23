import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/widgets/game_selection_overlay.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;

void main() {
  group('SelectionOverlay', () {
    late List<Player> testPlayers;
    late PlayerGrid testGrid;

    setUp(() {
      // Create a test grid with 12 cards
      final cards = List.generate(12, (index) => game.Card(value: index));
      testGrid = PlayerGrid.fromCards(cards);
      
      testPlayers = [
        Player(id: 'player-1', name: 'Alice', grid: testGrid),
        Player(id: 'player-2', name: 'Bob', grid: testGrid),
        Player(id: 'player-3', name: 'Charlie', grid: testGrid),
      ];
    });

    testWidgets('should not show overlay when not selecting', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Should not show overlay elements
      expect(find.byType(GameSelectionOverlay), findsOneWidget);
      expect(find.text('Game Content'), findsOneWidget);
      expect(find.byType(AnimatedContainer), findsNothing);
    });

    testWidgets('should show modal overlay when selecting opponents', 
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Start opponent selection
      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();

      // Wait for animation
      await tester.pumpAndSettle();
      
      // Should show overlay with fade effect
      expect(find.byType(AnimatedOpacity), findsOneWidget);
      
      // Should show opponent selection UI
      expect(find.text('Sélectionnez un adversaire'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Charlie'), findsOneWidget);
      expect(find.text('Alice'), findsNothing); // Current player not shown
    });

    testWidgets('should allow selecting an opponent', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start opponent selection
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Tap on Bob
      await tester.tap(find.text('Bob'));
      await tester.pump();

      // Should have selected Bob
      final state = container.read(cardSelectionProvider);
      expect(state.selectedOpponentId, equals('player-2'));
    });

    testWidgets('should show cancel button during selection', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start opponent selection
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should show cancel button
      expect(find.byIcon(Icons.close), findsOneWidget);
      
      // Tap cancel
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Should cancel selection
      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, isFalse);
    });

    testWidgets('should show contextual modal for card selection from discard', 
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // This would be used for actions like "Recyclage" that show discard pile
      // We'll implement this when we have the actual card data structure
    });

    testWidgets('should animate overlay appearance', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start selection
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();

      // Should start animation
      final opacityBefore = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      
      // Animate to full opacity
      await tester.pumpAndSettle();

      // Should now be visible
      final opacityAfter = tester.widget<AnimatedOpacity>(
        find.byType(AnimatedOpacity),
      );
      expect(opacityAfter.opacity, equals(1.0));
    });

    testWidgets('should show player avatars in grid layout', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start opponent selection
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Should show player avatars
      expect(find.byType(CircleAvatar), findsNWidgets(2)); // 2 opponents
      expect(find.byIcon(Icons.person), findsNWidgets(2));
    });

    testWidgets('should highlight selected opponent', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start opponent selection and select Bob
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Bob'));
      await tester.pump();

      // Should show highlight on selected player
      // Find the card that contains Bob text directly (not the outer container card)
      final cards = find.byType(Card);
      
      // Find the specific card containing Bob
      Card? bobCard;
      for (var i = 0; i < tester.widgetList(cards).length; i++) {
        final card = tester.widget<Card>(cards.at(i));
        // Check if this card contains Bob text as descendant
        final bobTextInCard = find.descendant(
          of: cards.at(i),
          matching: find.text('Bob'),
        );
        if (bobTextInCard.evaluate().isNotEmpty) {
          bobCard = card;
          break;
        }
      }
      
      expect(bobCard, isNotNull);
      // The selected card should have different styling
      expect(bobCard!.elevation, greaterThan(1));
    });

    testWidgets('should handle empty player list gracefully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: const [],
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start opponent selection
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();
      await tester.pumpAndSettle();

      // Should show no opponents message
      expect(find.text('Aucun adversaire disponible'), findsOneWidget);
    });

    testWidgets('should close overlay on background tap', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GameSelectionOverlay)),
      );
      
      // Start opponent selection
      container.read(cardSelectionProvider.notifier).startOpponentSelection();
      await tester.pump();
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      // Tap on background (outside modal)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      // Should cancel selection
      final state = container.read(cardSelectionProvider);
      expect(state.isSelecting, isFalse);
    });

    testWidgets('should show confirmation dialog for dangerous actions', 
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  const Center(child: Text('Game Content')),
                  GameSelectionOverlay(
                    players: testPlayers,
                    currentPlayerId: 'player-1',
                    requiresConfirmation: true,
                    confirmationMessage: 'Êtes-vous sûr de vouloir détruire cette carte ?',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // This will be implemented when we need confirmation dialogs
    });
  });
}