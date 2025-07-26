// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_grid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerGridModel _$PlayerGridModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_PlayerGridModel',
  json,
  ($checkedConvert) {
    final val = _PlayerGridModel(
      id: $checkedConvert('id', (v) => v as String),
      gameStateId: $checkedConvert('game_state_id', (v) => v as String),
      playerId: $checkedConvert('player_id', (v) => v as String),
      gridCards: $checkedConvert(
        'grid_cards',
        (v) =>
            (v as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
      ),
      actionCards: $checkedConvert(
        'action_cards',
        (v) =>
            (v as List<dynamic>).map((e) => e as Map<String, dynamic>).toList(),
      ),
      score: $checkedConvert('score', (v) => (v as num).toInt()),
      position: $checkedConvert('position', (v) => (v as num).toInt()),
      isActive: $checkedConvert('is_active', (v) => v as bool),
      hasRevealedAll: $checkedConvert('has_revealed_all', (v) => v as bool),
      createdAt: $checkedConvert(
        'created_at',
        (v) => DateTime.parse(v as String),
      ),
      updatedAt: $checkedConvert(
        'updated_at',
        (v) => DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'gameStateId': 'game_state_id',
    'playerId': 'player_id',
    'gridCards': 'grid_cards',
    'actionCards': 'action_cards',
    'isActive': 'is_active',
    'hasRevealedAll': 'has_revealed_all',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$PlayerGridModelToJson(_PlayerGridModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'game_state_id': instance.gameStateId,
      'player_id': instance.playerId,
      'grid_cards': instance.gridCards,
      'action_cards': instance.actionCards,
      'score': instance.score,
      'position': instance.position,
      'is_active': instance.isActive,
      'has_revealed_all': instance.hasRevealedAll,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
