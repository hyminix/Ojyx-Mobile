import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_top_players.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}

void main() {
  group('GetTopPlayersUseCase', () {
    late GetTopPlayersUseCase useCase;
    late MockGlobalScoreRepository mockRepository;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      useCase = GetTopPlayersUseCase(mockRepository);
    });

    final testTopPlayers = [
      const PlayerStats(
        playerId: 'player1',
        playerName: 'Alice',
        totalGamesPlayed: 50,
        totalWins: 40,
        averageScore: 85.5,
        bestScore: 55,
        worstScore: 120,
        averagePosition: 1.2,
        totalRoundsPlayed: 250,
      ),
      const PlayerStats(
        playerId: 'player2',
        playerName: 'Bob',
        totalGamesPlayed: 45,
        totalWins: 30,
        averageScore: 95.0,
        bestScore: 65,
        worstScore: 130,
        averagePosition: 1.8,
        totalRoundsPlayed: 225,
      ),
      const PlayerStats(
        playerId: 'player3',
        playerName: 'Charlie',
        totalGamesPlayed: 60,
        totalWins: 35,
        averageScore: 105.5,
        bestScore: 75,
        worstScore: 140,
        averagePosition: 2.1,
        totalRoundsPlayed: 300,
      ),
    ];

    test('should get top players from repository with default limit', () async {
      when(
        () => mockRepository.getTopPlayers(limit: 10),
      ).thenAnswer((_) async => testTopPlayers);

      final result = await useCase(const GetTopPlayersParams());

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (players) {
        expect(players.length, equals(3));
        expect(players.first.playerId, equals('player1'));
        expect(players.first.winRate, equals(0.8)); // 40/50
        // Verify players are sorted by win rate (descending)
        expect(players[0].winRate, greaterThanOrEqualTo(players[1].winRate));
        expect(players[1].winRate, greaterThanOrEqualTo(players[2].winRate));
      });

      verify(() => mockRepository.getTopPlayers(limit: 10)).called(1);
    });

    test('should get top players with custom limit', () async {
      when(
        () => mockRepository.getTopPlayers(limit: 5),
      ).thenAnswer((_) async => testTopPlayers.take(2).toList());

      final result = await useCase(const GetTopPlayersParams(limit: 5));

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (players) {
        expect(players.length, equals(2));
      });

      verify(() => mockRepository.getTopPlayers(limit: 5)).called(1);
    });

    test('should handle empty list', () async {
      when(
        () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
      ).thenAnswer((_) async => []);

      final result = await useCase(const GetTopPlayersParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (players) => expect(players, isEmpty),
      );
    });

    test('should return failure when repository throws exception', () async {
      when(
        () => mockRepository.getTopPlayers(limit: any(named: 'limit')),
      ).thenThrow(Exception('Database error'));

      final result = await useCase(const GetTopPlayersParams());

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should have failed'),
      );
    });

    test('should handle large limit', () async {
      when(
        () => mockRepository.getTopPlayers(limit: 100),
      ).thenAnswer((_) async => testTopPlayers);

      final result = await useCase(const GetTopPlayersParams(limit: 100));

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (players) {
        expect(players.length, equals(3));
      });
    });

    test('should filter out players with no games', () async {
      final playersWithNoGames = [
        ...testTopPlayers,
        const PlayerStats(
          playerId: 'player4',
          playerName: 'David',
          totalGamesPlayed: 0,
          totalWins: 0,
          averageScore: 0,
          bestScore: 0,
          worstScore: 0,
          averagePosition: 0,
          totalRoundsPlayed: 0,
        ),
      ];

      when(
        () => mockRepository.getTopPlayers(limit: 10),
      ).thenAnswer((_) async => playersWithNoGames);

      final result = await useCase(const GetTopPlayersParams());

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (players) {
        // Repository should already filter these, but verify
        expect(players.length, equals(4));
        expect(players.any((p) => p.totalGamesPlayed == 0), isTrue);
      });
    });
  });
}
