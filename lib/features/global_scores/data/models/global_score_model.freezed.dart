// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_score_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalScoreModel {

 String get id;@JsonKey(name: 'player_id') String get playerId;@JsonKey(name: 'player_name') String get playerName;@JsonKey(name: 'room_id') String get roomId;@JsonKey(name: 'total_score') int get totalScore;@JsonKey(name: 'round_number') int get roundNumber; int get position;@JsonKey(name: 'is_winner') bool get isWinner;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'game_ended_at') DateTime? get gameEndedAt;
/// Create a copy of GlobalScoreModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalScoreModelCopyWith<GlobalScoreModel> get copyWith => _$GlobalScoreModelCopyWithImpl<GlobalScoreModel>(this as GlobalScoreModel, _$identity);

  /// Serializes this GlobalScoreModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalScoreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.position, position) || other.position == position)&&(identical(other.isWinner, isWinner) || other.isWinner == isWinner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.gameEndedAt, gameEndedAt) || other.gameEndedAt == gameEndedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,playerId,playerName,roomId,totalScore,roundNumber,position,isWinner,createdAt,gameEndedAt);

@override
String toString() {
  return 'GlobalScoreModel(id: $id, playerId: $playerId, playerName: $playerName, roomId: $roomId, totalScore: $totalScore, roundNumber: $roundNumber, position: $position, isWinner: $isWinner, createdAt: $createdAt, gameEndedAt: $gameEndedAt)';
}


}

/// @nodoc
abstract mixin class $GlobalScoreModelCopyWith<$Res>  {
  factory $GlobalScoreModelCopyWith(GlobalScoreModel value, $Res Function(GlobalScoreModel) _then) = _$GlobalScoreModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'player_id') String playerId,@JsonKey(name: 'player_name') String playerName,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'total_score') int totalScore,@JsonKey(name: 'round_number') int roundNumber, int position,@JsonKey(name: 'is_winner') bool isWinner,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'game_ended_at') DateTime? gameEndedAt
});




}
/// @nodoc
class _$GlobalScoreModelCopyWithImpl<$Res>
    implements $GlobalScoreModelCopyWith<$Res> {
  _$GlobalScoreModelCopyWithImpl(this._self, this._then);

  final GlobalScoreModel _self;
  final $Res Function(GlobalScoreModel) _then;

/// Create a copy of GlobalScoreModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? roomId = null,Object? totalScore = null,Object? roundNumber = null,Object? position = null,Object? isWinner = null,Object? createdAt = null,Object? gameEndedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isWinner: null == isWinner ? _self.isWinner : isWinner // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,gameEndedAt: freezed == gameEndedAt ? _self.gameEndedAt : gameEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [GlobalScoreModel].
extension GlobalScoreModelPatterns on GlobalScoreModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalScoreModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalScoreModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalScoreModel value)  $default,){
final _that = this;
switch (_that) {
case _GlobalScoreModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalScoreModel value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalScoreModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'player_id')  String playerId, @JsonKey(name: 'player_name')  String playerName, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'total_score')  int totalScore, @JsonKey(name: 'round_number')  int roundNumber,  int position, @JsonKey(name: 'is_winner')  bool isWinner, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'game_ended_at')  DateTime? gameEndedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalScoreModel() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.roomId,_that.totalScore,_that.roundNumber,_that.position,_that.isWinner,_that.createdAt,_that.gameEndedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'player_id')  String playerId, @JsonKey(name: 'player_name')  String playerName, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'total_score')  int totalScore, @JsonKey(name: 'round_number')  int roundNumber,  int position, @JsonKey(name: 'is_winner')  bool isWinner, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'game_ended_at')  DateTime? gameEndedAt)  $default,) {final _that = this;
switch (_that) {
case _GlobalScoreModel():
return $default(_that.id,_that.playerId,_that.playerName,_that.roomId,_that.totalScore,_that.roundNumber,_that.position,_that.isWinner,_that.createdAt,_that.gameEndedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'player_id')  String playerId, @JsonKey(name: 'player_name')  String playerName, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'total_score')  int totalScore, @JsonKey(name: 'round_number')  int roundNumber,  int position, @JsonKey(name: 'is_winner')  bool isWinner, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'game_ended_at')  DateTime? gameEndedAt)?  $default,) {final _that = this;
switch (_that) {
case _GlobalScoreModel() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.roomId,_that.totalScore,_that.roundNumber,_that.position,_that.isWinner,_that.createdAt,_that.gameEndedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalScoreModel extends GlobalScoreModel {
  const _GlobalScoreModel({required this.id, @JsonKey(name: 'player_id') required this.playerId, @JsonKey(name: 'player_name') required this.playerName, @JsonKey(name: 'room_id') required this.roomId, @JsonKey(name: 'total_score') required this.totalScore, @JsonKey(name: 'round_number') required this.roundNumber, required this.position, @JsonKey(name: 'is_winner') required this.isWinner, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'game_ended_at') this.gameEndedAt}): super._();
  factory _GlobalScoreModel.fromJson(Map<String, dynamic> json) => _$GlobalScoreModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'player_id') final  String playerId;
@override@JsonKey(name: 'player_name') final  String playerName;
@override@JsonKey(name: 'room_id') final  String roomId;
@override@JsonKey(name: 'total_score') final  int totalScore;
@override@JsonKey(name: 'round_number') final  int roundNumber;
@override final  int position;
@override@JsonKey(name: 'is_winner') final  bool isWinner;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'game_ended_at') final  DateTime? gameEndedAt;

