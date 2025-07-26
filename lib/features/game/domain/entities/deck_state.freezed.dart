// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deck_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeckState {

 List<Card> get drawPile; List<Card> get discardPile;
/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeckStateCopyWith<DeckState> get copyWith => _$DeckStateCopyWithImpl<DeckState>(this as DeckState, _$identity);

  /// Serializes this DeckState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeckState&&const DeepCollectionEquality().equals(other.drawPile, drawPile)&&const DeepCollectionEquality().equals(other.discardPile, discardPile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(drawPile),const DeepCollectionEquality().hash(discardPile));

@override
String toString() {
  return 'DeckState(drawPile: $drawPile, discardPile: $discardPile)';
}


}

/// @nodoc
abstract mixin class $DeckStateCopyWith<$Res>  {
  factory $DeckStateCopyWith(DeckState value, $Res Function(DeckState) _then) = _$DeckStateCopyWithImpl;
@useResult
$Res call({
 List<Card> drawPile, List<Card> discardPile
});




}
/// @nodoc
class _$DeckStateCopyWithImpl<$Res>
    implements $DeckStateCopyWith<$Res> {
  _$DeckStateCopyWithImpl(this._self, this._then);

  final DeckState _self;
  final $Res Function(DeckState) _then;

/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drawPile = null,Object? discardPile = null,}) {
  return _then(_self.copyWith(
drawPile: null == drawPile ? _self.drawPile : drawPile // ignore: cast_nullable_to_non_nullable
as List<Card>,discardPile: null == discardPile ? _self.discardPile : discardPile // ignore: cast_nullable_to_non_nullable
as List<Card>,
  ));
}

}


/// Adds pattern-matching-related methods to [DeckState].
extension DeckStatePatterns on DeckState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeckState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeckState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeckState value)  $default,){
final _that = this;
switch (_that) {
case _DeckState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeckState value)?  $default,){
final _that = this;
switch (_that) {
case _DeckState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Card> drawPile,  List<Card> discardPile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeckState() when $default != null:
return $default(_that.drawPile,_that.discardPile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Card> drawPile,  List<Card> discardPile)  $default,) {final _that = this;
switch (_that) {
case _DeckState():
return $default(_that.drawPile,_that.discardPile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Card> drawPile,  List<Card> discardPile)?  $default,) {final _that = this;
switch (_that) {
case _DeckState() when $default != null:
return $default(_that.drawPile,_that.discardPile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeckState extends DeckState {
  const _DeckState({required final  List<Card> drawPile, required final  List<Card> discardPile}): _drawPile = drawPile,_discardPile = discardPile,super._();
  factory _DeckState.fromJson(Map<String, dynamic> json) => _$DeckStateFromJson(json);

 final  List<Card> _drawPile;
@override List<Card> get drawPile {
  if (_drawPile is EqualUnmodifiableListView) return _drawPile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drawPile);
}

 final  List<Card> _discardPile;
@override List<Card> get discardPile {
  if (_discardPile is EqualUnmodifiableListView) return _discardPile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discardPile);
}


/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeckStateCopyWith<_DeckState> get copyWith => __$DeckStateCopyWithImpl<_DeckState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeckStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeckState&&const DeepCollectionEquality().equals(other._drawPile, _drawPile)&&const DeepCollectionEquality().equals(other._discardPile, _discardPile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_drawPile),const DeepCollectionEquality().hash(_discardPile));

@override
String toString() {
  return 'DeckState(drawPile: $drawPile, discardPile: $discardPile)';
}


}

/// @nodoc
abstract mixin class _$DeckStateCopyWith<$Res> implements $DeckStateCopyWith<$Res> {
  factory _$DeckStateCopyWith(_DeckState value, $Res Function(_DeckState) _then) = __$DeckStateCopyWithImpl;
@override @useResult
$Res call({
 List<Card> drawPile, List<Card> discardPile
});




}
/// @nodoc
class __$DeckStateCopyWithImpl<$Res>
    implements _$DeckStateCopyWith<$Res> {
  __$DeckStateCopyWithImpl(this._self, this._then);

  final _DeckState _self;
  final $Res Function(_DeckState) _then;

/// Create a copy of DeckState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drawPile = null,Object? discardPile = null,}) {
  return _then(_DeckState(
drawPile: null == drawPile ? _self._drawPile : drawPile // ignore: cast_nullable_to_non_nullable
as List<Card>,discardPile: null == discardPile ? _self._discardPile : discardPile // ignore: cast_nullable_to_non_nullable
as List<Card>,
  ));
}


}

// dart format on
