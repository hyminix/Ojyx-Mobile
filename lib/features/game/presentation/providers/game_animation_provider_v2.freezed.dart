// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_animation_provider_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameAnimationState {

 bool get showingDirectionChange; PlayDirection get direction;
/// Create a copy of GameAnimationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameAnimationStateCopyWith<GameAnimationState> get copyWith => _$GameAnimationStateCopyWithImpl<GameAnimationState>(this as GameAnimationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameAnimationState&&(identical(other.showingDirectionChange, showingDirectionChange) || other.showingDirectionChange == showingDirectionChange)&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,showingDirectionChange,direction);

@override
String toString() {
  return 'GameAnimationState(showingDirectionChange: $showingDirectionChange, direction: $direction)';
}


}

/// @nodoc
abstract mixin class $GameAnimationStateCopyWith<$Res>  {
  factory $GameAnimationStateCopyWith(GameAnimationState value, $Res Function(GameAnimationState) _then) = _$GameAnimationStateCopyWithImpl;
@useResult
$Res call({
 bool showingDirectionChange, PlayDirection direction
});




}
/// @nodoc
class _$GameAnimationStateCopyWithImpl<$Res>
    implements $GameAnimationStateCopyWith<$Res> {
  _$GameAnimationStateCopyWithImpl(this._self, this._then);

  final GameAnimationState _self;
  final $Res Function(GameAnimationState) _then;

/// Create a copy of GameAnimationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? showingDirectionChange = null,Object? direction = null,}) {
  return _then(_self.copyWith(
showingDirectionChange: null == showingDirectionChange ? _self.showingDirectionChange : showingDirectionChange // ignore: cast_nullable_to_non_nullable
as bool,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PlayDirection,
  ));
}

}


/// Adds pattern-matching-related methods to [GameAnimationState].
extension GameAnimationStatePatterns on GameAnimationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameAnimationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameAnimationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameAnimationState value)  $default,){
final _that = this;
switch (_that) {
case _GameAnimationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameAnimationState value)?  $default,){
final _that = this;
switch (_that) {
case _GameAnimationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool showingDirectionChange,  PlayDirection direction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameAnimationState() when $default != null:
return $default(_that.showingDirectionChange,_that.direction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool showingDirectionChange,  PlayDirection direction)  $default,) {final _that = this;
switch (_that) {
case _GameAnimationState():
return $default(_that.showingDirectionChange,_that.direction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool showingDirectionChange,  PlayDirection direction)?  $default,) {final _that = this;
switch (_that) {
case _GameAnimationState() when $default != null:
return $default(_that.showingDirectionChange,_that.direction);case _:
  return null;

}
}

}

/// @nodoc


class _GameAnimationState implements GameAnimationState {
  const _GameAnimationState({this.showingDirectionChange = false, this.direction = PlayDirection.forward});
  

@override@JsonKey() final  bool showingDirectionChange;
@override@JsonKey() final  PlayDirection direction;

/// Create a copy of GameAnimationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameAnimationStateCopyWith<_GameAnimationState> get copyWith => __$GameAnimationStateCopyWithImpl<_GameAnimationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameAnimationState&&(identical(other.showingDirectionChange, showingDirectionChange) || other.showingDirectionChange == showingDirectionChange)&&(identical(other.direction, direction) || other.direction == direction));
}


@override
int get hashCode => Object.hash(runtimeType,showingDirectionChange,direction);

@override
String toString() {
  return 'GameAnimationState(showingDirectionChange: $showingDirectionChange, direction: $direction)';
}


}

/// @nodoc
abstract mixin class _$GameAnimationStateCopyWith<$Res> implements $GameAnimationStateCopyWith<$Res> {
  factory _$GameAnimationStateCopyWith(_GameAnimationState value, $Res Function(_GameAnimationState) _then) = __$GameAnimationStateCopyWithImpl;
@override @useResult
$Res call({
 bool showingDirectionChange, PlayDirection direction
});




}
/// @nodoc
class __$GameAnimationStateCopyWithImpl<$Res>
    implements _$GameAnimationStateCopyWith<$Res> {
  __$GameAnimationStateCopyWithImpl(this._self, this._then);

  final _GameAnimationState _self;
  final $Res Function(_GameAnimationState) _then;

/// Create a copy of GameAnimationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? showingDirectionChange = null,Object? direction = null,}) {
  return _then(_GameAnimationState(
showingDirectionChange: null == showingDirectionChange ? _self.showingDirectionChange : showingDirectionChange // ignore: cast_nullable_to_non_nullable
as bool,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as PlayDirection,
  ));
}


}

// dart format on
