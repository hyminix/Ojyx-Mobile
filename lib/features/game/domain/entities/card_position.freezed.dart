// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CardPosition {
  int get row => throw _privateConstructorUsedError;
  int get col => throw _privateConstructorUsedError;

  /// Create a copy of CardPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardPositionCopyWith<CardPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardPositionCopyWith<$Res> {
  factory $CardPositionCopyWith(
    CardPosition value,
    $Res Function(CardPosition) then,
  ) = _$CardPositionCopyWithImpl<$Res, CardPosition>;
  @useResult
  $Res call({int row, int col});
}

/// @nodoc
class _$CardPositionCopyWithImpl<$Res, $Val extends CardPosition>
    implements $CardPositionCopyWith<$Res> {
  _$CardPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? row = null, Object? col = null}) {
    return _then(
      _value.copyWith(
            row: null == row
                ? _value.row
                : row // ignore: cast_nullable_to_non_nullable
                      as int,
            col: null == col
                ? _value.col
                : col // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardPositionImplCopyWith<$Res>
    implements $CardPositionCopyWith<$Res> {
  factory _$$CardPositionImplCopyWith(
    _$CardPositionImpl value,
    $Res Function(_$CardPositionImpl) then,
  ) = __$$CardPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int row, int col});
}

/// @nodoc
class __$$CardPositionImplCopyWithImpl<$Res>
    extends _$CardPositionCopyWithImpl<$Res, _$CardPositionImpl>
    implements _$$CardPositionImplCopyWith<$Res> {
  __$$CardPositionImplCopyWithImpl(
    _$CardPositionImpl _value,
    $Res Function(_$CardPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? row = null, Object? col = null}) {
    return _then(
      _$CardPositionImpl(
        row: null == row
            ? _value.row
            : row // ignore: cast_nullable_to_non_nullable
                  as int,
        col: null == col
            ? _value.col
            : col // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$CardPositionImpl extends _CardPosition {
  const _$CardPositionImpl({required this.row, required this.col}) : super._();

  @override
  final int row;
  @override
  final int col;

  @override
  String toString() {
    return 'CardPosition(row: $row, col: $col)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardPositionImpl &&
            (identical(other.row, row) || other.row == row) &&
            (identical(other.col, col) || other.col == col));
  }

  @override
  int get hashCode => Object.hash(runtimeType, row, col);

  /// Create a copy of CardPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardPositionImplCopyWith<_$CardPositionImpl> get copyWith =>
      __$$CardPositionImplCopyWithImpl<_$CardPositionImpl>(this, _$identity);
}

abstract class _CardPosition extends CardPosition {
  const factory _CardPosition({
    required final int row,
    required final int col,
  }) = _$CardPositionImpl;
  const _CardPosition._() : super._();

  @override
  int get row;
  @override
  int get col;

  /// Create a copy of CardPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardPositionImplCopyWith<_$CardPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
