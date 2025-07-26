import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_card.freezed.dart';
part 'action_card.g.dart';

enum ActionCardType {
  teleport,
  turnAround,
  peek,
  swap,
  shield,
  draw,
  reveal,
  shuffle,
  steal,
  duplicate,
  skip,
  reverse,
  discard,
  freeze,
  mirror,
  bomb,
  heal,
  curse,
  gift,
  gamble,
  scout,
}

enum ActionTiming {
  immediate, // Must be played immediately when drawn
  optional, // Can be stored and played later
  reactive, // Can be played in reaction to other actions
}

enum ActionTarget {
  self,
  singleOpponent,
  allOpponents,
  allPlayers,
  deck,
  discard,
  none,
}

@Freezed()
abstract class ActionCard with _$ActionCard {
  const factory ActionCard({
    required String id,
    required ActionCardType type,
    required String name,
    required String description,
    @Default(ActionTiming.optional) ActionTiming timing,
    @Default(ActionTarget.none) ActionTarget target,
    @Default({}) Map<String, dynamic> parameters,
  }) = _ActionCard;

  const ActionCard._();

  factory ActionCard.fromJson(Map<String, dynamic> json) =>
      _$ActionCardFromJson(json);

  bool get isImmediate => timing == ActionTiming.immediate;
  bool get isOptional => timing == ActionTiming.optional;
  bool get isReactive => timing == ActionTiming.reactive;
}
