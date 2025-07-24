// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'end_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EndGameState _$EndGameStateFromJson(Map<String, dynamic> json) {
  return _EndGameState.fromJson(json);
}

/// @nodoc
mixin _$EndGameState {
  List<GamePlayer> get players => throw _privateConstructorUsedError;
  String get roundInitiatorId => throw _privateConstructorUsedError;
  int get roundNumber => throw _privateConstructorUsedError;
  Map<String, bool> get playersVotes => throw _privateConstructorUsedError;

  /// Serializes this EndGameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EndGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EndGameStateCopyWith<EndGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndGameStateCopyWith<$Res> {
  factory $EndGameStateCopyWith(
    EndGameState value,
    $Res Function(EndGameState) then,
  ) = _$EndGameStateCopyWithImpl<$Res, EndGameState>;
  @useResult
  $Res call({
    List<GamePlayer> players,
    String roundInitiatorId,
    int roundNumber,
    Map<String, bool> playersVotes,
  });
}

/// @nodoc
class _$EndGameStateCopyWithImpl<$Res, $Val extends EndGameState>
    implements $EndGameStateCopyWith<$Res> {
  _$EndGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EndGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? roundInitiatorId = null,
    Object? roundNumber = null,
    Object? playersVotes = null,
  }) {
    return _then(
      _value.copyWith(
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<GamePlayer>,
            roundInitiatorId: null == roundInitiatorId
                ? _value.roundInitiatorId
                : roundInitiatorId // ignore: cast_nullable_to_non_nullable
                      as String,
            roundNumber: null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            playersVotes: null == playersVotes
                ? _value.playersVotes
                : playersVotes // ignore: cast_nullable_to_non_nullable
                      as Map<String, bool>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EndGameStateImplCopyWith<$Res>
    implements $EndGameStateCopyWith<$Res> {
  factory _$$EndGameStateImplCopyWith(
    _$EndGameStateImpl value,
    $Res Function(_$EndGameStateImpl) then,
  ) = __$$EndGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<GamePlayer> players,
    String roundInitiatorId,
    int roundNumber,
    Map<String, bool> playersVotes,
  });
}

/// @nodoc
class __$$EndGameStateImplCopyWithImpl<$Res>
    extends _$EndGameStateCopyWithImpl<$Res, _$EndGameStateImpl>
    implements _$$EndGameStateImplCopyWith<$Res> {
  __$$EndGameStateImplCopyWithImpl(
    _$EndGameStateImpl _value,
    $Res Function(_$EndGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EndGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? players = null,
    Object? roundInitiatorId = null,
    Object? roundNumber = null,
    Object? playersVotes = null,
  }) {
    return _then(
      _$EndGameStateImpl(
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<GamePlayer>,
        roundInitiatorId: null == roundInitiatorId
            ? _value.roundInitiatorId
            : roundInitiatorId // ignore: cast_nullable_to_non_nullable
                  as String,
        roundNumber: null == roundNumber
            ? _value.roundNumber
            : roundNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        playersVotes: null == playersVotes
            ? _value._playersVotes
            : playersVotes // ignore: cast_nullable_to_non_nullable
                  as Map<String, bool>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EndGameStateImpl extends _EndGameState {
  const _$EndGameStateImpl({
    required final List<GamePlayer> players,
    required this.roundInitiatorId,
    required this.roundNumber,
    final Map<String, bool> playersVotes = const {},
  }) : _players = players,
       _playersVotes = playersVotes,
       super._();

  factory _$EndGameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$EndGameStateImplFromJson(json);

  final List<GamePlayer> _players;
  @override
  List<GamePlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final String roundInitiatorId;
  @override
  final int roundNumber;
  final Map<String, bool> _playersVotes;
  @override
  @JsonKey()
  Map<String, bool> get playersVotes {
    if (_playersVotes is EqualUnmodifiableMapView) return _playersVotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_playersVotes);
  }

  @override
  String toString() {
    return 'EndGameState(players: $players, roundInitiatorId: $roundInitiatorId, roundNumber: $roundNumber, playersVotes: $playersVotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndGameStateImpl &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.roundInitiatorId, roundInitiatorId) ||
                other.roundInitiatorId == roundInitiatorId) &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            const DeepCollectionEquality().equals(
              other._playersVotes,
              _playersVotes,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_players),
    roundInitiatorId,
    roundNumber,
    const DeepCollectionEquality().hash(_playersVotes),
  );

  /// Create a copy of EndGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EndGameStateImplCopyWith<_$EndGameStateImpl> get copyWith =>
      __$$EndGameStateImplCopyWithImpl<_$EndGameStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EndGameStateImplToJson(this);
  }
}

abstract class _EndGameState extends EndGameState {
  const factory _EndGameState({
    required final List<GamePlayer> players,
    required final String roundInitiatorId,
    required final int roundNumber,
    final Map<String, bool> playersVotes,
  }) = _$EndGameStateImpl;
  const _EndGameState._() : super._();

  factory _EndGameState.fromJson(Map<String, dynamic> json) =
      _$EndGameStateImpl.fromJson;

  @override
  List<GamePlayer> get players;
  @override
  String get roundInitiatorId;
  @override
  int get roundNumber;
  @override
  Map<String, bool> get playersVotes;

  /// Create a copy of EndGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EndGameStateImplCopyWith<_$EndGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
