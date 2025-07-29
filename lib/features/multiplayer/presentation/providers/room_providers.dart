import 'package:riverpod_annotation/riverpod_annotation.dart';

// Export du controller realtime
export 'room_realtime_controller.dart';
export 'game_sync_controller.dart';

import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource.dart';
import 'package:ojyx/features/multiplayer/data/datasources/supabase_room_datasource_impl.dart';
import 'package:ojyx/features/multiplayer/data/repositories/room_repository_impl.dart';
import 'package:ojyx/features/multiplayer/data/services/room_heartbeat_service.dart';
import 'package:ojyx/features/multiplayer/data/services/connection_monitor_service.dart';
import 'package:ojyx/features/multiplayer/data/services/room_realtime_service.dart';
import 'package:ojyx/features/multiplayer/domain/datasources/room_datasource.dart';
import 'package:ojyx/core/config/router_config.dart';
import 'package:ojyx/features/multiplayer/domain/repositories/room_repository.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/create_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/join_room_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room.dart';
import 'package:ojyx/features/multiplayer/domain/entities/room_event.dart';
import 'package:ojyx/features/game/presentation/providers/game_state_notifier.dart';
import 'package:ojyx/features/game/presentation/providers/repository_providers.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';

part 'room_providers.g.dart';

@riverpod
SupabaseRoomDatasource supabaseRoomDatasource(SupabaseRoomDatasourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseRoomDatasource(supabase);
}

@riverpod
RoomDatasource roomDatasource(RoomDatasourceRef ref) {
  final supabaseDatasource = ref.watch(supabaseRoomDatasourceProvider);
  return SupabaseRoomDatasourceImpl(supabaseDatasource);
}

@riverpod
RoomRepository roomRepository(RoomRepositoryRef ref) {
  final datasource = ref.watch(roomDatasourceProvider);
  final gameInitializationUseCase = ref.watch(
    gameInitializationUseCaseProvider,
  );
  return RoomRepositoryImpl(datasource, gameInitializationUseCase);
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
  final gameStateRepository = ref.watch(gameStateRepositoryProvider);
  return SyncGameStateUseCase(gameStateRepository);
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
@riverpod
String? currentRoomId(CurrentRoomIdRef ref) => null;

// Provider pour le service de heartbeat
@riverpod
RoomHeartbeatService roomHeartbeatService(RoomHeartbeatServiceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final service = RoomHeartbeatService(supabase);
  
  // Dispose the service when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
}

// Provider pour gérer l'état du heartbeat de la room actuelle
@riverpod
class RoomHeartbeatController extends _$RoomHeartbeatController {
  late final RoomHeartbeatService _heartbeatService;
  
  @override
  bool build() {
    _heartbeatService = ref.watch(roomHeartbeatServiceProvider);
    return false; // Not active by default
  }
  
  void startHeartbeat(String roomId) {
    _heartbeatService.startHeartbeat(roomId);
    state = true;
  }
  
  void stopHeartbeat() {
    _heartbeatService.stopHeartbeat();
    state = false;
  }
  
  void pauseHeartbeat() {
    _heartbeatService.pauseHeartbeat();
  }
  
  void resumeHeartbeat() {
    _heartbeatService.resumeHeartbeat();
  }
}

// Provider pour le service de monitoring de connexion
@riverpod
ConnectionMonitorService connectionMonitorService(ConnectionMonitorServiceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final router = ref.watch(routerProvider);
  
  final service = ConnectionMonitorService(
    supabase: supabase,
    router: router,
  );
  
  // Start monitoring when service is created
  service.startMonitoring();
  
  // Stop monitoring when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
}
