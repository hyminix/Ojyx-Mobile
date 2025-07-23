import 'package:mocktail/mocktail.dart';
import 'package:ojyx/features/multiplayer/domain/datasources/room_datasource.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/domain/entities/game_state.dart';

class MockRoomDatasource extends Mock implements RoomDatasource {}

// Helper function to register fallback values for mocktail
void registerRoomFallbackValues() {
  registerFallbackValue(
    Room(
      id: 'test-id',
      creatorId: 'test-creator',
      playerIds: ['test-creator'],
      status: RoomStatus.waiting,
      maxPlayers: 4,
      createdAt: DateTime.now(),
    ),
  );

  registerFallbackValue(
    const RoomEvent.playerJoined(
      playerId: 'test-player',
      playerName: 'Test Player',
    ),
  );

  registerFallbackValue(
    GameState(
      roomId: 'test-room',
      players: [],
      currentPlayerIndex: 0,
      deck: [],
      discardPile: [],
      actionDeck: [],
      actionDiscard: [],
      status: GameStatus.playing,
      turnDirection: TurnDirection.clockwise,
      lastRound: false,
      drawnCard: null,
      createdAt: DateTime.now(),
    ),
  );
}
