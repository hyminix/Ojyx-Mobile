// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamePlayer {

 String get id; String get name; PlayerGrid get grid; List<ActionCard> get actionCards; bool get isConnected; bool get isHost; bool get hasFinishedRound; int get scoreMultiplier;
/// Create a copy of GamePlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GamePlayerCopyWith<GamePlayer> get copyWith => _$GamePlayerCopyWithImpl<GamePlayer>(this as GamePlayer, _$identity);

  /// Serializes this GamePlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GamePlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.grid, grid) || other.grid == grid)&&const DeepCollectionEquality().equals(other.actionCards, actionCards)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isHost, isHost) || other.isHost == isHost)&&(identical(other.hasFinishedRound, hasFinishedRound) || other.hasFinishedRound == hasFinishedRound)&&(identical(other.scoreMultiplier, scoreMultiplier) || other.scoreMultiplier == scoreMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,grid,const DeepCollectionEquality().hash(actionCards),isConnected,isHost,hasFinishedRound,scoreMultiplier);

@override
String toString() {
  return 'GamePlayer(id: $id, name: $name, grid: $grid, actionCards: $actionCards, isConnected: $isConnected, isHost: $isHost, hasFinishedRound: $hasFinishedRound, scoreMultiplier: $scoreMultiplier)';
}


}

/// @nodoc
abstract mixin class $GamePlayerCopyWith<$Res>  {
  factory $GamePlayerCopyWith(GamePlayer value, $Res Function(GamePlayer) _then) = _$GamePlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name, PlayerGrid grid, List<ActionCard> actionCards, bool isConnected, bool isHost, bool hasFinishedRound, int scoreMultiplier
});


$PlayerGridCopyWith<$Res> get grid;

}
/// @nodoc
class _$GamePlayerCopyWithImpl<$Res>
    implements $GamePlayerCopyWith<$Res> {
  _$GamePlayerCopyWithImpl(this._self, this._then);

  final GamePlayer _self;
  final $Res Function(GamePlayer) _then;

/// Create a copy of GamePlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? grid = null,Object? actionCards = null,Object? isConnected = null,Object? isHost = null,Object? hasFinishedRound = null,Object? scoreMultiplier = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as PlayerGrid,actionCards: null == actionCards ? _self.actionCards : actionCards // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isHost: null == isHost ? _self.isHost : isHost // ignore: cast_nullable_to_non_nullable
as bool,hasFinishedRound: null == hasFinishedRound ? _self.hasFinishedRound : hasFinishedRound // ignore: cast_nullable_to_non_nullable
as bool,scoreMultiplier: null == scoreMultiplier ? _self.scoreMultiplier : scoreMultiplier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of GamePlayer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerGridCopyWith<$Res> get grid {
  
  return $PlayerGridCopyWith<$Res>(_self.grid, (value) {
    return _then(_self.copyWith(grid: value));
  });
}
}


