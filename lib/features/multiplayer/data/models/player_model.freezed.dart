// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) {
  return _PlayerModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime get lastSeenAt => throw _privateConstructorUsedError;
  String get connectionStatus => throw _privateConstructorUsedError;
  String? get currentRoomId => throw _privateConstructorUsedError;

  /// Serializes this PlayerModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
    PlayerModel value,
    $Res Function(PlayerModel) then,
  ) = _$PlayerModelCopyWithImpl<$Res, PlayerModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? avatarUrl,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime lastSeenAt,
    String connectionStatus,
    String? currentRoomId,
  });
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res, $Val extends PlayerModel>
    implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerModel
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
                      as String,
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
abstract class _$$PlayerModelImplCopyWith<$Res>
    implements $PlayerModelCopyWith<$Res> {
  factory _$$PlayerModelImplCopyWith(
    _$PlayerModelImpl value,
    $Res Function(_$PlayerModelImpl) then,
  ) = __$$PlayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? avatarUrl,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime lastSeenAt,
    String connectionStatus,
    String? currentRoomId,
  });
}

/// @nodoc
class __$$PlayerModelImplCopyWithImpl<$Res>
    extends _$PlayerModelCopyWithImpl<$Res, _$PlayerModelImpl>
    implements _$$PlayerModelImplCopyWith<$Res> {
  __$$PlayerModelImplCopyWithImpl(
    _$PlayerModelImpl _value,
    $Res Function(_$PlayerModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerModel
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
      _$PlayerModelImpl(
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
                  as String,
        currentRoomId: freezed == currentRoomId
            ? _value.currentRoomId
            : currentRoomId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerModelImpl extends _PlayerModel {
  const _$PlayerModelImpl({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.lastSeenAt,
    required this.connectionStatus,
    this.currentRoomId,
  }) : super._();

  factory _$PlayerModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerModelImplFromJson(json);

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
  final String connectionStatus;
  @override
  final String? currentRoomId;

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt, lastSeenAt: $lastSeenAt, connectionStatus: $connectionStatus, currentRoomId: $currentRoomId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerModelImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      __$$PlayerModelImplCopyWithImpl<_$PlayerModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerModelImplToJson(this);
  }
}

abstract class _PlayerModel extends PlayerModel {
  const factory _PlayerModel({
    required final String id,
    required final String name,
    final String? avatarUrl,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    required final DateTime lastSeenAt,
    required final String connectionStatus,
    final String? currentRoomId,
  }) = _$PlayerModelImpl;
  const _PlayerModel._() : super._();

  factory _PlayerModel.fromJson(Map<String, dynamic> json) =
      _$PlayerModelImpl.fromJson;

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
  String get connectionStatus;
  @override
  String? get currentRoomId;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerModelImplCopyWith<_$PlayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
