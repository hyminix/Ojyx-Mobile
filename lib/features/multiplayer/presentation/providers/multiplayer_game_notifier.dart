import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';

import '../../../game/domain/entities/action_card.dart';
import '../../../game/presentation/providers/game_state_notifier.dart';
import '../../domain/entities/room_event.dart';
import '../../domain/use_cases/sync_game_state_use_case.dart';
import '../../domain/repositories/room_repository.dart';
import 'room_providers.dart';

part 'multiplayer_game_notifier.g.dart';

@riverpod
class MultiplayerGameNotifier extends _$MultiplayerGameNotifier {
  late SyncGameStateUseCase _syncUseCase;
  late RoomRepository _roomRepository;
  StreamSubscription<RoomEvent>? _eventSubscription;
  String? _roomId;

  @override
  Future<void> build(String roomId) async {
    _roomId = roomId;
    _syncUseCase = ref.read(syncGameStateUseCaseProvider);
    _roomRepository = ref.read(roomRepositoryProvider);

    ref.onDispose(() {
      _eventSubscription?.cancel();
    });

    _listenToRoomEvents(roomId);
  }

  void _listenToRoomEvents(String roomId) {
    _eventSubscription = _roomRepository.watchRoomEvents(roomId).listen((
      event,
    ) {
      event.when(
        playerJoined: (playerId, playerName) {
          // Géré par le provider de room
        },
        playerLeft: (playerId) {
          // Géré par le provider de room
        },
        gameStarted: (gameId, initialState) {
          ref.read(gameStateNotifierProvider.notifier).loadState(initialState);
        },
        gameStateUpdated: (newState) {
          ref.read(gameStateNotifierProvider.notifier).loadState(newState);
        },
        playerAction: (playerId, actionType, actionData) {
          _handlePlayerAction(playerId, actionType, actionData);
        },
      );
    });
  }

  void _handlePlayerAction(
    String playerId,
    PlayerActionType actionType,
    Map<String, dynamic>? actionData,
  ) {
    // Les actions sont déjà reflétées dans le GameState mis à jour
    // qui est reçu via gameStateUpdated
    // Cette méthode pourrait être utilisée pour des effets locaux
    // comme des animations ou des sons
  }

  Future<void> syncAction({
    required String playerId,
    required PlayerActionType actionType,
    Map<String, dynamic>? actionData,
  }) async {
    final roomId = _roomId ?? '';

    // Créer l'événement d'action du joueur
    final event = RoomEvent.playerAction(
      playerId: playerId,
      actionType: actionType,
      actionData: actionData,
    );

    // Envoyer l'événement via le repository
    await _roomRepository.sendEvent(roomId: roomId, event: event);
  }

  Future<void> drawFromDeck(String playerId) async {
    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.drawCard,
      actionData: {'source': 'deck'},
    );
  }

  Future<void> drawFromDiscard(String playerId) async {
    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.drawCard,
      actionData: {'source': 'discard'},
    );
  }

  Future<void> discardCard(String playerId, int cardIndex) async {
    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.discardCard,
      actionData: {'cardIndex': cardIndex},
    );
  }

  Future<void> revealCard(String playerId, int position) async {
    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.revealCard,
      actionData: {'position': position},
    );
  }

  Future<void> endTurn(String playerId) async {
    await syncAction(playerId: playerId, actionType: PlayerActionType.endTurn);
  }

  Future<void> drawActionCard(String playerId) async {
    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.drawActionCard,
    );
  }

  Future<void> useActionCard(
    String playerId,
    ActionCard card, {
    Map<String, dynamic>? targetData,
  }) async {
    final actionData = <String, dynamic>{
      'cardId': card.id,
      'cardType': card.type.toString(),
    };

    // Add targetData if provided (for cards like teleportation)
    if (targetData != null) {
      actionData['targetData'] = targetData;
    }

    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.useActionCard,
      actionData: actionData,
    );
  }

  Future<void> discardActionCard(String playerId, ActionCard card) async {
    await syncAction(
      playerId: playerId,
      actionType: PlayerActionType.discardActionCard,
      actionData: {'cardId': card.id},
    );
  }
}
