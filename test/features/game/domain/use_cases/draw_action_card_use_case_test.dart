import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/core/utils/constants.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
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
    test(
      'should enable strategic action card acquisition and constraint management for enhanced competitive gameplay',
      () async {
        // Test behavior: Action card drawing system enables strategic gameplay with proper constraints
        // and validates game state conditions to maintain competitive balance

        final strategicActionCards = [
          const ActionCard(
            id: 'turnaround-master',
            type: ActionCardType.turnAround,
            name: 'Demi-tour',
            description: 'Inversez le sens du jeu',
            timing: ActionTiming.immediate,
            target: ActionTarget.none,
          ),
          const ActionCard(
            id: 'skip-tactical',
            type: ActionCardType.skip,
            name: 'Skip',
            description: 'Skip next player',
            timing: ActionTiming.optional,
            target: ActionTarget.none,
          ),
          const ActionCard(
            id: 'freeze-strategic',
            type: ActionCardType.freeze,
            name: 'Freeze',
            description: 'Freeze opponent grid',
            timing: ActionTiming.optional,
            target: ActionTarget.singleOpponent,
          ),
        ];

        // Scenario 1: Valid draw with space in hand
        final competitiveGrid = PlayerGrid.fromCards(
          List.generate(
            12,
            (i) => game_card.Card(value: i % 13 - 2, isRevealed: i < 2),
          ),
        );

        final strategicPlayer = GamePlayer(
          id: 'strategic-player-123',
          name: 'Tournament Champion',
          grid: competitiveGrid,
          actionCards: [
            strategicActionCards[0],
          ], // 1 card in hand, space for 2 more
        );

        final competitiveGameState = GameState(
          roomId: 'tournament-room-456',
          players: [
            strategicPlayer,
            GamePlayer(
              id: 'opponent-789',
              name: 'Challenger',
              grid: PlayerGrid.empty(),
              actionCards: [],
            ),
          ],
          currentPlayerIndex: 0,
          deck: List.generate(
            50,
            (i) => game_card.Card(value: i % 13 - 2, isRevealed: false),
          ),
          discardPile: [const game_card.Card(value: 5, isRevealed: true)],
          actionDeck: strategicActionCards.sublist(1),
          actionDiscard: [],
          status: GameStatus.playing,
          turnDirection: TurnDirection.clockwise,
          lastRound: false,
          drawnCard: null, // No card drawn yet this turn
        );

        when(
          () => mockRepository.drawActionCard(),
        ).thenAnswer((_) async => strategicActionCards[1]);
        when(
          () => mockRepository.addActionCardToPlayer(
            'strategic-player-123',
            strategicActionCards[1],
          ),
        ).thenAnswer((_) async {});

        // Act: Strategic draw
        final validDrawResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: competitiveGameState,
          ),
        );

        // Assert: Successful strategic acquisition
        expect(validDrawResult.isRight(), true);
        validDrawResult.fold((failure) => fail('Should allow valid draw'), (
          updatedState,
        ) {
          final updatedPlayer = updatedState.players.first;
          expect(
            updatedPlayer.actionCards.length,
            2,
            reason: 'Should have acquired new card',
          );
          expect(
            updatedPlayer.actionCards.any((card) => card.id == 'skip-tactical'),
            true,
          );
        });

        // Scenario 2: Constraint validation - hand full
        final fullHandState = competitiveGameState.copyWith(
          players: [
            strategicPlayer.copyWith(
              actionCards: List.generate(
                kMaxActionCardsInHand,
                (i) => ActionCard(
                  id: 'card-$i',
                  type: ActionCardType.values[i % ActionCardType.values.length],
                  name: 'Action $i',
                  description: 'Strategic action',
                  timing: ActionTiming.optional,
                  target: ActionTarget.none,
                ),
              ),
            ),
            competitiveGameState.players[1],
          ],
        );

        final fullHandResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: fullHandState,
          ),
        );

        expect(fullHandResult.isLeft(), true);
        fullHandResult.fold(
          (failure) => expect(failure.message, contains('cannot draw more')),
          (_) => fail('Should prevent drawing with full hand'),
        );

        // Scenario 3: Turn validation
        final wrongTurnState = competitiveGameState.copyWith(
          currentPlayerIndex: 1, // Other player's turn
        );

        final wrongTurnResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: wrongTurnState,
          ),
        );

        expect(wrongTurnResult.isLeft(), true);
        wrongTurnResult.fold(
          (failure) => expect(failure.message, contains('not your turn')),
          (_) => fail('Should enforce turn order'),
        );

        // Scenario 4: Already drew card this turn
        final alreadyDrewState = competitiveGameState.copyWith(
          drawnCard: const game_card.Card(value: 7, isRevealed: true),
        );

        final alreadyDrewResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: alreadyDrewState,
          ),
        );

        expect(alreadyDrewResult.isLeft(), true);
        alreadyDrewResult.fold(
          (failure) => expect(failure.message, contains('already drawn')),
          (_) => fail('Should enforce one draw per turn'),
        );

        // Scenario 5: Game state validation
        final notPlayingState = competitiveGameState.copyWith(
          status: GameStatus.waitingToStart,
        );

        final notPlayingResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: notPlayingState,
          ),
        );

        expect(notPlayingResult.isLeft(), true);
        notPlayingResult.fold(
          (failure) => expect(failure.message, contains('not in progress')),
          (_) => fail('Should only allow draws during active game'),
        );

        // Scenario 6: Empty action deck
        when(
          () => mockRepository.drawActionCard(),
        ).thenAnswer((_) async => null);

        final emptyDeckResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: competitiveGameState,
          ),
        );

        expect(emptyDeckResult.isLeft(), true);
        emptyDeckResult.fold(
          (failure) =>
              expect(failure.message, contains('No action cards available')),
          (_) => fail('Should handle empty deck gracefully'),
        );

        // Scenario 7: Immediate action cards are added for later processing
        final immediateCard = const ActionCard(
          id: 'immediate-turnaround',
          type: ActionCardType.turnAround,
          name: 'Demi-tour',
          description: 'Immediate direction change',
          timing: ActionTiming.immediate,
          target: ActionTarget.none,
        );

        when(
          () => mockRepository.drawActionCard(),
        ).thenAnswer((_) async => immediateCard);
        when(
          () => mockRepository.addActionCardToPlayer(
            'strategic-player-123',
            immediateCard,
          ),
        ).thenAnswer((_) async {});

        final immediateResult = await useCase(
          DrawActionCardParams(
            playerId: 'strategic-player-123',
            gameState: competitiveGameState,
          ),
        );

        expect(immediateResult.isRight(), true);
        immediateResult.fold(
          (failure) => fail('Should handle immediate cards'),
          (updatedState) {
            final updatedPlayer = updatedState.players.first;
            expect(
              updatedPlayer.actionCards.any(
                (card) => card.timing == ActionTiming.immediate,
              ),
              true,
            );
            // Actual immediate effect processing happens in separate game flow
          },
        );
      },
    );
  });
}
