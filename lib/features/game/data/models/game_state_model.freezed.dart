// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GameStateModel _$GameStateModelFromJson(Map<String, dynamic> json) {
  return _GameStateModel.fromJson(json);
}

/// @nodoc
mixin _$GameStateModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'room_id')
  String get roomId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_player_id')
  String get currentPlayerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'turn_number')
  int get turnNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'round_number')
  int get roundNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_data')
  Map<String, dynamic> get gameData => throw _privateConstructorUsedError;
  @JsonKey(name: 'winner_id')
  String? get winnerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this GameStateModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateModelCopyWith<GameStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateModelCopyWith<$Res> {
  factory $GameStateModelCopyWith(
    GameStateModel value,
    $Res Function(GameStateModel) then,
  ) = _$GameStateModelCopyWithImpl<$Res, GameStateModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'room_id') String roomId,
    String status,
    @JsonKey(name: 'current_player_id') String currentPlayerId,
    @JsonKey(name: 'turn_number') int turnNumber,
    @JsonKey(name: 'round_number') int roundNumber,
    @JsonKey(name: 'game_data') Map<String, dynamic> gameData,
    @JsonKey(name: 'winner_id') String? winnerId,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$GameStateModelCopyWithImpl<$Res, $Val extends GameStateModel>
    implements $GameStateModelCopyWith<$Res> {
  _$GameStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? status = null,
    Object? currentPlayerId = null,
    Object? turnNumber = null,
    Object? roundNumber = null,
    Object? gameData = null,
    Object? winnerId = freezed,
    Object? endedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPlayerId: null == currentPlayerId
                ? _value.currentPlayerId
                : currentPlayerId // ignore: cast_nullable_to_non_nullable
                      as String,
            turnNumber: null == turnNumber
                ? _value.turnNumber
                : turnNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            roundNumber: null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            gameData: null == gameData
                ? _value.gameData
                : gameData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            winnerId: freezed == winnerId
                ? _value.winnerId
                : winnerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            endedAt: freezed == endedAt
                ? _value.endedAt
                : endedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameStateModelImplCopyWith<$Res>
    implements $GameStateModelCopyWith<$Res> {
  factory _$$GameStateModelImplCopyWith(
    _$GameStateModelImpl value,
    $Res Function(_$GameStateModelImpl) then,
  ) = __$$GameStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'room_id') String roomId,
    String status,
    @JsonKey(name: 'current_player_id') String currentPlayerId,
    @JsonKey(name: 'turn_number') int turnNumber,
    @JsonKey(name: 'round_number') int roundNumber,
    @JsonKey(name: 'game_data') Map<String, dynamic> gameData,
    @JsonKey(name: 'winner_id') String? winnerId,
    @JsonKey(name: 'ended_at') DateTime? endedAt,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$GameStateModelImplCopyWithImpl<$Res>
    extends _$GameStateModelCopyWithImpl<$Res, _$GameStateModelImpl>
    implements _$$GameStateModelImplCopyWith<$Res> {
  __$$GameStateModelImplCopyWithImpl(
    _$GameStateModelImpl _value,
    $Res Function(_$GameStateModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? roomId = null,
    Object? status = null,
    Object? currentPlayerId = null,
    Object? turnNumber = null,
    Object? roundNumber = null,
    Object? gameData = null,
    Object? winnerId = freezed,
    Object? endedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$GameStateModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPlayerId: null == currentPlayerId
            ? _value.currentPlayerId
            : currentPlayerId // ignore: cast_nullable_to_non_nullable
                  as String,
        turnNumber: null == turnNumber
            ? _value.turnNumber
            : turnNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        roundNumber: null == roundNumber
            ? _value.roundNumber
            : roundNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        gameData: null == gameData
            ? _value._gameData
            : gameData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        winnerId: freezed == winnerId
            ? _value.winnerId
            : winnerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        endedAt: freezed == endedAt
            ? _value.endedAt
            : endedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateModelImpl extends _GameStateModel {
  const _$GameStateModelImpl({
    required this.id,
    @JsonKey(name: 'room_id') required this.roomId,
    required this.status,
    @JsonKey(name: 'current_player_id') required this.currentPlayerId,
    @JsonKey(name: 'turn_number') required this.turnNumber,
    @JsonKey(name: 'round_number') required this.roundNumber,
    @JsonKey(name: 'game_data') required final Map<String, dynamic> gameData,
    @JsonKey(name: 'winner_id') this.winnerId,
    @JsonKey(name: 'ended_at') this.endedAt,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _gameData = gameData,
       super._();

  factory _$GameStateModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'room_id')
  final String roomId;
  @override
  final String status;
  @override
  @JsonKey(name: 'current_player_id')
  final String currentPlayerId;
  @override
  @JsonKey(name: 'turn_number')
  final int turnNumber;
  @override
  @JsonKey(name: 'round_number')
  final int roundNumber;
  final Map<String, dynamic> _gameData;
  @override
  @JsonKey(name: 'game_data')
  Map<String, dynamic> get gameData {
    if (_gameData is EqualUnmodifiableMapView) return _gameData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_gameData);
  }

  @override
  @JsonKey(name: 'winner_id')
  final String? winnerId;
  @override
  @JsonKey(name: 'ended_at')
  final DateTime? endedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'GameStateModel(id: $id, roomId: $roomId, status: $status, currentPlayerId: $currentPlayerId, turnNumber: $turnNumber, roundNumber: $roundNumber, gameData: $gameData, winnerId: $winnerId, endedAt: $endedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentPlayerId, currentPlayerId) ||
                other.currentPlayerId == currentPlayerId) &&
            (identical(other.turnNumber, turnNumber) ||
                other.turnNumber == turnNumber) &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            const DeepCollectionEquality().equals(other._gameData, _gameData) &&
            (identical(other.winnerId, winnerId) ||
                other.winnerId == winnerId) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
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
    roomId,
    status,
    currentPlayerId,
    turnNumber,
    roundNumber,
    const DeepCollectionEquality().hash(_gameData),
    winnerId,
    endedAt,
    createdAt,
    updatedAt,
  );

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateModelImplCopyWith<_$GameStateModelImpl> get copyWith =>
      __$$GameStateModelImplCopyWithImpl<_$GameStateModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateModelImplToJson(this);
  }
}

abstract class _GameStateModel extends GameStateModel {
  const factory _GameStateModel({
    required final String id,
    @JsonKey(name: 'room_id') required final String roomId,
    required final String status,
    @JsonKey(name: 'current_player_id') required final String currentPlayerId,
    @JsonKey(name: 'turn_number') required final int turnNumber,
    @JsonKey(name: 'round_number') required final int roundNumber,
    @JsonKey(name: 'game_data') required final Map<String, dynamic> gameData,
    @JsonKey(name: 'winner_id') final String? winnerId,
    @JsonKey(name: 'ended_at') final DateTime? endedAt,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$GameStateModelImpl;
  const _GameStateModel._() : super._();

  factory _GameStateModel.fromJson(Map<String, dynamic> json) =
      _$GameStateModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'room_id')
  String get roomId;
  @override
  String get status;
  @override
  @JsonKey(name: 'current_player_id')
  String get currentPlayerId;
  @override
  @JsonKey(name: 'turn_number')
  int get turnNumber;
  @override
  @JsonKey(name: 'round_number')
  int get roundNumber;
  @override
  @JsonKey(name: 'game_data')
  Map<String, dynamic> get gameData;
  @override
  @JsonKey(name: 'winner_id')
  String? get winnerId;
  @override
  @JsonKey(name: 'ended_at')
  DateTime? get endedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of GameStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateModelImplCopyWith<_$GameStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
