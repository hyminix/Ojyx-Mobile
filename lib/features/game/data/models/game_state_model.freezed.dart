// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameStateModel {

 String get id;@JsonKey(name: 'room_id') String get roomId; String get status;@JsonKey(name: 'current_player_id') String get currentPlayerId;@JsonKey(name: 'turn_number') int get turnNumber;@JsonKey(name: 'round_number') int get roundNumber;@JsonKey(name: 'game_data') Map<String, dynamic> get gameData;@JsonKey(name: 'winner_id') String? get winnerId;@JsonKey(name: 'ended_at') DateTime? get endedAt;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of GameStateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateModelCopyWith<GameStateModel> get copyWith => _$GameStateModelCopyWithImpl<GameStateModel>(this as GameStateModel, _$identity);

  /// Serializes this GameStateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.turnNumber, turnNumber) || other.turnNumber == turnNumber)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&const DeepCollectionEquality().equals(other.gameData, gameData)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,status,currentPlayerId,turnNumber,roundNumber,const DeepCollectionEquality().hash(gameData),winnerId,endedAt,createdAt,updatedAt);

@override
String toString() {
  return 'GameStateModel(id: $id, roomId: $roomId, status: $status, currentPlayerId: $currentPlayerId, turnNumber: $turnNumber, roundNumber: $roundNumber, gameData: $gameData, winnerId: $winnerId, endedAt: $endedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $GameStateModelCopyWith<$Res>  {
  factory $GameStateModelCopyWith(GameStateModel value, $Res Function(GameStateModel) _then) = _$GameStateModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId, String status,@JsonKey(name: 'current_player_id') String currentPlayerId,@JsonKey(name: 'turn_number') int turnNumber,@JsonKey(name: 'round_number') int roundNumber,@JsonKey(name: 'game_data') Map<String, dynamic> gameData,@JsonKey(name: 'winner_id') String? winnerId,@JsonKey(name: 'ended_at') DateTime? endedAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$GameStateModelCopyWithImpl<$Res>
    implements $GameStateModelCopyWith<$Res> {
  _$GameStateModelCopyWithImpl(this._self, this._then);

  final GameStateModel _self;
  final $Res Function(GameStateModel) _then;

/// Create a copy of GameStateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? status = null,Object? currentPlayerId = null,Object? turnNumber = null,Object? roundNumber = null,Object? gameData = null,Object? winnerId = freezed,Object? endedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,gameData: null == gameData ? _self.gameData : gameData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GameStateModel].
extension GameStateModelPatterns on GameStateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameStateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameStateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameStateModel value)  $default,){
final _that = this;
switch (_that) {
case _GameStateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameStateModel value)?  $default,){
final _that = this;
switch (_that) {
case _GameStateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId,  String status, @JsonKey(name: 'current_player_id')  String currentPlayerId, @JsonKey(name: 'turn_number')  int turnNumber, @JsonKey(name: 'round_number')  int roundNumber, @JsonKey(name: 'game_data')  Map<String, dynamic> gameData, @JsonKey(name: 'winner_id')  String? winnerId, @JsonKey(name: 'ended_at')  DateTime? endedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameStateModel() when $default != null:
return $default(_that.id,_that.roomId,_that.status,_that.currentPlayerId,_that.turnNumber,_that.roundNumber,_that.gameData,_that.winnerId,_that.endedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId,  String status, @JsonKey(name: 'current_player_id')  String currentPlayerId, @JsonKey(name: 'turn_number')  int turnNumber, @JsonKey(name: 'round_number')  int roundNumber, @JsonKey(name: 'game_data')  Map<String, dynamic> gameData, @JsonKey(name: 'winner_id')  String? winnerId, @JsonKey(name: 'ended_at')  DateTime? endedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _GameStateModel():
return $default(_that.id,_that.roomId,_that.status,_that.currentPlayerId,_that.turnNumber,_that.roundNumber,_that.gameData,_that.winnerId,_that.endedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'room_id')  String roomId,  String status, @JsonKey(name: 'current_player_id')  String currentPlayerId, @JsonKey(name: 'turn_number')  int turnNumber, @JsonKey(name: 'round_number')  int roundNumber, @JsonKey(name: 'game_data')  Map<String, dynamic> gameData, @JsonKey(name: 'winner_id')  String? winnerId, @JsonKey(name: 'ended_at')  DateTime? endedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _GameStateModel() when $default != null:
return $default(_that.id,_that.roomId,_that.status,_that.currentPlayerId,_that.turnNumber,_that.roundNumber,_that.gameData,_that.winnerId,_that.endedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameStateModel extends GameStateModel {
  const _GameStateModel({required this.id, @JsonKey(name: 'room_id') required this.roomId, required this.status, @JsonKey(name: 'current_player_id') required this.currentPlayerId, @JsonKey(name: 'turn_number') required this.turnNumber, @JsonKey(name: 'round_number') required this.roundNumber, @JsonKey(name: 'game_data') required final  Map<String, dynamic> gameData, @JsonKey(name: 'winner_id') this.winnerId, @JsonKey(name: 'ended_at') this.endedAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _gameData = gameData,super._();
  factory _GameStateModel.fromJson(Map<String, dynamic> json) => _$GameStateModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'room_id') final  String roomId;
@override final  String status;
@override@JsonKey(name: 'current_player_id') final  String currentPlayerId;
@override@JsonKey(name: 'turn_number') final  int turnNumber;
@override@JsonKey(name: 'round_number') final  int roundNumber;
 final  Map<String, dynamic> _gameData;
@override@JsonKey(name: 'game_data') Map<String, dynamic> get gameData {
  if (_gameData is EqualUnmodifiableMapView) return _gameData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_gameData);
}

@override@JsonKey(name: 'winner_id') final  String? winnerId;
@override@JsonKey(name: 'ended_at') final  DateTime? endedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of GameStateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateModelCopyWith<_GameStateModel> get copyWith => __$GameStateModelCopyWithImpl<_GameStateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameStateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.status, status) || other.status == status)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.turnNumber, turnNumber) || other.turnNumber == turnNumber)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&const DeepCollectionEquality().equals(other._gameData, _gameData)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,status,currentPlayerId,turnNumber,roundNumber,const DeepCollectionEquality().hash(_gameData),winnerId,endedAt,createdAt,updatedAt);

