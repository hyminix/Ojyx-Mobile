// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameState {

 String get roomId; List<GamePlayer> get players; int get currentPlayerIndex; List<Card> get deck; List<Card> get discardPile; List<ActionCard> get actionDeck; List<ActionCard> get actionDiscard; GameStatus get status; TurnDirection get turnDirection; bool get lastRound; String? get initiatorPlayerId; String? get endRoundInitiator; Card? get drawnCard; DateTime? get createdAt; DateTime? get startedAt; DateTime? get finishedAt;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&const DeepCollectionEquality().equals(other.deck, deck)&&const DeepCollectionEquality().equals(other.discardPile, discardPile)&&const DeepCollectionEquality().equals(other.actionDeck, actionDeck)&&const DeepCollectionEquality().equals(other.actionDiscard, actionDiscard)&&(identical(other.status, status) || other.status == status)&&(identical(other.turnDirection, turnDirection) || other.turnDirection == turnDirection)&&(identical(other.lastRound, lastRound) || other.lastRound == lastRound)&&(identical(other.initiatorPlayerId, initiatorPlayerId) || other.initiatorPlayerId == initiatorPlayerId)&&(identical(other.endRoundInitiator, endRoundInitiator) || other.endRoundInitiator == endRoundInitiator)&&(identical(other.drawnCard, drawnCard) || other.drawnCard == drawnCard)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,const DeepCollectionEquality().hash(players),currentPlayerIndex,const DeepCollectionEquality().hash(deck),const DeepCollectionEquality().hash(discardPile),const DeepCollectionEquality().hash(actionDeck),const DeepCollectionEquality().hash(actionDiscard),status,turnDirection,lastRound,initiatorPlayerId,endRoundInitiator,drawnCard,createdAt,startedAt,finishedAt);

@override
String toString() {
  return 'GameState(roomId: $roomId, players: $players, currentPlayerIndex: $currentPlayerIndex, deck: $deck, discardPile: $discardPile, actionDeck: $actionDeck, actionDiscard: $actionDiscard, status: $status, turnDirection: $turnDirection, lastRound: $lastRound, initiatorPlayerId: $initiatorPlayerId, endRoundInitiator: $endRoundInitiator, drawnCard: $drawnCard, createdAt: $createdAt, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 String roomId, List<GamePlayer> players, int currentPlayerIndex, List<Card> deck, List<Card> discardPile, List<ActionCard> actionDeck, List<ActionCard> actionDiscard, GameStatus status, TurnDirection turnDirection, bool lastRound, String? initiatorPlayerId, String? endRoundInitiator, Card? drawnCard, DateTime? createdAt, DateTime? startedAt, DateTime? finishedAt
});


