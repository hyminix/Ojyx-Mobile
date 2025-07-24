import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/features/end_game/presentation/providers/end_game_provider.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:riverpod/riverpod.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/global_scores/domain/entities/global_score.dart';
import 'package:ojyx/features/global_scores/domain/repositories/global_score_repository.dart';
import 'package:ojyx/features/global_scores/domain/use_cases/save_global_score.dart';
import 'package:ojyx/features/global_scores/presentation/providers/global_score_providers.dart';
import 'package:ojyx/features/multiplayer/presentation/providers/room_providers.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game_card;
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

class MockGlobalScoreRepository extends Mock implements GlobalScoreRepository {}
class MockSaveGlobalScoreUseCase extends Mock implements SaveGlobalScoreUseCase {}
class FakeSaveGlobalScoreParams extends Fake implements SaveGlobalScoreParams {}

class StubGameStateNotifier extends GameStateNotifier {
  final GameState? stubState;
  
  StubGameStateNotifier(this.stubState);
  
  @override
  GameState? build() => stubState;
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSaveGlobalScoreParams());
  });

  group('EndGameScreen - SaveGlobalScore Integration', () {
    late ProviderContainer container;
    late MockGlobalScoreRepository mockRepository;
    late MockSaveGlobalScoreUseCase mockUseCase;
    late GameState testGameState;
    late List<Player> testPlayers;

    setUp(() {
      mockRepository = MockGlobalScoreRepository();
      mockUseCase = MockSaveGlobalScoreUseCase();

      // Create test players with proper grids
      testPlayers = [
        Player(
          id: 'player1',
          name: 'Alice',
          grid: PlayerGrid.fromCards(
            List.generate(12, (i) => 
              game_card.Card(
                value: i == 0 ? 5 : 10,
                isRevealed: true,
              ),
            ),
          ),
        ),
        Player(
          id: 'player2',
          name: 'Bob',
          grid: PlayerGrid.fromCards(
            List.generate(12, (i) => 
              game_card.Card(
                value: 12,
                isRevealed: true,
              ),
            ),
          ),
        ),
      ];

      testGameState = GameState(
        roomId: 'room123',
        status: GameStatus.finished,
        players: testPlayers,
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
        initiatorPlayerId: 'player1',
        endRoundInitiator: 'player1',
      );

      container = ProviderContainer(
        overrides: [
          currentRoomIdProvider.overrideWithValue('room123'),
          gameStateNotifierProvider.overrideWith(() => StubGameStateNotifier(testGameState)),
          globalScoreRepositoryProvider.overrideWithValue(mockRepository),
          saveGlobalScoreUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should save global scores when game ends', () async {
      // Arrange
      final expectedScores = [
        GlobalScore(
          id: '',
          playerId: 'player1',
          playerName: 'Alice',
          roomId: 'room123',
          totalScore: 115, // 5 + (10 * 11)
          roundNumber: 1,
          position: 1,
          isWinner: true,
          createdAt: DateTime.now(),
        ),
        GlobalScore(
          id: '',
          playerId: 'player2',
          playerName: 'Bob',
          roomId: 'room123',
          totalScore: 144, // 12 * 12
          roundNumber: 1,
          position: 2,
          isWinner: false,
          createdAt: DateTime.now(),
        ),
      ];

      when(() => mockUseCase(any())).thenAnswer(
        (_) async => Right(expectedScores),
      );

      // Act
      await container.read(endGameWithSaveProvider.future);

      // Assert and capture in one call
      final captured = verify(() => mockUseCase(captureAny())).captured;
      expect(captured.length, equals(1));
      
      final params = captured.first as SaveGlobalScoreParams;
      expect(params.gameState, equals(testGameState));
      expect(params.roundNumber, equals(1));
    });

    test('should handle save errors gracefully', () async {
      // Arrange
      when(() => mockUseCase(any())).thenAnswer(
        (_) async => const Left(Failure.server(message: 'Failed to save scores')),
      );

      // Act & Assert
      expect(
        () => container.read(endGameWithSaveProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('should not save scores if game not finished', () async {
      // Arrange
      final inProgressGame = testGameState.copyWith(
        status: GameStatus.playing,
      );
      
      container = ProviderContainer(
        overrides: [
          currentRoomIdProvider.overrideWithValue('room123'),
          gameStateNotifierProvider.overrideWith(() => StubGameStateNotifier(inProgressGame)),
          globalScoreRepositoryProvider.overrideWithValue(mockRepository),
          saveGlobalScoreUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      // Act
      await container.read(endGameWithSaveProvider.future);

      // Assert
      verifyNever(() => mockUseCase(any()));
    });

    test('should handle missing room ID gracefully', () async {
      // Arrange
      container = ProviderContainer(
        overrides: [
          currentRoomIdProvider.overrideWithValue(null),
          gameStateNotifierProvider.overrideWith(() => StubGameStateNotifier(testGameState)),
          globalScoreRepositoryProvider.overrideWithValue(mockRepository),
          saveGlobalScoreUseCaseProvider.overrideWithValue(mockUseCase),
        ],
      );

      // Act
      await container.read(endGameWithSaveProvider.future);

      // Assert
      verifyNever(() => mockUseCase(any()));
    });
  });
}