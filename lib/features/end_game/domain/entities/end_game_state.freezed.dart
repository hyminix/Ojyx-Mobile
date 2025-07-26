// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'end_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EndGameState {

 List<GamePlayer> get players; String get roundInitiatorId; int get roundNumber; Map<String, bool> get playersVotes;
/// Create a copy of EndGameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndGameStateCopyWith<EndGameState> get copyWith => _$EndGameStateCopyWithImpl<EndGameState>(this as EndGameState, _$identity);

  /// Serializes this EndGameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndGameState&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.roundInitiatorId, roundInitiatorId) || other.roundInitiatorId == roundInitiatorId)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&const DeepCollectionEquality().equals(other.playersVotes, playersVotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),roundInitiatorId,roundNumber,const DeepCollectionEquality().hash(playersVotes));

@override
String toString() {
  return 'EndGameState(players: $players, roundInitiatorId: $roundInitiatorId, roundNumber: $roundNumber, playersVotes: $playersVotes)';
}


}

/// @nodoc
abstract mixin class $EndGameStateCopyWith<$Res>  {
  factory $EndGameStateCopyWith(EndGameState value, $Res Function(EndGameState) _then) = _$EndGameStateCopyWithImpl;
@useResult
$Res call({
 List<GamePlayer> players, String roundInitiatorId, int roundNumber, Map<String, bool> playersVotes
});




}
/// @nodoc
class _$EndGameStateCopyWithImpl<$Res>
    implements $EndGameStateCopyWith<$Res> {
  _$EndGameStateCopyWithImpl(this._self, this._then);

  final EndGameState _self;
  final $Res Function(EndGameState) _then;

/// Create a copy of EndGameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? roundInitiatorId = null,Object? roundNumber = null,Object? playersVotes = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<GamePlayer>,roundInitiatorId: null == roundInitiatorId ? _self.roundInitiatorId : roundInitiatorId // ignore: cast_nullable_to_non_nullable
as String,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,playersVotes: null == playersVotes ? _self.playersVotes : playersVotes // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}

}


/// Adds pattern-matching-related methods to [EndGameState].
extension EndGameStatePatterns on EndGameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndGameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndGameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndGameState value)  $default,){
final _that = this;
switch (_that) {
case _EndGameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndGameState value)?  $default,){
final _that = this;
switch (_that) {
case _EndGameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GamePlayer> players,  String roundInitiatorId,  int roundNumber,  Map<String, bool> playersVotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndGameState() when $default != null:
return $default(_that.players,_that.roundInitiatorId,_that.roundNumber,_that.playersVotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GamePlayer> players,  String roundInitiatorId,  int roundNumber,  Map<String, bool> playersVotes)  $default,) {final _that = this;
switch (_that) {
case _EndGameState():
return $default(_that.players,_that.roundInitiatorId,_that.roundNumber,_that.playersVotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GamePlayer> players,  String roundInitiatorId,  int roundNumber,  Map<String, bool> playersVotes)?  $default,) {final _that = this;
switch (_that) {
case _EndGameState() when $default != null:
return $default(_that.players,_that.roundInitiatorId,_that.roundNumber,_that.playersVotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndGameState extends EndGameState {
  const _EndGameState({required final  List<GamePlayer> players, required this.roundInitiatorId, required this.roundNumber, final  Map<String, bool> playersVotes = const {}}): _players = players,_playersVotes = playersVotes,super._();
  factory _EndGameState.fromJson(Map<String, dynamic> json) => _$EndGameStateFromJson(json);

 final  List<GamePlayer> _players;
@override List<GamePlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  String roundInitiatorId;
@override final  int roundNumber;
 final  Map<String, bool> _playersVotes;
@override@JsonKey() Map<String, bool> get playersVotes {
  if (_playersVotes is EqualUnmodifiableMapView) return _playersVotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_playersVotes);
}


/// Create a copy of EndGameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndGameStateCopyWith<_EndGameState> get copyWith => __$EndGameStateCopyWithImpl<_EndGameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndGameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndGameState&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.roundInitiatorId, roundInitiatorId) || other.roundInitiatorId == roundInitiatorId)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&const DeepCollectionEquality().equals(other._playersVotes, _playersVotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),roundInitiatorId,roundNumber,const DeepCollectionEquality().hash(_playersVotes));

@override
String toString() {
  return 'EndGameState(players: $players, roundInitiatorId: $roundInitiatorId, roundNumber: $roundNumber, playersVotes: $playersVotes)';
}


}

/// @nodoc
abstract mixin class _$EndGameStateCopyWith<$Res> implements $EndGameStateCopyWith<$Res> {
  factory _$EndGameStateCopyWith(_EndGameState value, $Res Function(_EndGameState) _then) = __$EndGameStateCopyWithImpl;
@override @useResult
$Res call({
 List<GamePlayer> players, String roundInitiatorId, int roundNumber, Map<String, bool> playersVotes
});




}
/// @nodoc
class __$EndGameStateCopyWithImpl<$Res>
    implements _$EndGameStateCopyWith<$Res> {
  __$EndGameStateCopyWithImpl(this._self, this._then);

  final _EndGameState _self;
  final $Res Function(_EndGameState) _then;

/// Create a copy of EndGameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? roundInitiatorId = null,Object? roundNumber = null,Object? playersVotes = null,}) {
  return _then(_EndGameState(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<GamePlayer>,roundInitiatorId: null == roundInitiatorId ? _self.roundInitiatorId : roundInitiatorId // ignore: cast_nullable_to_non_nullable
as String,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,playersVotes: null == playersVotes ? _self._playersVotes : playersVotes // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,
  ));
}


}

// dart format on
