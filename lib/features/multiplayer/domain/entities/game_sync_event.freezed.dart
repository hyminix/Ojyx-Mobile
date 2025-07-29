// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_sync_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
GameSyncEvent _$GameSyncEventFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'playerJoined':
          return PlayerJoinedEvent.fromJson(
            json
          );
                case 'playerLeft':
          return PlayerLeftEvent.fromJson(
            json
          );
                case 'gameStateUpdated':
          return GameStateUpdatedEvent.fromJson(
            json
          );
                case 'cardRevealed':
          return CardRevealedEvent.fromJson(
            json
          );
                case 'actionCardPlayed':
          return ActionCardPlayedEvent.fromJson(
            json
          );
                case 'turnChanged':
          return TurnChangedEvent.fromJson(
            json
          );
                case 'roomSettingsChanged':
          return RoomSettingsChangedEvent.fromJson(
            json
          );
                case 'gameStarted':
          return GameStartedEvent.fromJson(
            json
          );
                case 'gameEnded':
          return GameEndedEvent.fromJson(
            json
          );
                case 'playerDisconnected':
          return PlayerDisconnectedEvent.fromJson(
            json
          );
                case 'playerReconnected':
          return PlayerReconnectedEvent.fromJson(
            json
          );
                case 'chatMessage':
          return ChatMessageEvent.fromJson(
            json
          );
                case 'syncError':
          return SyncErrorEvent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'GameSyncEvent',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$GameSyncEvent {



  /// Serializes this GameSyncEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSyncEvent);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GameSyncEvent()';
}


}

/// @nodoc
class $GameSyncEventCopyWith<$Res>  {
$GameSyncEventCopyWith(GameSyncEvent _, $Res Function(GameSyncEvent) __);
}


