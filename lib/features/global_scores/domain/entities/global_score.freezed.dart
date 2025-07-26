// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GlobalScore {

 String get id; String get playerId; String get playerName; String get roomId; int get totalScore; int get roundNumber; int get position; bool get isWinner; DateTime get createdAt; DateTime? get gameEndedAt;
/// Create a copy of GlobalScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlobalScoreCopyWith<GlobalScore> get copyWith => _$GlobalScoreCopyWithImpl<GlobalScore>(this as GlobalScore, _$identity);

  /// Serializes this GlobalScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlobalScore&&(identical(other.id, id) || other.id == id)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.position, position) || other.position == position)&&(identical(other.isWinner, isWinner) || other.isWinner == isWinner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.gameEndedAt, gameEndedAt) || other.gameEndedAt == gameEndedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,playerId,playerName,roomId,totalScore,roundNumber,position,isWinner,createdAt,gameEndedAt);

@override
String toString() {
  return 'GlobalScore(id: $id, playerId: $playerId, playerName: $playerName, roomId: $roomId, totalScore: $totalScore, roundNumber: $roundNumber, position: $position, isWinner: $isWinner, createdAt: $createdAt, gameEndedAt: $gameEndedAt)';
}


}

/// @nodoc
abstract mixin class $GlobalScoreCopyWith<$Res>  {
  factory $GlobalScoreCopyWith(GlobalScore value, $Res Function(GlobalScore) _then) = _$GlobalScoreCopyWithImpl;
@useResult
$Res call({
 String id, String playerId, String playerName, String roomId, int totalScore, int roundNumber, int position, bool isWinner, DateTime createdAt, DateTime? gameEndedAt
});




}
/// @nodoc
class _$GlobalScoreCopyWithImpl<$Res>
    implements $GlobalScoreCopyWith<$Res> {
  _$GlobalScoreCopyWithImpl(this._self, this._then);

  final GlobalScore _self;
  final $Res Function(GlobalScore) _then;

/// Create a copy of GlobalScore
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


/// Adds pattern-matching-related methods to [GlobalScore].
extension GlobalScorePatterns on GlobalScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlobalScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlobalScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlobalScore value)  $default,){
final _that = this;
switch (_that) {
case _GlobalScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlobalScore value)?  $default,){
final _that = this;
switch (_that) {
case _GlobalScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String playerId,  String playerName,  String roomId,  int totalScore,  int roundNumber,  int position,  bool isWinner,  DateTime createdAt,  DateTime? gameEndedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GlobalScore() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String playerId,  String playerName,  String roomId,  int totalScore,  int roundNumber,  int position,  bool isWinner,  DateTime createdAt,  DateTime? gameEndedAt)  $default,) {final _that = this;
switch (_that) {
case _GlobalScore():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String playerId,  String playerName,  String roomId,  int totalScore,  int roundNumber,  int position,  bool isWinner,  DateTime createdAt,  DateTime? gameEndedAt)?  $default,) {final _that = this;
switch (_that) {
case _GlobalScore() when $default != null:
return $default(_that.id,_that.playerId,_that.playerName,_that.roomId,_that.totalScore,_that.roundNumber,_that.position,_that.isWinner,_that.createdAt,_that.gameEndedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlobalScore extends GlobalScore {
  const _GlobalScore({required this.id, required this.playerId, required this.playerName, required this.roomId, required this.totalScore, required this.roundNumber, required this.position, required this.isWinner, required this.createdAt, this.gameEndedAt}): super._();
  factory _GlobalScore.fromJson(Map<String, dynamic> json) => _$GlobalScoreFromJson(json);

@override final  String id;
@override final  String playerId;
@override final  String playerName;
@override final  String roomId;
@override final  int totalScore;
@override final  int roundNumber;
@override final  int position;
@override final  bool isWinner;
@override final  DateTime createdAt;
@override final  DateTime? gameEndedAt;

/// Create a copy of GlobalScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlobalScoreCopyWith<_GlobalScore> get copyWith => __$GlobalScoreCopyWithImpl<_GlobalScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlobalScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlobalScore&&(identical(other.id, id) || other.id == id)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber)&&(identical(other.position, position) || other.position == position)&&(identical(other.isWinner, isWinner) || other.isWinner == isWinner)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.gameEndedAt, gameEndedAt) || other.gameEndedAt == gameEndedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,playerId,playerName,roomId,totalScore,roundNumber,position,isWinner,createdAt,gameEndedAt);

@override
String toString() {
  return 'GlobalScore(id: $id, playerId: $playerId, playerName: $playerName, roomId: $roomId, totalScore: $totalScore, roundNumber: $roundNumber, position: $position, isWinner: $isWinner, createdAt: $createdAt, gameEndedAt: $gameEndedAt)';
}


}

/// @nodoc
abstract mixin class _$GlobalScoreCopyWith<$Res> implements $GlobalScoreCopyWith<$Res> {
  factory _$GlobalScoreCopyWith(_GlobalScore value, $Res Function(_GlobalScore) _then) = __$GlobalScoreCopyWithImpl;
@override @useResult
$Res call({
 String id, String playerId, String playerName, String roomId, int totalScore, int roundNumber, int position, bool isWinner, DateTime createdAt, DateTime? gameEndedAt
});




}
/// @nodoc
class __$GlobalScoreCopyWithImpl<$Res>
    implements _$GlobalScoreCopyWith<$Res> {
  __$GlobalScoreCopyWithImpl(this._self, this._then);

  final _GlobalScore _self;
  final $Res Function(_GlobalScore) _then;

/// Create a copy of GlobalScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? playerId = null,Object? playerName = null,Object? roomId = null,Object? totalScore = null,Object? roundNumber = null,Object? position = null,Object? isWinner = null,Object? createdAt = null,Object? gameEndedAt = freezed,}) {
  return _then(_GlobalScore(
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


/// @nodoc
mixin _$PlayerStats {

 String get playerId; String get playerName; int get totalGamesPlayed; int get totalWins; double get averageScore; int get bestScore; int get worstScore; double get averagePosition; int get totalRoundsPlayed;
/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStatsCopyWith<PlayerStats> get copyWith => _$PlayerStatsCopyWithImpl<PlayerStats>(this as PlayerStats, _$identity);

  /// Serializes this PlayerStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.totalGamesPlayed, totalGamesPlayed) || other.totalGamesPlayed == totalGamesPlayed)&&(identical(other.totalWins, totalWins) || other.totalWins == totalWins)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.worstScore, worstScore) || other.worstScore == worstScore)&&(identical(other.averagePosition, averagePosition) || other.averagePosition == averagePosition)&&(identical(other.totalRoundsPlayed, totalRoundsPlayed) || other.totalRoundsPlayed == totalRoundsPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,totalGamesPlayed,totalWins,averageScore,bestScore,worstScore,averagePosition,totalRoundsPlayed);

@override
String toString() {
  return 'PlayerStats(playerId: $playerId, playerName: $playerName, totalGamesPlayed: $totalGamesPlayed, totalWins: $totalWins, averageScore: $averageScore, bestScore: $bestScore, worstScore: $worstScore, averagePosition: $averagePosition, totalRoundsPlayed: $totalRoundsPlayed)';
}


}

/// @nodoc
abstract mixin class $PlayerStatsCopyWith<$Res>  {
  factory $PlayerStatsCopyWith(PlayerStats value, $Res Function(PlayerStats) _then) = _$PlayerStatsCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, int totalGamesPlayed, int totalWins, double averageScore, int bestScore, int worstScore, double averagePosition, int totalRoundsPlayed
});




}
/// @nodoc
class _$PlayerStatsCopyWithImpl<$Res>
    implements $PlayerStatsCopyWith<$Res> {
  _$PlayerStatsCopyWithImpl(this._self, this._then);

  final PlayerStats _self;
  final $Res Function(PlayerStats) _then;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? totalGamesPlayed = null,Object? totalWins = null,Object? averageScore = null,Object? bestScore = null,Object? worstScore = null,Object? averagePosition = null,Object? totalRoundsPlayed = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,totalGamesPlayed: null == totalGamesPlayed ? _self.totalGamesPlayed : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
as int,totalWins: null == totalWins ? _self.totalWins : totalWins // ignore: cast_nullable_to_non_nullable
as int,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as double,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as int,worstScore: null == worstScore ? _self.worstScore : worstScore // ignore: cast_nullable_to_non_nullable
as int,averagePosition: null == averagePosition ? _self.averagePosition : averagePosition // ignore: cast_nullable_to_non_nullable
as double,totalRoundsPlayed: null == totalRoundsPlayed ? _self.totalRoundsPlayed : totalRoundsPlayed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerStats].
extension PlayerStatsPatterns on PlayerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerStats value)  $default,){
final _that = this;
switch (_that) {
case _PlayerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerStats value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int totalGamesPlayed,  int totalWins,  double averageScore,  int bestScore,  int worstScore,  double averagePosition,  int totalRoundsPlayed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.totalGamesPlayed,_that.totalWins,_that.averageScore,_that.bestScore,_that.worstScore,_that.averagePosition,_that.totalRoundsPlayed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int totalGamesPlayed,  int totalWins,  double averageScore,  int bestScore,  int worstScore,  double averagePosition,  int totalRoundsPlayed)  $default,) {final _that = this;
switch (_that) {
case _PlayerStats():
return $default(_that.playerId,_that.playerName,_that.totalGamesPlayed,_that.totalWins,_that.averageScore,_that.bestScore,_that.worstScore,_that.averagePosition,_that.totalRoundsPlayed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  int totalGamesPlayed,  int totalWins,  double averageScore,  int bestScore,  int worstScore,  double averagePosition,  int totalRoundsPlayed)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.totalGamesPlayed,_that.totalWins,_that.averageScore,_that.bestScore,_that.worstScore,_that.averagePosition,_that.totalRoundsPlayed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerStats extends PlayerStats {
  const _PlayerStats({required this.playerId, required this.playerName, required this.totalGamesPlayed, required this.totalWins, required this.averageScore, required this.bestScore, required this.worstScore, required this.averagePosition, required this.totalRoundsPlayed}): super._();
  factory _PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  int totalGamesPlayed;
@override final  int totalWins;
@override final  double averageScore;
@override final  int bestScore;
@override final  int worstScore;
@override final  double averagePosition;
@override final  int totalRoundsPlayed;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStatsCopyWith<_PlayerStats> get copyWith => __$PlayerStatsCopyWithImpl<_PlayerStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.totalGamesPlayed, totalGamesPlayed) || other.totalGamesPlayed == totalGamesPlayed)&&(identical(other.totalWins, totalWins) || other.totalWins == totalWins)&&(identical(other.averageScore, averageScore) || other.averageScore == averageScore)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.worstScore, worstScore) || other.worstScore == worstScore)&&(identical(other.averagePosition, averagePosition) || other.averagePosition == averagePosition)&&(identical(other.totalRoundsPlayed, totalRoundsPlayed) || other.totalRoundsPlayed == totalRoundsPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,totalGamesPlayed,totalWins,averageScore,bestScore,worstScore,averagePosition,totalRoundsPlayed);

@override
String toString() {
  return 'PlayerStats(playerId: $playerId, playerName: $playerName, totalGamesPlayed: $totalGamesPlayed, totalWins: $totalWins, averageScore: $averageScore, bestScore: $bestScore, worstScore: $worstScore, averagePosition: $averagePosition, totalRoundsPlayed: $totalRoundsPlayed)';
}


}

