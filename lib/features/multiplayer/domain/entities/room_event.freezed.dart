// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoomEvent _$RoomEventFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'playerJoined':
      return PlayerJoined.fromJson(json);
    case 'playerLeft':
      return PlayerLeft.fromJson(json);
    case 'gameStarted':
      return GameStarted.fromJson(json);
    case 'gameStateUpdated':
      return GameStateUpdated.fromJson(json);
    case 'playerAction':
      return PlayerAction.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'RoomEvent',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$RoomEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId, String playerName) playerJoined,
    required TResult Function(String playerId) playerLeft,
    required TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )
    gameStarted,
    required TResult Function(@GameStateConverter() GameState newState)
    gameStateUpdated,
    required TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )
    playerAction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId, String playerName)? playerJoined,
    TResult? Function(String playerId)? playerLeft,
    TResult? Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult? Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult? Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId, String playerName)? playerJoined,
    TResult Function(String playerId)? playerLeft,
    TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerJoined value) playerJoined,
    required TResult Function(PlayerLeft value) playerLeft,
    required TResult Function(GameStarted value) gameStarted,
    required TResult Function(GameStateUpdated value) gameStateUpdated,
    required TResult Function(PlayerAction value) playerAction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerJoined value)? playerJoined,
    TResult? Function(PlayerLeft value)? playerLeft,
    TResult? Function(GameStarted value)? gameStarted,
    TResult? Function(GameStateUpdated value)? gameStateUpdated,
    TResult? Function(PlayerAction value)? playerAction,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerJoined value)? playerJoined,
    TResult Function(PlayerLeft value)? playerLeft,
    TResult Function(GameStarted value)? gameStarted,
    TResult Function(GameStateUpdated value)? gameStateUpdated,
    TResult Function(PlayerAction value)? playerAction,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this RoomEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomEventCopyWith<$Res> {
  factory $RoomEventCopyWith(RoomEvent value, $Res Function(RoomEvent) then) =
      _$RoomEventCopyWithImpl<$Res, RoomEvent>;
}

/// @nodoc
class _$RoomEventCopyWithImpl<$Res, $Val extends RoomEvent>
    implements $RoomEventCopyWith<$Res> {
  _$RoomEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PlayerJoinedImplCopyWith<$Res> {
  factory _$$PlayerJoinedImplCopyWith(
    _$PlayerJoinedImpl value,
    $Res Function(_$PlayerJoinedImpl) then,
  ) = __$$PlayerJoinedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String playerId, String playerName});
}

/// @nodoc
class __$$PlayerJoinedImplCopyWithImpl<$Res>
    extends _$RoomEventCopyWithImpl<$Res, _$PlayerJoinedImpl>
    implements _$$PlayerJoinedImplCopyWith<$Res> {
  __$$PlayerJoinedImplCopyWithImpl(
    _$PlayerJoinedImpl _value,
    $Res Function(_$PlayerJoinedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null, Object? playerName = null}) {
    return _then(
      _$PlayerJoinedImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerName: null == playerName
            ? _value.playerName
            : playerName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerJoinedImpl implements PlayerJoined {
  const _$PlayerJoinedImpl({
    required this.playerId,
    required this.playerName,
    final String? $type,
  }) : $type = $type ?? 'playerJoined';

  factory _$PlayerJoinedImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerJoinedImplFromJson(json);

  @override
  final String playerId;
  @override
  final String playerName;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomEvent.playerJoined(playerId: $playerId, playerName: $playerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerJoinedImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.playerName, playerName) ||
                other.playerName == playerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId, playerName);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerJoinedImplCopyWith<_$PlayerJoinedImpl> get copyWith =>
      __$$PlayerJoinedImplCopyWithImpl<_$PlayerJoinedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId, String playerName) playerJoined,
    required TResult Function(String playerId) playerLeft,
    required TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )
    gameStarted,
    required TResult Function(@GameStateConverter() GameState newState)
    gameStateUpdated,
    required TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )
    playerAction,
  }) {
    return playerJoined(playerId, playerName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId, String playerName)? playerJoined,
    TResult? Function(String playerId)? playerLeft,
    TResult? Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult? Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult? Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
  }) {
    return playerJoined?.call(playerId, playerName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId, String playerName)? playerJoined,
    TResult Function(String playerId)? playerLeft,
    TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
    required TResult orElse(),
  }) {
    if (playerJoined != null) {
      return playerJoined(playerId, playerName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerJoined value) playerJoined,
    required TResult Function(PlayerLeft value) playerLeft,
    required TResult Function(GameStarted value) gameStarted,
    required TResult Function(GameStateUpdated value) gameStateUpdated,
    required TResult Function(PlayerAction value) playerAction,
  }) {
    return playerJoined(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerJoined value)? playerJoined,
    TResult? Function(PlayerLeft value)? playerLeft,
    TResult? Function(GameStarted value)? gameStarted,
    TResult? Function(GameStateUpdated value)? gameStateUpdated,
    TResult? Function(PlayerAction value)? playerAction,
  }) {
    return playerJoined?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerJoined value)? playerJoined,
    TResult Function(PlayerLeft value)? playerLeft,
    TResult Function(GameStarted value)? gameStarted,
    TResult Function(GameStateUpdated value)? gameStateUpdated,
    TResult Function(PlayerAction value)? playerAction,
    required TResult orElse(),
  }) {
    if (playerJoined != null) {
      return playerJoined(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerJoinedImplToJson(this);
  }
}

abstract class PlayerJoined implements RoomEvent {
  const factory PlayerJoined({
    required final String playerId,
    required final String playerName,
  }) = _$PlayerJoinedImpl;

  factory PlayerJoined.fromJson(Map<String, dynamic> json) =
      _$PlayerJoinedImpl.fromJson;

  String get playerId;
  String get playerName;

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerJoinedImplCopyWith<_$PlayerJoinedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerLeftImplCopyWith<$Res> {
  factory _$$PlayerLeftImplCopyWith(
    _$PlayerLeftImpl value,
    $Res Function(_$PlayerLeftImpl) then,
  ) = __$$PlayerLeftImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String playerId});
}

