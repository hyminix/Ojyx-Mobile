// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_monitor_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectionMonitorState implements DiagnosticableTreeMixin {

 ConnectionStatus get status; DateTime? get lastDisconnect; DateTime? get lastReconnect; int get reconnectAttempts; bool get isResynchronizing;
/// Create a copy of ConnectionMonitorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionMonitorStateCopyWith<ConnectionMonitorState> get copyWith => _$ConnectionMonitorStateCopyWithImpl<ConnectionMonitorState>(this as ConnectionMonitorState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ConnectionMonitorState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('lastDisconnect', lastDisconnect))..add(DiagnosticsProperty('lastReconnect', lastReconnect))..add(DiagnosticsProperty('reconnectAttempts', reconnectAttempts))..add(DiagnosticsProperty('isResynchronizing', isResynchronizing));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionMonitorState&&(identical(other.status, status) || other.status == status)&&(identical(other.lastDisconnect, lastDisconnect) || other.lastDisconnect == lastDisconnect)&&(identical(other.lastReconnect, lastReconnect) || other.lastReconnect == lastReconnect)&&(identical(other.reconnectAttempts, reconnectAttempts) || other.reconnectAttempts == reconnectAttempts)&&(identical(other.isResynchronizing, isResynchronizing) || other.isResynchronizing == isResynchronizing));
}


@override
int get hashCode => Object.hash(runtimeType,status,lastDisconnect,lastReconnect,reconnectAttempts,isResynchronizing);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ConnectionMonitorState(status: $status, lastDisconnect: $lastDisconnect, lastReconnect: $lastReconnect, reconnectAttempts: $reconnectAttempts, isResynchronizing: $isResynchronizing)';
}


}

