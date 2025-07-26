// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_card_state_provider_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionCardState {

 int get drawPileCount; int get discardPileCount; bool get isLoading;
/// Create a copy of ActionCardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionCardStateCopyWith<ActionCardState> get copyWith => _$ActionCardStateCopyWithImpl<ActionCardState>(this as ActionCardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionCardState&&(identical(other.drawPileCount, drawPileCount) || other.drawPileCount == drawPileCount)&&(identical(other.discardPileCount, discardPileCount) || other.discardPileCount == discardPileCount)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,drawPileCount,discardPileCount,isLoading);

@override
String toString() {
  return 'ActionCardState(drawPileCount: $drawPileCount, discardPileCount: $discardPileCount, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $ActionCardStateCopyWith<$Res>  {
  factory $ActionCardStateCopyWith(ActionCardState value, $Res Function(ActionCardState) _then) = _$ActionCardStateCopyWithImpl;
@useResult
$Res call({
 int drawPileCount, int discardPileCount, bool isLoading
});




}
/// @nodoc
class _$ActionCardStateCopyWithImpl<$Res>
    implements $ActionCardStateCopyWith<$Res> {
  _$ActionCardStateCopyWithImpl(this._self, this._then);

  final ActionCardState _self;
  final $Res Function(ActionCardState) _then;

/// Create a copy of ActionCardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? drawPileCount = null,Object? discardPileCount = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
drawPileCount: null == drawPileCount ? _self.drawPileCount : drawPileCount // ignore: cast_nullable_to_non_nullable
as int,discardPileCount: null == discardPileCount ? _self.discardPileCount : discardPileCount // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionCardState].
extension ActionCardStatePatterns on ActionCardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionCardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionCardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionCardState value)  $default,){
final _that = this;
switch (_that) {
case _ActionCardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionCardState value)?  $default,){
final _that = this;
switch (_that) {
case _ActionCardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int drawPileCount,  int discardPileCount,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionCardState() when $default != null:
return $default(_that.drawPileCount,_that.discardPileCount,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int drawPileCount,  int discardPileCount,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _ActionCardState():
return $default(_that.drawPileCount,_that.discardPileCount,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int drawPileCount,  int discardPileCount,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _ActionCardState() when $default != null:
return $default(_that.drawPileCount,_that.discardPileCount,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _ActionCardState implements ActionCardState {
  const _ActionCardState({required this.drawPileCount, required this.discardPileCount, required this.isLoading});
  

@override final  int drawPileCount;
@override final  int discardPileCount;
@override final  bool isLoading;

/// Create a copy of ActionCardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionCardStateCopyWith<_ActionCardState> get copyWith => __$ActionCardStateCopyWithImpl<_ActionCardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionCardState&&(identical(other.drawPileCount, drawPileCount) || other.drawPileCount == drawPileCount)&&(identical(other.discardPileCount, discardPileCount) || other.discardPileCount == discardPileCount)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,drawPileCount,discardPileCount,isLoading);

@override
String toString() {
  return 'ActionCardState(drawPileCount: $drawPileCount, discardPileCount: $discardPileCount, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$ActionCardStateCopyWith<$Res> implements $ActionCardStateCopyWith<$Res> {
  factory _$ActionCardStateCopyWith(_ActionCardState value, $Res Function(_ActionCardState) _then) = __$ActionCardStateCopyWithImpl;
@override @useResult
$Res call({
 int drawPileCount, int discardPileCount, bool isLoading
});




}
/// @nodoc
class __$ActionCardStateCopyWithImpl<$Res>
    implements _$ActionCardStateCopyWith<$Res> {
  __$ActionCardStateCopyWithImpl(this._self, this._then);

  final _ActionCardState _self;
  final $Res Function(_ActionCardState) _then;

/// Create a copy of ActionCardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? drawPileCount = null,Object? discardPileCount = null,Object? isLoading = null,}) {
  return _then(_ActionCardState(
drawPileCount: null == drawPileCount ? _self.drawPileCount : drawPileCount // ignore: cast_nullable_to_non_nullable
as int,discardPileCount: null == discardPileCount ? _self.discardPileCount : discardPileCount // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