/// @nodoc
class __$$PlayerLeftImplCopyWithImpl<$Res>
    extends _$RoomEventCopyWithImpl<$Res, _$PlayerLeftImpl>
    implements _$$PlayerLeftImplCopyWith<$Res> {
  __$$PlayerLeftImplCopyWithImpl(
    _$PlayerLeftImpl _value,
    $Res Function(_$PlayerLeftImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? playerId = null}) {
    return _then(
      _$PlayerLeftImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerLeftImpl implements PlayerLeft {
  const _$PlayerLeftImpl({required this.playerId, final String? $type})
    : $type = $type ?? 'playerLeft';

  factory _$PlayerLeftImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerLeftImplFromJson(json);

  @override
  final String playerId;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomEvent.playerLeft(playerId: $playerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerLeftImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, playerId);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerLeftImplCopyWith<_$PlayerLeftImpl> get copyWith =>
      __$$PlayerLeftImplCopyWithImpl<_$PlayerLeftImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId, String playerName) playerJoined,
    required TResult Function(String playerId) playerLeft,
    required TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )
    gameStarted,
    required TResult Function(@GameStateConverter() GameState newState)
    gameStateUpdated,
    required TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )
    playerAction,
  }) {
    return playerLeft(playerId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId, String playerName)? playerJoined,
    TResult? Function(String playerId)? playerLeft,
    TResult? Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult? Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult? Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
  }) {
    return playerLeft?.call(playerId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId, String playerName)? playerJoined,
    TResult Function(String playerId)? playerLeft,
    TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
    required TResult orElse(),
  }) {
    if (playerLeft != null) {
      return playerLeft(playerId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerJoined value) playerJoined,
    required TResult Function(PlayerLeft value) playerLeft,
    required TResult Function(GameStarted value) gameStarted,
    required TResult Function(GameStateUpdated value) gameStateUpdated,
    required TResult Function(PlayerAction value) playerAction,
  }) {
    return playerLeft(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerJoined value)? playerJoined,
    TResult? Function(PlayerLeft value)? playerLeft,
    TResult? Function(GameStarted value)? gameStarted,
    TResult? Function(GameStateUpdated value)? gameStateUpdated,
    TResult? Function(PlayerAction value)? playerAction,
  }) {
    return playerLeft?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerJoined value)? playerJoined,
    TResult Function(PlayerLeft value)? playerLeft,
    TResult Function(GameStarted value)? gameStarted,
    TResult Function(GameStateUpdated value)? gameStateUpdated,
    TResult Function(PlayerAction value)? playerAction,
    required TResult orElse(),
  }) {
    if (playerLeft != null) {
      return playerLeft(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerLeftImplToJson(this);
  }
}

abstract class PlayerLeft implements RoomEvent {
  const factory PlayerLeft({required final String playerId}) = _$PlayerLeftImpl;

  factory PlayerLeft.fromJson(Map<String, dynamic> json) =
      _$PlayerLeftImpl.fromJson;

  String get playerId;

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerLeftImplCopyWith<_$PlayerLeftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameStartedImplCopyWith<$Res> {
  factory _$$GameStartedImplCopyWith(
    _$GameStartedImpl value,
    $Res Function(_$GameStartedImpl) then,
  ) = __$$GameStartedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String gameId, @GameStateConverter() GameState initialState});

  $GameStateCopyWith<$Res> get initialState;
}

