// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Card _$CardFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Card', json, ($checkedConvert) {
      final val = _Card(
        value: $checkedConvert('value', (v) => (v as num).toInt()),
        isRevealed: $checkedConvert('is_revealed', (v) => v as bool? ?? false),
      );
      return val;
    }, fieldKeyMap: const {'isRevealed': 'is_revealed'});

Map<String, dynamic> _$CardToJson(_Card instance) => <String, dynamic>{
  'value': instance.value,
  'is_revealed': instance.isRevealed,
};
