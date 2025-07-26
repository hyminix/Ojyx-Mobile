// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_grid_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerGridModel {

 String get id; String get gameStateId; String get playerId; List<Map<String, dynamic>> get gridCards; List<Map<String, dynamic>> get actionCards; int get score; int get position; bool get isActive; bool get hasRevealedAll; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of PlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerGridModelCopyWith<PlayerGridModel> get copyWith => _$PlayerGridModelCopyWithImpl<PlayerGridModel>(this as PlayerGridModel, _$identity);

  /// Serializes this PlayerGridModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerGridModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gameStateId, gameStateId) || other.gameStateId == gameStateId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other.gridCards, gridCards)&&const DeepCollectionEquality().equals(other.actionCards, actionCards)&&(identical(other.score, score) || other.score == score)&&(identical(other.position, position) || other.position == position)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasRevealedAll, hasRevealedAll) || other.hasRevealedAll == hasRevealedAll)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameStateId,playerId,const DeepCollectionEquality().hash(gridCards),const DeepCollectionEquality().hash(actionCards),score,position,isActive,hasRevealedAll,createdAt,updatedAt);

@override
String toString() {
  return 'PlayerGridModel(id: $id, gameStateId: $gameStateId, playerId: $playerId, gridCards: $gridCards, actionCards: $actionCards, score: $score, position: $position, isActive: $isActive, hasRevealedAll: $hasRevealedAll, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PlayerGridModelCopyWith<$Res>  {
  factory $PlayerGridModelCopyWith(PlayerGridModel value, $Res Function(PlayerGridModel) _then) = _$PlayerGridModelCopyWithImpl;
@useResult
$Res call({
 String id, String gameStateId, String playerId, List<Map<String, dynamic>> gridCards, List<Map<String, dynamic>> actionCards, int score, int position, bool isActive, bool hasRevealedAll, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$PlayerGridModelCopyWithImpl<$Res>
    implements $PlayerGridModelCopyWith<$Res> {
  _$PlayerGridModelCopyWithImpl(this._self, this._then);

  final PlayerGridModel _self;
  final $Res Function(PlayerGridModel) _then;

/// Create a copy of PlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameStateId = null,Object? playerId = null,Object? gridCards = null,Object? actionCards = null,Object? score = null,Object? position = null,Object? isActive = null,Object? hasRevealedAll = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameStateId: null == gameStateId ? _self.gameStateId : gameStateId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,gridCards: null == gridCards ? _self.gridCards : gridCards // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,actionCards: null == actionCards ? _self.actionCards : actionCards // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hasRevealedAll: null == hasRevealedAll ? _self.hasRevealedAll : hasRevealedAll // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerGridModel].
extension PlayerGridModelPatterns on PlayerGridModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerGridModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerGridModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerGridModel value)  $default,){
final _that = this;
switch (_that) {
case _PlayerGridModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerGridModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerGridModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String gameStateId,  String playerId,  List<Map<String, dynamic>> gridCards,  List<Map<String, dynamic>> actionCards,  int score,  int position,  bool isActive,  bool hasRevealedAll,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerGridModel() when $default != null:
return $default(_that.id,_that.gameStateId,_that.playerId,_that.gridCards,_that.actionCards,_that.score,_that.position,_that.isActive,_that.hasRevealedAll,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String gameStateId,  String playerId,  List<Map<String, dynamic>> gridCards,  List<Map<String, dynamic>> actionCards,  int score,  int position,  bool isActive,  bool hasRevealedAll,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PlayerGridModel():
return $default(_that.id,_that.gameStateId,_that.playerId,_that.gridCards,_that.actionCards,_that.score,_that.position,_that.isActive,_that.hasRevealedAll,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String gameStateId,  String playerId,  List<Map<String, dynamic>> gridCards,  List<Map<String, dynamic>> actionCards,  int score,  int position,  bool isActive,  bool hasRevealedAll,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlayerGridModel() when $default != null:
return $default(_that.id,_that.gameStateId,_that.playerId,_that.gridCards,_that.actionCards,_that.score,_that.position,_that.isActive,_that.hasRevealedAll,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerGridModel extends PlayerGridModel {
  const _PlayerGridModel({required this.id, required this.gameStateId, required this.playerId, required final  List<Map<String, dynamic>> gridCards, required final  List<Map<String, dynamic>> actionCards, required this.score, required this.position, required this.isActive, required this.hasRevealedAll, required this.createdAt, required this.updatedAt}): _gridCards = gridCards,_actionCards = actionCards,super._();
  factory _PlayerGridModel.fromJson(Map<String, dynamic> json) => _$PlayerGridModelFromJson(json);

@override final  String id;
@override final  String gameStateId;
@override final  String playerId;
 final  List<Map<String, dynamic>> _gridCards;
@override List<Map<String, dynamic>> get gridCards {
  if (_gridCards is EqualUnmodifiableListView) return _gridCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gridCards);
}

 final  List<Map<String, dynamic>> _actionCards;
@override List<Map<String, dynamic>> get actionCards {
  if (_actionCards is EqualUnmodifiableListView) return _actionCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionCards);
}

@override final  int score;
@override final  int position;
@override final  bool isActive;
@override final  bool hasRevealedAll;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of PlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerGridModelCopyWith<_PlayerGridModel> get copyWith => __$PlayerGridModelCopyWithImpl<_PlayerGridModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerGridModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerGridModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gameStateId, gameStateId) || other.gameStateId == gameStateId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other._gridCards, _gridCards)&&const DeepCollectionEquality().equals(other._actionCards, _actionCards)&&(identical(other.score, score) || other.score == score)&&(identical(other.position, position) || other.position == position)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasRevealedAll, hasRevealedAll) || other.hasRevealedAll == hasRevealedAll)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameStateId,playerId,const DeepCollectionEquality().hash(_gridCards),const DeepCollectionEquality().hash(_actionCards),score,position,isActive,hasRevealedAll,createdAt,updatedAt);

@override
String toString() {
  return 'PlayerGridModel(id: $id, gameStateId: $gameStateId, playerId: $playerId, gridCards: $gridCards, actionCards: $actionCards, score: $score, position: $position, isActive: $isActive, hasRevealedAll: $hasRevealedAll, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PlayerGridModelCopyWith<$Res> implements $PlayerGridModelCopyWith<$Res> {
  factory _$PlayerGridModelCopyWith(_PlayerGridModel value, $Res Function(_PlayerGridModel) _then) = __$PlayerGridModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String gameStateId, String playerId, List<Map<String, dynamic>> gridCards, List<Map<String, dynamic>> actionCards, int score, int position, bool isActive, bool hasRevealedAll, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$PlayerGridModelCopyWithImpl<$Res>
    implements _$PlayerGridModelCopyWith<$Res> {
  __$PlayerGridModelCopyWithImpl(this._self, this._then);

  final _PlayerGridModel _self;
  final $Res Function(_PlayerGridModel) _then;

/// Create a copy of PlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameStateId = null,Object? playerId = null,Object? gridCards = null,Object? actionCards = null,Object? score = null,Object? position = null,Object? isActive = null,Object? hasRevealedAll = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PlayerGridModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameStateId: null == gameStateId ? _self.gameStateId : gameStateId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,gridCards: null == gridCards ? _self._gridCards : gridCards // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,actionCards: null == actionCards ? _self._actionCards : actionCards // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hasRevealedAll: null == hasRevealedAll ? _self.hasRevealedAll : hasRevealedAll // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
