// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerStateImpl _$$PlayerStateImplFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  r'_$PlayerStateImpl',
  json,
  ($checkedConvert) {
    final val = _$PlayerStateImpl(
      playerId: $checkedConvert('player_id', (v) => v as String),
      cards: $checkedConvert(
        'cards',
        (v) => (v as List<dynamic>)
            .map(
              (e) =>
                  e == null ? null : Card.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      ),
      currentScore: $checkedConvert('current_score', (v) => (v as num).toInt()),
      revealedCount: $checkedConvert(
        'revealed_count',
        (v) => (v as num).toInt(),
      ),
      identicalColumns: $checkedConvert(
        'identical_columns',
        (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
      ),
      hasFinished: $checkedConvert('has_finished', (v) => v as bool),
    );
    return val;
  },
  fieldKeyMap: const {
    'playerId': 'player_id',
    'currentScore': 'current_score',
    'revealedCount': 'revealed_count',
    'identicalColumns': 'identical_columns',
    'hasFinished': 'has_finished',
  },
);

Map<String, dynamic> _$$PlayerStateImplToJson(_$PlayerStateImpl instance) =>
    <String, dynamic>{
      'player_id': instance.playerId,
      'cards': instance.cards.map((e) => e?.toJson()).toList(),
      'current_score': instance.currentScore,
      'revealed_count': instance.revealedCount,
      'identical_columns': instance.identicalColumns,
      'has_finished': instance.hasFinished,
    };
