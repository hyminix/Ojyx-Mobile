import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/game/presentation/providers/card_selection_provider.dart';
import 'package:ojyx/features/game/domain/entities/card_position.dart';

void main() {
  group('Selectors Integration Tests', () {
    testWidgets('CardSelectionProvider integration - Teleport selection',
        (tester) async {
      CardSelectionState? capturedState;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);
                  capturedState = state;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Selecting: ${state.isSelecting}'),
                      Text('Type: ${state.selectionType?.toString() ?? "none"}'),
                      Text('First: ${state.firstSelection != null}'),
                      Text('Second: ${state.secondSelection != null}'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startTeleportSelection();
                        },
                        child: const Text('Start Teleport'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(0, 0);
                        },
                        child: const Text('Select 0,0'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(1, 1);
                        },
                        child: const Text('Select 1,1'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).completeSelection();
                        },
                        child: const Text('Complete'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Selecting: false'), findsOneWidget);
      expect(find.text('Type: none'), findsOneWidget);

      // Start teleport selection
      await tester.tap(find.text('Start Teleport'));
      await tester.pumpAndSettle();

      expect(capturedState!.isSelecting, isTrue);
      expect(capturedState!.selectionType, equals(CardSelectionType.teleport));
      expect(capturedState!.maxSelections, equals(2));

      // Select first card
      await tester.tap(find.text('Select 0,0'));
      await tester.pumpAndSettle();

      expect(capturedState!.firstSelection, isNotNull);
      expect(capturedState!.firstSelection!.row, equals(0));
      expect(capturedState!.firstSelection!.col, equals(0));

      // Select second card
      await tester.tap(find.text('Select 1,1'));
      await tester.pumpAndSettle();

      expect(capturedState!.secondSelection, isNotNull);
      expect(capturedState!.secondSelection!.row, equals(1));
      expect(capturedState!.secondSelection!.col, equals(1));
      expect(capturedState!.isSelectionComplete, isTrue);

      // Complete selection
      await tester.tap(find.text('Complete'));
      await tester.pumpAndSettle();

      expect(capturedState!.isSelecting, isFalse);
    });

    testWidgets('CardSelectionProvider integration - Peek multi-selection',
        (tester) async {
      List<CardPosition> selections = [];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);
                  selections = state.selections;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Selections: ${state.selections.length}'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startPeekSelection(maxCards: 3);
                        },
                        child: const Text('Start Peek'),
                      ),
                      for (int i = 0; i < 5; i++)
                        ElevatedButton(
                          onPressed: () {
                            ref.read(cardSelectionProvider.notifier).selectCard(i ~/ 2, i % 2);
                          },
                          child: Text('Select $i'),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Start peek selection
      await tester.tap(find.text('Start Peek'));
      await tester.pumpAndSettle();

      // Select cards
      await tester.tap(find.text('Select 0'));
      await tester.pumpAndSettle();
      expect(selections.length, equals(1));

      await tester.tap(find.text('Select 1'));
      await tester.pumpAndSettle();
      expect(selections.length, equals(2));

      await tester.tap(find.text('Select 2'));
      await tester.pumpAndSettle();
      expect(selections.length, equals(3));

      // Select 4th card - should replace oldest
      await tester.tap(find.text('Select 3'));
      await tester.pumpAndSettle();
      expect(selections.length, equals(3));

      // Toggle selection
      await tester.tap(find.text('Select 3'));
      await tester.pumpAndSettle();
      expect(selections.length, equals(2));
    });

    testWidgets('CardSelectionProvider integration - Opponent selection',
        (tester) async {
      String? selectedOpponentId;
      bool isComplete = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(cardSelectionProvider);
                  selectedOpponentId = state.selectedOpponentId;
                  isComplete = state.isSelectionComplete;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Opponent: ${state.selectedOpponentId ?? "none"}'),
                      Text('Complete: $isComplete'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startOpponentSelection();
                        },
                        child: const Text('Start Opponent Selection'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectOpponent('player-2');
                        },
                        child: const Text('Select Player 2'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).cancelSelection();
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Start opponent selection
      await tester.tap(find.text('Start Opponent Selection'));
      await tester.pumpAndSettle();

      expect(find.text('Opponent: none'), findsOneWidget);
      expect(find.text('Complete: false'), findsOneWidget);

      // Select opponent
      await tester.tap(find.text('Select Player 2'));
      await tester.pumpAndSettle();

      expect(selectedOpponentId, equals('player-2'));
      expect(isComplete, isTrue);

      // Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(selectedOpponentId, isNull);
    });

    testWidgets('CardSelectionProvider integration - Steal two-phase',
        (tester) async {
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
                      Text('Phase: ${state.selectedOpponentId == null ? "opponent" : "card"}'),
                      Text('Requires opponent: ${state.requiresOpponent}'),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startStealSelection();
                        },
                        child: const Text('Start Steal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectOpponent('player-3');
                        },
                        child: const Text('Select Opponent'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(2, 2);
                        },
                        child: const Text('Select Card'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          completedData = ref.read(cardSelectionProvider.notifier).completeSelection();
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

    testWidgets('CardSelectionProvider integration - Single card selections',
        (tester) async {
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
                          ref.read(cardSelectionProvider.notifier).startSingleSelection(
                            CardSelectionType.bomb,
                          );
                        },
                        child: const Text('Bomb'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).startSingleSelection(
                            CardSelectionType.mirror,
                          );
                        },
                        child: const Text('Mirror'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(cardSelectionProvider.notifier).selectCard(1, 2);
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

    testWidgets('Complete selection returns correct data structure',
        (tester) async {
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
                          ref.read(cardSelectionProvider.notifier).startTeleportSelection();
                          ref.read(cardSelectionProvider.notifier).selectCard(0, 0);
                          ref.read(cardSelectionProvider.notifier).selectCard(1, 1);
                          result = ref.read(cardSelectionProvider.notifier).completeSelection();
                        },
                        child: const Text('Test Teleport'),
                      ),
                      // Bomb test
                      ElevatedButton(
                        onPressed: () async {
                          ref.read(cardSelectionProvider.notifier).startSingleSelection(
                            CardSelectionType.bomb,
                          );
                          ref.read(cardSelectionProvider.notifier).selectCard(2, 3);
                          result = ref.read(cardSelectionProvider.notifier).completeSelection();
                        },
                        child: const Text('Test Bomb'),
                      ),
                      // Peek test
                      ElevatedButton(
                        onPressed: () async {
                          ref.read(cardSelectionProvider.notifier).startPeekSelection(maxCards: 2);
                          ref.read(cardSelectionProvider.notifier).selectCard(0, 1);
                          ref.read(cardSelectionProvider.notifier).selectCard(1, 0);
                          result = ref.read(cardSelectionProvider.notifier).completeSelection();
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