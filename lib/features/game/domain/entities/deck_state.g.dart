// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deck_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeckState _$DeckStateFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_DeckState',
  json,
  ($checkedConvert) {
    final val = _DeckState(
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
  fieldKeyMap: const {'drawPile': 'draw_pile', 'discardPile': 'discard_pile'},
);

Map<String, dynamic> _$DeckStateToJson(_DeckState instance) =>
    <String, dynamic>{
      'draw_pile': instance.drawPile.map((e) => e.toJson()).toList(),
      'discard_pile': instance.discardPile.map((e) => e.toJson()).toList(),
    };
