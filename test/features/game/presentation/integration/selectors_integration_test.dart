import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';

void main() {
  group('Card Selection User Behavior Tests', () {
    testWidgets('should enable strategic teleport card swapping through dual selection workflow', (
      tester,
    ) async {
      // Test behavior: players can select two cards strategically to swap positions
      Map<String, dynamic>? teleportResult;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Strategic Action: ${state.isSelecting ? "Active" : "Inactive"}'),
                      Text('Selection Type: ${state.selectionType?.toString() ?? "none"}'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startTeleportSelection();
                        },
                        child: const Text('Initiate Teleport Strategy'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(0, 0);
                        },
                        child: const Text('Choose Strategic Card 1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(2, 3);
                        },
                        child: const Text('Choose Strategic Card 2'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          teleportResult = ref.read(cardSelectionProvider.notifier).completeSelection();
                        },
                        child: const Text('Execute Teleport'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Player initiates strategic action
      await tester.tap(find.text('Initiate Teleport Strategy'));
      await tester.pumpAndSettle();
      
      expect(find.text('Strategic Action: Active'), findsOneWidget);
      expect(find.text('Selection Type: CardSelectionType.teleport'), findsOneWidget);

      // Player selects first strategic position
      await tester.tap(find.text('Choose Strategic Card 1'));
      await tester.pumpAndSettle();

      // Player selects second strategic position  
      await tester.tap(find.text('Choose Strategic Card 2'));
      await tester.pumpAndSettle();

      // Player executes the strategic swap
      await tester.tap(find.text('Execute Teleport'));
      await tester.pumpAndSettle();

      // Verify strategic action was completed successfully
      expect(teleportResult, isNotNull, reason: 'Teleport action should produce strategic result data');
      expect(teleportResult!['position1'], isNotNull, reason: 'First strategic position should be captured');
      expect(teleportResult!['position2'], isNotNull, reason: 'Second strategic position should be captured');
      expect(find.text('Strategic Action: Inactive'), findsOneWidget, reason: 'Strategic mode should end after execution');
    });

    testWidgets('should enable tactical card peeking with capacity management for strategic planning', (
      tester,
    ) async {
      // Test behavior: players can peek at multiple cards within capacity limits for strategic advantage
      List<CardPosition> revealedCards = [];
      Map<String, dynamic>? peekResult;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);
                  revealedCards = state.selections;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Information Gathered: ${state.selections.length} cards'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startPeekSelection(maxCards: 3);
                        },
                        child: const Text('Begin Intelligence Gathering'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(0, 0);
                        },
                        child: const Text('Scout Card A'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(1, 1);
                        },
                        child: const Text('Scout Card B'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(2, 2);
                        },
                        child: const Text('Scout Card C'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(0, 1);
                        },
                        child: const Text('Scout Additional Card'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          peekResult = ref.read(cardSelectionProvider.notifier).completeSelection();
                        },
                        child: const Text('Finalize Intelligence'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Player begins strategic intelligence gathering
      await tester.tap(find.text('Begin Intelligence Gathering'));
      await tester.pumpAndSettle();

      // Player gathers information within capacity
      await tester.tap(find.text('Scout Card A'));
      await tester.pumpAndSettle();
      expect(revealedCards.length, 1, reason: 'First card should be scouted for strategic planning');

      await tester.tap(find.text('Scout Card B'));
      await tester.pumpAndSettle();
      expect(revealedCards.length, 2, reason: 'Second card should expand strategic knowledge');

      await tester.tap(find.text('Scout Card C'));
      await tester.pumpAndSettle();
      expect(revealedCards.length, 3, reason: 'Third card should reach capacity limit');

      // Player attempts to exceed capacity - should manage intelligently
      await tester.tap(find.text('Scout Additional Card'));
      await tester.pumpAndSettle();
      expect(revealedCards.length, 3, reason: 'System should enforce strategic capacity limits');

      // Player finalizes their intelligence operation
      await tester.tap(find.text('Finalize Intelligence'));
      await tester.pumpAndSettle();
      
      expect(peekResult, isNotNull, reason: 'Intelligence operation should produce actionable data');
      expect(peekResult!['positions'], isNotNull, reason: 'Strategic positions should be recorded');
    });

    testWidgets('should enable competitive opponent targeting for multiplayer actions', (
      tester,
    ) async {
      // Test behavior: players can target specific opponents for competitive interactions
      String? targetedOpponent;
      bool actionReady = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);
                  targetedOpponent = state.selectedOpponentId;
                  actionReady = state.isSelectionComplete;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Target: ${state.selectedOpponentId ?? "No Target"}'),
                      Text('Ready to Act: $actionReady'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startOpponentSelection();
                        },
                        child: const Text('Choose Opponent Target'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectOpponent('player-2');
                        },
                        child: const Text('Target Player Alpha'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).cancelSelection();
                        },
                        child: const Text('Abort Targeting'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Player initiates opponent targeting
      await tester.tap(find.text('Choose Opponent Target'));
      await tester.pumpAndSettle();

      expect(find.text('Target: No Target'), findsOneWidget, reason: 'Initial state should show no target selected');
      expect(find.text('Ready to Act: false'), findsOneWidget, reason: 'Action should not be ready without target');

      // Player selects strategic target
      await tester.tap(find.text('Target Player Alpha'));
      await tester.pumpAndSettle();

      expect(targetedOpponent, equals('player-2'), reason: 'Strategic target should be locked in');
      expect(actionReady, isTrue, reason: 'Action should be ready with valid target');

      // Player changes their mind and aborts
      await tester.tap(find.text('Abort Targeting'));
      await tester.pumpAndSettle();

      expect(targetedOpponent, isNull, reason: 'Target should be cleared when action is aborted');
    });

    testWidgets('CardSelectionProvider integration - Steal two-phase', (
      tester,
    ) async {
      Map<String, dynamic>? completedData;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Phase: ${state.selectedOpponentId == null ? "opponent" : "card"}',
                      ),
                      Text('Requires opponent: ${state.requiresOpponent}'),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .startStealSelection();
                        },
                        child: const Text('Start Steal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectOpponent('player-3');
                        },
                        child: const Text('Select Opponent'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(2, 2);
                        },
                        child: const Text('Select Card'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          completedData = ref
                              .read(cardSelectionProvider.notifier)
                              .completeSelection();
                        },
                        child: const Text('Complete Steal'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Start steal selection
      await tester.tap(find.text('Start Steal'));
      await tester.pumpAndSettle();

      expect(find.text('Phase: opponent'), findsOneWidget);
      expect(find.text('Requires opponent: true'), findsOneWidget);

      // Select opponent
      await tester.tap(find.text('Select Opponent'));
      await tester.pumpAndSettle();

      expect(find.text('Phase: card'), findsOneWidget);

      // Select card
      await tester.tap(find.text('Select Card'));
      await tester.pumpAndSettle();

      // Complete
      await tester.tap(find.text('Complete Steal'));
      await tester.pumpAndSettle();

      expect(completedData, isNotNull);
      expect(completedData!['opponentId'], equals('player-3'));
      expect(completedData!['position'], isNotNull);
    });

    testWidgets('CardSelectionProvider integration - Single card selections', (
      tester,
    ) async {
      CardSelectionType? currentType;
      CardPosition? selectedPosition;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);
                  currentType = state.selectionType;
                  selectedPosition = state.firstSelection;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Type: ${currentType?.toString() ?? "none"}'),
                      Text('Selected: ${selectedPosition != null}'),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .startSingleSelection(CardSelectionType.bomb);
                        },
                        child: const Text('Bomb'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .startSingleSelection(CardSelectionType.mirror);
                        },
                        child: const Text('Mirror'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(1, 2);
                        },
                        child: const Text('Select Card'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Test bomb selection
      await tester.tap(find.text('Bomb'));
      await tester.pumpAndSettle();

      expect(currentType, equals(CardSelectionType.bomb));

      await tester.tap(find.text('Select Card'));
      await tester.pumpAndSettle();

      expect(selectedPosition, isNotNull);
      expect(selectedPosition!.row, equals(1));
      expect(selectedPosition!.col, equals(2));

      // Switch to mirror
      await tester.tap(find.text('Mirror'));
      await tester.pumpAndSettle();

      expect(currentType, equals(CardSelectionType.mirror));
      expect(selectedPosition, isNull); // Should reset
    });

    testWidgets('Complete selection returns correct data structure', (
      tester,
    ) async {
      Map<String, dynamic>? result;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Teleport test
                      ElevatedButton(
                        onPressed: () async {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .startTeleportSelection();
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(0, 0);
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(1, 1);
                          result = ref
                              .read(cardSelectionProvider.notifier)
                              .completeSelection();
                        },
                        child: const Text('Test Teleport'),
                      ),
                      // Bomb test
                      ElevatedButton(
                        onPressed: () async {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .startSingleSelection(CardSelectionType.bomb);
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(2, 3);
                          result = ref
                              .read(cardSelectionProvider.notifier)
                              .completeSelection();
                        },
                        child: const Text('Test Bomb'),
                      ),
                      // Peek test
                      ElevatedButton(
                        onPressed: () async {
                          ref
                              .read(cardSelectionProvider.notifier)
                              .startPeekSelection(maxCards: 2);
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(0, 1);
                          ref
                              .read(cardSelectionProvider.notifier)
                              .selectCard(1, 0);
                          result = ref
                              .read(cardSelectionProvider.notifier)
                              .completeSelection();
                        },
                        child: const Text('Test Peek'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Test teleport data
      await tester.tap(find.text('Test Teleport'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!['position1'], isNotNull);
      expect(result!['position2'], isNotNull);

      // Test bomb data
      await tester.tap(find.text('Test Bomb'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!['position'], isNotNull);

      // Test peek data
      await tester.tap(find.text('Test Peek'));
      await tester.pump();

      expect(result, isNotNull);
      expect(result!['positions'], isNotNull);
      expect((result!['positions'] as List).length, equals(2));
    });
  });
}