$CardCopyWith<$Res>? get drawnCard;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,Object? players = null,Object? currentPlayerIndex = null,Object? deck = null,Object? discardPile = null,Object? actionDeck = null,Object? actionDiscard = null,Object? status = null,Object? turnDirection = null,Object? lastRound = null,Object? initiatorPlayerId = freezed,Object? endRoundInitiator = freezed,Object? drawnCard = freezed,Object? createdAt = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_self.copyWith(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<GamePlayer>,currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,deck: null == deck ? _self.deck : deck // ignore: cast_nullable_to_non_nullable
as List<Card>,discardPile: null == discardPile ? _self.discardPile : discardPile // ignore: cast_nullable_to_non_nullable
as List<Card>,actionDeck: null == actionDeck ? _self.actionDeck : actionDeck // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,actionDiscard: null == actionDiscard ? _self.actionDiscard : actionDiscard // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,turnDirection: null == turnDirection ? _self.turnDirection : turnDirection // ignore: cast_nullable_to_non_nullable
as TurnDirection,lastRound: null == lastRound ? _self.lastRound : lastRound // ignore: cast_nullable_to_non_nullable
as bool,initiatorPlayerId: freezed == initiatorPlayerId ? _self.initiatorPlayerId : initiatorPlayerId // ignore: cast_nullable_to_non_nullable
as String?,endRoundInitiator: freezed == endRoundInitiator ? _self.endRoundInitiator : endRoundInitiator // ignore: cast_nullable_to_non_nullable
as String?,drawnCard: freezed == drawnCard ? _self.drawnCard : drawnCard // ignore: cast_nullable_to_non_nullable
as Card?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardCopyWith<$Res>? get drawnCard {
    if (_self.drawnCard == null) {
    return null;
  }

  return $CardCopyWith<$Res>(_self.drawnCard!, (value) {
    return _then(_self.copyWith(drawnCard: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomId,  List<GamePlayer> players,  int currentPlayerIndex,  List<Card> deck,  List<Card> discardPile,  List<ActionCard> actionDeck,  List<ActionCard> actionDiscard,  GameStatus status,  TurnDirection turnDirection,  bool lastRound,  String? initiatorPlayerId,  String? endRoundInitiator,  Card? drawnCard,  DateTime? createdAt,  DateTime? startedAt,  DateTime? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.roomId,_that.players,_that.currentPlayerIndex,_that.deck,_that.discardPile,_that.actionDeck,_that.actionDiscard,_that.status,_that.turnDirection,_that.lastRound,_that.initiatorPlayerId,_that.endRoundInitiator,_that.drawnCard,_that.createdAt,_that.startedAt,_that.finishedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomId,  List<GamePlayer> players,  int currentPlayerIndex,  List<Card> deck,  List<Card> discardPile,  List<ActionCard> actionDeck,  List<ActionCard> actionDiscard,  GameStatus status,  TurnDirection turnDirection,  bool lastRound,  String? initiatorPlayerId,  String? endRoundInitiator,  Card? drawnCard,  DateTime? createdAt,  DateTime? startedAt,  DateTime? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.roomId,_that.players,_that.currentPlayerIndex,_that.deck,_that.discardPile,_that.actionDeck,_that.actionDiscard,_that.status,_that.turnDirection,_that.lastRound,_that.initiatorPlayerId,_that.endRoundInitiator,_that.drawnCard,_that.createdAt,_that.startedAt,_that.finishedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomId,  List<GamePlayer> players,  int currentPlayerIndex,  List<Card> deck,  List<Card> discardPile,  List<ActionCard> actionDeck,  List<ActionCard> actionDiscard,  GameStatus status,  TurnDirection turnDirection,  bool lastRound,  String? initiatorPlayerId,  String? endRoundInitiator,  Card? drawnCard,  DateTime? createdAt,  DateTime? startedAt,  DateTime? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.roomId,_that.players,_that.currentPlayerIndex,_that.deck,_that.discardPile,_that.actionDeck,_that.actionDiscard,_that.status,_that.turnDirection,_that.lastRound,_that.initiatorPlayerId,_that.endRoundInitiator,_that.drawnCard,_that.createdAt,_that.startedAt,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc


class _GameState extends GameState {
  const _GameState({required this.roomId, required final  List<GamePlayer> players, required this.currentPlayerIndex, required final  List<Card> deck, required final  List<Card> discardPile, required final  List<ActionCard> actionDeck, required final  List<ActionCard> actionDiscard, required this.status, required this.turnDirection, required this.lastRound, this.initiatorPlayerId, this.endRoundInitiator, this.drawnCard, this.createdAt, this.startedAt, this.finishedAt}): _players = players,_deck = deck,_discardPile = discardPile,_actionDeck = actionDeck,_actionDiscard = actionDiscard,super._();
  

@override final  String roomId;
 final  List<GamePlayer> _players;
@override List<GamePlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  int currentPlayerIndex;
 final  List<Card> _deck;
@override List<Card> get deck {
  if (_deck is EqualUnmodifiableListView) return _deck;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deck);
}

 final  List<Card> _discardPile;
@override List<Card> get discardPile {
  if (_discardPile is EqualUnmodifiableListView) return _discardPile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discardPile);
}

 final  List<ActionCard> _actionDeck;
@override List<ActionCard> get actionDeck {
  if (_actionDeck is EqualUnmodifiableListView) return _actionDeck;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionDeck);
}

 final  List<ActionCard> _actionDiscard;
@override List<ActionCard> get actionDiscard {
  if (_actionDiscard is EqualUnmodifiableListView) return _actionDiscard;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionDiscard);
}

@override final  GameStatus status;
@override final  TurnDirection turnDirection;
@override final  bool lastRound;
@override final  String? initiatorPlayerId;
@override final  String? endRoundInitiator;
@override final  Card? drawnCard;
@override final  DateTime? createdAt;
@override final  DateTime? startedAt;
@override final  DateTime? finishedAt;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.currentPlayerIndex, currentPlayerIndex) || other.currentPlayerIndex == currentPlayerIndex)&&const DeepCollectionEquality().equals(other._deck, _deck)&&const DeepCollectionEquality().equals(other._discardPile, _discardPile)&&const DeepCollectionEquality().equals(other._actionDeck, _actionDeck)&&const DeepCollectionEquality().equals(other._actionDiscard, _actionDiscard)&&(identical(other.status, status) || other.status == status)&&(identical(other.turnDirection, turnDirection) || other.turnDirection == turnDirection)&&(identical(other.lastRound, lastRound) || other.lastRound == lastRound)&&(identical(other.initiatorPlayerId, initiatorPlayerId) || other.initiatorPlayerId == initiatorPlayerId)&&(identical(other.endRoundInitiator, endRoundInitiator) || other.endRoundInitiator == endRoundInitiator)&&(identical(other.drawnCard, drawnCard) || other.drawnCard == drawnCard)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,const DeepCollectionEquality().hash(_players),currentPlayerIndex,const DeepCollectionEquality().hash(_deck),const DeepCollectionEquality().hash(_discardPile),const DeepCollectionEquality().hash(_actionDeck),const DeepCollectionEquality().hash(_actionDiscard),status,turnDirection,lastRound,initiatorPlayerId,endRoundInitiator,drawnCard,createdAt,startedAt,finishedAt);

