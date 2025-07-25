// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'db_player_grid_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DbPlayerGridModel _$DbPlayerGridModelFromJson(Map<String, dynamic> json) {
  return _DbPlayerGridModel.fromJson(json);
}

/// @nodoc
mixin _$DbPlayerGridModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'game_state_id')
  String get gameStateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'player_id')
  String get playerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'grid_cards')
  List<Card> get gridCards => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_cards')
  List<ActionCard> get actionCards => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_revealed_all')
  bool get hasRevealedAll => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DbPlayerGridModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DbPlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DbPlayerGridModelCopyWith<DbPlayerGridModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DbPlayerGridModelCopyWith<$Res> {
  factory $DbPlayerGridModelCopyWith(
    DbPlayerGridModel value,
    $Res Function(DbPlayerGridModel) then,
  ) = _$DbPlayerGridModelCopyWithImpl<$Res, DbPlayerGridModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'game_state_id') String gameStateId,
    @JsonKey(name: 'player_id') String playerId,
    @JsonKey(name: 'grid_cards') List<Card> gridCards,
    @JsonKey(name: 'action_cards') List<ActionCard> actionCards,
    int score,
    int position,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'has_revealed_all') bool hasRevealedAll,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$DbPlayerGridModelCopyWithImpl<$Res, $Val extends DbPlayerGridModel>
    implements $DbPlayerGridModelCopyWith<$Res> {
  _$DbPlayerGridModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DbPlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameStateId = null,
    Object? playerId = null,
    Object? gridCards = null,
    Object? actionCards = null,
    Object? score = null,
    Object? position = null,
    Object? isActive = null,
    Object? hasRevealedAll = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            gameStateId: null == gameStateId
                ? _value.gameStateId
                : gameStateId // ignore: cast_nullable_to_non_nullable
                      as String,
            playerId: null == playerId
                ? _value.playerId
                : playerId // ignore: cast_nullable_to_non_nullable
                      as String,
            gridCards: null == gridCards
                ? _value.gridCards
                : gridCards // ignore: cast_nullable_to_non_nullable
                      as List<Card>,
            actionCards: null == actionCards
                ? _value.actionCards
                : actionCards // ignore: cast_nullable_to_non_nullable
                      as List<ActionCard>,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasRevealedAll: null == hasRevealedAll
                ? _value.hasRevealedAll
                : hasRevealedAll // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$DbPlayerGridModelImplCopyWith<$Res>
    implements $DbPlayerGridModelCopyWith<$Res> {
  factory _$$DbPlayerGridModelImplCopyWith(
    _$DbPlayerGridModelImpl value,
    $Res Function(_$DbPlayerGridModelImpl) then,
  ) = __$$DbPlayerGridModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'game_state_id') String gameStateId,
    @JsonKey(name: 'player_id') String playerId,
    @JsonKey(name: 'grid_cards') List<Card> gridCards,
    @JsonKey(name: 'action_cards') List<ActionCard> actionCards,
    int score,
    int position,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'has_revealed_all') bool hasRevealedAll,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$DbPlayerGridModelImplCopyWithImpl<$Res>
    extends _$DbPlayerGridModelCopyWithImpl<$Res, _$DbPlayerGridModelImpl>
    implements _$$DbPlayerGridModelImplCopyWith<$Res> {
  __$$DbPlayerGridModelImplCopyWithImpl(
    _$DbPlayerGridModelImpl _value,
    $Res Function(_$DbPlayerGridModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DbPlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? gameStateId = null,
    Object? playerId = null,
    Object? gridCards = null,
    Object? actionCards = null,
    Object? score = null,
    Object? position = null,
    Object? isActive = null,
    Object? hasRevealedAll = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$DbPlayerGridModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        gameStateId: null == gameStateId
            ? _value.gameStateId
            : gameStateId // ignore: cast_nullable_to_non_nullable
                  as String,
        playerId: null == playerId
            ? _value.playerId
            : playerId // ignore: cast_nullable_to_non_nullable
                  as String,
        gridCards: null == gridCards
            ? _value._gridCards
            : gridCards // ignore: cast_nullable_to_non_nullable
                  as List<Card>,
        actionCards: null == actionCards
            ? _value._actionCards
            : actionCards // ignore: cast_nullable_to_non_nullable
                  as List<ActionCard>,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasRevealedAll: null == hasRevealedAll
            ? _value.hasRevealedAll
            : hasRevealedAll // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$DbPlayerGridModelImpl extends _DbPlayerGridModel {
  const _$DbPlayerGridModelImpl({
    required this.id,
    @JsonKey(name: 'game_state_id') required this.gameStateId,
    @JsonKey(name: 'player_id') required this.playerId,
    @JsonKey(name: 'grid_cards') required final List<Card> gridCards,
    @JsonKey(name: 'action_cards') required final List<ActionCard> actionCards,
    required this.score,
    required this.position,
    @JsonKey(name: 'is_active') required this.isActive,
    @JsonKey(name: 'has_revealed_all') required this.hasRevealedAll,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _gridCards = gridCards,
       _actionCards = actionCards,
       super._();

  factory _$DbPlayerGridModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DbPlayerGridModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'game_state_id')
  final String gameStateId;
  @override
  @JsonKey(name: 'player_id')
  final String playerId;
  final List<Card> _gridCards;
  @override
  @JsonKey(name: 'grid_cards')
  List<Card> get gridCards {
    if (_gridCards is EqualUnmodifiableListView) return _gridCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gridCards);
  }

  final List<ActionCard> _actionCards;
  @override
  @JsonKey(name: 'action_cards')
  List<ActionCard> get actionCards {
    if (_actionCards is EqualUnmodifiableListView) return _actionCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionCards);
  }

  @override
  final int score;
  @override
  final int position;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'has_revealed_all')
  final bool hasRevealedAll;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'DbPlayerGridModel(id: $id, gameStateId: $gameStateId, playerId: $playerId, gridCards: $gridCards, actionCards: $actionCards, score: $score, position: $position, isActive: $isActive, hasRevealedAll: $hasRevealedAll, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DbPlayerGridModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.gameStateId, gameStateId) ||
                other.gameStateId == gameStateId) &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality().equals(
              other._gridCards,
              _gridCards,
            ) &&
            const DeepCollectionEquality().equals(
              other._actionCards,
              _actionCards,
            ) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.hasRevealedAll, hasRevealedAll) ||
                other.hasRevealedAll == hasRevealedAll) &&
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
    gameStateId,
    playerId,
    const DeepCollectionEquality().hash(_gridCards),
    const DeepCollectionEquality().hash(_actionCards),
    score,
    position,
    isActive,
    hasRevealedAll,
    createdAt,
    updatedAt,
  );

  /// Create a copy of DbPlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DbPlayerGridModelImplCopyWith<_$DbPlayerGridModelImpl> get copyWith =>
      __$$DbPlayerGridModelImplCopyWithImpl<_$DbPlayerGridModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DbPlayerGridModelImplToJson(this);
  }
}

