import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/get_player_stats.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}

void main() {
  group('GetPlayerStatsUseCase', () {
    late GetPlayerStatsUseCase useCase;
    late MockGlobalScoreRepository mockRepository;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      useCase = GetPlayerStatsUseCase(mockRepository);
    });

    final testStats = PlayerStats(
      playerId: 'player1',
      playerName: 'Alice',
      totalGamesPlayed: 25,
      totalWins: 15,
      averageScore: 98.5,
      bestScore: 65,
      worstScore: 145,
      averagePosition: 1.8,
      totalRoundsPlayed: 125,
    );

    test('should get player stats from repository', () async {
      when(
        () => mockRepository.getPlayerStats('player1'),
      ).thenAnswer((_) async => testStats);

      final result = await useCase(
        const GetPlayerStatsParams(playerId: 'player1'),
      );

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (stats) {
        expect(stats, isNotNull);
        expect(stats!.playerId, equals('player1'));
        expect(stats.totalGamesPlayed, equals(25));
        expect(stats.totalWins, equals(15));
        expect(stats.winRate, equals(0.6)); // 15/25
      });

      verify(() => mockRepository.getPlayerStats('player1')).called(1);
    });

    test('should return null when player has no stats', () async {
      when(
        () => mockRepository.getPlayerStats('unknown'),
      ).thenAnswer((_) async => null);

      final result = await useCase(
        const GetPlayerStatsParams(playerId: 'unknown'),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (stats) => expect(stats, isNull),
      );
    });

    test('should return failure when repository throws exception', () async {
      when(
        () => mockRepository.getPlayerStats(any()),
      ).thenThrow(Exception('Database error'));

      final result = await useCase(
        const GetPlayerStatsParams(playerId: 'player1'),
      );

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should have failed'),
      );
    });

    test('should calculate correct win rate', () async {
      final statsWithDifferentWinRate = PlayerStats(
        playerId: 'player2',
        playerName: 'Bob',
        totalGamesPlayed: 50,
        totalWins: 10,
        averageScore: 110,
        bestScore: 80,
        worstScore: 150,
        averagePosition: 2.5,
        totalRoundsPlayed: 200,
      );

      when(
        () => mockRepository.getPlayerStats('player2'),
      ).thenAnswer((_) async => statsWithDifferentWinRate);

      final result = await useCase(
        const GetPlayerStatsParams(playerId: 'player2'),
      );

      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (stats) {
        expect(stats, isNotNull);
        expect(stats!.winRate, equals(0.2)); // 10/50
      });
    });

    test('should handle empty player ID', () async {
      when(
        () => mockRepository.getPlayerStats(''),
      ).thenAnswer((_) async => null);

      final result = await useCase(const GetPlayerStatsParams(playerId: ''));

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (stats) => expect(stats, isNull),
      );
    });
  });
}
