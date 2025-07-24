// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_animation_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$GameAnimationState {
  bool get showingDirectionChange => throw _privateConstructorUsedError;
  PlayDirection get direction => throw _privateConstructorUsedError;

  /// Create a copy of GameAnimationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GameAnimationStateCopyWith<GameAnimationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameAnimationStateCopyWith<$Res> {
  factory $GameAnimationStateCopyWith(
    GameAnimationState value,
    $Res Function(GameAnimationState) then,
  ) = _$GameAnimationStateCopyWithImpl<$Res, GameAnimationState>;
  @useResult
  $Res call({bool showingDirectionChange, PlayDirection direction});
}

/// @nodoc
class _$GameAnimationStateCopyWithImpl<$Res, $Val extends GameAnimationState>
    implements $GameAnimationStateCopyWith<$Res> {
  _$GameAnimationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameAnimationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? showingDirectionChange = null, Object? direction = null}) {
    return _then(
      _value.copyWith(
            showingDirectionChange: null == showingDirectionChange
                ? _value.showingDirectionChange
                : showingDirectionChange // ignore: cast_nullable_to_non_nullable
                      as bool,
            direction: null == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as PlayDirection,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GameAnimationStateImplCopyWith<$Res>
    implements $GameAnimationStateCopyWith<$Res> {
  factory _$$GameAnimationStateImplCopyWith(
    _$GameAnimationStateImpl value,
    $Res Function(_$GameAnimationStateImpl) then,
  ) = __$$GameAnimationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool showingDirectionChange, PlayDirection direction});
}

/// @nodoc
class __$$GameAnimationStateImplCopyWithImpl<$Res>
    extends _$GameAnimationStateCopyWithImpl<$Res, _$GameAnimationStateImpl>
    implements _$$GameAnimationStateImplCopyWith<$Res> {
  __$$GameAnimationStateImplCopyWithImpl(
    _$GameAnimationStateImpl _value,
    $Res Function(_$GameAnimationStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameAnimationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? showingDirectionChange = null, Object? direction = null}) {
    return _then(
      _$GameAnimationStateImpl(
        showingDirectionChange: null == showingDirectionChange
            ? _value.showingDirectionChange
            : showingDirectionChange // ignore: cast_nullable_to_non_nullable
                  as bool,
        direction: null == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as PlayDirection,
      ),
    );
  }
}

/// @nodoc

class _$GameAnimationStateImpl implements _GameAnimationState {
  const _$GameAnimationStateImpl({
    this.showingDirectionChange = false,
    this.direction = PlayDirection.forward,
  });

  @override
  @JsonKey()
  final bool showingDirectionChange;
  @override
  @JsonKey()
  final PlayDirection direction;

  @override
  String toString() {
    return 'GameAnimationState(showingDirectionChange: $showingDirectionChange, direction: $direction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameAnimationStateImpl &&
            (identical(other.showingDirectionChange, showingDirectionChange) ||
                other.showingDirectionChange == showingDirectionChange) &&
            (identical(other.direction, direction) ||
                other.direction == direction));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, showingDirectionChange, direction);

  /// Create a copy of GameAnimationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameAnimationStateImplCopyWith<_$GameAnimationStateImpl> get copyWith =>
      __$$GameAnimationStateImplCopyWithImpl<_$GameAnimationStateImpl>(
        this,
        _$identity,
      );
}

abstract class _GameAnimationState implements GameAnimationState {
  const factory _GameAnimationState({
    final bool showingDirectionChange,
    final PlayDirection direction,
  }) = _$GameAnimationStateImpl;

  @override
  bool get showingDirectionChange;
  @override
  PlayDirection get direction;

  /// Create a copy of GameAnimationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameAnimationStateImplCopyWith<_$GameAnimationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