/// @nodoc
class __$$GameStartedImplCopyWithImpl<$Res>
    extends _$RoomEventCopyWithImpl<$Res, _$GameStartedImpl>
    implements _$$GameStartedImplCopyWith<$Res> {
  __$$GameStartedImplCopyWithImpl(
    _$GameStartedImpl _value,
    $Res Function(_$GameStartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gameId = null, Object? initialState = null}) {
    return _then(
      _$GameStartedImpl(
        gameId: null == gameId
            ? _value.gameId
            : gameId // ignore: cast_nullable_to_non_nullable
                  as String,
        initialState: null == initialState
            ? _value.initialState
            : initialState // ignore: cast_nullable_to_non_nullable
                  as GameState,
      ),
    );
  }

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res> get initialState {
    return $GameStateCopyWith<$Res>(_value.initialState, (value) {
      return _then(_value.copyWith(initialState: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStartedImpl implements GameStarted {
  const _$GameStartedImpl({
    required this.gameId,
    @GameStateConverter() required this.initialState,
    final String? $type,
  }) : $type = $type ?? 'gameStarted';

  factory _$GameStartedImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStartedImplFromJson(json);

  @override
  final String gameId;
  @override
  @GameStateConverter()
  final GameState initialState;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomEvent.gameStarted(gameId: $gameId, initialState: $initialState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStartedImpl &&
            (identical(other.gameId, gameId) || other.gameId == gameId) &&
            (identical(other.initialState, initialState) ||
                other.initialState == initialState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gameId, initialState);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStartedImplCopyWith<_$GameStartedImpl> get copyWith =>
      __$$GameStartedImplCopyWithImpl<_$GameStartedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId, String playerName) playerJoined,
    required TResult Function(String playerId) playerLeft,
    required TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )
    gameStarted,
    required TResult Function(@GameStateConverter() GameState newState)
    gameStateUpdated,
    required TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )
    playerAction,
  }) {
    return gameStarted(gameId, initialState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId, String playerName)? playerJoined,
    TResult? Function(String playerId)? playerLeft,
    TResult? Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult? Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult? Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
  }) {
    return gameStarted?.call(gameId, initialState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId, String playerName)? playerJoined,
    TResult Function(String playerId)? playerLeft,
    TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
    required TResult orElse(),
  }) {
    if (gameStarted != null) {
      return gameStarted(gameId, initialState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerJoined value) playerJoined,
    required TResult Function(PlayerLeft value) playerLeft,
    required TResult Function(GameStarted value) gameStarted,
    required TResult Function(GameStateUpdated value) gameStateUpdated,
    required TResult Function(PlayerAction value) playerAction,
  }) {
    return gameStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerJoined value)? playerJoined,
    TResult? Function(PlayerLeft value)? playerLeft,
    TResult? Function(GameStarted value)? gameStarted,
    TResult? Function(GameStateUpdated value)? gameStateUpdated,
    TResult? Function(PlayerAction value)? playerAction,
  }) {
    return gameStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerJoined value)? playerJoined,
    TResult Function(PlayerLeft value)? playerLeft,
    TResult Function(GameStarted value)? gameStarted,
    TResult Function(GameStateUpdated value)? gameStateUpdated,
    TResult Function(PlayerAction value)? playerAction,
    required TResult orElse(),
  }) {
    if (gameStarted != null) {
      return gameStarted(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStartedImplToJson(this);
  }
}

abstract class GameStarted implements RoomEvent {
  const factory GameStarted({
    required final String gameId,
    @GameStateConverter() required final GameState initialState,
  }) = _$GameStartedImpl;

  factory GameStarted.fromJson(Map<String, dynamic> json) =
      _$GameStartedImpl.fromJson;

  String get gameId;
  @GameStateConverter()
  GameState get initialState;

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStartedImplCopyWith<_$GameStartedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameStateUpdatedImplCopyWith<$Res> {
  factory _$$GameStateUpdatedImplCopyWith(
    _$GameStateUpdatedImpl value,
    $Res Function(_$GameStateUpdatedImpl) then,
  ) = __$$GameStateUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({@GameStateConverter() GameState newState});

  $GameStateCopyWith<$Res> get newState;
}

/// @nodoc
class __$$GameStateUpdatedImplCopyWithImpl<$Res>
    extends _$RoomEventCopyWithImpl<$Res, _$GameStateUpdatedImpl>
    implements _$$GameStateUpdatedImplCopyWith<$Res> {
  __$$GameStateUpdatedImplCopyWithImpl(
    _$GameStateUpdatedImpl _value,
    $Res Function(_$GameStateUpdatedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? newState = null}) {
    return _then(
      _$GameStateUpdatedImpl(
        newState: null == newState
            ? _value.newState
            : newState // ignore: cast_nullable_to_non_nullable
                  as GameState,
      ),
    );
  }

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GameStateCopyWith<$Res> get newState {
    return $GameStateCopyWith<$Res>(_value.newState, (value) {
      return _then(_value.copyWith(newState: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$GameStateUpdatedImpl implements GameStateUpdated {
  const _$GameStateUpdatedImpl({
    @GameStateConverter() required this.newState,
    final String? $type,
  }) : $type = $type ?? 'gameStateUpdated';

  factory _$GameStateUpdatedImpl.fromJson(Map<String, dynamic> json) =>
      _$$GameStateUpdatedImplFromJson(json);

  @override
  @GameStateConverter()
  final GameState newState;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomEvent.gameStateUpdated(newState: $newState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateUpdatedImpl &&
            (identical(other.newState, newState) ||
                other.newState == newState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, newState);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateUpdatedImplCopyWith<_$GameStateUpdatedImpl> get copyWith =>
      __$$GameStateUpdatedImplCopyWithImpl<_$GameStateUpdatedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId, String playerName) playerJoined,
    required TResult Function(String playerId) playerLeft,
    required TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )
    gameStarted,
    required TResult Function(@GameStateConverter() GameState newState)
    gameStateUpdated,
    required TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )
    playerAction,
  }) {
    return gameStateUpdated(newState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId, String playerName)? playerJoined,
    TResult? Function(String playerId)? playerLeft,
    TResult? Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult? Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult? Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
  }) {
    return gameStateUpdated?.call(newState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId, String playerName)? playerJoined,
    TResult Function(String playerId)? playerLeft,
    TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
    required TResult orElse(),
  }) {
    if (gameStateUpdated != null) {
      return gameStateUpdated(newState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerJoined value) playerJoined,
    required TResult Function(PlayerLeft value) playerLeft,
    required TResult Function(GameStarted value) gameStarted,
    required TResult Function(GameStateUpdated value) gameStateUpdated,
    required TResult Function(PlayerAction value) playerAction,
  }) {
    return gameStateUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerJoined value)? playerJoined,
    TResult? Function(PlayerLeft value)? playerLeft,
    TResult? Function(GameStarted value)? gameStarted,
    TResult? Function(GameStateUpdated value)? gameStateUpdated,
    TResult? Function(PlayerAction value)? playerAction,
  }) {
    return gameStateUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerJoined value)? playerJoined,
    TResult Function(PlayerLeft value)? playerLeft,
    TResult Function(GameStarted value)? gameStarted,
    TResult Function(GameStateUpdated value)? gameStateUpdated,
    TResult Function(PlayerAction value)? playerAction,
    required TResult orElse(),
  }) {
    if (gameStateUpdated != null) {
      return gameStateUpdated(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GameStateUpdatedImplToJson(this);
  }
}

abstract class GameStateUpdated implements RoomEvent {
  const factory GameStateUpdated({
    @GameStateConverter() required final GameState newState,
  }) = _$GameStateUpdatedImpl;

  factory GameStateUpdated.fromJson(Map<String, dynamic> json) =
      _$GameStateUpdatedImpl.fromJson;

  @GameStateConverter()
  GameState get newState;

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateUpdatedImplCopyWith<_$GameStateUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PlayerActionImplCopyWith<$Res> {
  factory _$$PlayerActionImplCopyWith(
    _$PlayerActionImpl value,
    $Res Function(_$PlayerActionImpl) then,
  ) = __$$PlayerActionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    String playerId,
    PlayerActionType actionType,
    Map<String, dynamic>? actionData,
  });
}

