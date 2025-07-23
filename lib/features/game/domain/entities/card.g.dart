// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardImpl _$$CardImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(r'_$CardImpl', json, ($checkedConvert) {
      final val = _$CardImpl(
        value: $checkedConvert('value', (v) => (v as num).toInt()),
        isRevealed: $checkedConvert('is_revealed', (v) => v as bool? ?? false),
      );
      return val;
    }, fieldKeyMap: const {'isRevealed': 'is_revealed'});

Map<String, dynamic> _$$CardImplToJson(_$CardImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'is_revealed': instance.isRevealed,
    };
