// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'card_selection_provider_v2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CardSelectionState {

 bool get isSelecting; CardSelectionType? get selectionType; CardPosition? get firstSelection; CardPosition? get secondSelection; List<CardPosition> get selections;// For multi-select modes
 int get maxSelections;// Max number of selections allowed
 String? get selectedOpponentId;// For opponent selection
 bool get requiresOpponent;
/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CardSelectionStateCopyWith<CardSelectionState> get copyWith => _$CardSelectionStateCopyWithImpl<CardSelectionState>(this as CardSelectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CardSelectionState&&(identical(other.isSelecting, isSelecting) || other.isSelecting == isSelecting)&&(identical(other.selectionType, selectionType) || other.selectionType == selectionType)&&(identical(other.firstSelection, firstSelection) || other.firstSelection == firstSelection)&&(identical(other.secondSelection, secondSelection) || other.secondSelection == secondSelection)&&const DeepCollectionEquality().equals(other.selections, selections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.selectedOpponentId, selectedOpponentId) || other.selectedOpponentId == selectedOpponentId)&&(identical(other.requiresOpponent, requiresOpponent) || other.requiresOpponent == requiresOpponent));
}


@override
int get hashCode => Object.hash(runtimeType,isSelecting,selectionType,firstSelection,secondSelection,const DeepCollectionEquality().hash(selections),maxSelections,selectedOpponentId,requiresOpponent);

@override
String toString() {
  return 'CardSelectionState(isSelecting: $isSelecting, selectionType: $selectionType, firstSelection: $firstSelection, secondSelection: $secondSelection, selections: $selections, maxSelections: $maxSelections, selectedOpponentId: $selectedOpponentId, requiresOpponent: $requiresOpponent)';
}


}

/// @nodoc
abstract mixin class $CardSelectionStateCopyWith<$Res>  {
  factory $CardSelectionStateCopyWith(CardSelectionState value, $Res Function(CardSelectionState) _then) = _$CardSelectionStateCopyWithImpl;
@useResult
$Res call({
 bool isSelecting, CardSelectionType? selectionType, CardPosition? firstSelection, CardPosition? secondSelection, List<CardPosition> selections, int maxSelections, String? selectedOpponentId, bool requiresOpponent
});


$CardPositionCopyWith<$Res>? get firstSelection;$CardPositionCopyWith<$Res>? get secondSelection;

}
/// @nodoc
class _$CardSelectionStateCopyWithImpl<$Res>
    implements $CardSelectionStateCopyWith<$Res> {
  _$CardSelectionStateCopyWithImpl(this._self, this._then);

  final CardSelectionState _self;
  final $Res Function(CardSelectionState) _then;

/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSelecting = null,Object? selectionType = freezed,Object? firstSelection = freezed,Object? secondSelection = freezed,Object? selections = null,Object? maxSelections = null,Object? selectedOpponentId = freezed,Object? requiresOpponent = null,}) {
  return _then(_self.copyWith(
isSelecting: null == isSelecting ? _self.isSelecting : isSelecting // ignore: cast_nullable_to_non_nullable
as bool,selectionType: freezed == selectionType ? _self.selectionType : selectionType // ignore: cast_nullable_to_non_nullable
as CardSelectionType?,firstSelection: freezed == firstSelection ? _self.firstSelection : firstSelection // ignore: cast_nullable_to_non_nullable
as CardPosition?,secondSelection: freezed == secondSelection ? _self.secondSelection : secondSelection // ignore: cast_nullable_to_non_nullable
as CardPosition?,selections: null == selections ? _self.selections : selections // ignore: cast_nullable_to_non_nullable
as List<CardPosition>,maxSelections: null == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int,selectedOpponentId: freezed == selectedOpponentId ? _self.selectedOpponentId : selectedOpponentId // ignore: cast_nullable_to_non_nullable
as String?,requiresOpponent: null == requiresOpponent ? _self.requiresOpponent : requiresOpponent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardPositionCopyWith<$Res>? get firstSelection {
    if (_self.firstSelection == null) {
    return null;
  }

  return $CardPositionCopyWith<$Res>(_self.firstSelection!, (value) {
    return _then(_self.copyWith(firstSelection: value));
  });
}/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardPositionCopyWith<$Res>? get secondSelection {
    if (_self.secondSelection == null) {
    return null;
  }

  return $CardPositionCopyWith<$Res>(_self.secondSelection!, (value) {
    return _then(_self.copyWith(secondSelection: value));
  });
}
}


/// Adds pattern-matching-related methods to [CardSelectionState].
extension CardSelectionStatePatterns on CardSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CardSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CardSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CardSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _CardSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CardSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _CardSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSelecting,  CardSelectionType? selectionType,  CardPosition? firstSelection,  CardPosition? secondSelection,  List<CardPosition> selections,  int maxSelections,  String? selectedOpponentId,  bool requiresOpponent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CardSelectionState() when $default != null:
return $default(_that.isSelecting,_that.selectionType,_that.firstSelection,_that.secondSelection,_that.selections,_that.maxSelections,_that.selectedOpponentId,_that.requiresOpponent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSelecting,  CardSelectionType? selectionType,  CardPosition? firstSelection,  CardPosition? secondSelection,  List<CardPosition> selections,  int maxSelections,  String? selectedOpponentId,  bool requiresOpponent)  $default,) {final _that = this;
switch (_that) {
case _CardSelectionState():
return $default(_that.isSelecting,_that.selectionType,_that.firstSelection,_that.secondSelection,_that.selections,_that.maxSelections,_that.selectedOpponentId,_that.requiresOpponent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSelecting,  CardSelectionType? selectionType,  CardPosition? firstSelection,  CardPosition? secondSelection,  List<CardPosition> selections,  int maxSelections,  String? selectedOpponentId,  bool requiresOpponent)?  $default,) {final _that = this;
switch (_that) {
case _CardSelectionState() when $default != null:
return $default(_that.isSelecting,_that.selectionType,_that.firstSelection,_that.secondSelection,_that.selections,_that.maxSelections,_that.selectedOpponentId,_that.requiresOpponent);case _:
  return null;

}
}

}

/// @nodoc


class _CardSelectionState extends CardSelectionState {
  const _CardSelectionState({this.isSelecting = false, this.selectionType, this.firstSelection, this.secondSelection, final  List<CardPosition> selections = const [], this.maxSelections = 1, this.selectedOpponentId, this.requiresOpponent = false}): _selections = selections,super._();
  

@override@JsonKey() final  bool isSelecting;
@override final  CardSelectionType? selectionType;
@override final  CardPosition? firstSelection;
@override final  CardPosition? secondSelection;
 final  List<CardPosition> _selections;
@override@JsonKey() List<CardPosition> get selections {
  if (_selections is EqualUnmodifiableListView) return _selections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selections);
}

// For multi-select modes
@override@JsonKey() final  int maxSelections;
// Max number of selections allowed
@override final  String? selectedOpponentId;
// For opponent selection
@override@JsonKey() final  bool requiresOpponent;

/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CardSelectionStateCopyWith<_CardSelectionState> get copyWith => __$CardSelectionStateCopyWithImpl<_CardSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CardSelectionState&&(identical(other.isSelecting, isSelecting) || other.isSelecting == isSelecting)&&(identical(other.selectionType, selectionType) || other.selectionType == selectionType)&&(identical(other.firstSelection, firstSelection) || other.firstSelection == firstSelection)&&(identical(other.secondSelection, secondSelection) || other.secondSelection == secondSelection)&&const DeepCollectionEquality().equals(other._selections, _selections)&&(identical(other.maxSelections, maxSelections) || other.maxSelections == maxSelections)&&(identical(other.selectedOpponentId, selectedOpponentId) || other.selectedOpponentId == selectedOpponentId)&&(identical(other.requiresOpponent, requiresOpponent) || other.requiresOpponent == requiresOpponent));
}


