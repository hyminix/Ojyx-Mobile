import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/presentation/providers/action_card_providers.dart';
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ojyx/core/errors/failures.dart';

class MockActionCardRepository extends Mock implements ActionCardRepository {}

void main() {
  late ProviderContainer container;
  late MockActionCardRepository mockRepository;

  setUp(() {
    mockRepository = MockActionCardRepository();
    container = ProviderContainer(
      overrides: [
        actionCardRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('actionCardRepositoryProvider', () {
    test('should provide action card repository', () {
      // Act
      final repository = container.read(actionCardRepositoryProvider);

      // Assert
      expect(repository, equals(mockRepository));
    });
  });

  group('useActionCardUseCaseProvider', () {
    test('should provide use action card use case', () {
      // Act
      final useCase = container.read(useActionCardUseCaseProvider);

      // Assert
      expect(useCase, isA<UseActionCardUseCase>());
    });
  });

  group('playerActionCardsProvider', () {
    test('should return empty list when player has no cards', () {
      // Arrange
      const playerId = 'player1';
      when(() => mockRepository.getPlayerActionCards(playerId)).thenReturn([]);

      // Act
      final cards = container.read(playerActionCardsProvider(playerId));

      // Assert
      expect(cards, isEmpty);
      verify(() => mockRepository.getPlayerActionCards(playerId)).called(1);
    });

    test('should return player action cards', () {
      // Arrange
      const playerId = 'player1';
      final actionCards = [
        ActionCard(
          id: 'card1',
          type: ActionCardType.teleport,
          name: 'Téléportation',
          description: 'Échangez deux cartes',
          timing: ActionTiming.optional,
          target: ActionTarget.self,
        ),
        ActionCard(
          id: 'card2',
          type: ActionCardType.skip,
          name: 'Saut',
          description: 'Sautez le tour du prochain joueur',
          timing: ActionTiming.optional,
          target: ActionTarget.none,
        ),
      ];

      when(
        () => mockRepository.getPlayerActionCards(playerId),
      ).thenReturn(actionCards);

      // Act
      final cards = container.read(playerActionCardsProvider(playerId));

      // Assert
      expect(cards, equals(actionCards));
      expect(cards.length, equals(2));
    });
  });

  group('canUseActionCardProvider', () {
    test('should return false when no action card selected', () {
      // Arrange
      const playerId = 'player1';
      final params = (playerId: playerId, actionCard: null as ActionCard?);

      // Act
      final canUse = container.read(canUseActionCardProvider(params));

      // Assert
      expect(canUse, isFalse);
    });

    test('should return false when player does not have the card', () {
      // Arrange
      const playerId = 'player1';
      final actionCard = ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      final params = (playerId: playerId, actionCard: actionCard);

      when(
        () => mockRepository.getPlayerActionCards(playerId),
      ).thenReturn([]); // Player has no cards

      // Act
      final canUse = container.read(canUseActionCardProvider(params));

      // Assert
      expect(canUse, isFalse);
    });

    test('should return true when player has the card', () {
      // Arrange
      const playerId = 'player1';
      final actionCard = ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      final params = (playerId: playerId, actionCard: actionCard);

      when(
        () => mockRepository.getPlayerActionCards(playerId),
      ).thenReturn([actionCard]); // Player has the card

      // Act
      final canUse = container.read(canUseActionCardProvider(params));

      // Assert
      expect(canUse, isTrue);
    });
  });

  group('actionCardNotifierProvider', () {
    test('should use action card successfully', () async {
      // Arrange
      final actionCard = ActionCard(
        id: 'card1',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Sautez le tour du prochain joueur',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );

      final gameState = GameState(
        roomId: 'test-room',
        players: [
          Player(
            id: 'player1',
            name: 'Player 1',
            grid: PlayerGrid.empty(),
            actionCards: [actionCard],
          ),
          Player(
            id: 'player2',
            name: 'Player 2',
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
        createdAt: DateTime.now(),
      );

      final updatedGameState = gameState.copyWith(currentPlayerIndex: 0);

      final notifier = container.read(actionCardNotifierProvider.notifier);

      // Mock the use case to return success
      final useCase = container.read(useActionCardUseCaseProvider);
      when(
        () => mockRepository.getPlayerActionCards('player1'),
      ).thenReturn([actionCard]);
      when(
        () => mockRepository.removeActionCardFromPlayer('player1', actionCard),
      ).thenAnswer((_) {});
      when(
        () => mockRepository.discardActionCard(actionCard),
      ).thenAnswer((_) {});

      // Act
      final result = await notifier.useActionCard(
        playerId: 'player1',
        actionCard: actionCard,
        gameState: gameState,
        targetData: null,
      );

      // Assert
      expect(result.isRight(), isTrue);
    });
  });
}
