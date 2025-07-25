import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';
import 'package:ojyx/features/global_scores/presentation/screens/game_history_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}

void main() {
  group('GameHistoryScreen', () {
    late List<GlobalScore> testGames;
    late MockGlobalScoreRepository mockRepository;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      testGames = [
        GlobalScore(
          id: '1',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room1',
          totalScore: 85,
          roundNumber: 3,
          position: 1,
          isWinner: true,
          createdAt: DateTime(2025, 1, 24, 14, 30),
          gameEndedAt: DateTime(2025, 1, 24, 15, 0),
        ),
        GlobalScore(
          id: '2',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room2',
          totalScore: 120,
          roundNumber: 5,
          position: 3,
          isWinner: false,
          createdAt: DateTime(2025, 1, 23, 20, 0),
          gameEndedAt: DateTime(2025, 1, 23, 21, 30),
        ),
        GlobalScore(
          id: '3',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room3',
          totalScore: 95,
          roundNumber: 4,
          position: 2,
          isWinner: false,
          createdAt: DateTime(2025, 1, 22, 18, 0),
          gameEndedAt: DateTime(2025, 1, 22, 19, 15),
        ),
      ];
    });

    Widget createWidgetUnderTest({
      List<GlobalScore>? games,
      bool isLoading = false,
      Exception? error,
      String playerId = 'player1',
      void Function(GlobalScore)? onGameTap,
    }) {
      // Set up mock behavior
      if (error != null) {
        when(
          () => mockRepository.getRecentGames(playerId, limit: 10),
        ).thenThrow(error);
      } else if (isLoading) {
        // Don't use the mock for loading test, rely on default provider behavior
      } else {
        when(
          () => mockRepository.getRecentGames(playerId, limit: 10),
        ).thenAnswer((_) async => games ?? testGames);
      }

      return ProviderScope(
        overrides: [
          globalScoreRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(
          home: GameHistoryScreen(playerId: playerId, onGameTap: onGameTap),
        ),
      );
    }

    testWidgets('should display loading indicator when loading', (
      tester,
    ) async {
      // Set up a never-completing future
      final completer = Completer<List<GlobalScore>>();
      when(
        () => mockRepository.getRecentGames('player1', limit: 10),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            globalScoreRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: GameHistoryScreen(playerId: 'player1'),
          ),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display game history when loaded', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: testGames));

      await tester.pumpAndSettle();

      // Check app bar
      expect(find.text('Historique des parties'), findsOneWidget);

      // Check game list
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(3));

      // Check first game (most recent)
      expect(find.text('24 janvier 2025'), findsOneWidget);
      expect(find.text('Score: 85'), findsOneWidget);
      expect(find.text('Position: 1er'), findsOneWidget);
      expect(find.text('🏆 Victoire'), findsOneWidget);
    });

    testWidgets('should display position correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: testGames));

      await tester.pumpAndSettle();

      expect(find.text('Position: 1er'), findsOneWidget); // First game
      expect(find.text('Position: 3e'), findsOneWidget); // Second game
      expect(find.text('Position: 2e'), findsOneWidget); // Third game
    });

    testWidgets('should show game duration when available', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: testGames));

      await tester.pumpAndSettle();

      // First game has 30 minutes duration
      expect(find.textContaining('Durée: 30 min'), findsOneWidget);
    });

    testWidgets('should show round number', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: testGames));

      await tester.pumpAndSettle();

      expect(find.text('3 manches'), findsOneWidget);
      expect(find.text('5 manches'), findsOneWidget);
      expect(find.text('4 manches'), findsOneWidget);
    });

    testWidgets('should display empty message when no games', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: []));

      await tester.pumpAndSettle();

      expect(find.text('Aucune partie jouée'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('should display error message on error', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(error: Exception('Failed to load')),
      );

      await tester.pumpAndSettle();

      expect(find.text('Erreur lors du chargement'), findsOneWidget);
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('should support pull to refresh', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: testGames));

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Trigger refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();

      // Should show refresh indicator
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to game details on tap', (tester) async {
      bool cardTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          games: testGames,
          onGameTap: (game) {
            cardTapped = true;
            expect(game.id, equals('1'));
          },
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      expect(cardTapped, isTrue);
    });

    testWidgets('should format dates in French', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(games: testGames));

      await tester.pumpAndSettle();

      expect(find.text('24 janvier 2025'), findsOneWidget);
      expect(find.text('23 janvier 2025'), findsOneWidget);
      expect(find.text('22 janvier 2025'), findsOneWidget);
    });
  });
}