/// @nodoc
abstract mixin class _$PlayerStatsCopyWith<$Res> implements $PlayerStatsCopyWith<$Res> {
  factory _$PlayerStatsCopyWith(_PlayerStats value, $Res Function(_PlayerStats) _then) = __$PlayerStatsCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, int totalGamesPlayed, int totalWins, double averageScore, int bestScore, int worstScore, double averagePosition, int totalRoundsPlayed
});




}
/// @nodoc
class __$PlayerStatsCopyWithImpl<$Res>
    implements _$PlayerStatsCopyWith<$Res> {
  __$PlayerStatsCopyWithImpl(this._self, this._then);

  final _PlayerStats _self;
  final $Res Function(_PlayerStats) _then;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? totalGamesPlayed = null,Object? totalWins = null,Object? averageScore = null,Object? bestScore = null,Object? worstScore = null,Object? averagePosition = null,Object? totalRoundsPlayed = null,}) {
  return _then(_PlayerStats(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,totalGamesPlayed: null == totalGamesPlayed ? _self.totalGamesPlayed : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
as int,totalWins: null == totalWins ? _self.totalWins : totalWins // ignore: cast_nullable_to_non_nullable
as int,averageScore: null == averageScore ? _self.averageScore : averageScore // ignore: cast_nullable_to_non_nullable
as double,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as int,worstScore: null == worstScore ? _self.worstScore : worstScore // ignore: cast_nullable_to_non_nullable
as int,averagePosition: null == averagePosition ? _self.averagePosition : averagePosition // ignore: cast_nullable_to_non_nullable
as double,totalRoundsPlayed: null == totalRoundsPlayed ? _self.totalRoundsPlayed : totalRoundsPlayed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