@override
String toString() {
  return 'GameStateModel(id: $id, roomId: $roomId, status: $status, currentPlayerId: $currentPlayerId, turnNumber: $turnNumber, roundNumber: $roundNumber, gameData: $gameData, winnerId: $winnerId, endedAt: $endedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$GameStateModelCopyWith<$Res> implements $GameStateModelCopyWith<$Res> {
  factory _$GameStateModelCopyWith(_GameStateModel value, $Res Function(_GameStateModel) _then) = __$GameStateModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId, String status,@JsonKey(name: 'current_player_id') String currentPlayerId,@JsonKey(name: 'turn_number') int turnNumber,@JsonKey(name: 'round_number') int roundNumber,@JsonKey(name: 'game_data') Map<String, dynamic> gameData,@JsonKey(name: 'winner_id') String? winnerId,@JsonKey(name: 'ended_at') DateTime? endedAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$GameStateModelCopyWithImpl<$Res>
    implements _$GameStateModelCopyWith<$Res> {
  __$GameStateModelCopyWithImpl(this._self, this._then);

  final _GameStateModel _self;
  final $Res Function(_GameStateModel) _then;

/// Create a copy of GameStateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? status = null,Object? currentPlayerId = null,Object? turnNumber = null,Object? roundNumber = null,Object? gameData = null,Object? winnerId = freezed,Object? endedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_GameStateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,gameData: null == gameData ? _self._gameData : gameData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
