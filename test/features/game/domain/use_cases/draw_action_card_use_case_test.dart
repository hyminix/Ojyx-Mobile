import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game_card;
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';
import 'package:ojyx/features/game/domain/use_cases/draw_action_card_use_case.dart';

class MockActionCardRepository extends Mock implements ActionCardRepository {}

void main() {
  late DrawActionCardUseCase useCase;
  late MockActionCardRepository mockRepository;
  
  setUp(() {
    mockRepository = MockActionCardRepository();
    useCase = DrawActionCardUseCase(mockRepository);
  });

  group('DrawActionCardUseCase', () {
    final testActionCard = ActionCard(
      id: 'test-card-1',
      type: ActionCardType.turnAround,
      name: 'Demi-tour',
      description: 'Inversez le sens du jeu',
      timing: ActionTiming.immediate,
      target: ActionTarget.none,
    );

    final testGrid = PlayerGrid.fromCards(
      List.generate(12, (i) => game_card.Card(value: 0, isRevealed: false)),
    );

    final testPlayer = Player(
      id: 'player1',
      name: 'Test Player',
      grid: testGrid,
      actionCards: [],
    );

    final testGameState = GameState(
      roomId: 'room1',
      players: [testPlayer],
      currentPlayerIndex: 0,
      deck: List.generate(10, (i) => game_card.Card(value: i, isRevealed: false)),
      discardPile: [],
      actionDeck: [],
      actionDiscard: [],
      status: GameStatus.playing,
      turnDirection: TurnDirection.clockwise,
      lastRound: false,
    );

    test('should draw an action card when player has less than 3 cards', () async {
      // Arrange
      when(() => mockRepository.drawActionCard()).thenReturn(testActionCard);
      when(() => mockRepository.addActionCardToPlayer('player1', testActionCard))
          .thenAnswer((_) async {});

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: testGameState,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (updatedState) {
          final updatedPlayer = updatedState.players.first;
          expect(updatedPlayer.actionCards.length, 1);
          expect(updatedPlayer.actionCards.first, testActionCard);
        },
      );
      
      verify(() => mockRepository.drawActionCard()).called(1);
      verify(() => mockRepository.addActionCardToPlayer('player1', testActionCard)).called(1);
    });

    test('should fail when player already has 3 action cards', () async {
      // Arrange
      final playerWithFullHand = testPlayer.copyWith(
        actionCards: List.generate(
          kMaxActionCardsInHand,
          (i) => ActionCard(
            id: 'card-$i',
            type: ActionCardType.skip,
            name: 'Skip $i',
            description: 'Skip',
            timing: ActionTiming.optional,
            target: ActionTarget.none,
          ),
        ),
      );

      final gameStateWithFullHand = testGameState.copyWith(
        players: [playerWithFullHand],
      );

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: gameStateWithFullHand,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('cannot draw more'));
        },
        (_) => fail('Should return failure'),
      );
      
      verifyNever(() => mockRepository.drawActionCard());
    });

    test('should fail when it is not the player\'s turn', () async {
      // Arrange
      final otherPlayer = Player(
        id: 'player2',
        name: 'Other Player',
        grid: testGrid,
        actionCards: [],
      );

      final gameStateWithOtherTurn = testGameState.copyWith(
        players: [testPlayer, otherPlayer],
        currentPlayerIndex: 1, // Other player's turn
      );

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: gameStateWithOtherTurn,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('not your turn'));
        },
        (_) => fail('Should return failure'),
      );
      
      verifyNever(() => mockRepository.drawActionCard());
    });

    test('should fail when player has already drawn a card this turn', () async {
      // Arrange
      final gameStateWithDrawnCard = testGameState.copyWith(
        drawnCard: game_card.Card(value: 5, isRevealed: true),
      );

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: gameStateWithDrawnCard,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('already drawn'));
        },
        (_) => fail('Should return failure'),
      );
      
      verifyNever(() => mockRepository.drawActionCard());
    });

    test('should fail when action card deck is empty', () async {
      // Arrange
      when(() => mockRepository.drawActionCard()).thenReturn(null);

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: testGameState,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('No action cards available'));
        },
        (_) => fail('Should return failure'),
      );
      
      verify(() => mockRepository.drawActionCard()).called(1);
    });

    test('should fail when game is not in progress', () async {
      // Arrange
      final gameStateNotInProgress = testGameState.copyWith(
        status: GameStatus.waitingToStart,
      );

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: gameStateNotInProgress,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('not in progress'));
        },
        (_) => fail('Should return failure'),
      );
      
      verifyNever(() => mockRepository.drawActionCard());
    });

    test('should handle immediate action cards correctly', () async {
      // Arrange
      final immediateCard = ActionCard(
        id: 'immediate-card',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Inversez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      );

      when(() => mockRepository.drawActionCard()).thenReturn(immediateCard);
      when(() => mockRepository.addActionCardToPlayer('player1', immediateCard))
          .thenAnswer((_) async {});

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: testGameState,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (updatedState) {
          // For immediate cards, we just verify the card was added
          final updatedPlayer = updatedState.players.first;
          expect(updatedPlayer.actionCards.length, 1);
          expect(updatedPlayer.actionCards.first.timing, ActionTiming.immediate);
          // The actual immediate action handling will be done in a separate flow
        },
      );
    });

    test('should update game state to indicate card was drawn', () async {
      // Arrange
      final optionalCard = ActionCard(
        id: 'optional-card',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Le prochain joueur passe son tour',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      when(() => mockRepository.drawActionCard()).thenReturn(optionalCard);
      when(() => mockRepository.addActionCardToPlayer('player1', optionalCard))
          .thenAnswer((_) async {});

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: testGameState,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (updatedState) {
          // For now, we mark that a card was drawn by setting a marker card
          // This prevents drawing multiple cards in the same turn
          expect(updatedState.drawnCard, isNotNull);
          expect(updatedState.drawnCard!.value, 0); // Using 0 as a valid marker
        },
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Arrange
      when(() => mockRepository.drawActionCard())
          .thenThrow(Exception('Repository error'));

      final params = DrawActionCardParams(
        playerId: 'player1',
        gameState: testGameState,
      );

      // Act
      final result = await useCase(params);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Failed to draw action card'));
        },
        (_) => fail('Should return failure'),
      );
    });
  });
}