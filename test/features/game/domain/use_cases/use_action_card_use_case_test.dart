import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class MockGameStateRepository extends Mock implements GameStateRepository {}

void main() {
  late UseActionCardUseCase useCase;
  late MockGameStateRepository mockRepository;

  setUp(() {
    mockRepository = MockGameStateRepository();
    useCase = UseActionCardUseCase(mockRepository);
  });

  GameState createTestGameState({
    int currentPlayerIndex = 0,
    TurnDirection turnDirection = TurnDirection.clockwise,
    bool lastRound = false,
  }) {
    final players = [
      GamePlayer(
        id: 'player1',
        name: 'GamePlayer 1',
        grid: PlayerGrid.empty(),
        actionCards: [],
        hasFinishedRound: false,
      ),
      GamePlayer(
        id: 'player2',
        name: 'GamePlayer 2',
        grid: PlayerGrid.empty(),
        actionCards: [],
        hasFinishedRound: false,
      ),
    ];

    return GameState(
      roomId: 'test-room',
      players: players,
      currentPlayerIndex: currentPlayerIndex,
      deck: [],
      discardPile: [],
      actionDeck: [],
      actionDiscard: [],
      status: GameStatus.playing,
      turnDirection: turnDirection,
      lastRound: lastRound,
      createdAt: DateTime.now(),
    );
  }

  group('UseActionCardUseCase', () {
    test('should use optional action card successfully', () async {
      // Arrange
      const gameStateId = 'test-game-id';
      const playerId = 'player1';
      const actionCardType = ActionCardType.skip;

      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      final expectedResponse = {
        'valid': true,
        'gameState': {}, // Server response format
      };

      when(
        () => mockRepository.useActionCard(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (response) {
        expect(response['valid'], isTrue);
        verify(
          () => mockRepository.useActionCard(
            gameStateId: gameStateId,
            playerId: playerId,
            actionCardType: actionCardType,
            targetData: null,
          ),
        ).called(1);
      });
    });

    test('should fail if player does not have the action card', () async {
      // Arrange
      const gameStateId = 'test-game-id';
      const playerId = 'player1';
      const actionCardType = ActionCardType.teleport;

      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      final expectedResponse = {
        'valid': false,
        'error': 'action card not available',
      };

      when(
        () => mockRepository.useActionCard(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<Failure>());
        expect(failure.message, contains('action card not available'));
      }, (_) => fail('Should not succeed'));
    });

    test('should use mandatory action card immediately', () async {
      // Arrange
      const gameStateId = 'test-game-id';
      const playerId = 'player1';
      const actionCardType = ActionCardType.turnAround;

      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      final expectedResponse = {
        'valid': true,
        'gameState': {
          'turnDirection': 'counterClockwise', // Reversed from clockwise
        },
      };

      when(
        () => mockRepository.useActionCard(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (response) {
        expect(response['valid'], isTrue);
        expect(
          response['gameState']['turnDirection'],
          equals('counterClockwise'),
        );
      });
    });

    test(
      'should reverse turn direction multiple times with Demi-tour',
      () async {
        // Arrange
        const gameStateId = 'test-game-id';
        const playerId = 'player1';
        const actionCardType = ActionCardType.turnAround;

        final params = UseActionCardParams(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        );

        final expectedResponse = {
          'valid': true,
          'gameState': {
            'turnDirection': 'clockwise', // Reversed from counterClockwise
          },
        };

        when(
          () => mockRepository.useActionCard(
            gameStateId: gameStateId,
            playerId: playerId,
            actionCardType: actionCardType,
            targetData: null,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should not fail'), (response) {
          expect(response['valid'], isTrue);
          expect(response['gameState']['turnDirection'], equals('clockwise'));
        });
      },
    );

    test('should validate target data for cards that require it', () async {
      // Arrange
      const gameStateId = 'test-game-id';
      const playerId = 'player1';
      const actionCardType = ActionCardType.teleport;

      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null, // Missing required target data
      );

      final expectedResponse = {'valid': false, 'error': 'invalid positions'};

      when(
        () => mockRepository.useActionCard(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<Failure>());
        expect(failure.message, contains('invalid positions'));
      }, (_) => fail('Should not succeed'));
    });

    test(
      'should handle teleportation action card with valid targets',
      () async {
        // Arrange
        const gameStateId = 'test-game-id';
        const playerId = 'player1';
        const actionCardType = ActionCardType.teleport;

        final targetData = {
          'position1': {'row': 0, 'col': 0},
          'position2': {'row': 1, 'col': 1},
        };

        final params = UseActionCardParams(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: targetData,
        );

        final expectedResponse = {
          'valid': true,
          'gameState': {'cards_swapped': true},
        };

        when(
          () => mockRepository.useActionCard(
            gameStateId: gameStateId,
            playerId: playerId,
            actionCardType: actionCardType,
            targetData: targetData,
          ),
        ).thenAnswer((_) async => expectedResponse);

        // Act
        final result = await useCase(params);

        // Assert
        expect(result.isRight(), isTrue);
        result.fold((failure) => fail('Should not fail'), (response) {
          expect(response['valid'], isTrue);
          expect(response['gameState']['cards_swapped'], isTrue);
        });
      },
    );

    test('should not allow using action card when not player turn', () async {
      // Arrange
      const gameStateId = 'test-game-id';
      const playerId = 'player1';
      const actionCardType = ActionCardType.teleport;

      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      final expectedResponse = {'valid': false, 'error': 'not your turn'};

      when(
        () => mockRepository.useActionCard(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), isTrue);
      result.fold((failure) {
        expect(failure, isA<Failure>());
        expect(failure.message, contains('not your turn'));
      }, (_) => fail('Should not succeed'));
    });

    test('should allow reaction cards outside of turn', () async {
      // Arrange
      const gameStateId = 'test-game-id';
      const playerId = 'player1';
      const actionCardType = ActionCardType.shield;

      final params = UseActionCardParams(
        gameStateId: gameStateId,
        playerId: playerId,
        actionCardType: actionCardType,
        targetData: null,
      );

      final expectedResponse = {
        'valid': true,
        'gameState': {'shield_activated': true},
      };

      when(
        () => mockRepository.useActionCard(
          gameStateId: gameStateId,
          playerId: playerId,
          actionCardType: actionCardType,
          targetData: null,
        ),
      ).thenAnswer((_) async => expectedResponse);

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), isTrue);
      result.fold((failure) => fail('Should not fail'), (response) {
        expect(response['valid'], isTrue);
        expect(response['gameState']['shield_activated'], isTrue);
      });
    });
  });
}
