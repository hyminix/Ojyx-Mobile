// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'optimistic_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OptimisticState<T> {

/// Valeur locale (optimiste) affichée à l'utilisateur
 T get localValue;/// Valeur confirmée par le serveur
 T? get serverValue;/// Indique si une synchronisation est en cours
 bool get isSyncing;/// Erreur de synchronisation si présente
 String? get syncError;/// Timestamp de la dernière tentative de synchronisation
 DateTime get lastSyncAttempt;/// Nombre d'actions en attente de synchronisation
 int get pendingActionsCount;/// ID de la dernière action synchronisée avec succès
 String? get lastSyncedActionId;
/// Create a copy of OptimisticState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptimisticStateCopyWith<T, OptimisticState<T>> get copyWith => _$OptimisticStateCopyWithImpl<T, OptimisticState<T>>(this as OptimisticState<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptimisticState<T>&&const DeepCollectionEquality().equals(other.localValue, localValue)&&const DeepCollectionEquality().equals(other.serverValue, serverValue)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.syncError, syncError) || other.syncError == syncError)&&(identical(other.lastSyncAttempt, lastSyncAttempt) || other.lastSyncAttempt == lastSyncAttempt)&&(identical(other.pendingActionsCount, pendingActionsCount) || other.pendingActionsCount == pendingActionsCount)&&(identical(other.lastSyncedActionId, lastSyncedActionId) || other.lastSyncedActionId == lastSyncedActionId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(localValue),const DeepCollectionEquality().hash(serverValue),isSyncing,syncError,lastSyncAttempt,pendingActionsCount,lastSyncedActionId);

@override
String toString() {
  return 'OptimisticState<$T>(localValue: $localValue, serverValue: $serverValue, isSyncing: $isSyncing, syncError: $syncError, lastSyncAttempt: $lastSyncAttempt, pendingActionsCount: $pendingActionsCount, lastSyncedActionId: $lastSyncedActionId)';
}


}

