import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/card.dart';

class MockGameStateRepository extends Mock implements GameStateRepository {}

void main() {
  group('GameStateRepository', () {
    late MockGameStateRepository mockRepository;
    late GameState mockGameState;
    late PlayerGrid mockPlayerGrid;

    setUp(() {
      mockRepository = MockGameStateRepository();
      
      mockPlayerGrid = PlayerGrid.fromCards(
        List.generate(12, (index) => const Card(value: 5)),
      );

      mockGameState = GameState(
        roomId: 'room123',
        players: [
          GamePlayer(
            id: 'player1',
            name: 'Player 1',
            grid: mockPlayerGrid,
          ),
          GamePlayer(
            id: 'player2', 
            name: 'Player 2',
            grid: mockPlayerGrid,
          ),
        ],
        currentPlayerIndex: 0,
        deck: const [Card(value: 5)],
        discardPile: const [Card(value: 3)],
        actionDeck: const [],
        actionDiscard: const [],
        status: GameStatus.playing,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );
    });

    group('initializeGame', () {
      test('should initialize a new game with given parameters', () async {
        when(() => mockRepository.initializeGame(
          roomId: 'room123',
          playerIds: ['player1', 'player2'],
          creatorId: 'player1',
        )).thenAnswer((_) async => mockGameState);

        final result = await mockRepository.initializeGame(
          roomId: 'room123',
          playerIds: ['player1', 'player2'],
          creatorId: 'player1',
        );

        expect(result, equals(mockGameState));
        expect(result.roomId, 'room123');
        expect(result.players.length, 2);
        verify(() => mockRepository.initializeGame(
          roomId: 'room123',
          playerIds: ['player1', 'player2'],
          creatorId: 'player1',
        )).called(1);
      });
    });

    group('getGameState', () {
      test('should return game state when it exists', () async {
        when(() => mockRepository.getGameState('game123'))
            .thenAnswer((_) async => mockGameState);

        final result = await mockRepository.getGameState('game123');

        expect(result, equals(mockGameState));
        expect(result?.roomId, 'room123');
        verify(() => mockRepository.getGameState('game123')).called(1);
      });

      test('should return null when game state does not exist', () async {
        when(() => mockRepository.getGameState('nonexistent'))
            .thenAnswer((_) async => null);

        final result = await mockRepository.getGameState('nonexistent');

        expect(result, isNull);
        verify(() => mockRepository.getGameState('nonexistent')).called(1);
      });
    });

    group('watchGameState', () {
      test('should emit game state updates', () async {
        final gameStateStream = Stream.value(mockGameState);
        when(() => mockRepository.watchGameState('game123'))
            .thenAnswer((_) => gameStateStream);

        final result = mockRepository.watchGameState('game123');

        await expectLater(result, emits(mockGameState));
        verify(() => mockRepository.watchGameState('game123')).called(1);
      });
    });

    group('getPlayerGrid', () {
      test('should return player grid when it exists', () async {
        when(() => mockRepository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'player1',
        )).thenAnswer((_) async => mockPlayerGrid);

        final result = await mockRepository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'player1',
        );

        expect(result, equals(mockPlayerGrid));
        expect(result?.totalScore, 60); // 12 cards * 5 value each
        verify(() => mockRepository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'player1',
        )).called(1);
      });

      test('should return null when player grid does not exist', () async {
        when(() => mockRepository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'nonexistent',
        )).thenAnswer((_) async => null);

        final result = await mockRepository.getPlayerGrid(
          gameStateId: 'game123',
          playerId: 'nonexistent',
        );

        expect(result, isNull);
      });
    });

    group('watchPlayerGrid', () {
      test('should emit player grid updates', () async {
        final gridStream = Stream.value(mockPlayerGrid);
        when(() => mockRepository.watchPlayerGrid(
          gameStateId: 'game123',
          playerId: 'player1',
        )).thenAnswer((_) => gridStream);

        final result = mockRepository.watchPlayerGrid(
          gameStateId: 'game123',
          playerId: 'player1',
        );

        await expectLater(result, emits(mockPlayerGrid));
      });
    });

    group('revealCard', () {
      test('should return success response when card is revealed', () async {
        final response = {'success': true, 'revealed_value': 5};
        when(() => mockRepository.revealCard(
          gameStateId: 'game123',
          playerId: 'player1',
          position: 0,
        )).thenAnswer((_) async => response);

        final result = await mockRepository.revealCard(
          gameStateId: 'game123',
          playerId: 'player1',
          position: 0,
        );

        expect(result, equals(response));
        expect(result['success'], isTrue);
        expect(result['revealed_value'], 5);
      });
    });

    group('useActionCard', () {
      test('should use action card successfully', () async {
        final response = {'success': true, 'action': 'card_used'};
        when(() => mockRepository.useActionCard(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.swap,
          targetData: {'target': 'player2'},
        )).thenAnswer((_) async => response);

        final result = await mockRepository.useActionCard(
          gameStateId: 'game123',
          playerId: 'player1',
          actionCardType: ActionCardType.swap,
          targetData: {'target': 'player2'},
        );

        expect(result, equals(response));
        expect(result['success'], isTrue);
      });
    });

    group('advanceTurn', () {
      test('should advance turn successfully', () async {
        final response = {
          'success': true,
          'new_current_player': 'player2',
        };
        when(() => mockRepository.advanceTurn(gameStateId: 'game123'))
            .thenAnswer((_) async => response);

        final result = await mockRepository.advanceTurn(gameStateId: 'game123');

        expect(result, equals(response));
        expect(result['new_current_player'], 'player2');
      });
    });

    group('checkEndGameConditions', () {
      test('should check end game conditions', () async {
        final response = {
          'game_ended': false,
          'winner': null,
        };
        when(() => mockRepository.checkEndGameConditions(gameStateId: 'game123'))
            .thenAnswer((_) async => response);

        final result = await mockRepository.checkEndGameConditions(
          gameStateId: 'game123',
        );

        expect(result['game_ended'], isFalse);
        expect(result['winner'], isNull);
      });
    });

    group('getAllPlayerGrids', () {
      test('should return all player grids', () async {
        final grids = [mockPlayerGrid, mockPlayerGrid];
        when(() => mockRepository.getAllPlayerGrids('game123'))
            .thenAnswer((_) async => grids);

        final result = await mockRepository.getAllPlayerGrids('game123');

        expect(result.length, 2);
        expect(result.every((grid) => grid.totalScore == 60), isTrue);
      });
    });

    group('getGameActions', () {
      test('should return game actions with limit', () async {
        final actions = [
          {'action': 'reveal_card', 'player': 'player1'},
          {'action': 'use_action_card', 'player': 'player2'},
        ];
        when(() => mockRepository.getGameActions(
          gameStateId: 'game123',
          limit: 10,
        )).thenAnswer((_) async => actions);

        final result = await mockRepository.getGameActions(
          gameStateId: 'game123',
          limit: 10,
        );

        expect(result.length, 2);
        expect(result[0]['action'], 'reveal_card');
        expect(result[1]['action'], 'use_action_card');
      });
    });

    group('watchGameActions', () {
      test('should emit game action updates', () async {
        final action = {'action': 'reveal_card', 'player': 'player1'};
        final actionStream = Stream.value(action);
        when(() => mockRepository.watchGameActions('game123'))
            .thenAnswer((_) => actionStream);

        final result = mockRepository.watchGameActions('game123');

        await expectLater(result, emits(action));
      });
    });
  });
}