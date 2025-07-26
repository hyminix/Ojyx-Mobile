// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'db_player_grid_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DbPlayerGridModel {

 String get id;@JsonKey(name: 'game_state_id') String get gameStateId;@JsonKey(name: 'player_id') String get playerId;@JsonKey(name: 'grid_cards') List<Card> get gridCards;@JsonKey(name: 'action_cards') List<ActionCard> get actionCards; int get score; int get position;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'has_revealed_all') bool get hasRevealedAll;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of DbPlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DbPlayerGridModelCopyWith<DbPlayerGridModel> get copyWith => _$DbPlayerGridModelCopyWithImpl<DbPlayerGridModel>(this as DbPlayerGridModel, _$identity);

  /// Serializes this DbPlayerGridModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DbPlayerGridModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gameStateId, gameStateId) || other.gameStateId == gameStateId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other.gridCards, gridCards)&&const DeepCollectionEquality().equals(other.actionCards, actionCards)&&(identical(other.score, score) || other.score == score)&&(identical(other.position, position) || other.position == position)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasRevealedAll, hasRevealedAll) || other.hasRevealedAll == hasRevealedAll)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameStateId,playerId,const DeepCollectionEquality().hash(gridCards),const DeepCollectionEquality().hash(actionCards),score,position,isActive,hasRevealedAll,createdAt,updatedAt);

@override
String toString() {
  return 'DbPlayerGridModel(id: $id, gameStateId: $gameStateId, playerId: $playerId, gridCards: $gridCards, actionCards: $actionCards, score: $score, position: $position, isActive: $isActive, hasRevealedAll: $hasRevealedAll, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DbPlayerGridModelCopyWith<$Res>  {
  factory $DbPlayerGridModelCopyWith(DbPlayerGridModel value, $Res Function(DbPlayerGridModel) _then) = _$DbPlayerGridModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'game_state_id') String gameStateId,@JsonKey(name: 'player_id') String playerId,@JsonKey(name: 'grid_cards') List<Card> gridCards,@JsonKey(name: 'action_cards') List<ActionCard> actionCards, int score, int position,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'has_revealed_all') bool hasRevealedAll,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$DbPlayerGridModelCopyWithImpl<$Res>
    implements $DbPlayerGridModelCopyWith<$Res> {
  _$DbPlayerGridModelCopyWithImpl(this._self, this._then);

  final DbPlayerGridModel _self;
  final $Res Function(DbPlayerGridModel) _then;

/// Create a copy of DbPlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameStateId = null,Object? playerId = null,Object? gridCards = null,Object? actionCards = null,Object? score = null,Object? position = null,Object? isActive = null,Object? hasRevealedAll = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameStateId: null == gameStateId ? _self.gameStateId : gameStateId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,gridCards: null == gridCards ? _self.gridCards : gridCards // ignore: cast_nullable_to_non_nullable
as List<Card>,actionCards: null == actionCards ? _self.actionCards : actionCards // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,hasRevealedAll: null == hasRevealedAll ? _self.hasRevealedAll : hasRevealedAll // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DbPlayerGridModel].
extension DbPlayerGridModelPatterns on DbPlayerGridModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DbPlayerGridModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DbPlayerGridModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DbPlayerGridModel value)  $default,){
final _that = this;
switch (_that) {
case _DbPlayerGridModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DbPlayerGridModel value)?  $default,){
final _that = this;
switch (_that) {
case _DbPlayerGridModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'game_state_id')  String gameStateId, @JsonKey(name: 'player_id')  String playerId, @JsonKey(name: 'grid_cards')  List<Card> gridCards, @JsonKey(name: 'action_cards')  List<ActionCard> actionCards,  int score,  int position, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'has_revealed_all')  bool hasRevealedAll, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DbPlayerGridModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'game_state_id')  String gameStateId, @JsonKey(name: 'player_id')  String playerId, @JsonKey(name: 'grid_cards')  List<Card> gridCards, @JsonKey(name: 'action_cards')  List<ActionCard> actionCards,  int score,  int position, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'has_revealed_all')  bool hasRevealedAll, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DbPlayerGridModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'game_state_id')  String gameStateId, @JsonKey(name: 'player_id')  String playerId, @JsonKey(name: 'grid_cards')  List<Card> gridCards, @JsonKey(name: 'action_cards')  List<ActionCard> actionCards,  int score,  int position, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'has_revealed_all')  bool hasRevealedAll, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DbPlayerGridModel() when $default != null:
return $default(_that.id,_that.gameStateId,_that.playerId,_that.gridCards,_that.actionCards,_that.score,_that.position,_that.isActive,_that.hasRevealedAll,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DbPlayerGridModel extends DbPlayerGridModel {
  const _DbPlayerGridModel({required this.id, @JsonKey(name: 'game_state_id') required this.gameStateId, @JsonKey(name: 'player_id') required this.playerId, @JsonKey(name: 'grid_cards') required final  List<Card> gridCards, @JsonKey(name: 'action_cards') required final  List<ActionCard> actionCards, required this.score, required this.position, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'has_revealed_all') required this.hasRevealedAll, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt}): _gridCards = gridCards,_actionCards = actionCards,super._();
  factory _DbPlayerGridModel.fromJson(Map<String, dynamic> json) => _$DbPlayerGridModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'game_state_id') final  String gameStateId;
