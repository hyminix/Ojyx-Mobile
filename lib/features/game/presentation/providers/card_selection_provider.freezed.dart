// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_selection_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CardSelectionState {
  bool get isSelecting => throw _privateConstructorUsedError;
  CardSelectionType? get selectionType => throw _privateConstructorUsedError;
  CardPosition? get firstSelection => throw _privateConstructorUsedError;
  CardPosition? get secondSelection => throw _privateConstructorUsedError;

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardSelectionStateCopyWith<CardSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardSelectionStateCopyWith<$Res> {
  factory $CardSelectionStateCopyWith(
    CardSelectionState value,
    $Res Function(CardSelectionState) then,
  ) = _$CardSelectionStateCopyWithImpl<$Res, CardSelectionState>;
  @useResult
  $Res call({
    bool isSelecting,
    CardSelectionType? selectionType,
    CardPosition? firstSelection,
    CardPosition? secondSelection,
  });

  $CardPositionCopyWith<$Res>? get firstSelection;
  $CardPositionCopyWith<$Res>? get secondSelection;
}

/// @nodoc
class _$CardSelectionStateCopyWithImpl<$Res, $Val extends CardSelectionState>
    implements $CardSelectionStateCopyWith<$Res> {
  _$CardSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSelecting = null,
    Object? selectionType = freezed,
    Object? firstSelection = freezed,
    Object? secondSelection = freezed,
  }) {
    return _then(
      _value.copyWith(
            isSelecting: null == isSelecting
                ? _value.isSelecting
                : isSelecting // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectionType: freezed == selectionType
                ? _value.selectionType
                : selectionType // ignore: cast_nullable_to_non_nullable
                      as CardSelectionType?,
            firstSelection: freezed == firstSelection
                ? _value.firstSelection
                : firstSelection // ignore: cast_nullable_to_non_nullable
                      as CardPosition?,
            secondSelection: freezed == secondSelection
                ? _value.secondSelection
                : secondSelection // ignore: cast_nullable_to_non_nullable
                      as CardPosition?,
          )
          as $Val,
    );
  }

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardPositionCopyWith<$Res>? get firstSelection {
    if (_value.firstSelection == null) {
      return null;
    }

    return $CardPositionCopyWith<$Res>(_value.firstSelection!, (value) {
      return _then(_value.copyWith(firstSelection: value) as $Val);
    });
  }

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CardPositionCopyWith<$Res>? get secondSelection {
    if (_value.secondSelection == null) {
      return null;
    }

    return $CardPositionCopyWith<$Res>(_value.secondSelection!, (value) {
      return _then(_value.copyWith(secondSelection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CardSelectionStateImplCopyWith<$Res>
    implements $CardSelectionStateCopyWith<$Res> {
  factory _$$CardSelectionStateImplCopyWith(
    _$CardSelectionStateImpl value,
    $Res Function(_$CardSelectionStateImpl) then,
  ) = __$$CardSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isSelecting,
    CardSelectionType? selectionType,
    CardPosition? firstSelection,
    CardPosition? secondSelection,
  });

  @override
  $CardPositionCopyWith<$Res>? get firstSelection;
  @override
  $CardPositionCopyWith<$Res>? get secondSelection;
}

/// @nodoc
class __$$CardSelectionStateImplCopyWithImpl<$Res>
    extends _$CardSelectionStateCopyWithImpl<$Res, _$CardSelectionStateImpl>
    implements _$$CardSelectionStateImplCopyWith<$Res> {
  __$$CardSelectionStateImplCopyWithImpl(
    _$CardSelectionStateImpl _value,
    $Res Function(_$CardSelectionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSelecting = null,
    Object? selectionType = freezed,
    Object? firstSelection = freezed,
    Object? secondSelection = freezed,
  }) {
    return _then(
      _$CardSelectionStateImpl(
        isSelecting: null == isSelecting
            ? _value.isSelecting
            : isSelecting // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectionType: freezed == selectionType
            ? _value.selectionType
            : selectionType // ignore: cast_nullable_to_non_nullable
                  as CardSelectionType?,
        firstSelection: freezed == firstSelection
            ? _value.firstSelection
            : firstSelection // ignore: cast_nullable_to_non_nullable
                  as CardPosition?,
        secondSelection: freezed == secondSelection
            ? _value.secondSelection
            : secondSelection // ignore: cast_nullable_to_non_nullable
                  as CardPosition?,
      ),
    );
  }
}

/// @nodoc

class _$CardSelectionStateImpl extends _CardSelectionState {
  const _$CardSelectionStateImpl({
    this.isSelecting = false,
    this.selectionType,
    this.firstSelection,
    this.secondSelection,
  }) : super._();

  @override
  @JsonKey()
  final bool isSelecting;
  @override
  final CardSelectionType? selectionType;
  @override
  final CardPosition? firstSelection;
  @override
  final CardPosition? secondSelection;

  @override
  String toString() {
    return 'CardSelectionState(isSelecting: $isSelecting, selectionType: $selectionType, firstSelection: $firstSelection, secondSelection: $secondSelection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardSelectionStateImpl &&
            (identical(other.isSelecting, isSelecting) ||
                other.isSelecting == isSelecting) &&
            (identical(other.selectionType, selectionType) ||
                other.selectionType == selectionType) &&
            (identical(other.firstSelection, firstSelection) ||
                other.firstSelection == firstSelection) &&
            (identical(other.secondSelection, secondSelection) ||
                other.secondSelection == secondSelection));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isSelecting,
    selectionType,
    firstSelection,
    secondSelection,
  );

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardSelectionStateImplCopyWith<_$CardSelectionStateImpl> get copyWith =>
      __$$CardSelectionStateImplCopyWithImpl<_$CardSelectionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CardSelectionState extends CardSelectionState {
  const factory _CardSelectionState({
    final bool isSelecting,
    final CardSelectionType? selectionType,
    final CardPosition? firstSelection,
    final CardPosition? secondSelection,
  }) = _$CardSelectionStateImpl;
  const _CardSelectionState._() : super._();

  @override
  bool get isSelecting;
  @override
  CardSelectionType? get selectionType;
  @override
  CardPosition? get firstSelection;
  @override
  CardPosition? get secondSelection;

  /// Create a copy of CardSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardSelectionStateImplCopyWith<_$CardSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