/// Adds pattern-matching-related methods to [GameSyncEvent].
extension GameSyncEventPatterns on GameSyncEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PlayerJoinedEvent value)?  playerJoined,TResult Function( PlayerLeftEvent value)?  playerLeft,TResult Function( GameStateUpdatedEvent value)?  gameStateUpdated,TResult Function( CardRevealedEvent value)?  cardRevealed,TResult Function( ActionCardPlayedEvent value)?  actionCardPlayed,TResult Function( TurnChangedEvent value)?  turnChanged,TResult Function( RoomSettingsChangedEvent value)?  roomSettingsChanged,TResult Function( GameStartedEvent value)?  gameStarted,TResult Function( GameEndedEvent value)?  gameEnded,TResult Function( PlayerDisconnectedEvent value)?  playerDisconnected,TResult Function( PlayerReconnectedEvent value)?  playerReconnected,TResult Function( ChatMessageEvent value)?  chatMessage,TResult Function( SyncErrorEvent value)?  syncError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PlayerJoinedEvent() when playerJoined != null:
return playerJoined(_that);case PlayerLeftEvent() when playerLeft != null:
return playerLeft(_that);case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that);case CardRevealedEvent() when cardRevealed != null:
return cardRevealed(_that);case ActionCardPlayedEvent() when actionCardPlayed != null:
return actionCardPlayed(_that);case TurnChangedEvent() when turnChanged != null:
return turnChanged(_that);case RoomSettingsChangedEvent() when roomSettingsChanged != null:
return roomSettingsChanged(_that);case GameStartedEvent() when gameStarted != null:
return gameStarted(_that);case GameEndedEvent() when gameEnded != null:
return gameEnded(_that);case PlayerDisconnectedEvent() when playerDisconnected != null:
return playerDisconnected(_that);case PlayerReconnectedEvent() when playerReconnected != null:
return playerReconnected(_that);case ChatMessageEvent() when chatMessage != null:
return chatMessage(_that);case SyncErrorEvent() when syncError != null:
return syncError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PlayerJoinedEvent value)  playerJoined,required TResult Function( PlayerLeftEvent value)  playerLeft,required TResult Function( GameStateUpdatedEvent value)  gameStateUpdated,required TResult Function( CardRevealedEvent value)  cardRevealed,required TResult Function( ActionCardPlayedEvent value)  actionCardPlayed,required TResult Function( TurnChangedEvent value)  turnChanged,required TResult Function( RoomSettingsChangedEvent value)  roomSettingsChanged,required TResult Function( GameStartedEvent value)  gameStarted,required TResult Function( GameEndedEvent value)  gameEnded,required TResult Function( PlayerDisconnectedEvent value)  playerDisconnected,required TResult Function( PlayerReconnectedEvent value)  playerReconnected,required TResult Function( ChatMessageEvent value)  chatMessage,required TResult Function( SyncErrorEvent value)  syncError,}){
final _that = this;
switch (_that) {
case PlayerJoinedEvent():
return playerJoined(_that);case PlayerLeftEvent():
return playerLeft(_that);case GameStateUpdatedEvent():
return gameStateUpdated(_that);case CardRevealedEvent():
return cardRevealed(_that);case ActionCardPlayedEvent():
return actionCardPlayed(_that);case TurnChangedEvent():
return turnChanged(_that);case RoomSettingsChangedEvent():
return roomSettingsChanged(_that);case GameStartedEvent():
return gameStarted(_that);case GameEndedEvent():
return gameEnded(_that);case PlayerDisconnectedEvent():
return playerDisconnected(_that);case PlayerReconnectedEvent():
return playerReconnected(_that);case ChatMessageEvent():
return chatMessage(_that);case SyncErrorEvent():
return syncError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PlayerJoinedEvent value)?  playerJoined,TResult? Function( PlayerLeftEvent value)?  playerLeft,TResult? Function( GameStateUpdatedEvent value)?  gameStateUpdated,TResult? Function( CardRevealedEvent value)?  cardRevealed,TResult? Function( ActionCardPlayedEvent value)?  actionCardPlayed,TResult? Function( TurnChangedEvent value)?  turnChanged,TResult? Function( RoomSettingsChangedEvent value)?  roomSettingsChanged,TResult? Function( GameStartedEvent value)?  gameStarted,TResult? Function( GameEndedEvent value)?  gameEnded,TResult? Function( PlayerDisconnectedEvent value)?  playerDisconnected,TResult? Function( PlayerReconnectedEvent value)?  playerReconnected,TResult? Function( ChatMessageEvent value)?  chatMessage,TResult? Function( SyncErrorEvent value)?  syncError,}){
final _that = this;
switch (_that) {
case PlayerJoinedEvent() when playerJoined != null:
return playerJoined(_that);case PlayerLeftEvent() when playerLeft != null:
return playerLeft(_that);case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that);case CardRevealedEvent() when cardRevealed != null:
return cardRevealed(_that);case ActionCardPlayedEvent() when actionCardPlayed != null:
return actionCardPlayed(_that);case TurnChangedEvent() when turnChanged != null:
return turnChanged(_that);case RoomSettingsChangedEvent() when roomSettingsChanged != null:
return roomSettingsChanged(_that);case GameStartedEvent() when gameStarted != null:
return gameStarted(_that);case GameEndedEvent() when gameEnded != null:
return gameEnded(_that);case PlayerDisconnectedEvent() when playerDisconnected != null:
return playerDisconnected(_that);case PlayerReconnectedEvent() when playerReconnected != null:
return playerReconnected(_that);case ChatMessageEvent() when chatMessage != null:
return chatMessage(_that);case SyncErrorEvent() when syncError != null:
return syncError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( LobbyPlayer player,  DateTime timestamp)?  playerJoined,TResult Function( String playerId,  DateTime timestamp,  bool isTimeout)?  playerLeft,TResult Function(@GameStateConverter()  GameState gameState,  DateTime timestamp,  String? triggeredBy)?  gameStateUpdated,TResult Function( String playerId,  int row,  int col,  Card card,  DateTime timestamp)?  cardRevealed,TResult Function( String playerId,  ActionCard actionCard,  Map<String, dynamic> actionData,  DateTime timestamp)?  actionCardPlayed,TResult Function( String previousPlayerId,  String currentPlayerId,  int turnNumber,  DateTime timestamp)?  turnChanged,TResult Function( Map<String, dynamic> settings,  DateTime timestamp,  String changedBy)?  roomSettingsChanged,TResult Function( String roomId,  String gameId,  List<String> playerIds,  DateTime timestamp)?  gameStarted,TResult Function( String gameId,  Map<String, int> finalScores,  String winnerId,  DateTime timestamp)?  gameEnded,TResult Function( String playerId,  DateTime disconnectedAt,  DateTime timeoutAt)?  playerDisconnected,TResult Function( String playerId,  DateTime reconnectedAt)?  playerReconnected,TResult Function( String playerId,  String message,  DateTime timestamp)?  chatMessage,TResult Function( String errorType,  String message,  DateTime timestamp,  Map<String, dynamic>? context)?  syncError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PlayerJoinedEvent() when playerJoined != null:
return playerJoined(_that.player,_that.timestamp);case PlayerLeftEvent() when playerLeft != null:
return playerLeft(_that.playerId,_that.timestamp,_that.isTimeout);case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that.gameState,_that.timestamp,_that.triggeredBy);case CardRevealedEvent() when cardRevealed != null:
return cardRevealed(_that.playerId,_that.row,_that.col,_that.card,_that.timestamp);case ActionCardPlayedEvent() when actionCardPlayed != null:
return actionCardPlayed(_that.playerId,_that.actionCard,_that.actionData,_that.timestamp);case TurnChangedEvent() when turnChanged != null:
return turnChanged(_that.previousPlayerId,_that.currentPlayerId,_that.turnNumber,_that.timestamp);case RoomSettingsChangedEvent() when roomSettingsChanged != null:
return roomSettingsChanged(_that.settings,_that.timestamp,_that.changedBy);case GameStartedEvent() when gameStarted != null:
return gameStarted(_that.roomId,_that.gameId,_that.playerIds,_that.timestamp);case GameEndedEvent() when gameEnded != null:
return gameEnded(_that.gameId,_that.finalScores,_that.winnerId,_that.timestamp);case PlayerDisconnectedEvent() when playerDisconnected != null:
return playerDisconnected(_that.playerId,_that.disconnectedAt,_that.timeoutAt);case PlayerReconnectedEvent() when playerReconnected != null:
return playerReconnected(_that.playerId,_that.reconnectedAt);case ChatMessageEvent() when chatMessage != null:
return chatMessage(_that.playerId,_that.message,_that.timestamp);case SyncErrorEvent() when syncError != null:
return syncError(_that.errorType,_that.message,_that.timestamp,_that.context);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( LobbyPlayer player,  DateTime timestamp)  playerJoined,required TResult Function( String playerId,  DateTime timestamp,  bool isTimeout)  playerLeft,required TResult Function(@GameStateConverter()  GameState gameState,  DateTime timestamp,  String? triggeredBy)  gameStateUpdated,required TResult Function( String playerId,  int row,  int col,  Card card,  DateTime timestamp)  cardRevealed,required TResult Function( String playerId,  ActionCard actionCard,  Map<String, dynamic> actionData,  DateTime timestamp)  actionCardPlayed,required TResult Function( String previousPlayerId,  String currentPlayerId,  int turnNumber,  DateTime timestamp)  turnChanged,required TResult Function( Map<String, dynamic> settings,  DateTime timestamp,  String changedBy)  roomSettingsChanged,required TResult Function( String roomId,  String gameId,  List<String> playerIds,  DateTime timestamp)  gameStarted,required TResult Function( String gameId,  Map<String, int> finalScores,  String winnerId,  DateTime timestamp)  gameEnded,required TResult Function( String playerId,  DateTime disconnectedAt,  DateTime timeoutAt)  playerDisconnected,required TResult Function( String playerId,  DateTime reconnectedAt)  playerReconnected,required TResult Function( String playerId,  String message,  DateTime timestamp)  chatMessage,required TResult Function( String errorType,  String message,  DateTime timestamp,  Map<String, dynamic>? context)  syncError,}) {final _that = this;
switch (_that) {
case PlayerJoinedEvent():
return playerJoined(_that.player,_that.timestamp);case PlayerLeftEvent():
return playerLeft(_that.playerId,_that.timestamp,_that.isTimeout);case GameStateUpdatedEvent():
return gameStateUpdated(_that.gameState,_that.timestamp,_that.triggeredBy);case CardRevealedEvent():
return cardRevealed(_that.playerId,_that.row,_that.col,_that.card,_that.timestamp);case ActionCardPlayedEvent():
return actionCardPlayed(_that.playerId,_that.actionCard,_that.actionData,_that.timestamp);case TurnChangedEvent():
return turnChanged(_that.previousPlayerId,_that.currentPlayerId,_that.turnNumber,_that.timestamp);case RoomSettingsChangedEvent():
return roomSettingsChanged(_that.settings,_that.timestamp,_that.changedBy);case GameStartedEvent():
return gameStarted(_that.roomId,_that.gameId,_that.playerIds,_that.timestamp);case GameEndedEvent():
return gameEnded(_that.gameId,_that.finalScores,_that.winnerId,_that.timestamp);case PlayerDisconnectedEvent():
return playerDisconnected(_that.playerId,_that.disconnectedAt,_that.timeoutAt);case PlayerReconnectedEvent():
return playerReconnected(_that.playerId,_that.reconnectedAt);case ChatMessageEvent():
return chatMessage(_that.playerId,_that.message,_that.timestamp);case SyncErrorEvent():
return syncError(_that.errorType,_that.message,_that.timestamp,_that.context);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( LobbyPlayer player,  DateTime timestamp)?  playerJoined,TResult? Function( String playerId,  DateTime timestamp,  bool isTimeout)?  playerLeft,TResult? Function(@GameStateConverter()  GameState gameState,  DateTime timestamp,  String? triggeredBy)?  gameStateUpdated,TResult? Function( String playerId,  int row,  int col,  Card card,  DateTime timestamp)?  cardRevealed,TResult? Function( String playerId,  ActionCard actionCard,  Map<String, dynamic> actionData,  DateTime timestamp)?  actionCardPlayed,TResult? Function( String previousPlayerId,  String currentPlayerId,  int turnNumber,  DateTime timestamp)?  turnChanged,TResult? Function( Map<String, dynamic> settings,  DateTime timestamp,  String changedBy)?  roomSettingsChanged,TResult? Function( String roomId,  String gameId,  List<String> playerIds,  DateTime timestamp)?  gameStarted,TResult? Function( String gameId,  Map<String, int> finalScores,  String winnerId,  DateTime timestamp)?  gameEnded,TResult? Function( String playerId,  DateTime disconnectedAt,  DateTime timeoutAt)?  playerDisconnected,TResult? Function( String playerId,  DateTime reconnectedAt)?  playerReconnected,TResult? Function( String playerId,  String message,  DateTime timestamp)?  chatMessage,TResult? Function( String errorType,  String message,  DateTime timestamp,  Map<String, dynamic>? context)?  syncError,}) {final _that = this;
switch (_that) {
case PlayerJoinedEvent() when playerJoined != null:
return playerJoined(_that.player,_that.timestamp);case PlayerLeftEvent() when playerLeft != null:
return playerLeft(_that.playerId,_that.timestamp,_that.isTimeout);case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that.gameState,_that.timestamp,_that.triggeredBy);case CardRevealedEvent() when cardRevealed != null:
return cardRevealed(_that.playerId,_that.row,_that.col,_that.card,_that.timestamp);case ActionCardPlayedEvent() when actionCardPlayed != null:
return actionCardPlayed(_that.playerId,_that.actionCard,_that.actionData,_that.timestamp);case TurnChangedEvent() when turnChanged != null:
return turnChanged(_that.previousPlayerId,_that.currentPlayerId,_that.turnNumber,_that.timestamp);case RoomSettingsChangedEvent() when roomSettingsChanged != null:
return roomSettingsChanged(_that.settings,_that.timestamp,_that.changedBy);case GameStartedEvent() when gameStarted != null:
return gameStarted(_that.roomId,_that.gameId,_that.playerIds,_that.timestamp);case GameEndedEvent() when gameEnded != null:
return gameEnded(_that.gameId,_that.finalScores,_that.winnerId,_that.timestamp);case PlayerDisconnectedEvent() when playerDisconnected != null:
return playerDisconnected(_that.playerId,_that.disconnectedAt,_that.timeoutAt);case PlayerReconnectedEvent() when playerReconnected != null:
return playerReconnected(_that.playerId,_that.reconnectedAt);case ChatMessageEvent() when chatMessage != null:
return chatMessage(_that.playerId,_that.message,_that.timestamp);case SyncErrorEvent() when syncError != null:
return syncError(_that.errorType,_that.message,_that.timestamp,_that.context);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PlayerJoinedEvent extends GameSyncEvent {
  const PlayerJoinedEvent({required this.player, required this.timestamp, final  String? $type}): $type = $type ?? 'playerJoined',super._();
  factory PlayerJoinedEvent.fromJson(Map<String, dynamic> json) => _$PlayerJoinedEventFromJson(json);

 final  LobbyPlayer player;
 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerJoinedEventCopyWith<PlayerJoinedEvent> get copyWith => _$PlayerJoinedEventCopyWithImpl<PlayerJoinedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerJoinedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerJoinedEvent&&(identical(other.player, player) || other.player == player)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,player,timestamp);

@override
String toString() {
  return 'GameSyncEvent.playerJoined(player: $player, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $PlayerJoinedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $PlayerJoinedEventCopyWith(PlayerJoinedEvent value, $Res Function(PlayerJoinedEvent) _then) = _$PlayerJoinedEventCopyWithImpl;
@useResult
$Res call({
 LobbyPlayer player, DateTime timestamp
});


$LobbyPlayerCopyWith<$Res> get player;

}
/// @nodoc
class _$PlayerJoinedEventCopyWithImpl<$Res>
    implements $PlayerJoinedEventCopyWith<$Res> {
  _$PlayerJoinedEventCopyWithImpl(this._self, this._then);

  final PlayerJoinedEvent _self;
  final $Res Function(PlayerJoinedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? player = null,Object? timestamp = null,}) {
  return _then(PlayerJoinedEvent(
player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as LobbyPlayer,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LobbyPlayerCopyWith<$Res> get player {
  
  return $LobbyPlayerCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class PlayerLeftEvent extends GameSyncEvent {
  const PlayerLeftEvent({required this.playerId, required this.timestamp, this.isTimeout = false, final  String? $type}): $type = $type ?? 'playerLeft',super._();
  factory PlayerLeftEvent.fromJson(Map<String, dynamic> json) => _$PlayerLeftEventFromJson(json);

 final  String playerId;
 final  DateTime timestamp;
@JsonKey() final  bool isTimeout;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerLeftEventCopyWith<PlayerLeftEvent> get copyWith => _$PlayerLeftEventCopyWithImpl<PlayerLeftEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerLeftEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerLeftEvent&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isTimeout, isTimeout) || other.isTimeout == isTimeout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,timestamp,isTimeout);

@override
String toString() {
  return 'GameSyncEvent.playerLeft(playerId: $playerId, timestamp: $timestamp, isTimeout: $isTimeout)';
}


}

/// @nodoc
abstract mixin class $PlayerLeftEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $PlayerLeftEventCopyWith(PlayerLeftEvent value, $Res Function(PlayerLeftEvent) _then) = _$PlayerLeftEventCopyWithImpl;
@useResult
$Res call({
 String playerId, DateTime timestamp, bool isTimeout
});




}
/// @nodoc
class _$PlayerLeftEventCopyWithImpl<$Res>
    implements $PlayerLeftEventCopyWith<$Res> {
  _$PlayerLeftEventCopyWithImpl(this._self, this._then);

  final PlayerLeftEvent _self;
  final $Res Function(PlayerLeftEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? timestamp = null,Object? isTimeout = null,}) {
  return _then(PlayerLeftEvent(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isTimeout: null == isTimeout ? _self.isTimeout : isTimeout // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GameStateUpdatedEvent extends GameSyncEvent {
  const GameStateUpdatedEvent({@GameStateConverter() required this.gameState, required this.timestamp, this.triggeredBy, final  String? $type}): $type = $type ?? 'gameStateUpdated',super._();
  factory GameStateUpdatedEvent.fromJson(Map<String, dynamic> json) => _$GameStateUpdatedEventFromJson(json);

@GameStateConverter() final  GameState gameState;
 final  DateTime timestamp;
 final  String? triggeredBy;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateUpdatedEventCopyWith<GameStateUpdatedEvent> get copyWith => _$GameStateUpdatedEventCopyWithImpl<GameStateUpdatedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateUpdatedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStateUpdatedEvent&&(identical(other.gameState, gameState) || other.gameState == gameState)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.triggeredBy, triggeredBy) || other.triggeredBy == triggeredBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameState,timestamp,triggeredBy);

@override
String toString() {
  return 'GameSyncEvent.gameStateUpdated(gameState: $gameState, timestamp: $timestamp, triggeredBy: $triggeredBy)';
}


}

/// @nodoc
abstract mixin class $GameStateUpdatedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $GameStateUpdatedEventCopyWith(GameStateUpdatedEvent value, $Res Function(GameStateUpdatedEvent) _then) = _$GameStateUpdatedEventCopyWithImpl;
@useResult
$Res call({
@GameStateConverter() GameState gameState, DateTime timestamp, String? triggeredBy
});


$GameStateCopyWith<$Res> get gameState;

}
/// @nodoc
class _$GameStateUpdatedEventCopyWithImpl<$Res>
    implements $GameStateUpdatedEventCopyWith<$Res> {
  _$GameStateUpdatedEventCopyWithImpl(this._self, this._then);

  final GameStateUpdatedEvent _self;
  final $Res Function(GameStateUpdatedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gameState = null,Object? timestamp = null,Object? triggeredBy = freezed,}) {
  return _then(GameStateUpdatedEvent(
gameState: null == gameState ? _self.gameState : gameState // ignore: cast_nullable_to_non_nullable
as GameState,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,triggeredBy: freezed == triggeredBy ? _self.triggeredBy : triggeredBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameStateCopyWith<$Res> get gameState {
  
  return $GameStateCopyWith<$Res>(_self.gameState, (value) {
    return _then(_self.copyWith(gameState: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class CardRevealedEvent extends GameSyncEvent {
  const CardRevealedEvent({required this.playerId, required this.row, required this.col, required this.card, required this.timestamp, final  String? $type}): $type = $type ?? 'cardRevealed',super._();
  factory CardRevealedEvent.fromJson(Map<String, dynamic> json) => _$CardRevealedEventFromJson(json);

 final  String playerId;
 final  int row;
 final  int col;
 final  Card card;
 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardRevealedEventCopyWith<CardRevealedEvent> get copyWith => _$CardRevealedEventCopyWithImpl<CardRevealedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CardRevealedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardRevealedEvent&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.row, row) || other.row == row)&&(identical(other.col, col) || other.col == col)&&(identical(other.card, card) || other.card == card)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,row,col,card,timestamp);

@override
String toString() {
  return 'GameSyncEvent.cardRevealed(playerId: $playerId, row: $row, col: $col, card: $card, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $CardRevealedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $CardRevealedEventCopyWith(CardRevealedEvent value, $Res Function(CardRevealedEvent) _then) = _$CardRevealedEventCopyWithImpl;
@useResult
$Res call({
 String playerId, int row, int col, Card card, DateTime timestamp
});


$CardCopyWith<$Res> get card;

}
/// @nodoc
class _$CardRevealedEventCopyWithImpl<$Res>
    implements $CardRevealedEventCopyWith<$Res> {
  _$CardRevealedEventCopyWithImpl(this._self, this._then);

  final CardRevealedEvent _self;
  final $Res Function(CardRevealedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? row = null,Object? col = null,Object? card = null,Object? timestamp = null,}) {
  return _then(CardRevealedEvent(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,col: null == col ? _self.col : col // ignore: cast_nullable_to_non_nullable
as int,card: null == card ? _self.card : card // ignore: cast_nullable_to_non_nullable
as Card,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardCopyWith<$Res> get card {
  
  return $CardCopyWith<$Res>(_self.card, (value) {
    return _then(_self.copyWith(card: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ActionCardPlayedEvent extends GameSyncEvent {
  const ActionCardPlayedEvent({required this.playerId, required this.actionCard, required final  Map<String, dynamic> actionData, required this.timestamp, final  String? $type}): _actionData = actionData,$type = $type ?? 'actionCardPlayed',super._();
  factory ActionCardPlayedEvent.fromJson(Map<String, dynamic> json) => _$ActionCardPlayedEventFromJson(json);

 final  String playerId;
 final  ActionCard actionCard;
 final  Map<String, dynamic> _actionData;
 Map<String, dynamic> get actionData {
  if (_actionData is EqualUnmodifiableMapView) return _actionData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_actionData);
}

 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionCardPlayedEventCopyWith<ActionCardPlayedEvent> get copyWith => _$ActionCardPlayedEventCopyWithImpl<ActionCardPlayedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionCardPlayedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionCardPlayedEvent&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.actionCard, actionCard) || other.actionCard == actionCard)&&const DeepCollectionEquality().equals(other._actionData, _actionData)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,actionCard,const DeepCollectionEquality().hash(_actionData),timestamp);

@override
String toString() {
  return 'GameSyncEvent.actionCardPlayed(playerId: $playerId, actionCard: $actionCard, actionData: $actionData, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ActionCardPlayedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $ActionCardPlayedEventCopyWith(ActionCardPlayedEvent value, $Res Function(ActionCardPlayedEvent) _then) = _$ActionCardPlayedEventCopyWithImpl;
@useResult
$Res call({
 String playerId, ActionCard actionCard, Map<String, dynamic> actionData, DateTime timestamp
});


$ActionCardCopyWith<$Res> get actionCard;

}
/// @nodoc
class _$ActionCardPlayedEventCopyWithImpl<$Res>
    implements $ActionCardPlayedEventCopyWith<$Res> {
  _$ActionCardPlayedEventCopyWithImpl(this._self, this._then);

  final ActionCardPlayedEvent _self;
  final $Res Function(ActionCardPlayedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? actionCard = null,Object? actionData = null,Object? timestamp = null,}) {
  return _then(ActionCardPlayedEvent(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,actionCard: null == actionCard ? _self.actionCard : actionCard // ignore: cast_nullable_to_non_nullable
as ActionCard,actionData: null == actionData ? _self._actionData : actionData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionCardCopyWith<$Res> get actionCard {
  
  return $ActionCardCopyWith<$Res>(_self.actionCard, (value) {
    return _then(_self.copyWith(actionCard: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class TurnChangedEvent extends GameSyncEvent {
  const TurnChangedEvent({required this.previousPlayerId, required this.currentPlayerId, required this.turnNumber, required this.timestamp, final  String? $type}): $type = $type ?? 'turnChanged',super._();
  factory TurnChangedEvent.fromJson(Map<String, dynamic> json) => _$TurnChangedEventFromJson(json);

 final  String previousPlayerId;
 final  String currentPlayerId;
 final  int turnNumber;
 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TurnChangedEventCopyWith<TurnChangedEvent> get copyWith => _$TurnChangedEventCopyWithImpl<TurnChangedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TurnChangedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TurnChangedEvent&&(identical(other.previousPlayerId, previousPlayerId) || other.previousPlayerId == previousPlayerId)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.turnNumber, turnNumber) || other.turnNumber == turnNumber)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,previousPlayerId,currentPlayerId,turnNumber,timestamp);

@override
String toString() {
  return 'GameSyncEvent.turnChanged(previousPlayerId: $previousPlayerId, currentPlayerId: $currentPlayerId, turnNumber: $turnNumber, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $TurnChangedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $TurnChangedEventCopyWith(TurnChangedEvent value, $Res Function(TurnChangedEvent) _then) = _$TurnChangedEventCopyWithImpl;
@useResult
$Res call({
 String previousPlayerId, String currentPlayerId, int turnNumber, DateTime timestamp
});




}
/// @nodoc
class _$TurnChangedEventCopyWithImpl<$Res>
    implements $TurnChangedEventCopyWith<$Res> {
  _$TurnChangedEventCopyWithImpl(this._self, this._then);

  final TurnChangedEvent _self;
  final $Res Function(TurnChangedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? previousPlayerId = null,Object? currentPlayerId = null,Object? turnNumber = null,Object? timestamp = null,}) {
  return _then(TurnChangedEvent(
previousPlayerId: null == previousPlayerId ? _self.previousPlayerId : previousPlayerId // ignore: cast_nullable_to_non_nullable
as String,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class RoomSettingsChangedEvent extends GameSyncEvent {
  const RoomSettingsChangedEvent({required final  Map<String, dynamic> settings, required this.timestamp, required this.changedBy, final  String? $type}): _settings = settings,$type = $type ?? 'roomSettingsChanged',super._();
  factory RoomSettingsChangedEvent.fromJson(Map<String, dynamic> json) => _$RoomSettingsChangedEventFromJson(json);

 final  Map<String, dynamic> _settings;
 Map<String, dynamic> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}

 final  DateTime timestamp;
 final  String changedBy;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSettingsChangedEventCopyWith<RoomSettingsChangedEvent> get copyWith => _$RoomSettingsChangedEventCopyWithImpl<RoomSettingsChangedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomSettingsChangedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSettingsChangedEvent&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_settings),timestamp,changedBy);

@override
String toString() {
  return 'GameSyncEvent.roomSettingsChanged(settings: $settings, timestamp: $timestamp, changedBy: $changedBy)';
}


}

/// @nodoc
abstract mixin class $RoomSettingsChangedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $RoomSettingsChangedEventCopyWith(RoomSettingsChangedEvent value, $Res Function(RoomSettingsChangedEvent) _then) = _$RoomSettingsChangedEventCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> settings, DateTime timestamp, String changedBy
});




}
/// @nodoc
class _$RoomSettingsChangedEventCopyWithImpl<$Res>
    implements $RoomSettingsChangedEventCopyWith<$Res> {
  _$RoomSettingsChangedEventCopyWithImpl(this._self, this._then);

  final RoomSettingsChangedEvent _self;
  final $Res Function(RoomSettingsChangedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,Object? timestamp = null,Object? changedBy = null,}) {
  return _then(RoomSettingsChangedEvent(
settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,changedBy: null == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GameStartedEvent extends GameSyncEvent {
  const GameStartedEvent({required this.roomId, required this.gameId, required final  List<String> playerIds, required this.timestamp, final  String? $type}): _playerIds = playerIds,$type = $type ?? 'gameStarted',super._();
  factory GameStartedEvent.fromJson(Map<String, dynamic> json) => _$GameStartedEventFromJson(json);

 final  String roomId;
 final  String gameId;
 final  List<String> _playerIds;
 List<String> get playerIds {
  if (_playerIds is EqualUnmodifiableListView) return _playerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerIds);
}

 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStartedEventCopyWith<GameStartedEvent> get copyWith => _$GameStartedEventCopyWithImpl<GameStartedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStartedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStartedEvent&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&const DeepCollectionEquality().equals(other._playerIds, _playerIds)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,roomId,gameId,const DeepCollectionEquality().hash(_playerIds),timestamp);

@override
String toString() {
  return 'GameSyncEvent.gameStarted(roomId: $roomId, gameId: $gameId, playerIds: $playerIds, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GameStartedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $GameStartedEventCopyWith(GameStartedEvent value, $Res Function(GameStartedEvent) _then) = _$GameStartedEventCopyWithImpl;
@useResult
$Res call({
 String roomId, String gameId, List<String> playerIds, DateTime timestamp
});




}
/// @nodoc
class _$GameStartedEventCopyWithImpl<$Res>
    implements $GameStartedEventCopyWith<$Res> {
  _$GameStartedEventCopyWithImpl(this._self, this._then);

  final GameStartedEvent _self;
  final $Res Function(GameStartedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? gameId = null,Object? playerIds = null,Object? timestamp = null,}) {
  return _then(GameStartedEvent(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,playerIds: null == playerIds ? _self._playerIds : playerIds // ignore: cast_nullable_to_non_nullable
as List<String>,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class GameEndedEvent extends GameSyncEvent {
  const GameEndedEvent({required this.gameId, required final  Map<String, int> finalScores, required this.winnerId, required this.timestamp, final  String? $type}): _finalScores = finalScores,$type = $type ?? 'gameEnded',super._();
  factory GameEndedEvent.fromJson(Map<String, dynamic> json) => _$GameEndedEventFromJson(json);

 final  String gameId;
 final  Map<String, int> _finalScores;
 Map<String, int> get finalScores {
  if (_finalScores is EqualUnmodifiableMapView) return _finalScores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_finalScores);
}

 final  String winnerId;
 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameEndedEventCopyWith<GameEndedEvent> get copyWith => _$GameEndedEventCopyWithImpl<GameEndedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameEndedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameEndedEvent&&(identical(other.gameId, gameId) || other.gameId == gameId)&&const DeepCollectionEquality().equals(other._finalScores, _finalScores)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gameId,const DeepCollectionEquality().hash(_finalScores),winnerId,timestamp);

@override
String toString() {
  return 'GameSyncEvent.gameEnded(gameId: $gameId, finalScores: $finalScores, winnerId: $winnerId, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $GameEndedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $GameEndedEventCopyWith(GameEndedEvent value, $Res Function(GameEndedEvent) _then) = _$GameEndedEventCopyWithImpl;
@useResult
$Res call({
 String gameId, Map<String, int> finalScores, String winnerId, DateTime timestamp
});




}
/// @nodoc
class _$GameEndedEventCopyWithImpl<$Res>
    implements $GameEndedEventCopyWith<$Res> {
  _$GameEndedEventCopyWithImpl(this._self, this._then);

  final GameEndedEvent _self;
  final $Res Function(GameEndedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gameId = null,Object? finalScores = null,Object? winnerId = null,Object? timestamp = null,}) {
  return _then(GameEndedEvent(
gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,finalScores: null == finalScores ? _self._finalScores : finalScores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,winnerId: null == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlayerDisconnectedEvent extends GameSyncEvent {
  const PlayerDisconnectedEvent({required this.playerId, required this.disconnectedAt, required this.timeoutAt, final  String? $type}): $type = $type ?? 'playerDisconnected',super._();
  factory PlayerDisconnectedEvent.fromJson(Map<String, dynamic> json) => _$PlayerDisconnectedEventFromJson(json);

 final  String playerId;
 final  DateTime disconnectedAt;
 final  DateTime timeoutAt;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerDisconnectedEventCopyWith<PlayerDisconnectedEvent> get copyWith => _$PlayerDisconnectedEventCopyWithImpl<PlayerDisconnectedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerDisconnectedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerDisconnectedEvent&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.disconnectedAt, disconnectedAt) || other.disconnectedAt == disconnectedAt)&&(identical(other.timeoutAt, timeoutAt) || other.timeoutAt == timeoutAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,disconnectedAt,timeoutAt);

@override
String toString() {
  return 'GameSyncEvent.playerDisconnected(playerId: $playerId, disconnectedAt: $disconnectedAt, timeoutAt: $timeoutAt)';
}


}

/// @nodoc
abstract mixin class $PlayerDisconnectedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $PlayerDisconnectedEventCopyWith(PlayerDisconnectedEvent value, $Res Function(PlayerDisconnectedEvent) _then) = _$PlayerDisconnectedEventCopyWithImpl;
@useResult
$Res call({
 String playerId, DateTime disconnectedAt, DateTime timeoutAt
});




}
/// @nodoc
class _$PlayerDisconnectedEventCopyWithImpl<$Res>
    implements $PlayerDisconnectedEventCopyWith<$Res> {
  _$PlayerDisconnectedEventCopyWithImpl(this._self, this._then);

  final PlayerDisconnectedEvent _self;
  final $Res Function(PlayerDisconnectedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? disconnectedAt = null,Object? timeoutAt = null,}) {
  return _then(PlayerDisconnectedEvent(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,disconnectedAt: null == disconnectedAt ? _self.disconnectedAt : disconnectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,timeoutAt: null == timeoutAt ? _self.timeoutAt : timeoutAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PlayerReconnectedEvent extends GameSyncEvent {
  const PlayerReconnectedEvent({required this.playerId, required this.reconnectedAt, final  String? $type}): $type = $type ?? 'playerReconnected',super._();
  factory PlayerReconnectedEvent.fromJson(Map<String, dynamic> json) => _$PlayerReconnectedEventFromJson(json);

 final  String playerId;
 final  DateTime reconnectedAt;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerReconnectedEventCopyWith<PlayerReconnectedEvent> get copyWith => _$PlayerReconnectedEventCopyWithImpl<PlayerReconnectedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerReconnectedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerReconnectedEvent&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.reconnectedAt, reconnectedAt) || other.reconnectedAt == reconnectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,reconnectedAt);

@override
String toString() {
  return 'GameSyncEvent.playerReconnected(playerId: $playerId, reconnectedAt: $reconnectedAt)';
}


}

/// @nodoc
abstract mixin class $PlayerReconnectedEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $PlayerReconnectedEventCopyWith(PlayerReconnectedEvent value, $Res Function(PlayerReconnectedEvent) _then) = _$PlayerReconnectedEventCopyWithImpl;
@useResult
$Res call({
 String playerId, DateTime reconnectedAt
});




}
/// @nodoc
class _$PlayerReconnectedEventCopyWithImpl<$Res>
    implements $PlayerReconnectedEventCopyWith<$Res> {
  _$PlayerReconnectedEventCopyWithImpl(this._self, this._then);

  final PlayerReconnectedEvent _self;
  final $Res Function(PlayerReconnectedEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? reconnectedAt = null,}) {
  return _then(PlayerReconnectedEvent(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,reconnectedAt: null == reconnectedAt ? _self.reconnectedAt : reconnectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChatMessageEvent extends GameSyncEvent {
  const ChatMessageEvent({required this.playerId, required this.message, required this.timestamp, final  String? $type}): $type = $type ?? 'chatMessage',super._();
  factory ChatMessageEvent.fromJson(Map<String, dynamic> json) => _$ChatMessageEventFromJson(json);

 final  String playerId;
 final  String message;
 final  DateTime timestamp;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageEventCopyWith<ChatMessageEvent> get copyWith => _$ChatMessageEventCopyWithImpl<ChatMessageEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageEvent&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,message,timestamp);

@override
String toString() {
  return 'GameSyncEvent.chatMessage(playerId: $playerId, message: $message, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $ChatMessageEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $ChatMessageEventCopyWith(ChatMessageEvent value, $Res Function(ChatMessageEvent) _then) = _$ChatMessageEventCopyWithImpl;
@useResult
$Res call({
 String playerId, String message, DateTime timestamp
});




}
/// @nodoc
class _$ChatMessageEventCopyWithImpl<$Res>
    implements $ChatMessageEventCopyWith<$Res> {
  _$ChatMessageEventCopyWithImpl(this._self, this._then);

  final ChatMessageEvent _self;
  final $Res Function(ChatMessageEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? message = null,Object? timestamp = null,}) {
  return _then(ChatMessageEvent(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class SyncErrorEvent extends GameSyncEvent {
  const SyncErrorEvent({required this.errorType, required this.message, required this.timestamp, final  Map<String, dynamic>? context, final  String? $type}): _context = context,$type = $type ?? 'syncError',super._();
  factory SyncErrorEvent.fromJson(Map<String, dynamic> json) => _$SyncErrorEventFromJson(json);

 final  String errorType;
 final  String message;
 final  DateTime timestamp;
 final  Map<String, dynamic>? _context;
 Map<String, dynamic>? get context {
  final value = _context;
  if (value == null) return null;
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncErrorEventCopyWith<SyncErrorEvent> get copyWith => _$SyncErrorEventCopyWithImpl<SyncErrorEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncErrorEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncErrorEvent&&(identical(other.errorType, errorType) || other.errorType == errorType)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&const DeepCollectionEquality().equals(other._context, _context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,errorType,message,timestamp,const DeepCollectionEquality().hash(_context));

@override
String toString() {
  return 'GameSyncEvent.syncError(errorType: $errorType, message: $message, timestamp: $timestamp, context: $context)';
}


}

/// @nodoc
abstract mixin class $SyncErrorEventCopyWith<$Res> implements $GameSyncEventCopyWith<$Res> {
  factory $SyncErrorEventCopyWith(SyncErrorEvent value, $Res Function(SyncErrorEvent) _then) = _$SyncErrorEventCopyWithImpl;
@useResult
$Res call({
 String errorType, String message, DateTime timestamp, Map<String, dynamic>? context
});




}
/// @nodoc
class _$SyncErrorEventCopyWithImpl<$Res>
    implements $SyncErrorEventCopyWith<$Res> {
  _$SyncErrorEventCopyWithImpl(this._self, this._then);

  final SyncErrorEvent _self;
  final $Res Function(SyncErrorEvent) _then;

/// Create a copy of GameSyncEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorType = null,Object? message = null,Object? timestamp = null,Object? context = freezed,}) {
  return _then(SyncErrorEvent(
errorType: null == errorType ? _self.errorType : errorType // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,context: freezed == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