@override@JsonKey(name: 'player_id') final  String playerId;
 final  List<Card> _gridCards;
@override@JsonKey(name: 'grid_cards') List<Card> get gridCards {
  if (_gridCards is EqualUnmodifiableListView) return _gridCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gridCards);
}

 final  List<ActionCard> _actionCards;
@override@JsonKey(name: 'action_cards') List<ActionCard> get actionCards {
  if (_actionCards is EqualUnmodifiableListView) return _actionCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actionCards);
}

@override final  int score;
@override final  int position;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'has_revealed_all') final  bool hasRevealedAll;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of DbPlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DbPlayerGridModelCopyWith<_DbPlayerGridModel> get copyWith => __$DbPlayerGridModelCopyWithImpl<_DbPlayerGridModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DbPlayerGridModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DbPlayerGridModel&&(identical(other.id, id) || other.id == id)&&(identical(other.gameStateId, gameStateId) || other.gameStateId == gameStateId)&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other._gridCards, _gridCards)&&const DeepCollectionEquality().equals(other._actionCards, _actionCards)&&(identical(other.score, score) || other.score == score)&&(identical(other.position, position) || other.position == position)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.hasRevealedAll, hasRevealedAll) || other.hasRevealedAll == hasRevealedAll)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gameStateId,playerId,const DeepCollectionEquality().hash(_gridCards),const DeepCollectionEquality().hash(_actionCards),score,position,isActive,hasRevealedAll,createdAt,updatedAt);

@override
String toString() {
  return 'DbPlayerGridModel(id: $id, gameStateId: $gameStateId, playerId: $playerId, gridCards: $gridCards, actionCards: $actionCards, score: $score, position: $position, isActive: $isActive, hasRevealedAll: $hasRevealedAll, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DbPlayerGridModelCopyWith<$Res> implements $DbPlayerGridModelCopyWith<$Res> {
  factory _$DbPlayerGridModelCopyWith(_DbPlayerGridModel value, $Res Function(_DbPlayerGridModel) _then) = __$DbPlayerGridModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'game_state_id') String gameStateId,@JsonKey(name: 'player_id') String playerId,@JsonKey(name: 'grid_cards') List<Card> gridCards,@JsonKey(name: 'action_cards') List<ActionCard> actionCards, int score, int position,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'has_revealed_all') bool hasRevealedAll,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$DbPlayerGridModelCopyWithImpl<$Res>
    implements _$DbPlayerGridModelCopyWith<$Res> {
  __$DbPlayerGridModelCopyWithImpl(this._self, this._then);

  final _DbPlayerGridModel _self;
  final $Res Function(_DbPlayerGridModel) _then;

/// Create a copy of DbPlayerGridModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameStateId = null,Object? playerId = null,Object? gridCards = null,Object? actionCards = null,Object? score = null,Object? position = null,Object? isActive = null,Object? hasRevealedAll = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_DbPlayerGridModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameStateId: null == gameStateId ? _self.gameStateId : gameStateId // ignore: cast_nullable_to_non_nullable
as String,playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,gridCards: null == gridCards ? _self._gridCards : gridCards // ignore: cast_nullable_to_non_nullable
as List<Card>,actionCards: null == actionCards ? _self._actionCards : actionCards // ignore: cast_nullable_to_non_nullable
as List<ActionCard>,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
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
