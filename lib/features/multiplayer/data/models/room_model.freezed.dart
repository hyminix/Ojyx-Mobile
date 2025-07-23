// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) {
  return _RoomModel.fromJson(json);
}

/// @nodoc
mixin _$RoomModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'creator_id')
  String get creatorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_ids')
  List<String> get playerIds => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_players')
  int get maxPlayers => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_game_id')
  String? get currentGameId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RoomModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomModelCopyWith<RoomModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomModelCopyWith<$Res> {
  factory $RoomModelCopyWith(RoomModel value, $Res Function(RoomModel) then) =
      _$RoomModelCopyWithImpl<$Res, RoomModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'creator_id') String creatorId,
    @JsonKey(name: 'player_ids') List<String> playerIds,
    String status,
    @JsonKey(name: 'max_players') int maxPlayers,
    @JsonKey(name: 'current_game_id') String? currentGameId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$RoomModelCopyWithImpl<$Res, $Val extends RoomModel>
    implements $RoomModelCopyWith<$Res> {
  _$RoomModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? playerIds = null,
    Object? status = null,
    Object? maxPlayers = null,
    Object? currentGameId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            creatorId: null == creatorId
                ? _value.creatorId
                : creatorId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerIds: null == playerIds
                ? _value.playerIds
                : playerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            maxPlayers: null == maxPlayers
                ? _value.maxPlayers
                : maxPlayers // ignore: cast_nullable_to_non_nullable
                      as int,
            currentGameId: freezed == currentGameId
                ? _value.currentGameId
                : currentGameId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoomModelImplCopyWith<$Res>
    implements $RoomModelCopyWith<$Res> {
  factory _$$RoomModelImplCopyWith(
    _$RoomModelImpl value,
    $Res Function(_$RoomModelImpl) then,
  ) = __$$RoomModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'creator_id') String creatorId,
    @JsonKey(name: 'player_ids') List<String> playerIds,
    String status,
    @JsonKey(name: 'max_players') int maxPlayers,
    @JsonKey(name: 'current_game_id') String? currentGameId,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$RoomModelImplCopyWithImpl<$Res>
    extends _$RoomModelCopyWithImpl<$Res, _$RoomModelImpl>
    implements _$$RoomModelImplCopyWith<$Res> {
  __$$RoomModelImplCopyWithImpl(
    _$RoomModelImpl _value,
    $Res Function(_$RoomModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? creatorId = null,
    Object? playerIds = null,
    Object? status = null,
    Object? maxPlayers = null,
    Object? currentGameId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RoomModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        creatorId: null == creatorId
            ? _value.creatorId
            : creatorId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerIds: null == playerIds
            ? _value._playerIds
            : playerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        maxPlayers: null == maxPlayers
            ? _value.maxPlayers
            : maxPlayers // ignore: cast_nullable_to_non_nullable
                  as int,
        currentGameId: freezed == currentGameId
            ? _value.currentGameId
            : currentGameId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomModelImpl implements _RoomModel {
  const _$RoomModelImpl({
    required this.id,
    @JsonKey(name: 'creator_id') required this.creatorId,
    @JsonKey(name: 'player_ids') required final List<String> playerIds,
    required this.status,
    @JsonKey(name: 'max_players') required this.maxPlayers,
    @JsonKey(name: 'current_game_id') this.currentGameId,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _playerIds = playerIds;

  factory _$RoomModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'creator_id')
  final String creatorId;
  final List<String> _playerIds;
  @override
  @JsonKey(name: 'player_ids')
  List<String> get playerIds {
    if (_playerIds is EqualUnmodifiableListView) return _playerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerIds);
  }

  @override
  final String status;
  @override
  @JsonKey(name: 'max_players')
  final int maxPlayers;
  @override
  @JsonKey(name: 'current_game_id')
  final String? currentGameId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RoomModel(id: $id, creatorId: $creatorId, playerIds: $playerIds, status: $status, maxPlayers: $maxPlayers, currentGameId: $currentGameId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId) &&
            const DeepCollectionEquality().equals(
              other._playerIds,
              _playerIds,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.maxPlayers, maxPlayers) ||
                other.maxPlayers == maxPlayers) &&
            (identical(other.currentGameId, currentGameId) ||
                other.currentGameId == currentGameId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    creatorId,
    const DeepCollectionEquality().hash(_playerIds),
    status,
    maxPlayers,
    currentGameId,
    createdAt,
    updatedAt,
  );

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomModelImplCopyWith<_$RoomModelImpl> get copyWith =>
      __$$RoomModelImplCopyWithImpl<_$RoomModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomModelImplToJson(this);
  }
}

abstract class _RoomModel implements RoomModel {
  const factory _RoomModel({
    required final String id,
    @JsonKey(name: 'creator_id') required final String creatorId,
    @JsonKey(name: 'player_ids') required final List<String> playerIds,
    required final String status,
    @JsonKey(name: 'max_players') required final int maxPlayers,
    @JsonKey(name: 'current_game_id') final String? currentGameId,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$RoomModelImpl;

  factory _RoomModel.fromJson(Map<String, dynamic> json) =
      _$RoomModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'creator_id')
  String get creatorId;
  @override
  @JsonKey(name: 'player_ids')
  List<String> get playerIds;
  @override
  String get status;
  @override
  @JsonKey(name: 'max_players')
  int get maxPlayers;
  @override
  @JsonKey(name: 'current_game_id')
  String? get currentGameId;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of RoomModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomModelImplCopyWith<_$RoomModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