/// Create a copy of GlobalScoreModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalScoreModelCopyWith<_GlobalScoreModel> get copyWith => __$GlobalScoreModelCopyWithImpl<_GlobalScoreModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalScoreModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalScoreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.position, position) || other.position == position)&&(identical(other.isWinner, isWinner) || other.isWinner == isWinner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.gameEndedAt, gameEndedAt) || other.gameEndedAt == gameEndedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,playerId,playerName,roomId,totalScore,roundNumber,position,isWinner,createdAt,gameEndedAt);

@override
String toString() {
  return 'GlobalScoreModel(id: $id, playerId: $playerId, playerName: $playerName, roomId: $roomId, totalScore: $totalScore, roundNumber: $roundNumber, position: $position, isWinner: $isWinner, createdAt: $createdAt, gameEndedAt: $gameEndedAt)';
}


}

/// @nodoc
abstract mixin class _$GlobalScoreModelCopyWith<$Res> implements $GlobalScoreModelCopyWith<$Res> {
  factory _$GlobalScoreModelCopyWith(_GlobalScoreModel value, $Res Function(_GlobalScoreModel) _then) = __$GlobalScoreModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'player_id') String playerId,@JsonKey(name: 'player_name') String playerName,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'total_score') int totalScore,@JsonKey(name: 'round_number') int roundNumber, int position,@JsonKey(name: 'is_winner') bool isWinner,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'game_ended_at') DateTime? gameEndedAt
});




}
/// @nodoc
class __$GlobalScoreModelCopyWithImpl<$Res>
    implements _$GlobalScoreModelCopyWith<$Res> {
  __$GlobalScoreModelCopyWithImpl(this._self, this._then);

  final _GlobalScoreModel _self;
  final $Res Function(_GlobalScoreModel) _then;

/// Create a copy of GlobalScoreModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? roomId = null,Object? totalScore = null,Object? roundNumber = null,Object? position = null,Object? isWinner = null,Object? createdAt = null,Object? gameEndedAt = freezed,}) {
  return _then(_GlobalScoreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isWinner: null == isWinner ? _self.isWinner : isWinner // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,gameEndedAt: freezed == gameEndedAt ? _self.gameEndedAt : gameEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
