// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerJoined _$PlayerJoinedFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PlayerJoined',
      json,
      ($checkedConvert) {
        final val = PlayerJoined(
          playerId: $checkedConvert('player_id', (v) => v as String),
          playerName: $checkedConvert('player_name', (v) => v as String),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'playerId': 'player_id',
        'playerName': 'player_name',
        r'$type': 'runtimeType',
      },
    );

Map<String, dynamic> _$PlayerJoinedToJson(PlayerJoined instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'player_name': instance.playerName,
      'runtimeType': instance.$type,
    };

PlayerLeft _$PlayerLeftFromJson(Map<String, dynamic> json) => $checkedCreate(
  'PlayerLeft',
  json,
  ($checkedConvert) {
    final val = PlayerLeft(
      playerId: $checkedConvert('player_id', (v) => v as String),
      $type: $checkedConvert('runtimeType', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {'playerId': 'player_id', r'$type': 'runtimeType'},
);

Map<String, dynamic> _$PlayerLeftToJson(PlayerLeft instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'runtimeType': instance.$type,
    };

GameStarted _$GameStartedFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GameStarted',
  json,
  ($checkedConvert) {
    final val = GameStarted(
      gameId: $checkedConvert('game_id', (v) => v as String),
      initialState: $checkedConvert(
        'initial_state',
        (v) => const GameStateConverter().fromJson(v as Map<String, dynamic>),
      ),
      $type: $checkedConvert('runtimeType', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {
    'gameId': 'game_id',
    'initialState': 'initial_state',
    r'$type': 'runtimeType',
  },
);

Map<String, dynamic> _$GameStartedToJson(GameStarted instance) =>
    <String, dynamic>{
      'game_id': instance.gameId,
      'initial_state': const GameStateConverter().toJson(instance.initialState),
      'runtimeType': instance.$type,
    };

GameStateUpdated _$GameStateUpdatedFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GameStateUpdated',
      json,
      ($checkedConvert) {
        final val = GameStateUpdated(
          newState: $checkedConvert(
            'new_state',
            (v) =>
                const GameStateConverter().fromJson(v as Map<String, dynamic>),
          ),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'newState': 'new_state', r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$GameStateUpdatedToJson(GameStateUpdated instance) =>
    <String, dynamic>{
      'new_state': const GameStateConverter().toJson(instance.newState),
      'runtimeType': instance.$type,
    };

PlayerAction _$PlayerActionFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PlayerAction',
      json,
      ($checkedConvert) {
        final val = PlayerAction(
          playerId: $checkedConvert('player_id', (v) => v as String),
          actionType: $checkedConvert(
            'action_type',
            (v) => $enumDecode(_$PlayerActionTypeEnumMap, v),
          ),
          actionData: $checkedConvert(
            'action_data',
            (v) => v as Map<String, dynamic>?,
          ),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'playerId': 'player_id',
        'actionType': 'action_type',
        'actionData': 'action_data',
        r'$type': 'runtimeType',
      },
    );

Map<String, dynamic> _$PlayerActionToJson(PlayerAction instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'action_type': _$PlayerActionTypeEnumMap[instance.actionType]!,
      'action_data': instance.actionData,
      'runtimeType': instance.$type,
    };

const _$PlayerActionTypeEnumMap = {
  PlayerActionType.drawCard: 'drawCard',
  PlayerActionType.discardCard: 'discardCard',
  PlayerActionType.revealCard: 'revealCard',
  PlayerActionType.playActionCard: 'playActionCard',
  PlayerActionType.endTurn: 'endTurn',
  PlayerActionType.drawActionCard: 'drawActionCard',
  PlayerActionType.useActionCard: 'useActionCard',
  PlayerActionType.discardActionCard: 'discardActionCard',
};