/// @nodoc
class __$$PlayerActionImplCopyWithImpl<$Res>
    extends _$RoomEventCopyWithImpl<$Res, _$PlayerActionImpl>
    implements _$$PlayerActionImplCopyWith<$Res> {
  __$$PlayerActionImplCopyWithImpl(
    _$PlayerActionImpl _value,
    $Res Function(_$PlayerActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? actionType = null,
    Object? actionData = freezed,
  }) {
    return _then(
      _$PlayerActionImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        actionType: null == actionType
            ? _value.actionType
            : actionType // ignore: cast_nullable_to_non_nullable
                  as PlayerActionType,
        actionData: freezed == actionData
            ? _value._actionData
            : actionData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerActionImpl implements PlayerAction {
  const _$PlayerActionImpl({
    required this.playerId,
    required this.actionType,
    final Map<String, dynamic>? actionData,
    final String? $type,
  }) : _actionData = actionData,
       $type = $type ?? 'playerAction';

  factory _$PlayerActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerActionImplFromJson(json);

  @override
  final String playerId;
  @override
  final PlayerActionType actionType;
  final Map<String, dynamic>? _actionData;
  @override
  Map<String, dynamic>? get actionData {
    final value = _actionData;
    if (value == null) return null;
    if (_actionData is EqualUnmodifiableMapView) return _actionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'RoomEvent.playerAction(playerId: $playerId, actionType: $actionType, actionData: $actionData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerActionImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            (identical(other.actionType, actionType) ||
                other.actionType == actionType) &&
            const DeepCollectionEquality().equals(
              other._actionData,
              _actionData,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    actionType,
    const DeepCollectionEquality().hash(_actionData),
  );

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerActionImplCopyWith<_$PlayerActionImpl> get copyWith =>
      __$$PlayerActionImplCopyWithImpl<_$PlayerActionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String playerId, String playerName) playerJoined,
    required TResult Function(String playerId) playerLeft,
    required TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )
    gameStarted,
    required TResult Function(@GameStateConverter() GameState newState)
    gameStateUpdated,
    required TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )
    playerAction,
  }) {
    return playerAction(playerId, actionType, actionData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String playerId, String playerName)? playerJoined,
    TResult? Function(String playerId)? playerLeft,
    TResult? Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult? Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult? Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
  }) {
    return playerAction?.call(playerId, actionType, actionData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String playerId, String playerName)? playerJoined,
    TResult Function(String playerId)? playerLeft,
    TResult Function(
      String gameId,
      @GameStateConverter() GameState initialState,
    )?
    gameStarted,
    TResult Function(@GameStateConverter() GameState newState)?
    gameStateUpdated,
    TResult Function(
      String playerId,
      PlayerActionType actionType,
      Map<String, dynamic>? actionData,
    )?
    playerAction,
    required TResult orElse(),
  }) {
    if (playerAction != null) {
      return playerAction(playerId, actionType, actionData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PlayerJoined value) playerJoined,
    required TResult Function(PlayerLeft value) playerLeft,
    required TResult Function(GameStarted value) gameStarted,
    required TResult Function(GameStateUpdated value) gameStateUpdated,
    required TResult Function(PlayerAction value) playerAction,
  }) {
    return playerAction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PlayerJoined value)? playerJoined,
    TResult? Function(PlayerLeft value)? playerLeft,
    TResult? Function(GameStarted value)? gameStarted,
    TResult? Function(GameStateUpdated value)? gameStateUpdated,
    TResult? Function(PlayerAction value)? playerAction,
  }) {
    return playerAction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PlayerJoined value)? playerJoined,
    TResult Function(PlayerLeft value)? playerLeft,
    TResult Function(GameStarted value)? gameStarted,
    TResult Function(GameStateUpdated value)? gameStateUpdated,
    TResult Function(PlayerAction value)? playerAction,
    required TResult orElse(),
  }) {
    if (playerAction != null) {
      return playerAction(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerActionImplToJson(this);
  }
}

abstract class PlayerAction implements RoomEvent {
  const factory PlayerAction({
    required final String playerId,
    required final PlayerActionType actionType,
    final Map<String, dynamic>? actionData,
  }) = _$PlayerActionImpl;

  factory PlayerAction.fromJson(Map<String, dynamic> json) =
      _$PlayerActionImpl.fromJson;

  String get playerId;
  PlayerActionType get actionType;
  Map<String, dynamic>? get actionData;

  /// Create a copy of RoomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerActionImplCopyWith<_$PlayerActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
