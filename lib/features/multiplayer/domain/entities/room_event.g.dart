// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerJoinedImpl _$$PlayerJoinedImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PlayerJoinedImpl',
      json,
      ($checkedConvert) {
        final val = _$PlayerJoinedImpl(
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

Map<String, dynamic> _$$PlayerJoinedImplToJson(_$PlayerJoinedImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'player_name': instance.playerName,
      'runtimeType': instance.$type,
    };

_$PlayerLeftImpl _$$PlayerLeftImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PlayerLeftImpl',
      json,
      ($checkedConvert) {
        final val = _$PlayerLeftImpl(
          playerId: $checkedConvert('player_id', (v) => v as String),
          $type: $checkedConvert('runtimeType', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'playerId': 'player_id', r'$type': 'runtimeType'},
    );

Map<String, dynamic> _$$PlayerLeftImplToJson(_$PlayerLeftImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'runtimeType': instance.$type,
    };

_$GameStartedImpl _$$GameStartedImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$GameStartedImpl',
      json,
      ($checkedConvert) {
        final val = _$GameStartedImpl(
          gameId: $checkedConvert('game_id', (v) => v as String),
          initialState: $checkedConvert(
            'initial_state',
            (v) =>
                const GameStateConverter().fromJson(v as Map<String, dynamic>),
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

Map<String, dynamic> _$$GameStartedImplToJson(_$GameStartedImpl instance) =>
    <String, dynamic>{
      'game_id': instance.gameId,
      'initial_state': const GameStateConverter().toJson(instance.initialState),
      'runtimeType': instance.$type,
    };

_$GameStateUpdatedImpl _$$GameStateUpdatedImplFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  r'_$GameStateUpdatedImpl',
  json,
  ($checkedConvert) {
    final val = _$GameStateUpdatedImpl(
      newState: $checkedConvert(
        'new_state',
        (v) => const GameStateConverter().fromJson(v as Map<String, dynamic>),
      ),
      $type: $checkedConvert('runtimeType', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {'newState': 'new_state', r'$type': 'runtimeType'},
);

Map<String, dynamic> _$$GameStateUpdatedImplToJson(
  _$GameStateUpdatedImpl instance,
) => <String, dynamic>{
  'new_state': const GameStateConverter().toJson(instance.newState),
  'runtimeType': instance.$type,
};

_$PlayerActionImpl _$$PlayerActionImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$PlayerActionImpl',
      json,
      ($checkedConvert) {
        final val = _$PlayerActionImpl(
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

Map<String, dynamic> _$$PlayerActionImplToJson(_$PlayerActionImpl instance) =>
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