/// Adds pattern-matching-related methods to [GamePlayer].
extension GamePlayerPatterns on GamePlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GamePlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GamePlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GamePlayer value)  $default,){
final _that = this;
switch (_that) {
case _GamePlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GamePlayer value)?  $default,){
final _that = this;
switch (_that) {
case _GamePlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  PlayerGrid grid,  List<ActionCard> actionCards,  bool isConnected,  bool isHost,  bool hasFinishedRound,  int scoreMultiplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GamePlayer() when $default != null:
return $default(_that.id,_that.name,_that.grid,_that.actionCards,_that.isConnected,_that.isHost,_that.hasFinishedRound,_that.scoreMultiplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  PlayerGrid grid,  List<ActionCard> actionCards,  bool isConnected,  bool isHost,  bool hasFinishedRound,  int scoreMultiplier)  $default,) {final _that = this;
switch (_that) {
case _GamePlayer():
return $default(_that.id,_that.name,_that.grid,_that.actionCards,_that.isConnected,_that.isHost,_that.hasFinishedRound,_that.scoreMultiplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  PlayerGrid grid,  List<ActionCard> actionCards,  bool isConnected,  bool isHost,  bool hasFinishedRound,  int scoreMultiplier)?  $default,) {final _that = this;
switch (_that) {
case _GamePlayer() when $default != null:
return $default(_that.id,_that.name,_that.grid,_that.actionCards,_that.isConnected,_that.isHost,_that.hasFinishedRound,_that.scoreMultiplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GamePlayer extends GamePlayer {
  const _GamePlayer({required this.id, required this.name, required this.grid, final  List<ActionCard> actionCards = const [], this.isConnected = true, this.isHost = false, this.hasFinishedRound = false, this.scoreMultiplier = 1}): assert(actionCards.length <= kMaxActionCardsInHand),_actionCards = actionCards,super._();
  factory _GamePlayer.fromJson(Map<String, dynamic> json) => _$GamePlayerFromJson(json);

@override final  String id;
@override final  String name;
@override final  PlayerGrid grid;
 final  List<ActionCard> _actionCards;
@override@JsonKey() List<ActionCard> get actionCards {
  if (_actionCards is EqualUnmodifiableListView) return _actionCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionCards);
}

@override@JsonKey() final  bool isConnected;
@override@JsonKey() final  bool isHost;
@override@JsonKey() final  bool hasFinishedRound;
@override@JsonKey() final  int scoreMultiplier;

/// Create a copy of GamePlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GamePlayerCopyWith<_GamePlayer> get copyWith => __$GamePlayerCopyWithImpl<_GamePlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GamePlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GamePlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.grid, grid) || other.grid == grid)&&const DeepCollectionEquality().equals(other._actionCards, _actionCards)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.isHost, isHost) || other.isHost == isHost)&&(identical(other.hasFinishedRound, hasFinishedRound) || other.hasFinishedRound == hasFinishedRound)&&(identical(other.scoreMultiplier, scoreMultiplier) || other.scoreMultiplier == scoreMultiplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,grid,const DeepCollectionEquality().hash(_actionCards),isConnected,isHost,hasFinishedRound,scoreMultiplier);

@override
String toString() {
  return 'GamePlayer(id: $id, name: $name, grid: $grid, actionCards: $actionCards, isConnected: $isConnected, isHost: $isHost, hasFinishedRound: $hasFinishedRound, scoreMultiplier: $scoreMultiplier)';
}


}

/// @nodoc
abstract mixin class _$GamePlayerCopyWith<$Res> implements $GamePlayerCopyWith<$Res> {
  factory _$GamePlayerCopyWith(_GamePlayer value, $Res Function(_GamePlayer) _then) = __$GamePlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, PlayerGrid grid, List<ActionCard> actionCards, bool isConnected, bool isHost, bool hasFinishedRound, int scoreMultiplier
});


@override $PlayerGridCopyWith<$Res> get grid;

}
/// @nodoc
class __$GamePlayerCopyWithImpl<$Res>
    implements _$GamePlayerCopyWith<$Res> {
  __$GamePlayerCopyWithImpl(this._self, this._then);

  final _GamePlayer _self;
  final $Res Function(_GamePlayer) _then;

/// Create a copy of GamePlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? grid = null,Object? actionCards = null,Object? isConnected = null,Object? isHost = null,Object? hasFinishedRound = null,Object? scoreMultiplier = null,}) {
  return _then(_GamePlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as PlayerGrid,actionCards: null == actionCards ? _self._actionCards : actionCards // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,isHost: null == isHost ? _self.isHost : isHost // ignore: cast_nullable_to_non_nullable
as bool,hasFinishedRound: null == hasFinishedRound ? _self.hasFinishedRound : hasFinishedRound // ignore: cast_nullable_to_non_nullable
as bool,scoreMultiplier: null == scoreMultiplier ? _self.scoreMultiplier : scoreMultiplier // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GamePlayer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerGridCopyWith<$Res> get grid {
  
  return $PlayerGridCopyWith<$Res>(_self.grid, (value) {
    return _then(_self.copyWith(grid: value));
  });
}
}

// dart format on