abstract class _DbPlayerGridModel extends DbPlayerGridModel {
  const factory _DbPlayerGridModel({
    required final String id,
    @JsonKey(name: 'game_state_id') required final String gameStateId,
    @JsonKey(name: 'player_id') required final String playerId,
    @JsonKey(name: 'grid_cards') required final List<Card> gridCards,
    @JsonKey(name: 'action_cards') required final List<ActionCard> actionCards,
    required final int score,
    required final int position,
    @JsonKey(name: 'is_active') required final bool isActive,
    @JsonKey(name: 'has_revealed_all') required final bool hasRevealedAll,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$DbPlayerGridModelImpl;
  const _DbPlayerGridModel._() : super._();

  factory _DbPlayerGridModel.fromJson(Map<String, dynamic> json) =
      _$DbPlayerGridModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'game_state_id')
  String get gameStateId;
  @override
  @JsonKey(name: 'player_id')
  String get playerId;
  @override
  @JsonKey(name: 'grid_cards')
  List<Card> get gridCards;
  @override
  @JsonKey(name: 'action_cards')
  List<ActionCard> get actionCards;
  @override
  int get score;
  @override
  int get position;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'has_revealed_all')
  bool get hasRevealedAll;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of DbPlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DbPlayerGridModelImplCopyWith<_$DbPlayerGridModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
