// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ActionCard _$ActionCardFromJson(Map<String, dynamic> json) {
  return _ActionCard.fromJson(json);
}

/// @nodoc
mixin _$ActionCard {
  String get id => throw _privateConstructorUsedError;
  ActionCardType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ActionTiming get timing => throw _privateConstructorUsedError;
  ActionTarget get target => throw _privateConstructorUsedError;
  Map<String, dynamic> get parameters => throw _privateConstructorUsedError;

  /// Serializes this ActionCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActionCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActionCardCopyWith<ActionCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionCardCopyWith<$Res> {
  factory $ActionCardCopyWith(
    ActionCard value,
    $Res Function(ActionCard) then,
  ) = _$ActionCardCopyWithImpl<$Res, ActionCard>;
  @useResult
  $Res call({
    String id,
    ActionCardType type,
    String name,
    String description,
    ActionTiming timing,
    ActionTarget target,
    Map<String, dynamic> parameters,
  });
}

/// @nodoc
class _$ActionCardCopyWithImpl<$Res, $Val extends ActionCard>
    implements $ActionCardCopyWith<$Res> {
  _$ActionCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActionCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? timing = null,
    Object? target = null,
    Object? parameters = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ActionCardType,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            timing: null == timing
                ? _value.timing
                : timing // ignore: cast_nullable_to_non_nullable
                      as ActionTiming,
            target: null == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                      as ActionTarget,
            parameters: null == parameters
                ? _value.parameters
                : parameters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActionCardImplCopyWith<$Res>
    implements $ActionCardCopyWith<$Res> {
  factory _$$ActionCardImplCopyWith(
    _$ActionCardImpl value,
    $Res Function(_$ActionCardImpl) then,
  ) = __$$ActionCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ActionCardType type,
    String name,
    String description,
    ActionTiming timing,
    ActionTarget target,
    Map<String, dynamic> parameters,
  });
}

/// @nodoc
class __$$ActionCardImplCopyWithImpl<$Res>
    extends _$ActionCardCopyWithImpl<$Res, _$ActionCardImpl>
    implements _$$ActionCardImplCopyWith<$Res> {
  __$$ActionCardImplCopyWithImpl(
    _$ActionCardImpl _value,
    $Res Function(_$ActionCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActionCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? timing = null,
    Object? target = null,
    Object? parameters = null,
  }) {
    return _then(
      _$ActionCardImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ActionCardType,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        timing: null == timing
            ? _value.timing
            : timing // ignore: cast_nullable_to_non_nullable
                  as ActionTiming,
        target: null == target
            ? _value.target
            : target // ignore: cast_nullable_to_non_nullable
                  as ActionTarget,
        parameters: null == parameters
            ? _value._parameters
            : parameters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionCardImpl extends _ActionCard {
  const _$ActionCardImpl({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    this.timing = ActionTiming.optional,
    this.target = ActionTarget.none,
    final Map<String, dynamic> parameters = const {},
  }) : _parameters = parameters,
       super._();

  factory _$ActionCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionCardImplFromJson(json);

  @override
  final String id;
  @override
  final ActionCardType type;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey()
  final ActionTiming timing;
  @override
  @JsonKey()
  final ActionTarget target;
  final Map<String, dynamic> _parameters;
  @override
  @JsonKey()
  Map<String, dynamic> get parameters {
    if (_parameters is EqualUnmodifiableMapView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_parameters);
  }

  @override
  String toString() {
    return 'ActionCard(id: $id, type: $type, name: $name, description: $description, timing: $timing, target: $target, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timing, timing) || other.timing == timing) &&
            (identical(other.target, target) || other.target == target) &&
            const DeepCollectionEquality().equals(
              other._parameters,
              _parameters,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    name,
    description,
    timing,
    target,
    const DeepCollectionEquality().hash(_parameters),
  );

  /// Create a copy of ActionCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionCardImplCopyWith<_$ActionCardImpl> get copyWith =>
      __$$ActionCardImplCopyWithImpl<_$ActionCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionCardImplToJson(this);
  }
}

abstract class _ActionCard extends ActionCard {
  const factory _ActionCard({
    required final String id,
    required final ActionCardType type,
    required final String name,
    required final String description,
    final ActionTiming timing,
    final ActionTarget target,
    final Map<String, dynamic> parameters,
  }) = _$ActionCardImpl;
  const _ActionCard._() : super._();

  factory _ActionCard.fromJson(Map<String, dynamic> json) =
      _$ActionCardImpl.fromJson;

  @override
  String get id;
  @override
  ActionCardType get type;
  @override
  String get name;
  @override
  String get description;
  @override
  ActionTiming get timing;
  @override
  ActionTarget get target;
  @override
  Map<String, dynamic> get parameters;

  /// Create a copy of ActionCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActionCardImplCopyWith<_$ActionCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
