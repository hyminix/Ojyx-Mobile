// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionCard _$ActionCardFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ActionCard',
  json,
  ($checkedConvert) {
    final val = _ActionCard(
      id: $checkedConvert('id', (v) => v as String),
      type: $checkedConvert(
        'type',
        (v) => $enumDecode(_$ActionCardTypeEnumMap, v),
      ),
      name: $checkedConvert('name', (v) => v as String),
      description: $checkedConvert('description', (v) => v as String),
      timing: $checkedConvert(
        'timing',
        (v) =>
            $enumDecodeNullable(_$ActionTimingEnumMap, v) ??
            ActionTiming.optional,
      ),
      target: $checkedConvert(
        'target',
        (v) =>
            $enumDecodeNullable(_$ActionTargetEnumMap, v) ?? ActionTarget.none,
      ),
      parameters: $checkedConvert(
        'parameters',
        (v) => v as Map<String, dynamic>? ?? const {},
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$ActionCardToJson(_ActionCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ActionCardTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'timing': _$ActionTimingEnumMap[instance.timing]!,
      'target': _$ActionTargetEnumMap[instance.target]!,
      'parameters': instance.parameters,
    };

const _$ActionCardTypeEnumMap = {
  ActionCardType.teleport: 'teleport',
  ActionCardType.turnAround: 'turnAround',
  ActionCardType.peek: 'peek',
  ActionCardType.swap: 'swap',
  ActionCardType.shield: 'shield',
  ActionCardType.draw: 'draw',
  ActionCardType.reveal: 'reveal',
  ActionCardType.shuffle: 'shuffle',
  ActionCardType.steal: 'steal',
  ActionCardType.duplicate: 'duplicate',
  ActionCardType.skip: 'skip',
  ActionCardType.reverse: 'reverse',
  ActionCardType.discard: 'discard',
  ActionCardType.freeze: 'freeze',
  ActionCardType.mirror: 'mirror',
  ActionCardType.bomb: 'bomb',
  ActionCardType.heal: 'heal',
  ActionCardType.curse: 'curse',
  ActionCardType.gift: 'gift',
  ActionCardType.gamble: 'gamble',
  ActionCardType.scout: 'scout',
};

const _$ActionTimingEnumMap = {
  ActionTiming.immediate: 'immediate',
  ActionTiming.optional: 'optional',
  ActionTiming.reactive: 'reactive',
};

const _$ActionTargetEnumMap = {
  ActionTarget.self: 'self',
  ActionTarget.singleOpponent: 'singleOpponent',
  ActionTarget.allOpponents: 'allOpponents',
  ActionTarget.allPlayers: 'allPlayers',
  ActionTarget.deck: 'deck',
  ActionTarget.discard: 'discard',
  ActionTarget.none: 'none',
};