@override
int get hashCode => Object.hash(runtimeType,isSelecting,selectionType,firstSelection,secondSelection,const DeepCollectionEquality().hash(_selections),maxSelections,selectedOpponentId,requiresOpponent);

@override
String toString() {
  return 'CardSelectionState(isSelecting: $isSelecting, selectionType: $selectionType, firstSelection: $firstSelection, secondSelection: $secondSelection, selections: $selections, maxSelections: $maxSelections, selectedOpponentId: $selectedOpponentId, requiresOpponent: $requiresOpponent)';
}


}

/// @nodoc
abstract mixin class _$CardSelectionStateCopyWith<$Res> implements $CardSelectionStateCopyWith<$Res> {
  factory _$CardSelectionStateCopyWith(_CardSelectionState value, $Res Function(_CardSelectionState) _then) = __$CardSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSelecting, CardSelectionType? selectionType, CardPosition? firstSelection, CardPosition? secondSelection, List<CardPosition> selections, int maxSelections, String? selectedOpponentId, bool requiresOpponent
});


@override $CardPositionCopyWith<$Res>? get firstSelection;@override $CardPositionCopyWith<$Res>? get secondSelection;

}
/// @nodoc
class __$CardSelectionStateCopyWithImpl<$Res>
    implements _$CardSelectionStateCopyWith<$Res> {
  __$CardSelectionStateCopyWithImpl(this._self, this._then);

  final _CardSelectionState _self;
  final $Res Function(_CardSelectionState) _then;

/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSelecting = null,Object? selectionType = freezed,Object? firstSelection = freezed,Object? secondSelection = freezed,Object? selections = null,Object? maxSelections = null,Object? selectedOpponentId = freezed,Object? requiresOpponent = null,}) {
  return _then(_CardSelectionState(
isSelecting: null == isSelecting ? _self.isSelecting : isSelecting // ignore: cast_nullable_to_non_nullable
as bool,selectionType: freezed == selectionType ? _self.selectionType : selectionType // ignore: cast_nullable_to_non_nullable
as CardSelectionType?,firstSelection: freezed == firstSelection ? _self.firstSelection : firstSelection // ignore: cast_nullable_to_non_nullable
as CardPosition?,secondSelection: freezed == secondSelection ? _self.secondSelection : secondSelection // ignore: cast_nullable_to_non_nullable
as CardPosition?,selections: null == selections ? _self._selections : selections // ignore: cast_nullable_to_non_nullable
as List<CardPosition>,maxSelections: null == maxSelections ? _self.maxSelections : maxSelections // ignore: cast_nullable_to_non_nullable
as int,selectedOpponentId: freezed == selectedOpponentId ? _self.selectedOpponentId : selectedOpponentId // ignore: cast_nullable_to_non_nullable
as String?,requiresOpponent: null == requiresOpponent ? _self.requiresOpponent : requiresOpponent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardPositionCopyWith<$Res>? get firstSelection {
    if (_self.firstSelection == null) {
    return null;
  }

  return $CardPositionCopyWith<$Res>(_self.firstSelection!, (value) {
    return _then(_self.copyWith(firstSelection: value));
  });
}/// Create a copy of CardSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CardPositionCopyWith<$Res>? get secondSelection {
    if (_self.secondSelection == null) {
    return null;
  }

  return $CardPositionCopyWith<$Res>(_self.secondSelection!, (value) {
    return _then(_self.copyWith(secondSelection: value));
  });
}
}

// dart format on
