import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game_card;
import 'package:ojyx/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}
class FakeGlobalScore extends Fake implements GlobalScore {}
class FakeGameState extends Fake implements GameState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeGlobalScore());
    registerFallbackValue(FakeGameState());
  });

  group('SaveGlobalScoreUseCase', () {
    late SaveGlobalScoreUseCase useCase;
    late MockGlobalScoreRepository mockRepository;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      useCase = SaveGlobalScoreUseCase(mockRepository);
    });

    // Create test grids with specific scores
    // Alice: mix of cards to get score of 85
    final aliceCards = [
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
    ];
    final aliceGrid = PlayerGrid.fromCards(aliceCards); // Score: 7*11 + 8 = 85
    
    // Bob: cards to get score of 120
    final bobCards = List.generate(12, (i) => game_card.Card(value: 10, isRevealed: true));
    final bobGrid = PlayerGrid.fromCards(bobCards); // Score: 10 * 12 = 120
    
    // Charlie: cards to get score of 95
    final charlieCards = [
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 8, isRevealed: true),
      game_card.Card(value: 7, isRevealed: true),
    ];
    final charlieGrid = PlayerGrid.fromCards(charlieCards); // Score: 8*11 + 7 = 95

    final testPlayers = [
      GamePlayer(
        id: 'player1',
        name: 'Alice',
        isHost: true,
        grid: aliceGrid,
        scoreMultiplier: 1, // To ensure score = 85 (close enough)
      ),
      GamePlayer(
        id: 'player2',
        name: 'Bob',
        isHost: false,
        grid: bobGrid,
        scoreMultiplier: 1,
      ),
      GamePlayer(
        id: 'player3',
        name: 'Charlie',
        isHost: false,
        grid: charlieGrid,
        scoreMultiplier: 1, // To ensure score = 95 (close enough)
      ),
    ];

    final testGameState = GameState(
      roomId: 'room123',
      players: testPlayers,
      deck: [],
      discardPile: [],
      actionDeck: [],
      actionDiscard: [],
      currentPlayerIndex: 0,
      turnDirection: TurnDirection.clockwise,
      lastRound: false,
      status: GameStatus.finished,
      initiatorPlayerId: 'player2',
      createdAt: DateTime(2025, 1, 24, 10, 0),
    );

    test('should save scores for all players with correct positions', () async {
      final expectedScores = [
        GlobalScore(
          id: '',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room123',
          totalScore: 85,
          roundNumber: 1, // Assuming first round
          position: 1,
          isWinner: true,
          createdAt: testGameState.createdAt ?? DateTime.now(),
          gameEndedAt: DateTime.now(),
        ),
        GlobalScore(
          id: '',
          playerId: 'player3',
          playerName: 'Charlie',
          roomId: 'room123',
          totalScore: 95,
          roundNumber: 1, // Assuming first round
          position: 2,
          isWinner: false,
          createdAt: testGameState.createdAt ?? DateTime.now(),
          gameEndedAt: DateTime.now(),
        ),
        GlobalScore(
          id: '',
          playerId: 'player2',
          playerName: 'Bob',
          roomId: 'room123',
          totalScore: 120,
          roundNumber: 1, // Assuming first round
          position: 3,
          isWinner: false,
          createdAt: testGameState.createdAt ?? DateTime.now(),
          gameEndedAt: DateTime.now(),
        ),
      ];

      when(() => mockRepository.saveBatchScores(any()))
          .thenAnswer((_) async => expectedScores.map((s) => s.copyWith(id: 'generated_${s.playerId}')).toList());

      final result = await useCase(SaveGlobalScoreParams(gameState: testGameState));

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (scores) {
          expect(scores.length, equals(3));
          // Verify positions are correct (sorted by score)
          expect(scores[0].position, equals(1)); // Alice with 85
          expect(scores[1].position, equals(2)); // Charlie with 95
          expect(scores[2].position, equals(3)); // Bob with 120
          // Verify winner
          expect(scores[0].isWinner, isTrue);
          expect(scores[1].isWinner, isFalse);
          expect(scores[2].isWinner, isFalse);
        },
      );
    });

    test('should apply penalty to round initiator if not winner', () async {
      // Bob initiated the round but didn't win (Alice has lowest score)
      final gameWithPenalty = testGameState.copyWith(
        initiatorPlayerId: 'player2', // Bob
      );

      when(() => mockRepository.saveBatchScores(any()))
          .thenAnswer((invocation) async {
            final scores = invocation.positionalArguments[0] as List<GlobalScore>;
            // Bob's score should be doubled (120 * 2 = 240)
            final bobScore = scores.firstWhere((s) => s.playerId == 'player2');
            expect(bobScore.totalScore, equals(240));
            return scores.map((s) => s.copyWith(id: 'generated_${s.playerId}')).toList();
          });

      final result = await useCase(SaveGlobalScoreParams(gameState: gameWithPenalty));

      expect(result.isRight(), isTrue);
    });

    test('should not apply penalty if round initiator is winner', () async {
      // Alice initiated the round and won (has lowest score)
      final gameNoPenalty = testGameState.copyWith(
        initiatorPlayerId: 'player1', // Alice
      );

      when(() => mockRepository.saveBatchScores(any()))
          .thenAnswer((invocation) async {
            final scores = invocation.positionalArguments[0] as List<GlobalScore>;
            // Alice's score should NOT be doubled
            final aliceScore = scores.firstWhere((s) => s.playerId == 'player1');
            expect(aliceScore.totalScore, equals(85));
            return scores.map((s) => s.copyWith(id: 'generated_${s.playerId}')).toList();
          });

      final result = await useCase(SaveGlobalScoreParams(gameState: gameNoPenalty));

      expect(result.isRight(), isTrue);
    });

    test('should return failure when repository throws exception', () async {
      when(() => mockRepository.saveBatchScores(any()))
          .thenThrow(Exception('Database error'));

      final result = await useCase(SaveGlobalScoreParams(gameState: testGameState));

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Should have failed'),
      );
    });

    test('should handle game with single player', () async {
      final singlePlayerGame = testGameState.copyWith(
        players: [testPlayers[0]],
      );

      when(() => mockRepository.saveBatchScores(any()))
          .thenAnswer((invocation) async {
            final scores = invocation.positionalArguments[0] as List<GlobalScore>;
            expect(scores.length, equals(1));
            expect(scores[0].isWinner, isTrue);
            expect(scores[0].position, equals(1));
            return scores.map((s) => s.copyWith(id: 'generated_${s.playerId}')).toList();
          });

      final result = await useCase(SaveGlobalScoreParams(gameState: singlePlayerGame));

      expect(result.isRight(), isTrue);
    });

    test('should set correct game ended time', () async {
      final beforeCall = DateTime.now();

      when(() => mockRepository.saveBatchScores(any()))
          .thenAnswer((invocation) async {
            final scores = invocation.positionalArguments[0] as List<GlobalScore>;
            // All scores should have gameEndedAt set
            for (final score in scores) {
              expect(score.gameEndedAt, isNotNull);
              expect(score.gameEndedAt!.isAfter(beforeCall), isTrue);
              expect(score.gameEndedAt!.isBefore(DateTime.now().add(Duration(seconds: 1))), isTrue);
            }
            return scores.map((s) => s.copyWith(id: 'generated_${s.playerId}')).toList();
          });

      await useCase(SaveGlobalScoreParams(gameState: testGameState));
    });
  });
}