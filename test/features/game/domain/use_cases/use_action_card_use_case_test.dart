import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/card.dart' as game;
import 'package:ojyx/features/game/domain/repositories/action_card_repository.dart';
import 'package:ojyx/features/game/domain/use_cases/use_action_card_use_case.dart';
import 'package:ojyx/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class MockActionCardRepository extends Mock implements ActionCardRepository {}

class FakeActionCard extends Fake implements ActionCard {}

void main() {
  late UseActionCardUseCase useCase;
  late MockActionCardRepository mockRepository;
  
  setUpAll(() {
    registerFallbackValue(FakeActionCard());
  });
  
  setUp(() {
    mockRepository = MockActionCardRepository();
    useCase = UseActionCardUseCase(mockRepository);
  });
  
  GameState createTestGameState({
    int currentPlayerIndex = 0,
    TurnDirection turnDirection = TurnDirection.clockwise,
    bool lastRound = false,
  }) {
    final players = [
      Player(
        id: 'player1',
        name: 'Player 1',
        grid: PlayerGrid.empty(),
        actionCards: [],
        hasFinishedRound: false,
      ),
      Player(
        id: 'player2',
        name: 'Player 2',
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
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.skip,
        name: 'Saut',
        description: 'Sautez le tour du prochain joueur',
        timing: ActionTiming.optional,
        target: ActionTarget.none,
      );
      
      final gameState = createTestGameState();
      final params = UseActionCardParams(
        playerId: 'player1',
        actionCard: actionCard,
        gameState: gameState,
        targetData: null,
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([actionCard]);
      when(() => mockRepository.removeActionCardFromPlayer('player1', actionCard))
          .thenAnswer((_) {});
      when(() => mockRepository.discardActionCard(actionCard))
          .thenAnswer((_) {});
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (updatedState) {
          expect(updatedState, isNotNull);
          verify(() => mockRepository.removeActionCardFromPlayer('player1', actionCard)).called(1);
          verify(() => mockRepository.discardActionCard(actionCard)).called(1);
        },
      );
    });
    
    test('should fail if player does not have the action card', () async {
      // Arrange
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      
      final gameState = createTestGameState();
      final params = UseActionCardParams(
        playerId: 'player1',
        actionCard: actionCard,
        gameState: gameState,
        targetData: null,
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([]); // Player has no cards
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('does not have this action card'));
        },
        (_) => fail('Should not succeed'),
      );
    });
    
    test('should use mandatory action card immediately', () async {
      // Arrange
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.turnAround,
        name: 'Demi-tour',
        description: 'Inversez le sens du jeu',
        timing: ActionTiming.immediate,
        target: ActionTarget.none,
      );
      
      final gameState = createTestGameState();
      final params = UseActionCardParams(
        playerId: 'player1',
        actionCard: actionCard,
        gameState: gameState,
        targetData: null,
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([actionCard]);
      when(() => mockRepository.removeActionCardFromPlayer('player1', actionCard))
          .thenAnswer((_) {});
      when(() => mockRepository.discardActionCard(actionCard))
          .thenAnswer((_) {});
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (updatedState) {
          // For Demi-tour, the direction should be reversed
          expect(updatedState.turnDirection, 
                 equals(gameState.turnDirection == TurnDirection.clockwise 
                        ? TurnDirection.counterClockwise 
                        : TurnDirection.clockwise));
        },
      );
    });
    
    test('should validate target data for cards that require it', () async {
      // Arrange
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      
      final gameState = createTestGameState();
      final params = UseActionCardParams(
        playerId: 'player1',
        actionCard: actionCard,
        gameState: gameState,
        targetData: null, // Missing required target data
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([actionCard]);
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.message, contains('requires target data'));
        },
        (_) => fail('Should not succeed'),
      );
    });
    
    test('should handle teleportation action card with valid targets', () async {
      // Arrange
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      
      // Grid layout (3 rows x 4 columns):
      // Row 0: [5, 10, 3, 7]
      // Row 1: [2, 8, 4, 9]  
      // Row 2: [1, 6, 11, 12]
      final grid = PlayerGrid.fromCards([
        const game.Card(value: 5, isRevealed: true),   // (0,0)
        const game.Card(value: 10, isRevealed: false), // (0,1)
        const game.Card(value: 3, isRevealed: true),   // (0,2)
        const game.Card(value: 7, isRevealed: false),  // (0,3)
        const game.Card(value: 2, isRevealed: true),   // (1,0)
        const game.Card(value: 8, isRevealed: false),  // (1,1)
        const game.Card(value: 4, isRevealed: true),   // (1,2)
        const game.Card(value: 9, isRevealed: false),  // (1,3)
        const game.Card(value: 1, isRevealed: true),   // (2,0)
        const game.Card(value: 6, isRevealed: false),  // (2,1)
        const game.Card(value: 11, isRevealed: true),  // (2,2)
        const game.Card(value: 12, isRevealed: false), // (2,3)
      ]);
      
      final gameState = GameState(
        roomId: 'test-room',
        players: [
          Player(
            id: 'player1',
            name: 'Player 1',
            grid: grid,
            actionCards: [actionCard],
            hasFinishedRound: false,
          ),
          Player(
            id: 'player2',
            name: 'Player 2',
            grid: PlayerGrid.empty(),
            actionCards: [],
            hasFinishedRound: false,
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
      
      final targetData = {
        'position1': {'row': 0, 'col': 0},
        'position2': {'row': 1, 'col': 1},
      };
      
      final params = UseActionCardParams(
        playerId: 'player1',
        actionCard: actionCard,
        gameState: gameState,
        targetData: targetData,
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([actionCard]);
      when(() => mockRepository.removeActionCardFromPlayer('player1', actionCard))
          .thenAnswer((_) {});
      when(() => mockRepository.discardActionCard(actionCard))
          .thenAnswer((_) {});
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should not fail'),
        (updatedState) {
          // Verify cards were swapped
          // (0,0) had 5, (1,1) had 8, after swap:
          final updatedGrid = updatedState.players[0].grid;
          expect(updatedGrid.getCard(0, 0)?.value, equals(8)); // Was 5, now 8
          expect(updatedGrid.getCard(1, 1)?.value, equals(5)); // Was 8, now 5
        },
      );
    });
    
    test('should not allow using action card when not player turn', () async {
      // Arrange
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.teleport,
        name: 'Téléportation',
        description: 'Échangez deux cartes',
        timing: ActionTiming.optional,
        target: ActionTarget.self,
      );
      
      final gameState = createTestGameState(currentPlayerIndex: 1); // Player 2's turn
      final params = UseActionCardParams(
        playerId: 'player1', // Player 1 trying to play
        actionCard: actionCard,
        gameState: gameState,
        targetData: null,
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([actionCard]);
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<GameLogicFailure>());
          expect(failure.message, contains('not your turn'));
        },
        (_) => fail('Should not succeed'),
      );
    });
    
    test('should allow reaction cards outside of turn', () async {
      // Arrange
      final actionCard = const ActionCard(
        id: 'card1',
        type: ActionCardType.shield,
        name: 'Bouclier',
        description: 'Protégez-vous des attaques',
        timing: ActionTiming.reactive,
        target: ActionTarget.self,
      );
      
      final gameState = createTestGameState(currentPlayerIndex: 1); // Player 2's turn
      final params = UseActionCardParams(
        playerId: 'player1', // Player 1 can play reaction
        actionCard: actionCard,
        gameState: gameState,
        targetData: null,
      );
      
      when(() => mockRepository.getPlayerActionCards('player1'))
          .thenReturn([actionCard]);
      when(() => mockRepository.removeActionCardFromPlayer('player1', actionCard))
          .thenAnswer((_) {});
      when(() => mockRepository.discardActionCard(actionCard))
          .thenAnswer((_) {});
      
      // Act
      final result = await useCase(params);
      
      // Assert
      expect(result.isRight(), isTrue);
    });
  });
}