import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/game/domain/use_cases/game_initialization_use_case.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';
import 'package:ojyx/features/game/domain/entities/player_grid.dart';
import 'package:ojyx/features/game/domain/repositories/game_state_repository.dart';

class MockGameStateRepository extends Mock implements GameStateRepository {}

void main() {
  late GameInitializationUseCase useCase;
  late MockGameStateRepository mockRepository;

  setUp(() {
    mockRepository = MockGameStateRepository();
    useCase = GameInitializationUseCase(mockRepository);
  });

  group('GameInitializationUseCase', () {
    final testPlayers = [
      GamePlayer(
        id: 'player1',
        name: 'Player 1',
        grid: PlayerGrid.empty(),
        isHost: true,
      ),
      GamePlayer(
        id: 'player2',
        name: 'Player 2',
        grid: PlayerGrid.empty(),
        isHost: false,
      ),
    ];

    final testGameState = GameState(
      roomId: 'room123',
      players: testPlayers,
      currentPlayerIndex: 0,
      deck: [],
      discardPile: [],
      actionDeck: [],
      actionDiscard: [],
      status: GameStatus.waitingToStart,
      turnDirection: TurnDirection.clockwise,
      lastRound: false,
    );

    test('should initialize game with correct number of players', () async {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';
      const creatorId = 'player1';

      when(() => mockRepository.initializeGame(
        roomId: roomId,
        playerIds: playerIds,
        creatorId: creatorId,
      )).thenAnswer((_) async => testGameState.copyWith(
        players: playerIds.map((id) => GamePlayer(
          id: id,
          name: 'Player $id',
          grid: PlayerGrid.empty(),
          isHost: id == creatorId,
        )).toList(),
      ));

      // Act
      final result = await useCase.execute(
        playerIds: playerIds,
        roomId: roomId,
        creatorId: creatorId,
      );

      // Assert
      expect(result.players.length, equals(3));
      expect(result.roomId, equals(roomId));
      verify(() => mockRepository.initializeGame(
        roomId: roomId,
        playerIds: playerIds,
        creatorId: creatorId,
      )).called(1);
    });

    test('should set creator as host', () async {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';
      const creatorId = 'player2';

      final expectedGameState = testGameState.copyWith(
        players: playerIds.map((id) => GamePlayer(
          id: id,
          name: 'Player $id',
          grid: PlayerGrid.empty(),
          isHost: id == creatorId,
        )).toList(),
      );

      when(() => mockRepository.initializeGame(
        roomId: roomId,
        playerIds: playerIds,
        creatorId: creatorId,
      )).thenAnswer((_) async => expectedGameState);

      // Act
      final result = await useCase.execute(
        playerIds: playerIds,
        roomId: roomId,
        creatorId: creatorId,
      );

      // Assert
      expect(result.players[0].isHost, isFalse);
      expect(result.players[1].isHost, isTrue);
      expect(result.players[2].isHost, isFalse);
    });

    test('should throw exception when no players provided', () async {
      // Arrange
      final playerIds = <String>[];
      const roomId = 'room123';
      const creatorId = 'player1';

      // Act & Assert
      expect(
        () => useCase.execute(
          playerIds: playerIds,
          roomId: roomId,
          creatorId: creatorId,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Cannot initialize game with no players'),
        )),
      );
    });

    test('should throw exception when less than 2 players', () async {
      // Arrange
      final playerIds = ['player1'];
      const roomId = 'room123';
      const creatorId = 'player1';

      // Act & Assert
      expect(
        () => useCase.execute(
          playerIds: playerIds,
          roomId: roomId,
          creatorId: creatorId,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Game requires 2-8 players'),
        )),
      );
    });

    test('should throw exception when more than 8 players', () async {
      // Arrange
      final playerIds = List.generate(9, (i) => 'player${i + 1}');
      const roomId = 'room123';
      const creatorId = 'player1';

      // Act & Assert
      expect(
        () => useCase.execute(
          playerIds: playerIds,
          roomId: roomId,
          creatorId: creatorId,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Game requires 2-8 players'),
        )),
      );
    });

    test('should throw exception when creator not in player list', () async {
      // Arrange
      final playerIds = ['player1', 'player2'];
      const roomId = 'room123';
      const creatorId = 'player3'; // Not in playerIds

      // Act & Assert
      expect(
        () => useCase.execute(
          playerIds: playerIds,
          roomId: roomId,
          creatorId: creatorId,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Creator must be included in player list'),
        )),
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Arrange
      final playerIds = ['player1', 'player2'];
      const roomId = 'room123';
      const creatorId = 'player1';

      when(() => mockRepository.initializeGame(
        roomId: roomId,
        playerIds: playerIds,
        creatorId: creatorId,
      )).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(
          playerIds: playerIds,
          roomId: roomId,
          creatorId: creatorId,
        ),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to initialize game'),
        )),
      );
    });

    test('should get game state', () async {
      // Arrange
      const gameStateId = 'game123';

      when(() => mockRepository.getGameState(gameStateId))
          .thenAnswer((_) async => testGameState);

      // Act
      final result = await useCase.getGameState(gameStateId);

      // Assert
      expect(result, equals(testGameState));
      verify(() => mockRepository.getGameState(gameStateId)).called(1);
    });

    test('should watch game state changes', () async {
      // Arrange
      const gameStateId = 'game123';
      final gameStateStream = Stream.value(testGameState);

      when(() => mockRepository.watchGameState(gameStateId))
          .thenAnswer((_) => gameStateStream);

      // Act
      final stream = useCase.watchGameState(gameStateId);

      // Assert
      expect(stream, emits(testGameState));
      verify(() => mockRepository.watchGameState(gameStateId)).called(1);
    });
  });
}