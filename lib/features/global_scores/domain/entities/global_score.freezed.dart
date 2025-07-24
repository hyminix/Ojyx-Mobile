// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GlobalScore _$GlobalScoreFromJson(Map<String, dynamic> json) {
  return _GlobalScore.fromJson(json);
}

/// @nodoc
mixin _$GlobalScore {
  String get id => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  int get roundNumber => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  bool get isWinner => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get gameEndedAt => throw _privateConstructorUsedError;

  /// Serializes this GlobalScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GlobalScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GlobalScoreCopyWith<GlobalScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalScoreCopyWith<$Res> {
  factory $GlobalScoreCopyWith(
    GlobalScore value,
    $Res Function(GlobalScore) then,
  ) = _$GlobalScoreCopyWithImpl<$Res, GlobalScore>;
  @useResult
  $Res call({
    String id,
    String playerId,
    String playerName,
    String roomId,
    int totalScore,
    int roundNumber,
    int position,
    bool isWinner,
    DateTime createdAt,
    DateTime? gameEndedAt,
  });
}

/// @nodoc
class _$GlobalScoreCopyWithImpl<$Res, $Val extends GlobalScore>
    implements $GlobalScoreCopyWith<$Res> {
  _$GlobalScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GlobalScore
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
abstract class _$$GlobalScoreImplCopyWith<$Res>
    implements $GlobalScoreCopyWith<$Res> {
  factory _$$GlobalScoreImplCopyWith(
    _$GlobalScoreImpl value,
    $Res Function(_$GlobalScoreImpl) then,
  ) = __$$GlobalScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String playerId,
    String playerName,
    String roomId,
    int totalScore,
    int roundNumber,
    int position,
    bool isWinner,
    DateTime createdAt,
    DateTime? gameEndedAt,
  });
}

