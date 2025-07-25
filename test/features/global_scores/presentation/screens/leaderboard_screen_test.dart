import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';
import 'package:ojyx/features/global_scores/presentation/screens/leaderboard_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}

void main() {
  group('LeaderboardScreen', () {
    late MockGlobalScoreRepository mockRepository;
    late List<PlayerStats> testPlayers;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      testPlayers = [
        PlayerStats(
          playerId: 'player1',
          playerName: 'Alice',
          totalGamesPlayed: 50,
          totalWins: 30,
          averageScore: 85.5,
          bestScore: 60,
          worstScore: 120,
          averagePosition: 1.8,
          totalRoundsPlayed: 250,
        ),
        PlayerStats(
          playerId: 'player2',
          playerName: 'Bob',
          totalGamesPlayed: 45,
          totalWins: 20,
          averageScore: 92.3,
          bestScore: 70,
          worstScore: 130,
          averagePosition: 2.3,
          totalRoundsPlayed: 225,
        ),
        PlayerStats(
          playerId: 'player3',
          playerName: 'Charlie',
          totalGamesPlayed: 40,
          totalWins: 15,
          averageScore: 98.7,
          bestScore: 75,
          worstScore: 140,
          averagePosition: 2.8,
          totalRoundsPlayed: 200,
        ),
      ];
    });

    Widget createWidgetUnderTest({
      List<PlayerStats>? players,
      bool isLoading = false,
      Exception? error,
      void Function(PlayerStats)? onPlayerTap,
    }) {
      // Set up mock behavior
      if (error != null) {
        when(
          () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
        ).thenThrow(error);
      } else if (isLoading) {
        // For loading state, we'll override with a completer
      } else {
        when(
          () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
        ).thenAnswer((_) async => players ?? testPlayers);
      }

      return ProviderScope(
        overrides: [
          globalScoreRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: MaterialApp(home: LeaderboardScreen(onPlayerTap: onPlayerTap)),
      );
    }

    testWidgets('should display loading indicator when loading', (
      tester,
    ) async {
      // Set up a never-completing future
      final completer = Completer<List<PlayerStats>>();
      when(
        () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            globalScoreRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(home: LeaderboardScreen()),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display leaderboard when loaded', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(players: testPlayers));

      await tester.pumpAndSettle();

      // Check app bar
      expect(find.text('Classement'), findsOneWidget);

      // Check leaderboard list
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(3));

      // Check first player (best win rate)
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('30 victoires'), findsOneWidget);
      expect(find.text('60.0%'), findsOneWidget); // Win rate
    });

    testWidgets('should display trophy icons for top 3', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(players: testPlayers));

      await tester.pumpAndSettle();

      // Check for trophy emojis
      expect(find.text('🥇'), findsOneWidget); // Gold for 1st
      expect(find.text('🥈'), findsOneWidget); // Silver for 2nd
      expect(find.text('🥉'), findsOneWidget); // Bronze for 3rd
    });

    testWidgets('should display player statistics', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(players: testPlayers));

      await tester.pumpAndSettle();

      // Check Alice's stats
      expect(find.text('50 parties'), findsOneWidget);
      expect(find.text('Score moyen: 85.5'), findsOneWidget);
      expect(find.text('Meilleur: 60'), findsOneWidget);

      // Check Bob's stats
      expect(find.text('45 parties'), findsOneWidget);
      expect(find.text('Score moyen: 92.3'), findsOneWidget);
    });

    testWidgets('should display empty message when no players', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(players: []));

      await tester.pumpAndSettle();

      expect(find.text('Aucun joueur dans le classement'), findsOneWidget);
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
      await tester.pumpWidget(createWidgetUnderTest(players: testPlayers));

      await tester.pumpAndSettle();

      expect(find.byType(RefreshIndicator), findsOneWidget);

      // Trigger refresh
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pump();

      // Should show refresh indicator
      expect(find.byType(RefreshProgressIndicator), findsOneWidget);
    });

    testWidgets('should navigate to player details on tap', (tester) async {
      bool playerTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          players: testPlayers,
          onPlayerTap: (player) {
            playerTapped = true;
            expect(player.playerId, equals('player1'));
          },
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card).first);
      await tester.pumpAndSettle();

      expect(playerTapped, isTrue);
    });

    testWidgets('should sort players by win rate', (tester) async {
      // Create players with different win rates
      final unsortedPlayers = [
        PlayerStats(
          playerId: 'player1',
          playerName: 'Low Winner',
          totalGamesPlayed: 10,
          totalWins: 2,
          averageScore: 100,
          bestScore: 80,
          worstScore: 120,
          averagePosition: 3.0,
          totalRoundsPlayed: 50,
        ),
        PlayerStats(
          playerId: 'player2',
          playerName: 'High Winner',
          totalGamesPlayed: 10,
          totalWins: 8,
          averageScore: 85,
          bestScore: 70,
          worstScore: 100,
          averagePosition: 1.5,
          totalRoundsPlayed: 50,
        ),
        PlayerStats(
          playerId: 'player3',
          playerName: 'Mid Winner',
          totalGamesPlayed: 10,
          totalWins: 5,
          averageScore: 92,
          bestScore: 75,
          worstScore: 110,
          averagePosition: 2.0,
          totalRoundsPlayed: 50,
        ),
      ];

      await tester.pumpWidget(createWidgetUnderTest(players: unsortedPlayers));

      await tester.pumpAndSettle();

      // Verify order: High Winner (80%) should be first
      final cards = find.byType(Card);
      expect(
        find.descendant(of: cards.at(0), matching: find.text('High Winner')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: cards.at(1), matching: find.text('Mid Winner')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: cards.at(2), matching: find.text('Low Winner')),
        findsOneWidget,
      );
    });
  });
}