/// @nodoc
abstract mixin class $OptimisticStateCopyWith<T,$Res>  {
  factory $OptimisticStateCopyWith(OptimisticState<T> value, $Res Function(OptimisticState<T>) _then) = _$OptimisticStateCopyWithImpl;
@useResult
$Res call({
 T localValue, T? serverValue, bool isSyncing, String? syncError, DateTime lastSyncAttempt, int pendingActionsCount, String? lastSyncedActionId
});




}
/// @nodoc
class _$OptimisticStateCopyWithImpl<T,$Res>
    implements $OptimisticStateCopyWith<T, $Res> {
  _$OptimisticStateCopyWithImpl(this._self, this._then);

  final OptimisticState<T> _self;
  final $Res Function(OptimisticState<T>) _then;

/// Create a copy of OptimisticState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localValue = freezed,Object? serverValue = freezed,Object? isSyncing = null,Object? syncError = freezed,Object? lastSyncAttempt = null,Object? pendingActionsCount = null,Object? lastSyncedActionId = freezed,}) {
  return _then(_self.copyWith(
localValue: freezed == localValue ? _self.localValue : localValue // ignore: cast_nullable_to_non_nullable
as T,serverValue: freezed == serverValue ? _self.serverValue : serverValue // ignore: cast_nullable_to_non_nullable
as T?,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,syncError: freezed == syncError ? _self.syncError : syncError // ignore: cast_nullable_to_non_nullable
as String?,lastSyncAttempt: null == lastSyncAttempt ? _self.lastSyncAttempt : lastSyncAttempt // ignore: cast_nullable_to_non_nullable
as DateTime,pendingActionsCount: null == pendingActionsCount ? _self.pendingActionsCount : pendingActionsCount // ignore: cast_nullable_to_non_nullable
as int,lastSyncedActionId: freezed == lastSyncedActionId ? _self.lastSyncedActionId : lastSyncedActionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OptimisticState].
extension OptimisticStatePatterns<T> on OptimisticState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptimisticState<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptimisticState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptimisticState<T> value)  $default,){
final _that = this;
switch (_that) {
case _OptimisticState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptimisticState<T> value)?  $default,){
final _that = this;
switch (_that) {
case _OptimisticState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( T localValue,  T? serverValue,  bool isSyncing,  String? syncError,  DateTime lastSyncAttempt,  int pendingActionsCount,  String? lastSyncedActionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptimisticState() when $default != null:
return $default(_that.localValue,_that.serverValue,_that.isSyncing,_that.syncError,_that.lastSyncAttempt,_that.pendingActionsCount,_that.lastSyncedActionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( T localValue,  T? serverValue,  bool isSyncing,  String? syncError,  DateTime lastSyncAttempt,  int pendingActionsCount,  String? lastSyncedActionId)  $default,) {final _that = this;
switch (_that) {
case _OptimisticState():
return $default(_that.localValue,_that.serverValue,_that.isSyncing,_that.syncError,_that.lastSyncAttempt,_that.pendingActionsCount,_that.lastSyncedActionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( T localValue,  T? serverValue,  bool isSyncing,  String? syncError,  DateTime lastSyncAttempt,  int pendingActionsCount,  String? lastSyncedActionId)?  $default,) {final _that = this;
switch (_that) {
case _OptimisticState() when $default != null:
return $default(_that.localValue,_that.serverValue,_that.isSyncing,_that.syncError,_that.lastSyncAttempt,_that.pendingActionsCount,_that.lastSyncedActionId);case _:
  return null;

}
}

}

/// @nodoc


class _OptimisticState<T> extends OptimisticState<T> {
  const _OptimisticState({required this.localValue, this.serverValue, this.isSyncing = false, this.syncError, required this.lastSyncAttempt, this.pendingActionsCount = 0, this.lastSyncedActionId}): super._();
  

/// Valeur locale (optimiste) affichée à l'utilisateur
@override final  T localValue;
/// Valeur confirmée par le serveur
@override final  T? serverValue;
/// Indique si une synchronisation est en cours
@override@JsonKey() final  bool isSyncing;
/// Erreur de synchronisation si présente
@override final  String? syncError;
/// Timestamp de la dernière tentative de synchronisation
@override final  DateTime lastSyncAttempt;
/// Nombre d'actions en attente de synchronisation
@override@JsonKey() final  int pendingActionsCount;
/// ID de la dernière action synchronisée avec succès
@override final  String? lastSyncedActionId;

/// Create a copy of OptimisticState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptimisticStateCopyWith<T, _OptimisticState<T>> get copyWith => __$OptimisticStateCopyWithImpl<T, _OptimisticState<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptimisticState<T>&&const DeepCollectionEquality().equals(other.localValue, localValue)&&const DeepCollectionEquality().equals(other.serverValue, serverValue)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.syncError, syncError) || other.syncError == syncError)&&(identical(other.lastSyncAttempt, lastSyncAttempt) || other.lastSyncAttempt == lastSyncAttempt)&&(identical(other.pendingActionsCount, pendingActionsCount) || other.pendingActionsCount == pendingActionsCount)&&(identical(other.lastSyncedActionId, lastSyncedActionId) || other.lastSyncedActionId == lastSyncedActionId));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(localValue),const DeepCollectionEquality().hash(serverValue),isSyncing,syncError,lastSyncAttempt,pendingActionsCount,lastSyncedActionId);

@override
String toString() {
  return 'OptimisticState<$T>(localValue: $localValue, serverValue: $serverValue, isSyncing: $isSyncing, syncError: $syncError, lastSyncAttempt: $lastSyncAttempt, pendingActionsCount: $pendingActionsCount, lastSyncedActionId: $lastSyncedActionId)';
}


}

/// @nodoc
abstract mixin class _$OptimisticStateCopyWith<T,$Res> implements $OptimisticStateCopyWith<T, $Res> {
  factory _$OptimisticStateCopyWith(_OptimisticState<T> value, $Res Function(_OptimisticState<T>) _then) = __$OptimisticStateCopyWithImpl;
@override @useResult
$Res call({
 T localValue, T? serverValue, bool isSyncing, String? syncError, DateTime lastSyncAttempt, int pendingActionsCount, String? lastSyncedActionId
});




}
/// @nodoc
class __$OptimisticStateCopyWithImpl<T,$Res>
    implements _$OptimisticStateCopyWith<T, $Res> {
  __$OptimisticStateCopyWithImpl(this._self, this._then);

  final _OptimisticState<T> _self;
  final $Res Function(_OptimisticState<T>) _then;

/// Create a copy of OptimisticState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localValue = freezed,Object? serverValue = freezed,Object? isSyncing = null,Object? syncError = freezed,Object? lastSyncAttempt = null,Object? pendingActionsCount = null,Object? lastSyncedActionId = freezed,}) {
  return _then(_OptimisticState<T>(
localValue: freezed == localValue ? _self.localValue : localValue // ignore: cast_nullable_to_non_nullable
as T,serverValue: freezed == serverValue ? _self.serverValue : serverValue // ignore: cast_nullable_to_non_nullable
as T?,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,syncError: freezed == syncError ? _self.syncError : syncError // ignore: cast_nullable_to_non_nullable
as String?,lastSyncAttempt: null == lastSyncAttempt ? _self.lastSyncAttempt : lastSyncAttempt // ignore: cast_nullable_to_non_nullable
as DateTime,pendingActionsCount: null == pendingActionsCount ? _self.pendingActionsCount : pendingActionsCount // ignore: cast_nullable_to_non_nullable
as int,lastSyncedActionId: freezed == lastSyncedActionId ? _self.lastSyncedActionId : lastSyncedActionId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
