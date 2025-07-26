// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EndGameState _$EndGameStateFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_EndGameState',
      json,
      ($checkedConvert) {
        final val = _EndGameState(
          players: $checkedConvert(
            'players',
            (v) => (v as List<dynamic>)
                .map((e) => GamePlayer.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          roundInitiatorId: $checkedConvert(
            'round_initiator_id',
            (v) => v as String,
          ),
          roundNumber: $checkedConvert(
            'round_number',
            (v) => (v as num).toInt(),
          ),
          playersVotes: $checkedConvert(
            'players_votes',
            (v) =>
                (v as Map<String, dynamic>?)?.map(
                  (k, e) => MapEntry(k, e as bool),
                ) ??
                const {},
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'roundInitiatorId': 'round_initiator_id',
        'roundNumber': 'round_number',
        'playersVotes': 'players_votes',
      },
    );

Map<String, dynamic> _$EndGameStateToJson(_EndGameState instance) =>
    <String, dynamic>{
      'players': instance.players.map((e) => e.toJson()).toList(),
      'round_initiator_id': instance.roundInitiatorId,
      'round_number': instance.roundNumber,
      'players_votes': instance.playersVotes,
    };
