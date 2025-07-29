// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_sync_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerJoinedEvent _$PlayerJoinedEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlayerJoinedEvent', json, ($checkedConvert) {
      final val = PlayerJoinedEvent(
        player: $checkedConvert(
          'player',
          (v) => LobbyPlayer.fromJson(v as Map<String, dynamic>),
        ),
        timestamp: $checkedConvert(
          'timestamp',
          (v) => DateTime.parse(v as String),
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$PlayerJoinedEventToJson(PlayerJoinedEvent instance) =>
    <String, dynamic>{
      'player': instance.player.toJson(),
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.$type,
    };

PlayerLeftEvent _$PlayerLeftEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PlayerLeftEvent',
      json,
      ($checkedConvert) {
        final val = PlayerLeftEvent(
          playerId: $checkedConvert('player_id', (v) => v as String),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          isTimeout: $checkedConvert('is_timeout', (v) => v as bool? ?? false),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'playerId': 'player_id',
        'isTimeout': 'is_timeout',
        r'$type': 'type',
      },
    );

Map<String, dynamic> _$PlayerLeftEventToJson(PlayerLeftEvent instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'timestamp': instance.timestamp.toIso8601String(),
      'is_timeout': instance.isTimeout,
      'type': instance.$type,
    };

GameStateUpdatedEvent _$GameStateUpdatedEventFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'GameStateUpdatedEvent',
  json,
  ($checkedConvert) {
    final val = GameStateUpdatedEvent(
      gameState: $checkedConvert(
        'game_state',
        (v) => const GameStateConverter().fromJson(v as Map<String, dynamic>),
      ),
      timestamp: $checkedConvert(
        'timestamp',
        (v) => DateTime.parse(v as String),
      ),
      triggeredBy: $checkedConvert('triggered_by', (v) => v as String?),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'gameState': 'game_state',
    'triggeredBy': 'triggered_by',
    r'$type': 'type',
  },
);

Map<String, dynamic> _$GameStateUpdatedEventToJson(
  GameStateUpdatedEvent instance,
) => <String, dynamic>{
  'game_state': const GameStateConverter().toJson(instance.gameState),
  'timestamp': instance.timestamp.toIso8601String(),
  'triggered_by': instance.triggeredBy,
  'type': instance.$type,
};

CardRevealedEvent _$CardRevealedEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'CardRevealedEvent',
      json,
      ($checkedConvert) {
        final val = CardRevealedEvent(
          playerId: $checkedConvert('player_id', (v) => v as String),
          row: $checkedConvert('row', (v) => (v as num).toInt()),
          col: $checkedConvert('col', (v) => (v as num).toInt()),
          card: $checkedConvert(
            'card',
            (v) => Card.fromJson(v as Map<String, dynamic>),
          ),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'playerId': 'player_id', r'$type': 'type'},
    );

Map<String, dynamic> _$CardRevealedEventToJson(CardRevealedEvent instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'row': instance.row,
      'col': instance.col,
      'card': instance.card.toJson(),
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.$type,
    };

ActionCardPlayedEvent _$ActionCardPlayedEventFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'ActionCardPlayedEvent',
  json,
  ($checkedConvert) {
    final val = ActionCardPlayedEvent(
      playerId: $checkedConvert('player_id', (v) => v as String),
      actionCard: $checkedConvert(
        'action_card',
        (v) => ActionCard.fromJson(v as Map<String, dynamic>),
      ),
      actionData: $checkedConvert(
        'action_data',
        (v) => v as Map<String, dynamic>,
      ),
      timestamp: $checkedConvert(
        'timestamp',
        (v) => DateTime.parse(v as String),
      ),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'playerId': 'player_id',
    'actionCard': 'action_card',
    'actionData': 'action_data',
    r'$type': 'type',
  },
);

Map<String, dynamic> _$ActionCardPlayedEventToJson(
  ActionCardPlayedEvent instance,
) => <String, dynamic>{
  'player_id': instance.playerId,
  'action_card': instance.actionCard.toJson(),
  'action_data': instance.actionData,
  'timestamp': instance.timestamp.toIso8601String(),
  'type': instance.$type,
};

TurnChangedEvent _$TurnChangedEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'TurnChangedEvent',
      json,
      ($checkedConvert) {
        final val = TurnChangedEvent(
          previousPlayerId: $checkedConvert(
            'previous_player_id',
            (v) => v as String,
          ),
          currentPlayerId: $checkedConvert(
            'current_player_id',
            (v) => v as String,
          ),
          turnNumber: $checkedConvert('turn_number', (v) => (v as num).toInt()),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'previousPlayerId': 'previous_player_id',
        'currentPlayerId': 'current_player_id',
        'turnNumber': 'turn_number',
        r'$type': 'type',
      },
    );

Map<String, dynamic> _$TurnChangedEventToJson(TurnChangedEvent instance) =>
    <String, dynamic>{
      'previous_player_id': instance.previousPlayerId,
      'current_player_id': instance.currentPlayerId,
      'turn_number': instance.turnNumber,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.$type,
    };

RoomSettingsChangedEvent _$RoomSettingsChangedEventFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'RoomSettingsChangedEvent',
  json,
  ($checkedConvert) {
    final val = RoomSettingsChangedEvent(
      settings: $checkedConvert('settings', (v) => v as Map<String, dynamic>),
      timestamp: $checkedConvert(
        'timestamp',
        (v) => DateTime.parse(v as String),
      ),
      changedBy: $checkedConvert('changed_by', (v) => v as String),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {'changedBy': 'changed_by', r'$type': 'type'},
);

Map<String, dynamic> _$RoomSettingsChangedEventToJson(
  RoomSettingsChangedEvent instance,
) => <String, dynamic>{
  'settings': instance.settings,
  'timestamp': instance.timestamp.toIso8601String(),
  'changed_by': instance.changedBy,
  'type': instance.$type,
};

GameStartedEvent _$GameStartedEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GameStartedEvent',
      json,
      ($checkedConvert) {
        final val = GameStartedEvent(
          roomId: $checkedConvert('room_id', (v) => v as String),
          gameId: $checkedConvert('game_id', (v) => v as String),
          playerIds: $checkedConvert(
            'player_ids',
            (v) => (v as List<dynamic>).map((e) => e as String).toList(),
          ),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'roomId': 'room_id',
        'gameId': 'game_id',
        'playerIds': 'player_ids',
        r'$type': 'type',
      },
    );

Map<String, dynamic> _$GameStartedEventToJson(GameStartedEvent instance) =>
    <String, dynamic>{
      'room_id': instance.roomId,
      'game_id': instance.gameId,
      'player_ids': instance.playerIds,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.$type,
    };

GameEndedEvent _$GameEndedEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GameEndedEvent',
      json,
      ($checkedConvert) {
        final val = GameEndedEvent(
          gameId: $checkedConvert('game_id', (v) => v as String),
          finalScores: $checkedConvert(
            'final_scores',
            (v) => Map<String, int>.from(v as Map),
          ),
          winnerId: $checkedConvert('winner_id', (v) => v as String),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'gameId': 'game_id',
        'finalScores': 'final_scores',
        'winnerId': 'winner_id',
        r'$type': 'type',
      },
    );

Map<String, dynamic> _$GameEndedEventToJson(GameEndedEvent instance) =>
    <String, dynamic>{
      'game_id': instance.gameId,
      'final_scores': instance.finalScores,
      'winner_id': instance.winnerId,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.$type,
    };

PlayerDisconnectedEvent _$PlayerDisconnectedEventFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'PlayerDisconnectedEvent',
  json,
  ($checkedConvert) {
    final val = PlayerDisconnectedEvent(
      playerId: $checkedConvert('player_id', (v) => v as String),
      disconnectedAt: $checkedConvert(
        'disconnected_at',
        (v) => DateTime.parse(v as String),
      ),
      timeoutAt: $checkedConvert(
        'timeout_at',
        (v) => DateTime.parse(v as String),
      ),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'playerId': 'player_id',
    'disconnectedAt': 'disconnected_at',
    'timeoutAt': 'timeout_at',
    r'$type': 'type',
  },
);

Map<String, dynamic> _$PlayerDisconnectedEventToJson(
  PlayerDisconnectedEvent instance,
) => <String, dynamic>{
  'player_id': instance.playerId,
  'disconnected_at': instance.disconnectedAt.toIso8601String(),
  'timeout_at': instance.timeoutAt.toIso8601String(),
  'type': instance.$type,
};

PlayerReconnectedEvent _$PlayerReconnectedEventFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  'PlayerReconnectedEvent',
  json,
  ($checkedConvert) {
    final val = PlayerReconnectedEvent(
      playerId: $checkedConvert('player_id', (v) => v as String),
      reconnectedAt: $checkedConvert(
        'reconnected_at',
        (v) => DateTime.parse(v as String),
      ),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'playerId': 'player_id',
    'reconnectedAt': 'reconnected_at',
    r'$type': 'type',
  },
);

Map<String, dynamic> _$PlayerReconnectedEventToJson(
  PlayerReconnectedEvent instance,
) => <String, dynamic>{
  'player_id': instance.playerId,
  'reconnected_at': instance.reconnectedAt.toIso8601String(),
  'type': instance.$type,
};

ChatMessageEvent _$ChatMessageEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ChatMessageEvent',
      json,
      ($checkedConvert) {
        final val = ChatMessageEvent(
          playerId: $checkedConvert('player_id', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'playerId': 'player_id', r'$type': 'type'},
    );

Map<String, dynamic> _$ChatMessageEventToJson(ChatMessageEvent instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'type': instance.$type,
    };

SyncErrorEvent _$SyncErrorEventFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SyncErrorEvent',
      json,
      ($checkedConvert) {
        final val = SyncErrorEvent(
          errorType: $checkedConvert('error_type', (v) => v as String),
          message: $checkedConvert('message', (v) => v as String),
          timestamp: $checkedConvert(
            'timestamp',
            (v) => DateTime.parse(v as String),
          ),
          context: $checkedConvert(
            'context',
            (v) => v as Map<String, dynamic>?,
          ),
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'errorType': 'error_type', r'$type': 'type'},
    );

Map<String, dynamic> _$SyncErrorEventToJson(SyncErrorEvent instance) =>
    <String, dynamic>{
      'error_type': instance.errorType,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'context': instance.context,
      'type': instance.$type,
    };
