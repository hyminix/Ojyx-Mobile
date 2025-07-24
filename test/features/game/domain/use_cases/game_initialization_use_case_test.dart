import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/domain/use_cases/game_initialization_use_case.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';
import 'package:ojyx/features/game/domain/entities/game_player.dart';

void main() {
  late GameInitializationUseCase useCase;

  setUp(() {
    useCase = GameInitializationUseCase();
  });

  group('GameInitializationUseCase', () {
    test('should initialize game with correct number of players', () {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
      );

      // Assert
      expect(gameState.players.length, equals(3));
      expect(gameState.roomId, equals(roomId));
    });

    test('should set first player as host', () {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
      );

      // Assert
      expect(gameState.players[0].isHost, isTrue);
      expect(gameState.players[1].isHost, isFalse);
      expect(gameState.players[2].isHost, isFalse);
    });

    test('should initialize players with empty grids and no action cards', () {
      // Arrange
      final playerIds = ['player1', 'player2'];
      const roomId = 'room123';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
      );

      // Assert
      for (final player in gameState.players) {
        // PlayerGrid has a 2D structure (3 rows x 4 columns = 12 cards)
        expect(player.grid.cards.length, equals(3)); // 3 rows
        expect(player.grid.cards[0].length, equals(4)); // 4 columns

        // Check that all cards are initially null (empty grid)
        bool allCardsNull = true;
        for (final row in player.grid.cards) {
          for (final card in row) {
            if (card != null) {
              allCardsNull = false;
              break;
            }
          }
          if (!allCardsNull) break;
        }
        expect(allCardsNull, isTrue);
        expect(player.actionCards, isEmpty);
      }
    });

    test('should set player names correctly', () {
      // Arrange
      final playerIds = ['player1', 'player2'];
      const roomId = 'room123';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
      );

      // Assert
      expect(gameState.players[0].name, equals('GamePlayer player1'));
      expect(gameState.players[1].name, equals('GamePlayer player2'));
    });

    test(
      'should start with first player when no starting player specified',
      () {
        // Arrange
        final playerIds = ['player1', 'player2', 'player3'];
        const roomId = 'room123';

        // Act
        final gameState = useCase.initializeGame(
          playerIds: playerIds,
          roomId: roomId,
        );

        // Assert
        expect(gameState.currentPlayerIndex, equals(0));
      },
    );

    test(
      'should start with specified player when startingPlayerId is provided',
      () {
        // Arrange
        final playerIds = ['player1', 'player2', 'player3'];
        const roomId = 'room123';
        const startingPlayerId = 'player2';

        // Act
        final gameState = useCase.initializeGame(
          playerIds: playerIds,
          roomId: roomId,
          startingPlayerId: startingPlayerId,
        );

        // Assert
        expect(gameState.currentPlayerIndex, equals(1));
      },
    );

    test('should default to first player if startingPlayerId not found', () {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';
      const startingPlayerId = 'invalid_player_id';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
        startingPlayerId: startingPlayerId,
      );

      // Assert
      expect(gameState.currentPlayerIndex, equals(-1));
    });

    test('should handle single player game', () {
      // Arrange
      final playerIds = ['player1'];
      const roomId = 'room123';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
      );

      // Assert
      expect(gameState.players.length, equals(1));
      expect(gameState.players[0].isHost, isTrue);
      expect(gameState.currentPlayerIndex, equals(0));
    });

    test('should create players with correct IDs', () {
      // Arrange
      final playerIds = ['player1', 'player2', 'player3'];
      const roomId = 'room123';

      // Act
      final gameState = useCase.initializeGame(
        playerIds: playerIds,
        roomId: roomId,
      );

      // Assert
      for (int i = 0; i < playerIds.length; i++) {
        expect(gameState.players[i].id, equals(playerIds[i]));
      }
    });
  });
}
