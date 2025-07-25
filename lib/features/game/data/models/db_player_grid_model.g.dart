// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_player_grid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DbPlayerGridModelImpl _$$DbPlayerGridModelImplFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  r'_$DbPlayerGridModelImpl',
  json,
  ($checkedConvert) {
    final val = _$DbPlayerGridModelImpl(
      id: $checkedConvert('id', (v) => v as String),
      gameStateId: $checkedConvert('game_state_id', (v) => v as String),
      playerId: $checkedConvert('player_id', (v) => v as String),
      gridCards: $checkedConvert(
        'grid_cards',
        (v) => (v as List<dynamic>)
            .map((e) => Card.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      actionCards: $checkedConvert(
        'action_cards',
        (v) => (v as List<dynamic>)
            .map((e) => ActionCard.fromJson(e as Map<String, dynamic>))
            .toList(),
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

Map<String, dynamic> _$$DbPlayerGridModelImplToJson(
  _$DbPlayerGridModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'game_state_id': instance.gameStateId,
  'player_id': instance.playerId,
  'grid_cards': instance.gridCards.map((e) => e.toJson()).toList(),
  'action_cards': instance.actionCards.map((e) => e.toJson()).toList(),
  'score': instance.score,
  'position': instance.position,
  'is_active': instance.isActive,
  'has_revealed_all': instance.hasRevealedAll,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
