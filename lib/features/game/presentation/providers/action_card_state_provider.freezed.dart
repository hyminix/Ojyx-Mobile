// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_card_state_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ActionCardState {
  int get drawPileCount => throw _privateConstructorUsedError;
  int get discardPileCount => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Create a copy of ActionCardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionCardStateCopyWith<ActionCardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionCardStateCopyWith<$Res> {
  factory $ActionCardStateCopyWith(
    ActionCardState value,
    $Res Function(ActionCardState) then,
  ) = _$ActionCardStateCopyWithImpl<$Res, ActionCardState>;
  @useResult
  $Res call({int drawPileCount, int discardPileCount, bool isLoading});
}

/// @nodoc
class _$ActionCardStateCopyWithImpl<$Res, $Val extends ActionCardState>
    implements $ActionCardStateCopyWith<$Res> {
  _$ActionCardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionCardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drawPileCount = null,
    Object? discardPileCount = null,
    Object? isLoading = null,
  }) {
    return _then(
      _value.copyWith(
            drawPileCount: null == drawPileCount
                ? _value.drawPileCount
                : drawPileCount // ignore: cast_nullable_to_non_nullable
                      as int,
            discardPileCount: null == discardPileCount
                ? _value.discardPileCount
                : discardPileCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActionCardStateImplCopyWith<$Res>
    implements $ActionCardStateCopyWith<$Res> {
  factory _$$ActionCardStateImplCopyWith(
    _$ActionCardStateImpl value,
    $Res Function(_$ActionCardStateImpl) then,
  ) = __$$ActionCardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int drawPileCount, int discardPileCount, bool isLoading});
}

/// @nodoc
class __$$ActionCardStateImplCopyWithImpl<$Res>
    extends _$ActionCardStateCopyWithImpl<$Res, _$ActionCardStateImpl>
    implements _$$ActionCardStateImplCopyWith<$Res> {
  __$$ActionCardStateImplCopyWithImpl(
    _$ActionCardStateImpl _value,
    $Res Function(_$ActionCardStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionCardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drawPileCount = null,
    Object? discardPileCount = null,
    Object? isLoading = null,
  }) {
    return _then(
      _$ActionCardStateImpl(
        drawPileCount: null == drawPileCount
            ? _value.drawPileCount
            : drawPileCount // ignore: cast_nullable_to_non_nullable
                  as int,
        discardPileCount: null == discardPileCount
            ? _value.discardPileCount
            : discardPileCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$ActionCardStateImpl implements _ActionCardState {
  const _$ActionCardStateImpl({
    required this.drawPileCount,
    required this.discardPileCount,
    required this.isLoading,
  });

  @override
  final int drawPileCount;
  @override
  final int discardPileCount;
  @override
  final bool isLoading;

  @override
  String toString() {
    return 'ActionCardState(drawPileCount: $drawPileCount, discardPileCount: $discardPileCount, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionCardStateImpl &&
            (identical(other.drawPileCount, drawPileCount) ||
                other.drawPileCount == drawPileCount) &&
            (identical(other.discardPileCount, discardPileCount) ||
                other.discardPileCount == discardPileCount) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, drawPileCount, discardPileCount, isLoading);

  /// Create a copy of ActionCardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionCardStateImplCopyWith<_$ActionCardStateImpl> get copyWith =>
      __$$ActionCardStateImplCopyWithImpl<_$ActionCardStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ActionCardState implements ActionCardState {
  const factory _ActionCardState({
    required final int drawPileCount,
    required final int discardPileCount,
    required final bool isLoading,
  }) = _$ActionCardStateImpl;

  @override
  int get drawPileCount;
  @override
  int get discardPileCount;
  @override
  bool get isLoading;

  /// Create a copy of ActionCardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionCardStateImplCopyWith<_$ActionCardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
