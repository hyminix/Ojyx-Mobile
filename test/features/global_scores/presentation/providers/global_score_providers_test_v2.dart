import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../helpers/riverpod_test_helpers.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_player_stats.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_top_players.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}

class FakeSaveGlobalScoreParams extends Fake implements SaveGlobalScoreParams {}

class FakeGetPlayerStatsParams extends Fake implements GetPlayerStatsParams {}

class FakeGetTopPlayersParams extends Fake implements GetTopPlayersParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSaveGlobalScoreParams());
    registerFallbackValue(FakeGetPlayerStatsParams());
    registerFallbackValue(FakeGetTopPlayersParams());
  });

  group('GlobalScore Providers', () {
    late ProviderContainer container;
    late MockGlobalScoreRepository mockRepository;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      container = createTestContainer(
        overrides: [
          globalScoreRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
    });

    group('Repository Provider', () {
      test('should provide GlobalScoreRepository instance', () {
        final repository = container.read(globalScoreRepositoryProvider);
        expect(repository, equals(mockRepository));
      });
    });

    group('Use Case Providers', () {
      test('should provide SaveGlobalScoreUseCase', () {
        final useCase = container.read(saveGlobalScoreUseCaseProvider);
        expect(useCase, isA<SaveGlobalScoreUseCase>());
      });

      test('should provide GetPlayerStatsUseCase', () {
        final useCase = container.read(getPlayerStatsUseCaseProvider);
        expect(useCase, isA<GetPlayerStatsUseCase>());
      });

      test('should provide GetTopPlayersUseCase', () {
        final useCase = container.read(getTopPlayersUseCaseProvider);
        expect(useCase, isA<GetTopPlayersUseCase>());
      });
    });

    group('PlayerStatsProvider', () {
      final testStats = const PlayerStats(
        playerId: 'player1',
        playerName: 'Alice',
        totalGamesPlayed: 10,
        totalWins: 5,
        averageScore: 100,
        bestScore: 80,
        worstScore: 120,
        averagePosition: 2.0,
        totalRoundsPlayed: 50,
      );

      test('should fetch player stats successfully', () async {
        when(
          () => mockRepository.getPlayerStats('player1'),
        ).thenAnswer((_) async => testStats);

        final stats = await container.read(
          playerStatsProvider('player1').future,
        );

        expect(stats, equals(testStats));
        verify(() => mockRepository.getPlayerStats('player1')).called(1);
      });

      test('should handle null stats', () async {
        when(
          () => mockRepository.getPlayerStats('unknown'),
        ).thenAnswer((_) async => null);

        final stats = await container.read(
          playerStatsProvider('unknown').future,
        );

        expect(stats, isNull);
      });

      test('should handle errors', () async {
        when(
          () => mockRepository.getPlayerStats(any()),
        ).thenThrow(Exception('Failed to fetch'));

        expect(
          () => container.read(playerStatsProvider('player1').future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('TopPlayersProvider', () {
      final testTopPlayers = [
        const PlayerStats(
          playerId: 'player1',
          playerName: 'Alice',
          totalGamesPlayed: 20,
          totalWins: 15,
          averageScore: 90,
          bestScore: 70,
          worstScore: 110,
          averagePosition: 1.5,
          totalRoundsPlayed: 100,
        ),
        const PlayerStats(
          playerId: 'player2',
          playerName: 'Bob',
          totalGamesPlayed: 15,
          totalWins: 8,
          averageScore: 100,
          bestScore: 80,
          worstScore: 120,
          averagePosition: 2.2,
          totalRoundsPlayed: 75,
        ),
      ];

      test('should fetch top players successfully', () async {
        when(
          () => mockRepository.getTopPlayers(limit: 10),
        ).thenAnswer((_) async => testTopPlayers);

        final players = await container.read(topPlayersProvider.future);

        expect(players.length, equals(2));
        expect(players.first.playerId, equals('player1'));
        verify(() => mockRepository.getTopPlayers(limit: 10)).called(1);
      });

      test('should handle empty list', () async {
        when(
          () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
        ).thenAnswer((_) async => []);

        final players = await container.read(topPlayersProvider.future);

        expect(players, isEmpty);
      });

      test('should handle errors', () async {
        when(
          () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
        ).thenThrow(Exception('Failed to fetch'));

        expect(
          () => container.read(topPlayersProvider.future),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('RecentGamesProvider', () {
      final testGames = [
        GlobalScore(
          id: '1',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room1',
          totalScore: 95,
          roundNumber: 3,
          position: 2,
          isWinner: false,
          createdAt: DateTime(2025, 1, 24, 12, 0),
        ),
        GlobalScore(
          id: '2',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room2',
          totalScore: 85,
          roundNumber: 2,
          position: 1,
          isWinner: true,
          createdAt: DateTime(2025, 1, 23, 18, 0),
        ),
      ];

      test('should fetch recent games successfully', () async {
        when(
          () => mockRepository.getRecentGames('player1', limit: 10),
        ).thenAnswer((_) async => testGames);

        final games = await container.read(
          recentGamesProvider('player1').future,
        );

        expect(games.length, equals(2));
        expect(games.first.id, equals('1'));
        verify(
          () => mockRepository.getRecentGames('player1', limit: 10),
        ).called(1);
      });

      test('should handle empty list', () async {
        when(
          () =>
              mockRepository.getRecentGames(any(), limit: any(named: 'limit')),
        ).thenAnswer((_) async => []);

        final games = await container.read(
          recentGamesProvider('player1').future,
        );

        expect(games, isEmpty);
      });
    });
  });
}
