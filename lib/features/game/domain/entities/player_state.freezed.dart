// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerState {

 String get playerId; List<Card?> get cards; int get currentScore; int get revealedCount; List<int> get identicalColumns; bool get hasFinished;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other.cards, cards)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.revealedCount, revealedCount) || other.revealedCount == revealedCount)&&const DeepCollectionEquality().equals(other.identicalColumns, identicalColumns)&&(identical(other.hasFinished, hasFinished) || other.hasFinished == hasFinished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,const DeepCollectionEquality().hash(cards),currentScore,revealedCount,const DeepCollectionEquality().hash(identicalColumns),hasFinished);

@override
String toString() {
  return 'PlayerState(playerId: $playerId, cards: $cards, currentScore: $currentScore, revealedCount: $revealedCount, identicalColumns: $identicalColumns, hasFinished: $hasFinished)';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 String playerId, List<Card?> cards, int currentScore, int revealedCount, List<int> identicalColumns, bool hasFinished
});




}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? cards = null,Object? currentScore = null,Object? revealedCount = null,Object? identicalColumns = null,Object? hasFinished = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<Card?>,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as int,revealedCount: null == revealedCount ? _self.revealedCount : revealedCount // ignore: cast_nullable_to_non_nullable
as int,identicalColumns: null == identicalColumns ? _self.identicalColumns : identicalColumns // ignore: cast_nullable_to_non_nullable
as List<int>,hasFinished: null == hasFinished ? _self.hasFinished : hasFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  List<Card?> cards,  int currentScore,  int revealedCount,  List<int> identicalColumns,  bool hasFinished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.playerId,_that.cards,_that.currentScore,_that.revealedCount,_that.identicalColumns,_that.hasFinished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  List<Card?> cards,  int currentScore,  int revealedCount,  List<int> identicalColumns,  bool hasFinished)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.playerId,_that.cards,_that.currentScore,_that.revealedCount,_that.identicalColumns,_that.hasFinished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  List<Card?> cards,  int currentScore,  int revealedCount,  List<int> identicalColumns,  bool hasFinished)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.playerId,_that.cards,_that.currentScore,_that.revealedCount,_that.identicalColumns,_that.hasFinished);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerState implements PlayerState {
  const _PlayerState({required this.playerId, required final  List<Card?> cards, required this.currentScore, required this.revealedCount, required final  List<int> identicalColumns, required this.hasFinished}): _cards = cards,_identicalColumns = identicalColumns;
  factory _PlayerState.fromJson(Map<String, dynamic> json) => _$PlayerStateFromJson(json);

@override final  String playerId;
 final  List<Card?> _cards;
@override List<Card?> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

@override final  int currentScore;
@override final  int revealedCount;
 final  List<int> _identicalColumns;
@override List<int> get identicalColumns {
  if (_identicalColumns is EqualUnmodifiableListView) return _identicalColumns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_identicalColumns);
}

@override final  bool hasFinished;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other._cards, _cards)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.revealedCount, revealedCount) || other.revealedCount == revealedCount)&&const DeepCollectionEquality().equals(other._identicalColumns, _identicalColumns)&&(identical(other.hasFinished, hasFinished) || other.hasFinished == hasFinished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,const DeepCollectionEquality().hash(_cards),currentScore,revealedCount,const DeepCollectionEquality().hash(_identicalColumns),hasFinished);

@override
String toString() {
  return 'PlayerState(playerId: $playerId, cards: $cards, currentScore: $currentScore, revealedCount: $revealedCount, identicalColumns: $identicalColumns, hasFinished: $hasFinished)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 String playerId, List<Card?> cards, int currentScore, int revealedCount, List<int> identicalColumns, bool hasFinished
});




}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? cards = null,Object? currentScore = null,Object? revealedCount = null,Object? identicalColumns = null,Object? hasFinished = null,}) {
  return _then(_PlayerState(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<Card?>,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as int,revealedCount: null == revealedCount ? _self.revealedCount : revealedCount // ignore: cast_nullable_to_non_nullable
as int,identicalColumns: null == identicalColumns ? _self._identicalColumns : identicalColumns // ignore: cast_nullable_to_non_nullable
as List<int>,hasFinished: null == hasFinished ? _self.hasFinished : hasFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
