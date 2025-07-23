import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/supabase_room_datasource.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/use_cases/create_room_use_case.dart';
import '../../domain/use_cases/join_room_use_case.dart';
import '../../domain/use_cases/sync_game_state_use_case.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/room_event.dart';
import '../../../../core/providers/supabase_provider.dart';

part 'room_providers.g.dart';

@riverpod
SupabaseRoomDatasource supabaseRoomDatasource(SupabaseRoomDatasourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseRoomDatasource(supabase);
}

@riverpod
RoomRepository roomRepository(RoomRepositoryRef ref) {
  final datasource = ref.watch(supabaseRoomDatasourceProvider);
  return RoomRepositoryImpl(datasource);
}

@riverpod
CreateRoomUseCase createRoomUseCase(CreateRoomUseCaseRef ref) {
  final repository = ref.watch(roomRepositoryProvider);
  return CreateRoomUseCase(repository);
}

@riverpod
JoinRoomUseCase joinRoomUseCase(JoinRoomUseCaseRef ref) {
  final repository = ref.watch(roomRepositoryProvider);
  return JoinRoomUseCase(repository);
}

@riverpod
SyncGameStateUseCase syncGameStateUseCase(SyncGameStateUseCaseRef ref) {
  final repository = ref.watch(roomRepositoryProvider);
  return SyncGameStateUseCase(repository);
}

@riverpod
Stream<Room> currentRoom(CurrentRoomRef ref, String roomId) {
  final repository = ref.watch(roomRepositoryProvider);
  return repository.watchRoom(roomId);
}

@riverpod
Stream<RoomEvent> roomEvents(RoomEventsRef ref, String roomId) {
  final repository = ref.watch(roomRepositoryProvider);
  return repository.watchRoomEvents(roomId);
}

@riverpod
Future<List<Room>> availableRooms(AvailableRoomsRef ref) async {
  final repository = ref.watch(roomRepositoryProvider);
  return await repository.getAvailableRooms();
}

// Provider pour stocker l'ID de la room courante
final currentRoomIdProvider = Provider<String?>((ref) => null);