/// @nodoc
class __$$GlobalScoreImplCopyWithImpl<$Res>
    extends _$GlobalScoreCopyWithImpl<$Res, _$GlobalScoreImpl>
    implements _$$GlobalScoreImplCopyWith<$Res> {
  __$$GlobalScoreImplCopyWithImpl(
    _$GlobalScoreImpl _value,
    $Res Function(_$GlobalScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GlobalScore
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
      _$GlobalScoreImpl(
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
class _$GlobalScoreImpl extends _GlobalScore {
  const _$GlobalScoreImpl({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.roomId,
    required this.totalScore,
    required this.roundNumber,
    required this.position,
    required this.isWinner,
    required this.createdAt,
    this.gameEndedAt,
  }) : super._();

  factory _$GlobalScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$GlobalScoreImplFromJson(json);

  @override
  final String id;
  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final String roomId;
  @override
  final int totalScore;
  @override
  final int roundNumber;
  @override
  final int position;
  @override
  final bool isWinner;
  @override
  final DateTime createdAt;
  @override
  final DateTime? gameEndedAt;

  @override
  String toString() {
    return 'GlobalScore(id: $id, playerId: $playerId, playerName: $playerName, roomId: $roomId, totalScore: $totalScore, roundNumber: $roundNumber, position: $position, isWinner: $isWinner, createdAt: $createdAt, gameEndedAt: $gameEndedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalScoreImpl &&
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

  /// Create a copy of GlobalScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalScoreImplCopyWith<_$GlobalScoreImpl> get copyWith =>
      __$$GlobalScoreImplCopyWithImpl<_$GlobalScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GlobalScoreImplToJson(this);
  }
}

abstract class _GlobalScore extends GlobalScore {
  const factory _GlobalScore({
    required final String id,
    required final String playerId,
    required final String playerName,
    required final String roomId,
    required final int totalScore,
    required final int roundNumber,
    required final int position,
    required final bool isWinner,
    required final DateTime createdAt,
    final DateTime? gameEndedAt,
  }) = _$GlobalScoreImpl;
  const _GlobalScore._() : super._();

  factory _GlobalScore.fromJson(Map<String, dynamic> json) =
      _$GlobalScoreImpl.fromJson;

  @override
  String get id;
  @override
  String get playerId;
  @override
  String get playerName;
  @override
  String get roomId;
  @override
  int get totalScore;
  @override
  int get roundNumber;
  @override
  int get position;
  @override
  bool get isWinner;
  @override
  DateTime get createdAt;
  @override
  DateTime? get gameEndedAt;

  /// Create a copy of GlobalScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GlobalScoreImplCopyWith<_$GlobalScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlayerStats _$PlayerStatsFromJson(Map<String, dynamic> json) {
  return _PlayerStats.fromJson(json);
}

/// @nodoc
mixin _$PlayerStats {
  String get playerId => throw _privateConstructorUsedError;
  String get playerName => throw _privateConstructorUsedError;
  int get totalGamesPlayed => throw _privateConstructorUsedError;
  int get totalWins => throw _privateConstructorUsedError;
  double get averageScore => throw _privateConstructorUsedError;
  int get bestScore => throw _privateConstructorUsedError;
  int get worstScore => throw _privateConstructorUsedError;
  double get averagePosition => throw _privateConstructorUsedError;
  int get totalRoundsPlayed => throw _privateConstructorUsedError;

  /// Serializes this PlayerStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStatsCopyWith<PlayerStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStatsCopyWith<$Res> {
  factory $PlayerStatsCopyWith(
    PlayerStats value,
    $Res Function(PlayerStats) then,
  ) = _$PlayerStatsCopyWithImpl<$Res, PlayerStats>;
  @useResult
  $Res call({
    String playerId,
    String playerName,
    int totalGamesPlayed,
    int totalWins,
    double averageScore,
    int bestScore,
    int worstScore,
    double averagePosition,
    int totalRoundsPlayed,
  });
}

/// @nodoc
class _$PlayerStatsCopyWithImpl<$Res, $Val extends PlayerStats>
    implements $PlayerStatsCopyWith<$Res> {
  _$PlayerStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? totalGamesPlayed = null,
    Object? totalWins = null,
    Object? averageScore = null,
    Object? bestScore = null,
    Object? worstScore = null,
    Object? averagePosition = null,
    Object? totalRoundsPlayed = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerName: null == playerName
                ? _value.playerName
                : playerName // ignore: cast_nullable_to_non_nullable
                      as String,
            totalGamesPlayed: null == totalGamesPlayed
                ? _value.totalGamesPlayed
                : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
            totalWins: null == totalWins
                ? _value.totalWins
                : totalWins // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            bestScore: null == bestScore
                ? _value.bestScore
                : bestScore // ignore: cast_nullable_to_non_nullable
                      as int,
            worstScore: null == worstScore
                ? _value.worstScore
                : worstScore // ignore: cast_nullable_to_non_nullable
                      as int,
            averagePosition: null == averagePosition
                ? _value.averagePosition
                : averagePosition // ignore: cast_nullable_to_non_nullable
                      as double,
            totalRoundsPlayed: null == totalRoundsPlayed
                ? _value.totalRoundsPlayed
                : totalRoundsPlayed // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerStatsImplCopyWith<$Res>
    implements $PlayerStatsCopyWith<$Res> {
  factory _$$PlayerStatsImplCopyWith(
    _$PlayerStatsImpl value,
    $Res Function(_$PlayerStatsImpl) then,
  ) = __$$PlayerStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    String playerName,
    int totalGamesPlayed,
    int totalWins,
    double averageScore,
    int bestScore,
    int worstScore,
    double averagePosition,
    int totalRoundsPlayed,
  });
}

/// @nodoc
class __$$PlayerStatsImplCopyWithImpl<$Res>
    extends _$PlayerStatsCopyWithImpl<$Res, _$PlayerStatsImpl>
    implements _$$PlayerStatsImplCopyWith<$Res> {
  __$$PlayerStatsImplCopyWithImpl(
    _$PlayerStatsImpl _value,
    $Res Function(_$PlayerStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerName = null,
    Object? totalGamesPlayed = null,
    Object? totalWins = null,
    Object? averageScore = null,
    Object? bestScore = null,
    Object? worstScore = null,
    Object? averagePosition = null,
    Object? totalRoundsPlayed = null,
  }) {
    return _then(
      _$PlayerStatsImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
        totalGamesPlayed: null == totalGamesPlayed
            ? _value.totalGamesPlayed
            : totalGamesPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
        totalWins: null == totalWins
            ? _value.totalWins
            : totalWins // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        bestScore: null == bestScore
            ? _value.bestScore
            : bestScore // ignore: cast_nullable_to_non_nullable
                  as int,
        worstScore: null == worstScore
            ? _value.worstScore
            : worstScore // ignore: cast_nullable_to_non_nullable
                  as int,
        averagePosition: null == averagePosition
            ? _value.averagePosition
            : averagePosition // ignore: cast_nullable_to_non_nullable
                  as double,
        totalRoundsPlayed: null == totalRoundsPlayed
            ? _value.totalRoundsPlayed
            : totalRoundsPlayed // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStatsImpl extends _PlayerStats {
  const _$PlayerStatsImpl({
    required this.playerId,
    required this.playerName,
    required this.totalGamesPlayed,
    required this.totalWins,
    required this.averageScore,
    required this.bestScore,
    required this.worstScore,
    required this.averagePosition,
    required this.totalRoundsPlayed,
  }) : super._();

  factory _$PlayerStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStatsImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;
  @override
  final int totalGamesPlayed;
  @override
  final int totalWins;
  @override
  final double averageScore;
  @override
  final int bestScore;
  @override
  final int worstScore;
  @override
  final double averagePosition;
  @override
  final int totalRoundsPlayed;

  @override
  String toString() {
    return 'PlayerStats(playerId: $playerId, playerName: $playerName, totalGamesPlayed: $totalGamesPlayed, totalWins: $totalWins, averageScore: $averageScore, bestScore: $bestScore, worstScore: $worstScore, averagePosition: $averagePosition, totalRoundsPlayed: $totalRoundsPlayed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStatsImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName) &&
            (identical(other.totalGamesPlayed, totalGamesPlayed) ||
                other.totalGamesPlayed == totalGamesPlayed) &&
            (identical(other.totalWins, totalWins) ||
                other.totalWins == totalWins) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.bestScore, bestScore) ||
                other.bestScore == bestScore) &&
            (identical(other.worstScore, worstScore) ||
                other.worstScore == worstScore) &&
            (identical(other.averagePosition, averagePosition) ||
                other.averagePosition == averagePosition) &&
            (identical(other.totalRoundsPlayed, totalRoundsPlayed) ||
                other.totalRoundsPlayed == totalRoundsPlayed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    playerName,
    totalGamesPlayed,
    totalWins,
    averageScore,
    bestScore,
    worstScore,
    averagePosition,
    totalRoundsPlayed,
  );

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStatsImplCopyWith<_$PlayerStatsImpl> get copyWith =>
      __$$PlayerStatsImplCopyWithImpl<_$PlayerStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStatsImplToJson(this);
  }
}

abstract class _PlayerStats extends PlayerStats {
  const factory _PlayerStats({
    required final String playerId,
    required final String playerName,
    required final int totalGamesPlayed,
    required final int totalWins,
    required final double averageScore,
    required final int bestScore,
    required final int worstScore,
    required final double averagePosition,
    required final int totalRoundsPlayed,
  }) = _$PlayerStatsImpl;
  const _PlayerStats._() : super._();

  factory _PlayerStats.fromJson(Map<String, dynamic> json) =
      _$PlayerStatsImpl.fromJson;

  @override
  String get playerId;
  @override
  String get playerName;
  @override
  int get totalGamesPlayed;
  @override
  int get totalWins;
  @override
  double get averageScore;
  @override
  int get bestScore;
  @override
  int get worstScore;
  @override
  double get averagePosition;
  @override
  int get totalRoundsPlayed;

  /// Create a copy of PlayerStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStatsImplCopyWith<_$PlayerStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
