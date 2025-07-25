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
    // Simplified setup using a builder pattern
    GameState createTestGameState({
      String roomId = 'room123',
      List<String> playerIds = const ['player1', 'player2'],
      String creatorId = 'player1',
    }) {
      final players = playerIds
          .map(
            (id) => GamePlayer(
              id: id,
              name: 'Player $id',
              grid: PlayerGrid.empty(),
              isHost: id == creatorId,
            ),
          )
          .toList();

      return GameState(
        roomId: roomId,
        players: players,
        currentPlayerIndex: 0,
        deck: [],
        discardPile: [],
        actionDeck: [],
        actionDiscard: [],
        status: GameStatus.waitingToStart,
        turnDirection: TurnDirection.clockwise,
        lastRound: false,
      );
    }

    void mockRepositoryInitialize({
      String roomId = 'room123',
      List<String> playerIds = const ['player1', 'player2'],
      String creatorId = 'player1',
    }) {
      when(
        () => mockRepository.initializeGame(
          roomId: roomId,
          playerIds: playerIds,
          creatorId: creatorId,
        ),
      ).thenAnswer(
        (_) async => createTestGameState(
          roomId: roomId,
          playerIds: playerIds,
          creatorId: creatorId,
        ),
      );
    }

    test('should initialize game with correct setup', () async {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';
      const creatorId = 'player2'; // Different creator to test host assignment

      mockRepositoryInitialize(
        roomId: roomId,
        playerIds: playerIds,
        creatorId: creatorId,
      );

      // Act
      final result = await useCase.execute(
        playerIds: playerIds,
        roomId: roomId,
        creatorId: creatorId,
      );

      // Assert - Test multiple initialization aspects
      expect(
        result.players.length,
        equals(3),
        reason: 'Should create correct number of players',
      );
      expect(
        result.roomId,
        equals(roomId),
        reason: 'Should set correct room ID',
      );

      // Test host assignment
      expect(
        result.players[0].isHost,
        isFalse,
        reason: 'Player1 should not be host',
      );
      expect(
        result.players[1].isHost,
        isTrue,
        reason: 'Creator (Player2) should be host',
      );
      expect(
        result.players[2].isHost,
        isFalse,
        reason: 'Player3 should not be host',
      );

      verify(
        () => mockRepository.initializeGame(
          roomId: roomId,
          playerIds: playerIds,
          creatorId: creatorId,
        ),
      ).called(1);
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
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Cannot initialize game with no players'),
          ),
        ),
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
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Game requires 2-8 players'),
          ),
        ),
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
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Game requires 2-8 players'),
          ),
        ),
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
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Creator must be included in player list'),
          ),
        ),
      );
    });

    test('should handle repository exceptions gracefully', () async {
      // Arrange
      final playerIds = ['player1', 'player2'];
      const roomId = 'room123';
      const creatorId = 'player1';

      when(
        () => mockRepository.initializeGame(
          roomId: roomId,
          playerIds: playerIds,
          creatorId: creatorId,
        ),
      ).thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(
          playerIds: playerIds,
          roomId: roomId,
          creatorId: creatorId,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to initialize game'),
          ),
        ),
      );
    });

    test('should handle game state retrieval and streaming', () async {
      // Arrange
      const gameStateId = 'game123';
      final testState = createTestGameState();
      final gameStateStream = Stream.value(testState);

      when(
        () => mockRepository.getGameState(gameStateId),
      ).thenAnswer((_) async => testState);
      when(
        () => mockRepository.watchGameState(gameStateId),
      ).thenAnswer((_) => gameStateStream);

      // Act & Assert - Get game state
      final result = await useCase.getGameState(gameStateId);
      expect(result, equals(testState));

      // Act & Assert - Watch game state changes
      final stream = useCase.watchGameState(gameStateId);
      expect(stream, emits(testState));

      // Verify repository calls
      verify(() => mockRepository.getGameState(gameStateId)).called(1);
      verify(() => mockRepository.watchGameState(gameStateId)).called(1);
    });
  });
}
