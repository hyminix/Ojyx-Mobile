// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_grid_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerGridModel _$PlayerGridModelFromJson(Map<String, dynamic> json) {
  return _PlayerGridModel.fromJson(json);
}

/// @nodoc
mixin _$PlayerGridModel {
  String get id => throw _privateConstructorUsedError;
  String get gameStateId => throw _privateConstructorUsedError;
  String get playerId => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get gridCards =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get actionCards =>
      throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  int get position => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get hasRevealedAll => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PlayerGridModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerGridModelCopyWith<PlayerGridModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerGridModelCopyWith<$Res> {
  factory $PlayerGridModelCopyWith(
    PlayerGridModel value,
    $Res Function(PlayerGridModel) then,
  ) = _$PlayerGridModelCopyWithImpl<$Res, PlayerGridModel>;
  @useResult
  $Res call({
    String id,
    String gameStateId,
    String playerId,
    List<Map<String, dynamic>> gridCards,
    List<Map<String, dynamic>> actionCards,
    int score,
    int position,
    bool isActive,
    bool hasRevealedAll,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$PlayerGridModelCopyWithImpl<$Res, $Val extends PlayerGridModel>
    implements $PlayerGridModelCopyWith<$Res> {
  _$PlayerGridModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerGridModel
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
                      as List<Map<String, dynamic>>,
            actionCards: null == actionCards
                ? _value.actionCards
                : actionCards // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>,
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
abstract class _$$PlayerGridModelImplCopyWith<$Res>
    implements $PlayerGridModelCopyWith<$Res> {
  factory _$$PlayerGridModelImplCopyWith(
    _$PlayerGridModelImpl value,
    $Res Function(_$PlayerGridModelImpl) then,
  ) = __$$PlayerGridModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String gameStateId,
    String playerId,
    List<Map<String, dynamic>> gridCards,
    List<Map<String, dynamic>> actionCards,
    int score,
    int position,
    bool isActive,
    bool hasRevealedAll,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$PlayerGridModelImplCopyWithImpl<$Res>
    extends _$PlayerGridModelCopyWithImpl<$Res, _$PlayerGridModelImpl>
    implements _$$PlayerGridModelImplCopyWith<$Res> {
  __$$PlayerGridModelImplCopyWithImpl(
    _$PlayerGridModelImpl _value,
    $Res Function(_$PlayerGridModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerGridModel
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
      _$PlayerGridModelImpl(
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
                  as List<Map<String, dynamic>>,
        actionCards: null == actionCards
            ? _value._actionCards
            : actionCards // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>,
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
class _$PlayerGridModelImpl extends _PlayerGridModel {
  const _$PlayerGridModelImpl({
    required this.id,
    required this.gameStateId,
    required this.playerId,
    required final List<Map<String, dynamic>> gridCards,
    required final List<Map<String, dynamic>> actionCards,
    required this.score,
    required this.position,
    required this.isActive,
    required this.hasRevealedAll,
    required this.createdAt,
    required this.updatedAt,
  }) : _gridCards = gridCards,
       _actionCards = actionCards,
       super._();

  factory _$PlayerGridModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerGridModelImplFromJson(json);

  @override
  final String id;
  @override
  final String gameStateId;
  @override
  final String playerId;
  final List<Map<String, dynamic>> _gridCards;
  @override
  List<Map<String, dynamic>> get gridCards {
    if (_gridCards is EqualUnmodifiableListView) return _gridCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gridCards);
  }

  final List<Map<String, dynamic>> _actionCards;
  @override
  List<Map<String, dynamic>> get actionCards {
    if (_actionCards is EqualUnmodifiableListView) return _actionCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionCards);
  }

  @override
  final int score;
  @override
  final int position;
  @override
  final bool isActive;
  @override
  final bool hasRevealedAll;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PlayerGridModel(id: $id, gameStateId: $gameStateId, playerId: $playerId, gridCards: $gridCards, actionCards: $actionCards, score: $score, position: $position, isActive: $isActive, hasRevealedAll: $hasRevealedAll, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerGridModelImpl &&
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

  /// Create a copy of PlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerGridModelImplCopyWith<_$PlayerGridModelImpl> get copyWith =>
      __$$PlayerGridModelImplCopyWithImpl<_$PlayerGridModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerGridModelImplToJson(this);
  }
}

abstract class _PlayerGridModel extends PlayerGridModel {
  const factory _PlayerGridModel({
    required final String id,
    required final String gameStateId,
    required final String playerId,
    required final List<Map<String, dynamic>> gridCards,
    required final List<Map<String, dynamic>> actionCards,
    required final int score,
    required final int position,
    required final bool isActive,
    required final bool hasRevealedAll,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$PlayerGridModelImpl;
  const _PlayerGridModel._() : super._();

  factory _PlayerGridModel.fromJson(Map<String, dynamic> json) =
      _$PlayerGridModelImpl.fromJson;

  @override
  String get id;
  @override
  String get gameStateId;
  @override
  String get playerId;
  @override
  List<Map<String, dynamic>> get gridCards;
  @override
  List<Map<String, dynamic>> get actionCards;
  @override
  int get score;
  @override
  int get position;
  @override
  bool get isActive;
  @override
  bool get hasRevealedAll;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of PlayerGridModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerGridModelImplCopyWith<_$PlayerGridModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
