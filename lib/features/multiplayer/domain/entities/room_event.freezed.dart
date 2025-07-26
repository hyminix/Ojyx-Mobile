// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
RoomEvent _$RoomEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'playerJoined':
          return PlayerJoined.fromJson(
            json
          );
                case 'playerLeft':
          return PlayerLeft.fromJson(
            json
          );
                case 'gameStarted':
          return GameStarted.fromJson(
            json
          );
                case 'gameStateUpdated':
          return GameStateUpdated.fromJson(
            json
          );
                case 'playerAction':
          return PlayerAction.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'RoomEvent',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$RoomEvent {



  /// Serializes this RoomEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'RoomEvent()';
}


}

/// @nodoc
class $RoomEventCopyWith<$Res>  {
$RoomEventCopyWith(RoomEvent _, $Res Function(RoomEvent) __);
}


/// Adds pattern-matching-related methods to [RoomEvent].
extension RoomEventPatterns on RoomEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlayerJoined value)?  playerJoined,TResult Function( PlayerLeft value)?  playerLeft,TResult Function( GameStarted value)?  gameStarted,TResult Function( GameStateUpdated value)?  gameStateUpdated,TResult Function( PlayerAction value)?  playerAction,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlayerJoined() when playerJoined != null:
return playerJoined(_that);case PlayerLeft() when playerLeft != null:
return playerLeft(_that);case GameStarted() when gameStarted != null:
return gameStarted(_that);case GameStateUpdated() when gameStateUpdated != null:
return gameStateUpdated(_that);case PlayerAction() when playerAction != null:
return playerAction(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlayerJoined value)  playerJoined,required TResult Function( PlayerLeft value)  playerLeft,required TResult Function( GameStarted value)  gameStarted,required TResult Function( GameStateUpdated value)  gameStateUpdated,required TResult Function( PlayerAction value)  playerAction,}){
final _that = this;
switch (_that) {
case PlayerJoined():
return playerJoined(_that);case PlayerLeft():
return playerLeft(_that);case GameStarted():
return gameStarted(_that);case GameStateUpdated():
return gameStateUpdated(_that);case PlayerAction():
return playerAction(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlayerJoined value)?  playerJoined,TResult? Function( PlayerLeft value)?  playerLeft,TResult? Function( GameStarted value)?  gameStarted,TResult? Function( GameStateUpdated value)?  gameStateUpdated,TResult? Function( PlayerAction value)?  playerAction,}){
final _that = this;
switch (_that) {
case PlayerJoined() when playerJoined != null:
return playerJoined(_that);case PlayerLeft() when playerLeft != null:
return playerLeft(_that);case GameStarted() when gameStarted != null:
return gameStarted(_that);case GameStateUpdated() when gameStateUpdated != null:
return gameStateUpdated(_that);case PlayerAction() when playerAction != null:
return playerAction(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String playerId,  String playerName)?  playerJoined,TResult Function( String playerId)?  playerLeft,TResult Function( String gameId, @GameStateConverter()  GameState initialState)?  gameStarted,TResult Function(@GameStateConverter()  GameState newState)?  gameStateUpdated,TResult Function( String playerId,  PlayerActionType actionType,  Map<String, dynamic>? actionData)?  playerAction,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlayerJoined() when playerJoined != null:
return playerJoined(_that.playerId,_that.playerName);case PlayerLeft() when playerLeft != null:
return playerLeft(_that.playerId);case GameStarted() when gameStarted != null:
return gameStarted(_that.gameId,_that.initialState);case GameStateUpdated() when gameStateUpdated != null:
return gameStateUpdated(_that.newState);case PlayerAction() when playerAction != null:
return playerAction(_that.playerId,_that.actionType,_that.actionData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String playerId,  String playerName)  playerJoined,required TResult Function( String playerId)  playerLeft,required TResult Function( String gameId, @GameStateConverter()  GameState initialState)  gameStarted,required TResult Function(@GameStateConverter()  GameState newState)  gameStateUpdated,required TResult Function( String playerId,  PlayerActionType actionType,  Map<String, dynamic>? actionData)  playerAction,}) {final _that = this;
switch (_that) {
case PlayerJoined():
return playerJoined(_that.playerId,_that.playerName);case PlayerLeft():
return playerLeft(_that.playerId);case GameStarted():
return gameStarted(_that.gameId,_that.initialState);case GameStateUpdated():
return gameStateUpdated(_that.newState);case PlayerAction():
return playerAction(_that.playerId,_that.actionType,_that.actionData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String playerId,  String playerName)?  playerJoined,TResult? Function( String playerId)?  playerLeft,TResult? Function( String gameId, @GameStateConverter()  GameState initialState)?  gameStarted,TResult? Function(@GameStateConverter()  GameState newState)?  gameStateUpdated,TResult? Function( String playerId,  PlayerActionType actionType,  Map<String, dynamic>? actionData)?  playerAction,}) {final _that = this;
switch (_that) {
case PlayerJoined() when playerJoined != null:
return playerJoined(_that.playerId,_that.playerName);case PlayerLeft() when playerLeft != null:
return playerLeft(_that.playerId);case GameStarted() when gameStarted != null:
return gameStarted(_that.gameId,_that.initialState);case GameStateUpdated() when gameStateUpdated != null:
return gameStateUpdated(_that.newState);case PlayerAction() when playerAction != null:
return playerAction(_that.playerId,_that.actionType,_that.actionData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PlayerJoined implements RoomEvent {
  const PlayerJoined({required this.playerId, required this.playerName, final  String? $type}): $type = $type ?? 'playerJoined';
  factory PlayerJoined.fromJson(Map<String, dynamic> json) => _$PlayerJoinedFromJson(json);

 final  String playerId;
 final  String playerName;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerJoinedCopyWith<PlayerJoined> get copyWith => _$PlayerJoinedCopyWithImpl<PlayerJoined>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerJoinedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerJoined&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName);

@override
String toString() {
  return 'RoomEvent.playerJoined(playerId: $playerId, playerName: $playerName)';
}


}

/// @nodoc
abstract mixin class $PlayerJoinedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $PlayerJoinedCopyWith(PlayerJoined value, $Res Function(PlayerJoined) _then) = _$PlayerJoinedCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName
});




}
/// @nodoc
class _$PlayerJoinedCopyWithImpl<$Res>
    implements $PlayerJoinedCopyWith<$Res> {
  _$PlayerJoinedCopyWithImpl(this._self, this._then);

  final PlayerJoined _self;
  final $Res Function(PlayerJoined) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,}) {
  return _then(PlayerJoined(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlayerLeft implements RoomEvent {
  const PlayerLeft({required this.playerId, final  String? $type}): $type = $type ?? 'playerLeft';
  factory PlayerLeft.fromJson(Map<String, dynamic> json) => _$PlayerLeftFromJson(json);

 final  String playerId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerLeftCopyWith<PlayerLeft> get copyWith => _$PlayerLeftCopyWithImpl<PlayerLeft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerLeftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerLeft&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'RoomEvent.playerLeft(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $PlayerLeftCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $PlayerLeftCopyWith(PlayerLeft value, $Res Function(PlayerLeft) _then) = _$PlayerLeftCopyWithImpl;
@useResult
$Res call({
 String playerId
});




}
/// @nodoc
class _$PlayerLeftCopyWithImpl<$Res>
    implements $PlayerLeftCopyWith<$Res> {
  _$PlayerLeftCopyWithImpl(this._self, this._then);

  final PlayerLeft _self;
  final $Res Function(PlayerLeft) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(PlayerLeft(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GameStarted implements RoomEvent {
  const GameStarted({required this.gameId, @GameStateConverter() required this.initialState, final  String? $type}): $type = $type ?? 'gameStarted';
  factory GameStarted.fromJson(Map<String, dynamic> json) => _$GameStartedFromJson(json);

 final  String gameId;
@GameStateConverter() final  GameState initialState;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStartedCopyWith<GameStarted> get copyWith => _$GameStartedCopyWithImpl<GameStarted>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStartedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStarted&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.initialState, initialState) || other.initialState == initialState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,initialState);

@override
String toString() {
  return 'RoomEvent.gameStarted(gameId: $gameId, initialState: $initialState)';
}


}

/// @nodoc
abstract mixin class $GameStartedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $GameStartedCopyWith(GameStarted value, $Res Function(GameStarted) _then) = _$GameStartedCopyWithImpl;
@useResult
$Res call({
 String gameId,@GameStateConverter() GameState initialState
});


$GameStateCopyWith<$Res> get initialState;

}
/// @nodoc
class _$GameStartedCopyWithImpl<$Res>
    implements $GameStartedCopyWith<$Res> {
  _$GameStartedCopyWithImpl(this._self, this._then);

  final GameStarted _self;
  final $Res Function(GameStarted) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? initialState = null,}) {
  return _then(GameStarted(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,initialState: null == initialState ? _self.initialState : initialState // ignore: cast_nullable_to_non_nullable
as GameState,
  ));
}

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateCopyWith<$Res> get initialState {
  
  return $GameStateCopyWith<$Res>(_self.initialState, (value) {
    return _then(_self.copyWith(initialState: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class GameStateUpdated implements RoomEvent {
  const GameStateUpdated({@GameStateConverter() required this.newState, final  String? $type}): $type = $type ?? 'gameStateUpdated';
  factory GameStateUpdated.fromJson(Map<String, dynamic> json) => _$GameStateUpdatedFromJson(json);

@GameStateConverter() final  GameState newState;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateUpdatedCopyWith<GameStateUpdated> get copyWith => _$GameStateUpdatedCopyWithImpl<GameStateUpdated>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateUpdatedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStateUpdated&&(identical(other.newState, newState) || other.newState == newState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,newState);

@override
String toString() {
  return 'RoomEvent.gameStateUpdated(newState: $newState)';
}


}

/// @nodoc
abstract mixin class $GameStateUpdatedCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $GameStateUpdatedCopyWith(GameStateUpdated value, $Res Function(GameStateUpdated) _then) = _$GameStateUpdatedCopyWithImpl;
@useResult
$Res call({
@GameStateConverter() GameState newState
});


$GameStateCopyWith<$Res> get newState;

}
/// @nodoc
class _$GameStateUpdatedCopyWithImpl<$Res>
    implements $GameStateUpdatedCopyWith<$Res> {
  _$GameStateUpdatedCopyWithImpl(this._self, this._then);

  final GameStateUpdated _self;
  final $Res Function(GameStateUpdated) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? newState = null,}) {
  return _then(GameStateUpdated(
newState: null == newState ? _self.newState : newState // ignore: cast_nullable_to_non_nullable
as GameState,
  ));
}

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateCopyWith<$Res> get newState {
  
  return $GameStateCopyWith<$Res>(_self.newState, (value) {
    return _then(_self.copyWith(newState: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class PlayerAction implements RoomEvent {
  const PlayerAction({required this.playerId, required this.actionType, final  Map<String, dynamic>? actionData, final  String? $type}): _actionData = actionData,$type = $type ?? 'playerAction';
  factory PlayerAction.fromJson(Map<String, dynamic> json) => _$PlayerActionFromJson(json);

 final  String playerId;
 final  PlayerActionType actionType;
 final  Map<String, dynamic>? _actionData;
 Map<String, dynamic>? get actionData {
  final value = _actionData;
  if (value == null) return null;
  if (_actionData is EqualUnmodifiableMapView) return _actionData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerActionCopyWith<PlayerAction> get copyWith => _$PlayerActionCopyWithImpl<PlayerAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAction&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&const DeepCollectionEquality().equals(other._actionData, _actionData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,actionType,const DeepCollectionEquality().hash(_actionData));

@override
String toString() {
  return 'RoomEvent.playerAction(playerId: $playerId, actionType: $actionType, actionData: $actionData)';
}


}

/// @nodoc
abstract mixin class $PlayerActionCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory $PlayerActionCopyWith(PlayerAction value, $Res Function(PlayerAction) _then) = _$PlayerActionCopyWithImpl;
@useResult
$Res call({
 String playerId, PlayerActionType actionType, Map<String, dynamic>? actionData
});




}
/// @nodoc
class _$PlayerActionCopyWithImpl<$Res>
    implements $PlayerActionCopyWith<$Res> {
  _$PlayerActionCopyWithImpl(this._self, this._then);

  final PlayerAction _self;
  final $Res Function(PlayerAction) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? actionType = null,Object? actionData = freezed,}) {
  return _then(PlayerAction(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as PlayerActionType,actionData: freezed == actionData ? _self._actionData : actionData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
