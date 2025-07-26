// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActionCard {

 String get id; ActionCardType get type; String get name; String get description; ActionTiming get timing; ActionTarget get target; Map<String, dynamic> get parameters;
/// Create a copy of ActionCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionCardCopyWith<ActionCard> get copyWith => _$ActionCardCopyWithImpl<ActionCard>(this as ActionCard, _$identity);

  /// Serializes this ActionCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionCard&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.target, target) || other.target == target)&&const DeepCollectionEquality().equals(other.parameters, parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,timing,target,const DeepCollectionEquality().hash(parameters));

@override
String toString() {
  return 'ActionCard(id: $id, type: $type, name: $name, description: $description, timing: $timing, target: $target, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class $ActionCardCopyWith<$Res>  {
  factory $ActionCardCopyWith(ActionCard value, $Res Function(ActionCard) _then) = _$ActionCardCopyWithImpl;
@useResult
$Res call({
 String id, ActionCardType type, String name, String description, ActionTiming timing, ActionTarget target, Map<String, dynamic> parameters
});




}
/// @nodoc
class _$ActionCardCopyWithImpl<$Res>
    implements $ActionCardCopyWith<$Res> {
  _$ActionCardCopyWithImpl(this._self, this._then);

  final ActionCard _self;
  final $Res Function(ActionCard) _then;

/// Create a copy of ActionCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? timing = null,Object? target = null,Object? parameters = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionCardType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,timing: null == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as ActionTiming,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ActionTarget,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionCard].
extension ActionCardPatterns on ActionCard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionCard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionCard value)  $default,){
final _that = this;
switch (_that) {
case _ActionCard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionCard value)?  $default,){
final _that = this;
switch (_that) {
case _ActionCard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ActionCardType type,  String name,  String description,  ActionTiming timing,  ActionTarget target,  Map<String, dynamic> parameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionCard() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.timing,_that.target,_that.parameters);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ActionCardType type,  String name,  String description,  ActionTiming timing,  ActionTarget target,  Map<String, dynamic> parameters)  $default,) {final _that = this;
switch (_that) {
case _ActionCard():
return $default(_that.id,_that.type,_that.name,_that.description,_that.timing,_that.target,_that.parameters);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ActionCardType type,  String name,  String description,  ActionTiming timing,  ActionTarget target,  Map<String, dynamic> parameters)?  $default,) {final _that = this;
switch (_that) {
case _ActionCard() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.description,_that.timing,_that.target,_that.parameters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionCard extends ActionCard {
  const _ActionCard({required this.id, required this.type, required this.name, required this.description, this.timing = ActionTiming.optional, this.target = ActionTarget.none, final  Map<String, dynamic> parameters = const {}}): _parameters = parameters,super._();
  factory _ActionCard.fromJson(Map<String, dynamic> json) => _$ActionCardFromJson(json);

@override final  String id;
@override final  ActionCardType type;
@override final  String name;
@override final  String description;
@override@JsonKey() final  ActionTiming timing;
@override@JsonKey() final  ActionTarget target;
 final  Map<String, dynamic> _parameters;
@override@JsonKey() Map<String, dynamic> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}


/// Create a copy of ActionCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionCardCopyWith<_ActionCard> get copyWith => __$ActionCardCopyWithImpl<_ActionCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionCard&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.timing, timing) || other.timing == timing)&&(identical(other.target, target) || other.target == target)&&const DeepCollectionEquality().equals(other._parameters, _parameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,description,timing,target,const DeepCollectionEquality().hash(_parameters));

@override
String toString() {
  return 'ActionCard(id: $id, type: $type, name: $name, description: $description, timing: $timing, target: $target, parameters: $parameters)';
}


}

/// @nodoc
abstract mixin class _$ActionCardCopyWith<$Res> implements $ActionCardCopyWith<$Res> {
  factory _$ActionCardCopyWith(_ActionCard value, $Res Function(_ActionCard) _then) = __$ActionCardCopyWithImpl;
@override @useResult
$Res call({
 String id, ActionCardType type, String name, String description, ActionTiming timing, ActionTarget target, Map<String, dynamic> parameters
});




}
/// @nodoc
class __$ActionCardCopyWithImpl<$Res>
    implements _$ActionCardCopyWith<$Res> {
  __$ActionCardCopyWithImpl(this._self, this._then);

  final _ActionCard _self;
  final $Res Function(_ActionCard) _then;

/// Create a copy of ActionCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? description = null,Object? timing = null,Object? target = null,Object? parameters = null,}) {
  return _then(_ActionCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionCardType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,timing: null == timing ? _self.timing : timing // ignore: cast_nullable_to_non_nullable
as ActionTiming,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as ActionTarget,parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
