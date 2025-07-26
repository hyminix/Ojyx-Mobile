// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_grid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerGrid {

 List<List<Card?>> get cards;
/// Create a copy of PlayerGrid
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerGridCopyWith<PlayerGrid> get copyWith => _$PlayerGridCopyWithImpl<PlayerGrid>(this as PlayerGrid, _$identity);

  /// Serializes this PlayerGrid to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerGrid&&const DeepCollectionEquality().equals(other.cards, cards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cards));

@override
String toString() {
  return 'PlayerGrid(cards: $cards)';
}


}

/// @nodoc
abstract mixin class $PlayerGridCopyWith<$Res>  {
  factory $PlayerGridCopyWith(PlayerGrid value, $Res Function(PlayerGrid) _then) = _$PlayerGridCopyWithImpl;
@useResult
$Res call({
 List<List<Card?>> cards
});




}
/// @nodoc
class _$PlayerGridCopyWithImpl<$Res>
    implements $PlayerGridCopyWith<$Res> {
  _$PlayerGridCopyWithImpl(this._self, this._then);

  final PlayerGrid _self;
  final $Res Function(PlayerGrid) _then;

/// Create a copy of PlayerGrid
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cards = null,}) {
  return _then(_self.copyWith(
cards: null == cards ? _self.cards : cards // ignore: cast_nullable_to_non_nullable
as List<List<Card?>>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerGrid].
extension PlayerGridPatterns on PlayerGrid {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerGrid value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerGrid() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerGrid value)  $default,){
final _that = this;
switch (_that) {
case _PlayerGrid():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerGrid value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerGrid() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<List<Card?>> cards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerGrid() when $default != null:
return $default(_that.cards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<List<Card?>> cards)  $default,) {final _that = this;
switch (_that) {
case _PlayerGrid():
return $default(_that.cards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<List<Card?>> cards)?  $default,) {final _that = this;
switch (_that) {
case _PlayerGrid() when $default != null:
return $default(_that.cards);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerGrid extends PlayerGrid {
  const _PlayerGrid({required final  List<List<Card?>> cards}): _cards = cards,super._();
  factory _PlayerGrid.fromJson(Map<String, dynamic> json) => _$PlayerGridFromJson(json);

 final  List<List<Card?>> _cards;
@override List<List<Card?>> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}


/// Create a copy of PlayerGrid
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerGridCopyWith<_PlayerGrid> get copyWith => __$PlayerGridCopyWithImpl<_PlayerGrid>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerGridToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerGrid&&const DeepCollectionEquality().equals(other._cards, _cards));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_cards));

@override
String toString() {
  return 'PlayerGrid(cards: $cards)';
}


}

/// @nodoc
abstract mixin class _$PlayerGridCopyWith<$Res> implements $PlayerGridCopyWith<$Res> {
  factory _$PlayerGridCopyWith(_PlayerGrid value, $Res Function(_PlayerGrid) _then) = __$PlayerGridCopyWithImpl;
@override @useResult
$Res call({
 List<List<Card?>> cards
});




}
/// @nodoc
class __$PlayerGridCopyWithImpl<$Res>
    implements _$PlayerGridCopyWith<$Res> {
  __$PlayerGridCopyWithImpl(this._self, this._then);

  final _PlayerGrid _self;
  final $Res Function(_PlayerGrid) _then;

/// Create a copy of PlayerGrid
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cards = null,}) {
  return _then(_PlayerGrid(
cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<List<Card?>>,
  ));
}


}

// dart format on