/// @nodoc
abstract mixin class $ConnectionMonitorStateCopyWith<$Res>  {
  factory $ConnectionMonitorStateCopyWith(ConnectionMonitorState value, $Res Function(ConnectionMonitorState) _then) = _$ConnectionMonitorStateCopyWithImpl;
@useResult
$Res call({
 ConnectionStatus status, DateTime? lastDisconnect, DateTime? lastReconnect, int reconnectAttempts, bool isResynchronizing
});




}
/// @nodoc
class _$ConnectionMonitorStateCopyWithImpl<$Res>
    implements $ConnectionMonitorStateCopyWith<$Res> {
  _$ConnectionMonitorStateCopyWithImpl(this._self, this._then);

  final ConnectionMonitorState _self;
  final $Res Function(ConnectionMonitorState) _then;

/// Create a copy of ConnectionMonitorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? lastDisconnect = freezed,Object? lastReconnect = freezed,Object? reconnectAttempts = null,Object? isResynchronizing = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConnectionStatus,lastDisconnect: freezed == lastDisconnect ? _self.lastDisconnect : lastDisconnect // ignore: cast_nullable_to_non_nullable
as DateTime?,lastReconnect: freezed == lastReconnect ? _self.lastReconnect : lastReconnect // ignore: cast_nullable_to_non_nullable
as DateTime?,reconnectAttempts: null == reconnectAttempts ? _self.reconnectAttempts : reconnectAttempts // ignore: cast_nullable_to_non_nullable
as int,isResynchronizing: null == isResynchronizing ? _self.isResynchronizing : isResynchronizing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectionMonitorState].
extension ConnectionMonitorStatePatterns on ConnectionMonitorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectionMonitorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectionMonitorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectionMonitorState value)  $default,){
final _that = this;
switch (_that) {
case _ConnectionMonitorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectionMonitorState value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectionMonitorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConnectionStatus status,  DateTime? lastDisconnect,  DateTime? lastReconnect,  int reconnectAttempts,  bool isResynchronizing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectionMonitorState() when $default != null:
return $default(_that.status,_that.lastDisconnect,_that.lastReconnect,_that.reconnectAttempts,_that.isResynchronizing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConnectionStatus status,  DateTime? lastDisconnect,  DateTime? lastReconnect,  int reconnectAttempts,  bool isResynchronizing)  $default,) {final _that = this;
switch (_that) {
case _ConnectionMonitorState():
return $default(_that.status,_that.lastDisconnect,_that.lastReconnect,_that.reconnectAttempts,_that.isResynchronizing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConnectionStatus status,  DateTime? lastDisconnect,  DateTime? lastReconnect,  int reconnectAttempts,  bool isResynchronizing)?  $default,) {final _that = this;
switch (_that) {
case _ConnectionMonitorState() when $default != null:
return $default(_that.status,_that.lastDisconnect,_that.lastReconnect,_that.reconnectAttempts,_that.isResynchronizing);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectionMonitorState with DiagnosticableTreeMixin implements ConnectionMonitorState {
  const _ConnectionMonitorState({required this.status, this.lastDisconnect, this.lastReconnect, this.reconnectAttempts = 0, this.isResynchronizing = false});
  

@override final  ConnectionStatus status;
@override final  DateTime? lastDisconnect;
@override final  DateTime? lastReconnect;
@override@JsonKey() final  int reconnectAttempts;
@override@JsonKey() final  bool isResynchronizing;

/// Create a copy of ConnectionMonitorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectionMonitorStateCopyWith<_ConnectionMonitorState> get copyWith => __$ConnectionMonitorStateCopyWithImpl<_ConnectionMonitorState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ConnectionMonitorState'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('lastDisconnect', lastDisconnect))..add(DiagnosticsProperty('lastReconnect', lastReconnect))..add(DiagnosticsProperty('reconnectAttempts', reconnectAttempts))..add(DiagnosticsProperty('isResynchronizing', isResynchronizing));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectionMonitorState&&(identical(other.status, status) || other.status == status)&&(identical(other.lastDisconnect, lastDisconnect) || other.lastDisconnect == lastDisconnect)&&(identical(other.lastReconnect, lastReconnect) || other.lastReconnect == lastReconnect)&&(identical(other.reconnectAttempts, reconnectAttempts) || other.reconnectAttempts == reconnectAttempts)&&(identical(other.isResynchronizing, isResynchronizing) || other.isResynchronizing == isResynchronizing));
}


@override
int get hashCode => Object.hash(runtimeType,status,lastDisconnect,lastReconnect,reconnectAttempts,isResynchronizing);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ConnectionMonitorState(status: $status, lastDisconnect: $lastDisconnect, lastReconnect: $lastReconnect, reconnectAttempts: $reconnectAttempts, isResynchronizing: $isResynchronizing)';
}


}

/// @nodoc
abstract mixin class _$ConnectionMonitorStateCopyWith<$Res> implements $ConnectionMonitorStateCopyWith<$Res> {
  factory _$ConnectionMonitorStateCopyWith(_ConnectionMonitorState value, $Res Function(_ConnectionMonitorState) _then) = __$ConnectionMonitorStateCopyWithImpl;
@override @useResult
$Res call({
 ConnectionStatus status, DateTime? lastDisconnect, DateTime? lastReconnect, int reconnectAttempts, bool isResynchronizing
});




}
/// @nodoc
class __$ConnectionMonitorStateCopyWithImpl<$Res>
    implements _$ConnectionMonitorStateCopyWith<$Res> {
  __$ConnectionMonitorStateCopyWithImpl(this._self, this._then);

  final _ConnectionMonitorState _self;
  final $Res Function(_ConnectionMonitorState) _then;

/// Create a copy of ConnectionMonitorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? lastDisconnect = freezed,Object? lastReconnect = freezed,Object? reconnectAttempts = null,Object? isResynchronizing = null,}) {
  return _then(_ConnectionMonitorState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConnectionStatus,lastDisconnect: freezed == lastDisconnect ? _self.lastDisconnect : lastDisconnect // ignore: cast_nullable_to_non_nullable
as DateTime?,lastReconnect: freezed == lastReconnect ? _self.lastReconnect : lastReconnect // ignore: cast_nullable_to_non_nullable
as DateTime?,reconnectAttempts: null == reconnectAttempts ? _self.reconnectAttempts : reconnectAttempts // ignore: cast_nullable_to_non_nullable
as int,isResynchronizing: null == isResynchronizing ? _self.isResynchronizing : isResynchronizing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
