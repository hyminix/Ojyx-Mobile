// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeckStateImpl _$$DeckStateImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$DeckStateImpl',
      json,
      ($checkedConvert) {
        final val = _$DeckStateImpl(
          drawPile: $checkedConvert(
            'draw_pile',
            (v) => (v as List<dynamic>)
                .map((e) => Card.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          discardPile: $checkedConvert(
            'discard_pile',
            (v) => (v as List<dynamic>)
                .map((e) => Card.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'drawPile': 'draw_pile',
        'discardPile': 'discard_pile',
      },
    );

Map<String, dynamic> _$$DeckStateImplToJson(_$DeckStateImpl instance) =>
    <String, dynamic>{
      'draw_pile': instance.drawPile.map((e) => e.toJson()).toList(),
      'discard_pile': instance.discardPile.map((e) => e.toJson()).toList(),
    };
