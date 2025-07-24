// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_score_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GlobalScoreModel _$GlobalScoreModelFromJson(Map<String, dynamic> json) {
  return _GlobalScoreModel.fromJson(json);
}

/// @nodoc
mixin _$GlobalScoreModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_id')
  String get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_name')
  String get playerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'room_id')
  String get roomId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_score')
  int get totalScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'round_number')
  int get roundNumber => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_winner')
  bool get isWinner => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_ended_at')
  DateTime? get gameEndedAt => throw _privateConstructorUsedError;

  /// Serializes this GlobalScoreModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlobalScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalScoreModelCopyWith<GlobalScoreModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalScoreModelCopyWith<$Res> {
  factory $GlobalScoreModelCopyWith(
    GlobalScoreModel value,
    $Res Function(GlobalScoreModel) then,
  ) = _$GlobalScoreModelCopyWithImpl<$Res, GlobalScoreModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'player_id') String playerId,
    @JsonKey(name: 'player_name') String playerName,
    @JsonKey(name: 'room_id') String roomId,
    @JsonKey(name: 'total_score') int totalScore,
    @JsonKey(name: 'round_number') int roundNumber,
    int position,
    @JsonKey(name: 'is_winner') bool isWinner,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'game_ended_at') DateTime? gameEndedAt,
  });
}

/// @nodoc
class _$GlobalScoreModelCopyWithImpl<$Res, $Val extends GlobalScoreModel>
    implements $GlobalScoreModelCopyWith<$Res> {
  _$GlobalScoreModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? roomId = null,
    Object? totalScore = null,
    Object? roundNumber = null,
    Object? position = null,
    Object? isWinner = null,
    Object? createdAt = null,
    Object? gameEndedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            roundNumber: null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            isWinner: null == isWinner
                ? _value.isWinner
                : isWinner // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            gameEndedAt: freezed == gameEndedAt
                ? _value.gameEndedAt
                : gameEndedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GlobalScoreModelImplCopyWith<$Res>
    implements $GlobalScoreModelCopyWith<$Res> {
  factory _$$GlobalScoreModelImplCopyWith(
    _$GlobalScoreModelImpl value,
    $Res Function(_$GlobalScoreModelImpl) then,
  ) = __$$GlobalScoreModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'player_id') String playerId,
    @JsonKey(name: 'player_name') String playerName,
    @JsonKey(name: 'room_id') String roomId,
    @JsonKey(name: 'total_score') int totalScore,
    @JsonKey(name: 'round_number') int roundNumber,
    int position,
    @JsonKey(name: 'is_winner') bool isWinner,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'game_ended_at') DateTime? gameEndedAt,
  });
}

/// @nodoc
class __$$GlobalScoreModelImplCopyWithImpl<$Res>
    extends _$GlobalScoreModelCopyWithImpl<$Res, _$GlobalScoreModelImpl>
    implements _$$GlobalScoreModelImplCopyWith<$Res> {
  __$$GlobalScoreModelImplCopyWithImpl(
    _$GlobalScoreModelImpl _value,
    $Res Function(_$GlobalScoreModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GlobalScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerId = null,
    Object? playerName = null,
    Object? roomId = null,
    Object? totalScore = null,
    Object? roundNumber = null,
    Object? position = null,
    Object? isWinner = null,
    Object? createdAt = null,
    Object? gameEndedAt = freezed,
  }) {
    return _then(
      _$GlobalScoreModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        roundNumber: null == roundNumber
            ? _value.roundNumber
            : roundNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        isWinner: null == isWinner
            ? _value.isWinner
            : isWinner // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        gameEndedAt: freezed == gameEndedAt
            ? _value.gameEndedAt
            : gameEndedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GlobalScoreModelImpl extends _GlobalScoreModel {
  const _$GlobalScoreModelImpl({
    required this.id,
    @JsonKey(name: 'player_id') required this.playerId,
    @JsonKey(name: 'player_name') required this.playerName,
    @JsonKey(name: 'room_id') required this.roomId,
    @JsonKey(name: 'total_score') required this.totalScore,
    @JsonKey(name: 'round_number') required this.roundNumber,
    required this.position,
    @JsonKey(name: 'is_winner') required this.isWinner,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'game_ended_at') this.gameEndedAt,
  }) : super._();

  factory _$GlobalScoreModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalScoreModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'player_id')
  final String playerId;
  @override
  @JsonKey(name: 'player_name')
  final String playerName;
  @override
  @JsonKey(name: 'room_id')
  final String roomId;
  @override
  @JsonKey(name: 'total_score')
  final int totalScore;
  @override
  @JsonKey(name: 'round_number')
  final int roundNumber;
  @override
  final int position;
  @override
  @JsonKey(name: 'is_winner')
  final bool isWinner;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'game_ended_at')
  final DateTime? gameEndedAt;

  @override
  String toString() {
    return 'GlobalScoreModel(id: $id, playerId: $playerId, playerName: $playerName, roomId: $roomId, totalScore: $totalScore, roundNumber: $roundNumber, position: $position, isWinner: $isWinner, createdAt: $createdAt, gameEndedAt: $gameEndedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalScoreModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.isWinner, isWinner) ||
                other.isWinner == isWinner) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.gameEndedAt, gameEndedAt) ||
                other.gameEndedAt == gameEndedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    playerId,
    playerName,
    roomId,
    totalScore,
    roundNumber,
    position,
    isWinner,
    createdAt,
    gameEndedAt,
  );

  /// Create a copy of GlobalScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalScoreModelImplCopyWith<_$GlobalScoreModelImpl> get copyWith =>
      __$$GlobalScoreModelImplCopyWithImpl<_$GlobalScoreModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalScoreModelImplToJson(this);
  }
}

abstract class _GlobalScoreModel extends GlobalScoreModel {
  const factory _GlobalScoreModel({
    required final String id,
    @JsonKey(name: 'player_id') required final String playerId,
    @JsonKey(name: 'player_name') required final String playerName,
    @JsonKey(name: 'room_id') required final String roomId,
    @JsonKey(name: 'total_score') required final int totalScore,
    @JsonKey(name: 'round_number') required final int roundNumber,
    required final int position,
    @JsonKey(name: 'is_winner') required final bool isWinner,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'game_ended_at') final DateTime? gameEndedAt,
  }) = _$GlobalScoreModelImpl;
  const _GlobalScoreModel._() : super._();

  factory _GlobalScoreModel.fromJson(Map<String, dynamic> json) =
      _$GlobalScoreModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'player_id')
  String get playerId;
  @override
  @JsonKey(name: 'player_name')
  String get playerName;
  @override
  @JsonKey(name: 'room_id')
  String get roomId;
  @override
  @JsonKey(name: 'total_score')
  int get totalScore;
  @override
  @JsonKey(name: 'round_number')
  int get roundNumber;
  @override
  int get position;
  @override
  @JsonKey(name: 'is_winner')
  bool get isWinner;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'game_ended_at')
  DateTime? get gameEndedAt;

  /// Create a copy of GlobalScoreModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalScoreModelImplCopyWith<_$GlobalScoreModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
