import '../models/player_model.dart';

abstract class PlayerDataSource {
  Future<PlayerModel> createPlayer({
    required String name,
    String? avatarUrl,
    String? currentRoomId,
  });

  Future<PlayerModel?> getPlayer(String playerId);

  Future<PlayerModel> updatePlayer(PlayerModel player);

  Future<void> deletePlayer(String playerId);

  Future<List<PlayerModel>> getPlayersByRoom(String roomId);

  Future<void> updateConnectionStatus({
    required String playerId,
    required String status,
  });

  Future<void> updateLastSeen(String playerId);

  Stream<PlayerModel> watchPlayer(String playerId);

  Stream<List<PlayerModel>> watchPlayersInRoom(String roomId);
}
