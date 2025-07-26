// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LobbyPlayer {

 String get id; String get name; String? get avatarUrl; DateTime get createdAt; DateTime get updatedAt; DateTime get lastSeenAt; ConnectionStatus get connectionStatus; String? get currentRoomId;
/// Create a copy of LobbyPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LobbyPlayerCopyWith<LobbyPlayer> get copyWith => _$LobbyPlayerCopyWithImpl<LobbyPlayer>(this as LobbyPlayer, _$identity);

  /// Serializes this LobbyPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LobbyPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.currentRoomId, currentRoomId) || other.currentRoomId == currentRoomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,createdAt,updatedAt,lastSeenAt,connectionStatus,currentRoomId);

@override
String toString() {
  return 'LobbyPlayer(id: $id, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, lastSeenAt: $lastSeenAt, connectionStatus: $connectionStatus, currentRoomId: $currentRoomId)';
}


}

/// @nodoc
abstract mixin class $LobbyPlayerCopyWith<$Res>  {
  factory $LobbyPlayerCopyWith(LobbyPlayer value, $Res Function(LobbyPlayer) _then) = _$LobbyPlayerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? avatarUrl, DateTime createdAt, DateTime updatedAt, DateTime lastSeenAt, ConnectionStatus connectionStatus, String? currentRoomId
});




}
/// @nodoc
class _$LobbyPlayerCopyWithImpl<$Res>
    implements $LobbyPlayerCopyWith<$Res> {
  _$LobbyPlayerCopyWithImpl(this._self, this._then);

  final LobbyPlayer _self;
  final $Res Function(LobbyPlayer) _then;

/// Create a copy of LobbyPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? lastSeenAt = null,Object? connectionStatus = null,Object? currentRoomId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as ConnectionStatus,currentRoomId: freezed == currentRoomId ? _self.currentRoomId : currentRoomId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LobbyPlayer].
extension LobbyPlayerPatterns on LobbyPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LobbyPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LobbyPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LobbyPlayer value)  $default,){
final _that = this;
switch (_that) {
case _LobbyPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LobbyPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _LobbyPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  DateTime createdAt,  DateTime updatedAt,  DateTime lastSeenAt,  ConnectionStatus connectionStatus,  String? currentRoomId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LobbyPlayer() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.createdAt,_that.updatedAt,_that.lastSeenAt,_that.connectionStatus,_that.currentRoomId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? avatarUrl,  DateTime createdAt,  DateTime updatedAt,  DateTime lastSeenAt,  ConnectionStatus connectionStatus,  String? currentRoomId)  $default,) {final _that = this;
switch (_that) {
case _LobbyPlayer():
return $default(_that.id,_that.name,_that.avatarUrl,_that.createdAt,_that.updatedAt,_that.lastSeenAt,_that.connectionStatus,_that.currentRoomId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? avatarUrl,  DateTime createdAt,  DateTime updatedAt,  DateTime lastSeenAt,  ConnectionStatus connectionStatus,  String? currentRoomId)?  $default,) {final _that = this;
switch (_that) {
case _LobbyPlayer() when $default != null:
return $default(_that.id,_that.name,_that.avatarUrl,_that.createdAt,_that.updatedAt,_that.lastSeenAt,_that.connectionStatus,_that.currentRoomId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LobbyPlayer implements LobbyPlayer {
  const _LobbyPlayer({required this.id, required this.name, this.avatarUrl, required this.createdAt, required this.updatedAt, required this.lastSeenAt, required this.connectionStatus, this.currentRoomId});
  factory _LobbyPlayer.fromJson(Map<String, dynamic> json) => _$LobbyPlayerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? avatarUrl;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime lastSeenAt;
@override final  ConnectionStatus connectionStatus;
@override final  String? currentRoomId;

/// Create a copy of LobbyPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LobbyPlayerCopyWith<_LobbyPlayer> get copyWith => __$LobbyPlayerCopyWithImpl<_LobbyPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LobbyPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LobbyPlayer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.connectionStatus, connectionStatus) || other.connectionStatus == connectionStatus)&&(identical(other.currentRoomId, currentRoomId) || other.currentRoomId == currentRoomId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,avatarUrl,createdAt,updatedAt,lastSeenAt,connectionStatus,currentRoomId);

@override
String toString() {
  return 'LobbyPlayer(id: $id, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, lastSeenAt: $lastSeenAt, connectionStatus: $connectionStatus, currentRoomId: $currentRoomId)';
}


}

/// @nodoc
abstract mixin class _$LobbyPlayerCopyWith<$Res> implements $LobbyPlayerCopyWith<$Res> {
  factory _$LobbyPlayerCopyWith(_LobbyPlayer value, $Res Function(_LobbyPlayer) _then) = __$LobbyPlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? avatarUrl, DateTime createdAt, DateTime updatedAt, DateTime lastSeenAt, ConnectionStatus connectionStatus, String? currentRoomId
});




}
/// @nodoc
class __$LobbyPlayerCopyWithImpl<$Res>
    implements _$LobbyPlayerCopyWith<$Res> {
  __$LobbyPlayerCopyWithImpl(this._self, this._then);

  final _LobbyPlayer _self;
  final $Res Function(_LobbyPlayer) _then;

/// Create a copy of LobbyPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? avatarUrl = freezed,Object? createdAt = null,Object? updatedAt = null,Object? lastSeenAt = null,Object? connectionStatus = null,Object? currentRoomId = freezed,}) {
  return _then(_LobbyPlayer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,connectionStatus: null == connectionStatus ? _self.connectionStatus : connectionStatus // ignore: cast_nullable_to_non_nullable
as ConnectionStatus,currentRoomId: freezed == currentRoomId ? _self.currentRoomId : currentRoomId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
