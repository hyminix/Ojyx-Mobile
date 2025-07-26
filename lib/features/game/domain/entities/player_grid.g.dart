// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_grid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerGrid _$PlayerGridFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_PlayerGrid', json, ($checkedConvert) {
      final val = _PlayerGrid(
        cards: $checkedConvert(
          'cards',
          (v) => (v as List<dynamic>)
              .map(
                (e) => (e as List<dynamic>)
                    .map(
                      (e) => e == null
                          ? null
                          : Card.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PlayerGridToJson(_PlayerGrid instance) =>
    <String, dynamic>{
      'cards': instance.cards
          .map((e) => e.map((e) => e?.toJson()).toList())
          .toList(),
    };
