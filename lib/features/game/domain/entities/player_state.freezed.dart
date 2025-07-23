// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) {
  return _PlayerState.fromJson(json);
}

/// @nodoc
mixin _$PlayerState {
  String get playerId => throw _privateConstructorUsedError;
  List<Card?> get cards => throw _privateConstructorUsedError;
  int get currentScore => throw _privateConstructorUsedError;
  int get revealedCount => throw _privateConstructorUsedError;
  List<int> get identicalColumns => throw _privateConstructorUsedError;
  bool get hasFinished => throw _privateConstructorUsedError;

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerStateCopyWith<PlayerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerStateCopyWith<$Res> {
  factory $PlayerStateCopyWith(
    PlayerState value,
    $Res Function(PlayerState) then,
  ) = _$PlayerStateCopyWithImpl<$Res, PlayerState>;
  @useResult
  $Res call({
    String playerId,
    List<Card?> cards,
    int currentScore,
    int revealedCount,
    List<int> identicalColumns,
    bool hasFinished,
  });
}

/// @nodoc
class _$PlayerStateCopyWithImpl<$Res, $Val extends PlayerState>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? cards = null,
    Object? currentScore = null,
    Object? revealedCount = null,
    Object? identicalColumns = null,
    Object? hasFinished = null,
  }) {
    return _then(
      _value.copyWith(
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            cards: null == cards
                ? _value.cards
                : cards // ignore: cast_nullable_to_non_nullable
                      as List<Card?>,
            currentScore: null == currentScore
                ? _value.currentScore
                : currentScore // ignore: cast_nullable_to_non_nullable
                      as int,
            revealedCount: null == revealedCount
                ? _value.revealedCount
                : revealedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            identicalColumns: null == identicalColumns
                ? _value.identicalColumns
                : identicalColumns // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            hasFinished: null == hasFinished
                ? _value.hasFinished
                : hasFinished // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerStateImplCopyWith<$Res>
    implements $PlayerStateCopyWith<$Res> {
  factory _$$PlayerStateImplCopyWith(
    _$PlayerStateImpl value,
    $Res Function(_$PlayerStateImpl) then,
  ) = __$$PlayerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerId,
    List<Card?> cards,
    int currentScore,
    int revealedCount,
    List<int> identicalColumns,
    bool hasFinished,
  });
}

/// @nodoc
class __$$PlayerStateImplCopyWithImpl<$Res>
    extends _$PlayerStateCopyWithImpl<$Res, _$PlayerStateImpl>
    implements _$$PlayerStateImplCopyWith<$Res> {
  __$$PlayerStateImplCopyWithImpl(
    _$PlayerStateImpl _value,
    $Res Function(_$PlayerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? cards = null,
    Object? currentScore = null,
    Object? revealedCount = null,
    Object? identicalColumns = null,
    Object? hasFinished = null,
  }) {
    return _then(
      _$PlayerStateImpl(
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        cards: null == cards
            ? _value._cards
            : cards // ignore: cast_nullable_to_non_nullable
                  as List<Card?>,
        currentScore: null == currentScore
            ? _value.currentScore
            : currentScore // ignore: cast_nullable_to_non_nullable
                  as int,
        revealedCount: null == revealedCount
            ? _value.revealedCount
            : revealedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        identicalColumns: null == identicalColumns
            ? _value._identicalColumns
            : identicalColumns // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        hasFinished: null == hasFinished
            ? _value.hasFinished
            : hasFinished // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerStateImpl implements _PlayerState {
  const _$PlayerStateImpl({
    required this.playerId,
    required final List<Card?> cards,
    required this.currentScore,
    required this.revealedCount,
    required final List<int> identicalColumns,
    required this.hasFinished,
  }) : _cards = cards,
       _identicalColumns = identicalColumns;

  factory _$PlayerStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerStateImplFromJson(json);

  @override
  final String playerId;
  final List<Card?> _cards;
  @override
  List<Card?> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  final int currentScore;
  @override
  final int revealedCount;
  final List<int> _identicalColumns;
  @override
  List<int> get identicalColumns {
    if (_identicalColumns is EqualUnmodifiableListView)
      return _identicalColumns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_identicalColumns);
  }

  @override
  final bool hasFinished;

  @override
  String toString() {
    return 'PlayerState(playerId: $playerId, cards: $cards, currentScore: $currentScore, revealedCount: $revealedCount, identicalColumns: $identicalColumns, hasFinished: $hasFinished)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerStateImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(other._cards, _cards) &&
            (identical(other.currentScore, currentScore) ||
                other.currentScore == currentScore) &&
            (identical(other.revealedCount, revealedCount) ||
                other.revealedCount == revealedCount) &&
            const DeepCollectionEquality().equals(
              other._identicalColumns,
              _identicalColumns,
            ) &&
            (identical(other.hasFinished, hasFinished) ||
                other.hasFinished == hasFinished));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerId,
    const DeepCollectionEquality().hash(_cards),
    currentScore,
    revealedCount,
    const DeepCollectionEquality().hash(_identicalColumns),
    hasFinished,
  );

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      __$$PlayerStateImplCopyWithImpl<_$PlayerStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerStateImplToJson(this);
  }
}

abstract class _PlayerState implements PlayerState {
  const factory _PlayerState({
    required final String playerId,
    required final List<Card?> cards,
    required final int currentScore,
    required final int revealedCount,
    required final List<int> identicalColumns,
    required final bool hasFinished,
  }) = _$PlayerStateImpl;

  factory _PlayerState.fromJson(Map<String, dynamic> json) =
      _$PlayerStateImpl.fromJson;

  @override
  String get playerId;
  @override
  List<Card?> get cards;
  @override
  int get currentScore;
  @override
  int get revealedCount;
  @override
  List<int> get identicalColumns;
  @override
  bool get hasFinished;

  /// Create a copy of PlayerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerStateImplCopyWith<_$PlayerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
