// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameState {
  String get roomId => throw _privateConstructorUsedError;
  List<GamePlayer> get players => throw _privateConstructorUsedError;
  int get currentPlayerIndex => throw _privateConstructorUsedError;
  List<Card> get deck => throw _privateConstructorUsedError;
  List<Card> get discardPile => throw _privateConstructorUsedError;
  List<ActionCard> get actionDeck => throw _privateConstructorUsedError;
  List<ActionCard> get actionDiscard => throw _privateConstructorUsedError;
  GameStatus get status => throw _privateConstructorUsedError;
  TurnDirection get turnDirection => throw _privateConstructorUsedError;
  bool get lastRound => throw _privateConstructorUsedError;
  String? get initiatorPlayerId => throw _privateConstructorUsedError;
  String? get endRoundInitiator => throw _privateConstructorUsedError;
  Card? get drawnCard => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({
    String roomId,
    List<GamePlayer> players,
    int currentPlayerIndex,
    List<Card> deck,
    List<Card> discardPile,
    List<ActionCard> actionDeck,
    List<ActionCard> actionDiscard,
    GameStatus status,
    TurnDirection turnDirection,
    bool lastRound,
    String? initiatorPlayerId,
    String? endRoundInitiator,
    Card? drawnCard,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
  });

  $CardCopyWith<$Res>? get drawnCard;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? players = null,
    Object? currentPlayerIndex = null,
    Object? deck = null,
    Object? discardPile = null,
    Object? actionDeck = null,
    Object? actionDiscard = null,
    Object? status = null,
    Object? turnDirection = null,
    Object? lastRound = null,
    Object? initiatorPlayerId = freezed,
    Object? endRoundInitiator = freezed,
    Object? drawnCard = freezed,
    Object? createdAt = freezed,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            roomId: null == roomId
                ? _value.roomId
                : roomId // ignore: cast_nullable_to_non_nullable
                      as String,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<GamePlayer>,
            currentPlayerIndex: null == currentPlayerIndex
                ? _value.currentPlayerIndex
                : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            deck: null == deck
                ? _value.deck
                : deck // ignore: cast_nullable_to_non_nullable
                      as List<Card>,
            discardPile: null == discardPile
                ? _value.discardPile
                : discardPile // ignore: cast_nullable_to_non_nullable
                      as List<Card>,
            actionDeck: null == actionDeck
                ? _value.actionDeck
                : actionDeck // ignore: cast_nullable_to_non_nullable
                      as List<ActionCard>,
            actionDiscard: null == actionDiscard
                ? _value.actionDiscard
                : actionDiscard // ignore: cast_nullable_to_non_nullable
                      as List<ActionCard>,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as GameStatus,
            turnDirection: null == turnDirection
                ? _value.turnDirection
                : turnDirection // ignore: cast_nullable_to_non_nullable
                      as TurnDirection,
            lastRound: null == lastRound
                ? _value.lastRound
                : lastRound // ignore: cast_nullable_to_non_nullable
                      as bool,
            initiatorPlayerId: freezed == initiatorPlayerId
                ? _value.initiatorPlayerId
                : initiatorPlayerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            endRoundInitiator: freezed == endRoundInitiator
                ? _value.endRoundInitiator
                : endRoundInitiator // ignore: cast_nullable_to_non_nullable
                      as String?,
            drawnCard: freezed == drawnCard
                ? _value.drawnCard
                : drawnCard // ignore: cast_nullable_to_non_nullable
                      as Card?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            finishedAt: freezed == finishedAt
                ? _value.finishedAt
                : finishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardCopyWith<$Res>? get drawnCard {
    if (_value.drawnCard == null) {
      return null;
    }

    return $CardCopyWith<$Res>(_value.drawnCard!, (value) {
      return _then(_value.copyWith(drawnCard: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
    _$GameStateImpl value,
    $Res Function(_$GameStateImpl) then,
  ) = __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String roomId,
    List<GamePlayer> players,
    int currentPlayerIndex,
    List<Card> deck,
    List<Card> discardPile,
    List<ActionCard> actionDeck,
    List<ActionCard> actionDiscard,
    GameStatus status,
    TurnDirection turnDirection,
    bool lastRound,
    String? initiatorPlayerId,
    String? endRoundInitiator,
    Card? drawnCard,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? finishedAt,
  });

  @override
  $CardCopyWith<$Res>? get drawnCard;
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
    _$GameStateImpl _value,
    $Res Function(_$GameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? players = null,
    Object? currentPlayerIndex = null,
    Object? deck = null,
    Object? discardPile = null,
    Object? actionDeck = null,
    Object? actionDiscard = null,
    Object? status = null,
    Object? turnDirection = null,
    Object? lastRound = null,
    Object? initiatorPlayerId = freezed,
    Object? endRoundInitiator = freezed,
    Object? drawnCard = freezed,
    Object? createdAt = freezed,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
  }) {
    return _then(
      _$GameStateImpl(
        roomId: null == roomId
            ? _value.roomId
            : roomId // ignore: cast_nullable_to_non_nullable
                  as String,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<GamePlayer>,
        currentPlayerIndex: null == currentPlayerIndex
            ? _value.currentPlayerIndex
            : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        deck: null == deck
            ? _value._deck
            : deck // ignore: cast_nullable_to_non_nullable
                  as List<Card>,
        discardPile: null == discardPile
            ? _value._discardPile
            : discardPile // ignore: cast_nullable_to_non_nullable
                  as List<Card>,
        actionDeck: null == actionDeck
            ? _value._actionDeck
            : actionDeck // ignore: cast_nullable_to_non_nullable
                  as List<ActionCard>,
        actionDiscard: null == actionDiscard
            ? _value._actionDiscard
            : actionDiscard // ignore: cast_nullable_to_non_nullable
                  as List<ActionCard>,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as GameStatus,
        turnDirection: null == turnDirection
            ? _value.turnDirection
            : turnDirection // ignore: cast_nullable_to_non_nullable
                  as TurnDirection,
        lastRound: null == lastRound
            ? _value.lastRound
            : lastRound // ignore: cast_nullable_to_non_nullable
                  as bool,
        initiatorPlayerId: freezed == initiatorPlayerId
            ? _value.initiatorPlayerId
            : initiatorPlayerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        endRoundInitiator: freezed == endRoundInitiator
            ? _value.endRoundInitiator
            : endRoundInitiator // ignore: cast_nullable_to_non_nullable
                  as String?,
        drawnCard: freezed == drawnCard
            ? _value.drawnCard
            : drawnCard // ignore: cast_nullable_to_non_nullable
                  as Card?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        finishedAt: freezed == finishedAt
            ? _value.finishedAt
            : finishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$GameStateImpl extends _GameState {
  const _$GameStateImpl({
    required this.roomId,
    required final List<GamePlayer> players,
    required this.currentPlayerIndex,
    required final List<Card> deck,
    required final List<Card> discardPile,
    required final List<ActionCard> actionDeck,
    required final List<ActionCard> actionDiscard,
    required this.status,
    required this.turnDirection,
    required this.lastRound,
    this.initiatorPlayerId,
    this.endRoundInitiator,
    this.drawnCard,
    this.createdAt,
    this.startedAt,
    this.finishedAt,
  }) : _players = players,
       _deck = deck,
       _discardPile = discardPile,
       _actionDeck = actionDeck,
       _actionDiscard = actionDiscard,
       super._();

  @override
  final String roomId;
  final List<GamePlayer> _players;
  @override
  List<GamePlayer> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  final int currentPlayerIndex;
  final List<Card> _deck;
  @override
  List<Card> get deck {
    if (_deck is EqualUnmodifiableListView) return _deck;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deck);
  }

  final List<Card> _discardPile;
  @override
  List<Card> get discardPile {
    if (_discardPile is EqualUnmodifiableListView) return _discardPile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_discardPile);
  }

  final List<ActionCard> _actionDeck;
  @override
  List<ActionCard> get actionDeck {
    if (_actionDeck is EqualUnmodifiableListView) return _actionDeck;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionDeck);
  }

  final List<ActionCard> _actionDiscard;
  @override
  List<ActionCard> get actionDiscard {
    if (_actionDiscard is EqualUnmodifiableListView) return _actionDiscard;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionDiscard);
  }

  @override
  final GameStatus status;
  @override
  final TurnDirection turnDirection;
  @override
  final bool lastRound;
  @override
  final String? initiatorPlayerId;
  @override
  final String? endRoundInitiator;
  @override
  final Card? drawnCard;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? finishedAt;

  @override
  String toString() {
    return 'GameState(roomId: $roomId, players: $players, currentPlayerIndex: $currentPlayerIndex, deck: $deck, discardPile: $discardPile, actionDeck: $actionDeck, actionDiscard: $actionDiscard, status: $status, turnDirection: $turnDirection, lastRound: $lastRound, initiatorPlayerId: $initiatorPlayerId, endRoundInitiator: $endRoundInitiator, drawnCard: $drawnCard, createdAt: $createdAt, startedAt: $startedAt, finishedAt: $finishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.currentPlayerIndex, currentPlayerIndex) ||
                other.currentPlayerIndex == currentPlayerIndex) &&
            const DeepCollectionEquality().equals(other._deck, _deck) &&
            const DeepCollectionEquality().equals(
              other._discardPile,
              _discardPile,
            ) &&
            const DeepCollectionEquality().equals(
              other._actionDeck,
              _actionDeck,
            ) &&
            const DeepCollectionEquality().equals(
              other._actionDiscard,
              _actionDiscard,
            ) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.turnDirection, turnDirection) ||
                other.turnDirection == turnDirection) &&
            (identical(other.lastRound, lastRound) ||
                other.lastRound == lastRound) &&
            (identical(other.initiatorPlayerId, initiatorPlayerId) ||
                other.initiatorPlayerId == initiatorPlayerId) &&
            (identical(other.endRoundInitiator, endRoundInitiator) ||
                other.endRoundInitiator == endRoundInitiator) &&
            (identical(other.drawnCard, drawnCard) ||
                other.drawnCard == drawnCard) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roomId,
    const DeepCollectionEquality().hash(_players),
    currentPlayerIndex,
    const DeepCollectionEquality().hash(_deck),
    const DeepCollectionEquality().hash(_discardPile),
    const DeepCollectionEquality().hash(_actionDeck),
    const DeepCollectionEquality().hash(_actionDiscard),
    status,
    turnDirection,
    lastRound,
    initiatorPlayerId,
    endRoundInitiator,
    drawnCard,
    createdAt,
    startedAt,
    finishedAt,
  );

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState extends GameState {
  const factory _GameState({
    required final String roomId,
    required final List<GamePlayer> players,
    required final int currentPlayerIndex,
    required final List<Card> deck,
    required final List<Card> discardPile,
    required final List<ActionCard> actionDeck,
    required final List<ActionCard> actionDiscard,
    required final GameStatus status,
    required final TurnDirection turnDirection,
    required final bool lastRound,
    final String? initiatorPlayerId,
    final String? endRoundInitiator,
    final Card? drawnCard,
    final DateTime? createdAt,
    final DateTime? startedAt,
    final DateTime? finishedAt,
  }) = _$GameStateImpl;
  const _GameState._() : super._();

  @override
  String get roomId;
  @override
  List<GamePlayer> get players;
  @override
  int get currentPlayerIndex;
  @override
  List<Card> get deck;
  @override
  List<Card> get discardPile;
  @override
  List<ActionCard> get actionDeck;
  @override
  List<ActionCard> get actionDiscard;
  @override
  GameStatus get status;
  @override
  TurnDirection get turnDirection;
  @override
  bool get lastRound;
  @override
  String? get initiatorPlayerId;
  @override
  String? get endRoundInitiator;
  @override
  Card? get drawnCard;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get finishedAt;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
