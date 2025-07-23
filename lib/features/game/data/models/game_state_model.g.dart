// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GameStateModelImpl _$$GameStateModelImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$GameStateModelImpl',
      json,
      ($checkedConvert) {
        final val = _$GameStateModelImpl(
          roomId: $checkedConvert('room_id', (v) => v as String),
          players: $checkedConvert(
            'players',
            (v) => (v as List<dynamic>)
                .map((e) => Player.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          currentPlayerIndex: $checkedConvert(
            'current_player_index',
            (v) => (v as num).toInt(),
          ),
          deck: $checkedConvert(
            'deck',
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
          actionDeck: $checkedConvert(
            'action_deck',
            (v) => (v as List<dynamic>)
                .map((e) => ActionCard.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          actionDiscard: $checkedConvert(
            'action_discard',
            (v) => (v as List<dynamic>)
                .map((e) => ActionCard.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          status: $checkedConvert(
            'status',
            (v) => $enumDecode(_$GameStatusEnumMap, v),
          ),
          turnDirection: $checkedConvert(
            'turn_direction',
            (v) => $enumDecode(_$TurnDirectionEnumMap, v),
          ),
          lastRound: $checkedConvert('last_round', (v) => v as bool),
          initiatorPlayerId: $checkedConvert(
            'initiator_player_id',
            (v) => v as String?,
          ),
          endRoundInitiator: $checkedConvert(
            'end_round_initiator',
            (v) => v as String?,
          ),
          drawnCard: $checkedConvert(
            'drawn_card',
            (v) => v == null ? null : Card.fromJson(v as Map<String, dynamic>),
          ),
          createdAt: $checkedConvert(
            'created_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          startedAt: $checkedConvert(
            'started_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
          finishedAt: $checkedConvert(
            'finished_at',
            (v) => v == null ? null : DateTime.parse(v as String),
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'roomId': 'room_id',
        'currentPlayerIndex': 'current_player_index',
        'discardPile': 'discard_pile',
        'actionDeck': 'action_deck',
        'actionDiscard': 'action_discard',
        'turnDirection': 'turn_direction',
        'lastRound': 'last_round',
        'initiatorPlayerId': 'initiator_player_id',
        'endRoundInitiator': 'end_round_initiator',
        'drawnCard': 'drawn_card',
        'createdAt': 'created_at',
        'startedAt': 'started_at',
        'finishedAt': 'finished_at',
      },
    );

Map<String, dynamic> _$$GameStateModelImplToJson(
  _$GameStateModelImpl instance,
) => <String, dynamic>{
  'room_id': instance.roomId,
  'players': instance.players.map((e) => e.toJson()).toList(),
  'current_player_index': instance.currentPlayerIndex,
  'deck': instance.deck.map((e) => e.toJson()).toList(),
  'discard_pile': instance.discardPile.map((e) => e.toJson()).toList(),
  'action_deck': instance.actionDeck.map((e) => e.toJson()).toList(),
  'action_discard': instance.actionDiscard.map((e) => e.toJson()).toList(),
  'status': _$GameStatusEnumMap[instance.status]!,
  'turn_direction': _$TurnDirectionEnumMap[instance.turnDirection]!,
  'last_round': instance.lastRound,
  'initiator_player_id': instance.initiatorPlayerId,
  'end_round_initiator': instance.endRoundInitiator,
  'drawn_card': instance.drawnCard?.toJson(),
  'created_at': instance.createdAt?.toIso8601String(),
  'started_at': instance.startedAt?.toIso8601String(),
  'finished_at': instance.finishedAt?.toIso8601String(),
};

const _$GameStatusEnumMap = {
  GameStatus.waitingToStart: 'waitingToStart',
  GameStatus.playing: 'playing',
  GameStatus.drawPhase: 'drawPhase',
  GameStatus.lastRound: 'lastRound',
  GameStatus.finished: 'finished',
  GameStatus.cancelled: 'cancelled',
};

const _$TurnDirectionEnumMap = {
  TurnDirection.clockwise: 'clockwise',
  TurnDirection.counterClockwise: 'counterClockwise',
};
