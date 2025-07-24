// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamePlayerImpl _$$GamePlayerImplFromJson(Map<String, dynamic> json) =>
    _$GamePlayerImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      grid: PlayerGrid.fromJson(json['grid'] as Map<String, dynamic>),
      actionCards: (json['action_cards'] as List<dynamic>?)
              ?.map((e) => ActionCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isConnected: json['is_connected'] as bool? ?? true,
      isHost: json['is_host'] as bool? ?? false,
      hasFinishedRound: json['has_finished_round'] as bool? ?? false,
      scoreMultiplier: (json['score_multiplier'] as num?)?.toInt() ?? 1,
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