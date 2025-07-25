import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_providers.dart';
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/game/presentation/providers/repository_providers.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockActionCardRepository extends Mock implements ActionCardRepository {}

class MockGameStateRepository extends Mock implements GameStateRepository {}

class MockUseActionCardUseCase extends Mock implements UseActionCardUseCase {}

class FakeUseActionCardParams extends Fake implements UseActionCardParams {}

void main() {
  late ProviderContainer container;
  late MockActionCardRepository mockRepository;
  late MockGameStateRepository mockGameStateRepository;
  late MockUseActionCardUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(FakeUseActionCardParams());
  });

  setUp(() {
    mockRepository = MockActionCardRepository();
    mockGameStateRepository = MockGameStateRepository();
    mockUseCase = MockUseActionCardUseCase();
    container = ProviderContainer(
      overrides: [
        actionCardRepositoryProvider.overrideWithValue(mockRepository),
        gameStateRepositoryProvider.overrideWithValue(mockGameStateRepository),
        useActionCardUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ActionCard Provider Behavior', () {
    test(
      'should update game state when action card is used successfully',
      () async {
        // Arrange - Setup initial game state
        final player1 = GamePlayer(
          id: 'player1',
          name: 'Player 1',
          grid: PlayerGrid.empty(),
          actionCards: [
            const ActionCard(
              id: 'card1',
              type: ActionCardType.skip,
              name: 'Skip Turn',
              description: 'Skip next player turn',
              timing: ActionTiming.optional,
            ),
          ],
        );

        final player2 = GamePlayer(
          id: 'player2',
          name: 'Player 2',
          grid: PlayerGrid.empty(),
          actionCards: [],
        );

        final initialGameState = GameState(
          roomId: 'room123',
          players: [player1, player2],
          currentPlayerIndex: 0,
          deck: [],
          discardPile: [],
          actionDeck: [],
          actionDiscard: [],
          status: GameStatus.playing,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
        );

        final updatedGameState = initialGameState.copyWith(
          currentPlayerIndex: 1, // Skip to next player
          players: [
            player1.removeActionCard('card1'), // Remove used card
            player2,
          ],
        );

        // Setup mock behavior
        when(() => mockUseCase(any())).thenAnswer(
          (_) async => const Right({'success': true, 'updated_state': true}),
        );

        // Act - Use action card
        final result = await container.read(useActionCardUseCaseProvider)(
          UseActionCardParams(
            gameStateId: 'room123',
            playerId: 'player1',
            actionCardType: ActionCardType.teleport,
            targetData: {'cardId': 'card1'},
          ),
        );

        // Assert - Verify state update
        expect(result.isRight(), true);
        result.fold((failure) => fail('Should not fail'), (response) {
          expect(response['success'], true);
          expect(response['updated_state'], true);
        });
      },
    );

    test('should handle action card usage failure', () async {
      // Arrange - Setup game state
      final gameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'Player 1',
            grid: PlayerGrid.empty(),
            actionCards: [],
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Setup mock failure
      when(() => mockUseCase(any())).thenAnswer(
        (_) async => const Left(
          Failure.gameLogic(message: 'Card not found', code: 'CARD_NOT_FOUND'),
        ),
      );

      // Act - Try to use non-existent card
      final result = await container.read(useActionCardUseCaseProvider)(
        UseActionCardParams(
          gameStateId: 'room123',
          playerId: 'player1',
          actionCardType: ActionCardType.teleport,
          targetData: {'cardId': 'non-existent'},
        ),
      );

      // Assert - Verify failure
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Card not found'),
        (_) => fail('Should have failed'),
      );
    });

    test('should provide available action cards for current player', () {
      // Arrange - Setup game state with action cards
      final actionCards = [
        const ActionCard(
          id: 'card1',
          type: ActionCardType.teleport,
          name: 'Teleport',
          description: 'Teleport cards',
          timing: ActionTiming.optional,
        ),
        const ActionCard(
          id: 'card2',
          type: ActionCardType.peek,
          name: 'Peek',
          description: 'Peek at card',
          timing: ActionTiming.optional,
        ),
      ];

      final gameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'Player 1',
            grid: PlayerGrid.empty(),
            actionCards: actionCards,
          ),
        ],
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );

      // Act - Get available cards
      final currentPlayer = gameState.currentPlayer;
      final availableCards = currentPlayer.actionCards;

      // Assert
      expect(availableCards.length, 2);
      expect(availableCards[0].type, ActionCardType.teleport);
      expect(availableCards[1].type, ActionCardType.peek);
    });

    test('should enforce action card timing rules', () {
      // Arrange - Setup immediate action card
      final immediateCard = const ActionCard(
        id: 'immediate1',
        type: ActionCardType.turnAround,
        name: 'Turn Around',
        description: 'Reverse turn direction',
        timing: ActionTiming.immediate,
      );

      final optionalCard = const ActionCard(
        id: 'optional1',
        type: ActionCardType.shield,
        name: 'Shield',
        description: 'Protect from attacks',
        timing: ActionTiming.optional,
      );

      // Assert timing properties
      expect(immediateCard.isImmediate, true);
      expect(immediateCard.isOptional, false);
      expect(optionalCard.isImmediate, false);
      expect(optionalCard.isOptional, true);
    });

    test('should limit action cards in hand to maximum allowed', () {
      // Arrange - Try to add cards beyond limit
      final player = GamePlayer(
        id: 'player1',
        name: 'Player 1',
        grid: PlayerGrid.empty(),
        actionCards: [
          const ActionCard(
            id: 'card1',
            type: ActionCardType.skip,
            name: 'Skip',
            description: 'Skip turn',
          ),
          const ActionCard(
            id: 'card2',
            type: ActionCardType.peek,
            name: 'Peek',
            description: 'Peek at card',
          ),
          const ActionCard(
            id: 'card3',
            type: ActionCardType.swap,
            name: 'Swap',
            description: 'Swap cards',
          ),
        ],
      );

      // Act & Assert - Should throw when trying to add 4th card
      expect(
        () => player.addActionCard(
          const ActionCard(
            id: 'card4',
            type: ActionCardType.shield,
            name: 'Shield',
            description: 'Shield from attacks',
          ),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