@override
String toString() {
  return 'GameState(roomId: $roomId, players: $players, currentPlayerIndex: $currentPlayerIndex, deck: $deck, discardPile: $discardPile, actionDeck: $actionDeck, actionDiscard: $actionDiscard, status: $status, turnDirection: $turnDirection, lastRound: $lastRound, initiatorPlayerId: $initiatorPlayerId, endRoundInitiator: $endRoundInitiator, drawnCard: $drawnCard, createdAt: $createdAt, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 String roomId, List<GamePlayer> players, int currentPlayerIndex, List<Card> deck, List<Card> discardPile, List<ActionCard> actionDeck, List<ActionCard> actionDiscard, GameStatus status, TurnDirection turnDirection, bool lastRound, String? initiatorPlayerId, String? endRoundInitiator, Card? drawnCard, DateTime? createdAt, DateTime? startedAt, DateTime? finishedAt
});


@override $CardCopyWith<$Res>? get drawnCard;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? players = null,Object? currentPlayerIndex = null,Object? deck = null,Object? discardPile = null,Object? actionDeck = null,Object? actionDiscard = null,Object? status = null,Object? turnDirection = null,Object? lastRound = null,Object? initiatorPlayerId = freezed,Object? endRoundInitiator = freezed,Object? drawnCard = freezed,Object? createdAt = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_GameState(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<GamePlayer>,currentPlayerIndex: null == currentPlayerIndex ? _self.currentPlayerIndex : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
as int,deck: null == deck ? _self._deck : deck // ignore: cast_nullable_to_non_nullable
as List<Card>,discardPile: null == discardPile ? _self._discardPile : discardPile // ignore: cast_nullable_to_non_nullable
as List<Card>,actionDeck: null == actionDeck ? _self._actionDeck : actionDeck // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,actionDiscard: null == actionDiscard ? _self._actionDiscard : actionDiscard // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,turnDirection: null == turnDirection ? _self.turnDirection : turnDirection // ignore: cast_nullable_to_non_nullable
as TurnDirection,lastRound: null == lastRound ? _self.lastRound : lastRound // ignore: cast_nullable_to_non_nullable
as bool,initiatorPlayerId: freezed == initiatorPlayerId ? _self.initiatorPlayerId : initiatorPlayerId // ignore: cast_nullable_to_non_nullable
as String?,endRoundInitiator: freezed == endRoundInitiator ? _self.endRoundInitiator : endRoundInitiator // ignore: cast_nullable_to_non_nullable
as String?,drawnCard: freezed == drawnCard ? _self.drawnCard : drawnCard // ignore: cast_nullable_to_non_nullable
as Card?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardCopyWith<$Res>? get drawnCard {
    if (_self.drawnCard == null) {
    return null;
  }

  return $CardCopyWith<$Res>(_self.drawnCard!, (value) {
    return _then(_self.copyWith(drawnCard: value));
  });
}
}

// dart format on
