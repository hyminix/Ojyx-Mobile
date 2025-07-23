// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deck_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeckState _$DeckStateFromJson(Map<String, dynamic> json) {
  return _DeckState.fromJson(json);
}

/// @nodoc
mixin _$DeckState {
  List<Card> get drawPile => throw _privateConstructorUsedError;
  List<Card> get discardPile => throw _privateConstructorUsedError;

  /// Serializes this DeckState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeckState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeckStateCopyWith<DeckState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeckStateCopyWith<$Res> {
  factory $DeckStateCopyWith(DeckState value, $Res Function(DeckState) then) =
      _$DeckStateCopyWithImpl<$Res, DeckState>;
  @useResult
  $Res call({List<Card> drawPile, List<Card> discardPile});
}

/// @nodoc
class _$DeckStateCopyWithImpl<$Res, $Val extends DeckState>
    implements $DeckStateCopyWith<$Res> {
  _$DeckStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeckState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? drawPile = null, Object? discardPile = null}) {
    return _then(
      _value.copyWith(
            drawPile: null == drawPile
                ? _value.drawPile
                : drawPile // ignore: cast_nullable_to_non_nullable
                      as List<Card>,
            discardPile: null == discardPile
                ? _value.discardPile
                : discardPile // ignore: cast_nullable_to_non_nullable
                      as List<Card>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeckStateImplCopyWith<$Res>
    implements $DeckStateCopyWith<$Res> {
  factory _$$DeckStateImplCopyWith(
    _$DeckStateImpl value,
    $Res Function(_$DeckStateImpl) then,
  ) = __$$DeckStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Card> drawPile, List<Card> discardPile});
}

/// @nodoc
class __$$DeckStateImplCopyWithImpl<$Res>
    extends _$DeckStateCopyWithImpl<$Res, _$DeckStateImpl>
    implements _$$DeckStateImplCopyWith<$Res> {
  __$$DeckStateImplCopyWithImpl(
    _$DeckStateImpl _value,
    $Res Function(_$DeckStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeckState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? drawPile = null, Object? discardPile = null}) {
    return _then(
      _$DeckStateImpl(
        drawPile: null == drawPile
            ? _value._drawPile
            : drawPile // ignore: cast_nullable_to_non_nullable
                  as List<Card>,
        discardPile: null == discardPile
            ? _value._discardPile
            : discardPile // ignore: cast_nullable_to_non_nullable
                  as List<Card>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeckStateImpl extends _DeckState {
  const _$DeckStateImpl({
    required final List<Card> drawPile,
    required final List<Card> discardPile,
  }) : _drawPile = drawPile,
       _discardPile = discardPile,
       super._();

  factory _$DeckStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeckStateImplFromJson(json);

  final List<Card> _drawPile;
  @override
  List<Card> get drawPile {
    if (_drawPile is EqualUnmodifiableListView) return _drawPile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drawPile);
  }

  final List<Card> _discardPile;
  @override
  List<Card> get discardPile {
    if (_discardPile is EqualUnmodifiableListView) return _discardPile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_discardPile);
  }

  @override
  String toString() {
    return 'DeckState(drawPile: $drawPile, discardPile: $discardPile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeckStateImpl &&
            const DeepCollectionEquality().equals(other._drawPile, _drawPile) &&
            const DeepCollectionEquality().equals(
              other._discardPile,
              _discardPile,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_drawPile),
    const DeepCollectionEquality().hash(_discardPile),
  );

  /// Create a copy of DeckState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeckStateImplCopyWith<_$DeckStateImpl> get copyWith =>
      __$$DeckStateImplCopyWithImpl<_$DeckStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeckStateImplToJson(this);
  }
}

abstract class _DeckState extends DeckState {
  const factory _DeckState({
    required final List<Card> drawPile,
    required final List<Card> discardPile,
  }) = _$DeckStateImpl;
  const _DeckState._() : super._();

  factory _DeckState.fromJson(Map<String, dynamic> json) =
      _$DeckStateImpl.fromJson;

  @override
  List<Card> get drawPile;
  @override
  List<Card> get discardPile;

  /// Create a copy of DeckState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeckStateImplCopyWith<_$DeckStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
