// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_grid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerGridImpl _$$PlayerGridImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(r'_$PlayerGridImpl', json, ($checkedConvert) {
      final val = _$PlayerGridImpl(
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

Map<String, dynamic> _$$PlayerGridImplToJson(_$PlayerGridImpl instance) =>
    <String, dynamic>{
      'cards': instance.cards
          .map((e) => e.map((e) => e?.toJson()).toList())
          .toList(),
    };
