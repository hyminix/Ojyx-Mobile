// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return _Player.fromJson(json);
}

/// @nodoc
mixin _$Player {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  PlayerGrid get grid => throw _privateConstructorUsedError;
  List<ActionCard> get actionCards => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  bool get isHost => throw _privateConstructorUsedError;
  bool get hasFinishedRound => throw _privateConstructorUsedError;
  int get scoreMultiplier => throw _privateConstructorUsedError;

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerCopyWith<Player> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerCopyWith<$Res> {
  factory $PlayerCopyWith(Player value, $Res Function(Player) then) =
      _$PlayerCopyWithImpl<$Res, Player>;
  @useResult
  $Res call({
    String id,
    String name,
    PlayerGrid grid,
    List<ActionCard> actionCards,
    bool isConnected,
    bool isHost,
    bool hasFinishedRound,
    int scoreMultiplier,
  });

  $PlayerGridCopyWith<$Res> get grid;
}

/// @nodoc
class _$PlayerCopyWithImpl<$Res, $Val extends Player>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? grid = null,
    Object? actionCards = null,
    Object? isConnected = null,
    Object? isHost = null,
    Object? hasFinishedRound = null,
    Object? scoreMultiplier = null,
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
            grid: null == grid
                ? _value.grid
                : grid // ignore: cast_nullable_to_non_nullable
                      as PlayerGrid,
            actionCards: null == actionCards
                ? _value.actionCards
                : actionCards // ignore: cast_nullable_to_non_nullable
                      as List<ActionCard>,
            isConnected: null == isConnected
                ? _value.isConnected
                : isConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
            isHost: null == isHost
                ? _value.isHost
                : isHost // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasFinishedRound: null == hasFinishedRound
                ? _value.hasFinishedRound
                : hasFinishedRound // ignore: cast_nullable_to_non_nullable
                      as bool,
            scoreMultiplier: null == scoreMultiplier
                ? _value.scoreMultiplier
                : scoreMultiplier // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerGridCopyWith<$Res> get grid {
    return $PlayerGridCopyWith<$Res>(_value.grid, (value) {
      return _then(_value.copyWith(grid: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerImplCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$$PlayerImplCopyWith(
    _$PlayerImpl value,
    $Res Function(_$PlayerImpl) then,
  ) = __$$PlayerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    PlayerGrid grid,
    List<ActionCard> actionCards,
    bool isConnected,
    bool isHost,
    bool hasFinishedRound,
    int scoreMultiplier,
  });

  @override
  $PlayerGridCopyWith<$Res> get grid;
}

/// @nodoc
class __$$PlayerImplCopyWithImpl<$Res>
    extends _$PlayerCopyWithImpl<$Res, _$PlayerImpl>
    implements _$$PlayerImplCopyWith<$Res> {
  __$$PlayerImplCopyWithImpl(
    _$PlayerImpl _value,
    $Res Function(_$PlayerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? grid = null,
    Object? actionCards = null,
    Object? isConnected = null,
    Object? isHost = null,
    Object? hasFinishedRound = null,
    Object? scoreMultiplier = null,
  }) {
    return _then(
      _$PlayerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        grid: null == grid
            ? _value.grid
            : grid // ignore: cast_nullable_to_non_nullable
                  as PlayerGrid,
        actionCards: null == actionCards
            ? _value._actionCards
            : actionCards // ignore: cast_nullable_to_non_nullable
                  as List<ActionCard>,
        isConnected: null == isConnected
            ? _value.isConnected
            : isConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
        isHost: null == isHost
            ? _value.isHost
            : isHost // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasFinishedRound: null == hasFinishedRound
            ? _value.hasFinishedRound
            : hasFinishedRound // ignore: cast_nullable_to_non_nullable
                  as bool,
        scoreMultiplier: null == scoreMultiplier
            ? _value.scoreMultiplier
            : scoreMultiplier // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerImpl extends _Player {
  const _$PlayerImpl({
    required this.id,
    required this.name,
    required this.grid,
    final List<ActionCard> actionCards = const [],
    this.isConnected = true,
    this.isHost = false,
    this.hasFinishedRound = false,
    this.scoreMultiplier = 1,
  }) : assert(actionCards.length <= kMaxActionCardsInHand),
       _actionCards = actionCards,
       super._();

  factory _$PlayerImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final PlayerGrid grid;
  final List<ActionCard> _actionCards;
  @override
  @JsonKey()
  List<ActionCard> get actionCards {
    if (_actionCards is EqualUnmodifiableListView) return _actionCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionCards);
  }

  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final bool isHost;
  @override
  @JsonKey()
  final bool hasFinishedRound;
  @override
  @JsonKey()
  final int scoreMultiplier;

  @override
  String toString() {
    return 'Player(id: $id, name: $name, grid: $grid, actionCards: $actionCards, isConnected: $isConnected, isHost: $isHost, hasFinishedRound: $hasFinishedRound, scoreMultiplier: $scoreMultiplier)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.grid, grid) || other.grid == grid) &&
            const DeepCollectionEquality().equals(
              other._actionCards,
              _actionCards,
            ) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isHost, isHost) || other.isHost == isHost) &&
            (identical(other.hasFinishedRound, hasFinishedRound) ||
                other.hasFinishedRound == hasFinishedRound) &&
            (identical(other.scoreMultiplier, scoreMultiplier) ||
                other.scoreMultiplier == scoreMultiplier));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    grid,
    const DeepCollectionEquality().hash(_actionCards),
    isConnected,
    isHost,
    hasFinishedRound,
    scoreMultiplier,
  );

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      __$$PlayerImplCopyWithImpl<_$PlayerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerImplToJson(this);
  }
}

abstract class _Player extends Player {
  const factory _Player({
    required final String id,
    required final String name,
    required final PlayerGrid grid,
    final List<ActionCard> actionCards,
    final bool isConnected,
    final bool isHost,
    final bool hasFinishedRound,
    final int scoreMultiplier,
  }) = _$PlayerImpl;
  const _Player._() : super._();

  factory _Player.fromJson(Map<String, dynamic> json) = _$PlayerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  PlayerGrid get grid;
  @override
  List<ActionCard> get actionCards;
  @override
  bool get isConnected;
  @override
  bool get isHost;
  @override
  bool get hasFinishedRound;
  @override
  int get scoreMultiplier;

  /// Create a copy of Player
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerImplCopyWith<_$PlayerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
