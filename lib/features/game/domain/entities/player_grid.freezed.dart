// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_grid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerGrid _$PlayerGridFromJson(Map<String, dynamic> json) {
  return _PlayerGrid.fromJson(json);
}

/// @nodoc
mixin _$PlayerGrid {
  List<List<Card?>> get cards => throw _privateConstructorUsedError;

  /// Serializes this PlayerGrid to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerGrid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerGridCopyWith<PlayerGrid> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerGridCopyWith<$Res> {
  factory $PlayerGridCopyWith(
    PlayerGrid value,
    $Res Function(PlayerGrid) then,
  ) = _$PlayerGridCopyWithImpl<$Res, PlayerGrid>;
  @useResult
  $Res call({List<List<Card?>> cards});
}

/// @nodoc
class _$PlayerGridCopyWithImpl<$Res, $Val extends PlayerGrid>
    implements $PlayerGridCopyWith<$Res> {
  _$PlayerGridCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerGrid
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cards = null}) {
    return _then(
      _value.copyWith(
            cards: null == cards
                ? _value.cards
                : cards // ignore: cast_nullable_to_non_nullable
                      as List<List<Card?>>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlayerGridImplCopyWith<$Res>
    implements $PlayerGridCopyWith<$Res> {
  factory _$$PlayerGridImplCopyWith(
    _$PlayerGridImpl value,
    $Res Function(_$PlayerGridImpl) then,
  ) = __$$PlayerGridImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<List<Card?>> cards});
}

/// @nodoc
class __$$PlayerGridImplCopyWithImpl<$Res>
    extends _$PlayerGridCopyWithImpl<$Res, _$PlayerGridImpl>
    implements _$$PlayerGridImplCopyWith<$Res> {
  __$$PlayerGridImplCopyWithImpl(
    _$PlayerGridImpl _value,
    $Res Function(_$PlayerGridImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerGrid
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? cards = null}) {
    return _then(
      _$PlayerGridImpl(
        cards: null == cards
            ? _value._cards
            : cards // ignore: cast_nullable_to_non_nullable
                  as List<List<Card?>>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerGridImpl extends _PlayerGrid {
  const _$PlayerGridImpl({required final List<List<Card?>> cards})
    : _cards = cards,
      super._();

  factory _$PlayerGridImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerGridImplFromJson(json);

  final List<List<Card?>> _cards;
  @override
  List<List<Card?>> get cards {
    if (_cards is EqualUnmodifiableListView) return _cards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cards);
  }

  @override
  String toString() {
    return 'PlayerGrid(cards: $cards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerGridImpl &&
            const DeepCollectionEquality().equals(other._cards, _cards));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cards));

  /// Create a copy of PlayerGrid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerGridImplCopyWith<_$PlayerGridImpl> get copyWith =>
      __$$PlayerGridImplCopyWithImpl<_$PlayerGridImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerGridImplToJson(this);
  }
}

abstract class _PlayerGrid extends PlayerGrid {
  const factory _PlayerGrid({required final List<List<Card?>> cards}) =
      _$PlayerGridImpl;
  const _PlayerGrid._() : super._();

  factory _PlayerGrid.fromJson(Map<String, dynamic> json) =
      _$PlayerGridImpl.fromJson;

  @override
  List<List<Card?>> get cards;

  /// Create a copy of PlayerGrid
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerGridImplCopyWith<_$PlayerGridImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
