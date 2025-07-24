// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lobby_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$LobbyPlayer {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime get lastSeenAt => throw _privateConstructorUsedError;
  ConnectionStatus get connectionStatus => throw _privateConstructorUsedError;
  String? get currentRoomId => throw _privateConstructorUsedError;

  /// Create a copy of LobbyPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LobbyPlayerCopyWith<LobbyPlayer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LobbyPlayerCopyWith<$Res> {
  factory $LobbyPlayerCopyWith(
    LobbyPlayer value,
    $Res Function(LobbyPlayer) then,
  ) = _$LobbyPlayerCopyWithImpl<$Res, LobbyPlayer>;
  @useResult
  $Res call({
    String id,
    String name,
    String? avatarUrl,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime lastSeenAt,
    ConnectionStatus connectionStatus,
    String? currentRoomId,
  });
}

/// @nodoc
class _$LobbyPlayerCopyWithImpl<$Res, $Val extends LobbyPlayer>
    implements $LobbyPlayerCopyWith<$Res> {
  _$LobbyPlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LobbyPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSeenAt = null,
    Object? connectionStatus = null,
    Object? currentRoomId = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastSeenAt: null == lastSeenAt
                ? _value.lastSeenAt
                : lastSeenAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            connectionStatus: null == connectionStatus
                ? _value.connectionStatus
                : connectionStatus // ignore: cast_nullable_to_non_nullable
                      as ConnectionStatus,
            currentRoomId: freezed == currentRoomId
                ? _value.currentRoomId
                : currentRoomId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LobbyPlayerImplCopyWith<$Res>
    implements $LobbyPlayerCopyWith<$Res> {
  factory _$$LobbyPlayerImplCopyWith(
    _$LobbyPlayerImpl value,
    $Res Function(_$LobbyPlayerImpl) then,
  ) = __$$LobbyPlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? avatarUrl,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime lastSeenAt,
    ConnectionStatus connectionStatus,
    String? currentRoomId,
  });
}

/// @nodoc
class __$$LobbyPlayerImplCopyWithImpl<$Res>
    extends _$LobbyPlayerCopyWithImpl<$Res, _$LobbyPlayerImpl>
    implements _$$LobbyPlayerImplCopyWith<$Res> {
  __$$LobbyPlayerImplCopyWithImpl(
    _$LobbyPlayerImpl _value,
    $Res Function(_$LobbyPlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LobbyPlayer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? lastSeenAt = null,
    Object? connectionStatus = null,
    Object? currentRoomId = freezed,
  }) {
    return _then(
      _$LobbyPlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastSeenAt: null == lastSeenAt
            ? _value.lastSeenAt
            : lastSeenAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        connectionStatus: null == connectionStatus
            ? _value.connectionStatus
            : connectionStatus // ignore: cast_nullable_to_non_nullable
                  as ConnectionStatus,
        currentRoomId: freezed == currentRoomId
            ? _value.currentRoomId
            : currentRoomId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$LobbyPlayerImpl implements _LobbyPlayer {
  const _$LobbyPlayerImpl({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSeenAt,
    required this.connectionStatus,
    this.currentRoomId,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatarUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime lastSeenAt;
  @override
  final ConnectionStatus connectionStatus;
  @override
  final String? currentRoomId;

  @override
  String toString() {
    return 'LobbyPlayer(id: $id, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, lastSeenAt: $lastSeenAt, connectionStatus: $connectionStatus, currentRoomId: $currentRoomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LobbyPlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt) &&
            (identical(other.connectionStatus, connectionStatus) ||
                other.connectionStatus == connectionStatus) &&
            (identical(other.currentRoomId, currentRoomId) ||
                other.currentRoomId == currentRoomId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    avatarUrl,
    createdAt,
    updatedAt,
    lastSeenAt,
    connectionStatus,
    currentRoomId,
  );

  /// Create a copy of LobbyPlayer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LobbyPlayerImplCopyWith<_$LobbyPlayerImpl> get copyWith =>
      __$$LobbyPlayerImplCopyWithImpl<_$LobbyPlayerImpl>(this, _$identity);
}

abstract class _LobbyPlayer implements LobbyPlayer {
  const factory _LobbyPlayer({
    required final String id,
    required final String name,
    final String? avatarUrl,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final DateTime lastSeenAt,
    required final ConnectionStatus connectionStatus,
    final String? currentRoomId,
  }) = _$LobbyPlayerImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatarUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime get lastSeenAt;
  @override
  ConnectionStatus get connectionStatus;
  @override
  String? get currentRoomId;

  /// Create a copy of LobbyPlayer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LobbyPlayerImplCopyWith<_$LobbyPlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
