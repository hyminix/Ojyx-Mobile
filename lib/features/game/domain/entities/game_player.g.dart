// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamePlayerImpl _$$GamePlayerImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$GamePlayerImpl',
      json,
      ($checkedConvert) {
        final val = _$GamePlayerImpl(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          grid: $checkedConvert(
            'grid',
            (v) => PlayerGrid.fromJson(v as Map<String, dynamic>),
          ),
          actionCards: $checkedConvert(
            'action_cards',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => ActionCard.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const [],
          ),
          isConnected: $checkedConvert(
            'is_connected',
            (v) => v as bool? ?? true,
          ),
          isHost: $checkedConvert('is_host', (v) => v as bool? ?? false),
          hasFinishedRound: $checkedConvert(
            'has_finished_round',
            (v) => v as bool? ?? false,
          ),
          scoreMultiplier: $checkedConvert(
            'score_multiplier',
            (v) => (v as num?)?.toInt() ?? 1,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'actionCards': 'action_cards',
        'isConnected': 'is_connected',
        'isHost': 'is_host',
        'hasFinishedRound': 'has_finished_round',
        'scoreMultiplier': 'score_multiplier',
      },
    );

Map<String, dynamic> _$$GamePlayerImplToJson(_$GamePlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grid': instance.grid.toJson(),
      'action_cards': instance.actionCards.map((e) => e.toJson()).toList(),
      'is_connected': instance.isConnected,
      'is_host': instance.isHost,
      'has_finished_round': instance.hasFinishedRound,
      'score_multiplier': instance.scoreMultiplier,
    };
