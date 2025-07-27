// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_errors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NetworkError {

 String get code; String get message; String? get details; String get operation; DateTime get timestamp; int? get statusCode; Duration? get timeout;
/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkErrorCopyWith<NetworkError> get copyWith => _$NetworkErrorCopyWithImpl<NetworkError>(this as NetworkError, _$identity);

  /// Serializes this NetworkError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,statusCode,timeout);

@override
String toString() {
  return 'NetworkError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, statusCode: $statusCode, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res>  {
  factory $NetworkErrorCopyWith(NetworkError value, $Res Function(NetworkError) _then) = _$NetworkErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, int? statusCode, Duration? timeout
});




}
/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res>
    implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? statusCode = freezed,Object? timeout = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,timeout: freezed == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkError].
extension NetworkErrorPatterns on NetworkError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkError value)  $default,){
final _that = this;
switch (_that) {
case _NetworkError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkError value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  int? statusCode,  Duration? timeout)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.statusCode,_that.timeout);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  int? statusCode,  Duration? timeout)  $default,) {final _that = this;
switch (_that) {
case _NetworkError():
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.statusCode,_that.timeout);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  int? statusCode,  Duration? timeout)?  $default,) {final _that = this;
switch (_that) {
case _NetworkError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.statusCode,_that.timeout);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkError extends NetworkError {
  const _NetworkError({required this.code, required this.message, this.details, required this.operation, required this.timestamp, this.statusCode, this.timeout}): super._();
  factory _NetworkError.fromJson(Map<String, dynamic> json) => _$NetworkErrorFromJson(json);

@override final  String code;
@override final  String message;
@override final  String? details;
@override final  String operation;
@override final  DateTime timestamp;
@override final  int? statusCode;
@override final  Duration? timeout;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkErrorCopyWith<_NetworkError> get copyWith => __$NetworkErrorCopyWithImpl<_NetworkError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode)&&(identical(other.timeout, timeout) || other.timeout == timeout));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,statusCode,timeout);

@override
String toString() {
  return 'NetworkError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, statusCode: $statusCode, timeout: $timeout)';
}


}

/// @nodoc
abstract mixin class _$NetworkErrorCopyWith<$Res> implements $NetworkErrorCopyWith<$Res> {
  factory _$NetworkErrorCopyWith(_NetworkError value, $Res Function(_NetworkError) _then) = __$NetworkErrorCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, int? statusCode, Duration? timeout
});




}
/// @nodoc
class __$NetworkErrorCopyWithImpl<$Res>
    implements _$NetworkErrorCopyWith<$Res> {
  __$NetworkErrorCopyWithImpl(this._self, this._then);

  final _NetworkError _self;
  final $Res Function(_NetworkError) _then;

/// Create a copy of NetworkError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? statusCode = freezed,Object? timeout = freezed,}) {
  return _then(_NetworkError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,timeout: freezed == timeout ? _self.timeout : timeout // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}


/// @nodoc
mixin _$AuthError {

 String get code; String get message; String? get details; String get operation; DateTime get timestamp; String? get userId;
/// Create a copy of AuthError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this as AuthError, _$identity);

  /// Serializes this AuthError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,userId);

@override
String toString() {
  return 'AuthError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $AuthErrorCopyWith<$Res>  {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, String? userId
});




}
/// @nodoc
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;

/// Create a copy of AuthError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? userId = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthError].
extension AuthErrorPatterns on AuthError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthError value)  $default,){
final _that = this;
switch (_that) {
case _AuthError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthError value)?  $default,){
final _that = this;
switch (_that) {
case _AuthError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? userId)  $default,) {final _that = this;
switch (_that) {
case _AuthError():
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _AuthError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthError extends AuthError {
  const _AuthError({required this.code, required this.message, this.details, required this.operation, required this.timestamp, this.userId}): super._();
  factory _AuthError.fromJson(Map<String, dynamic> json) => _$AuthErrorFromJson(json);

@override final  String code;
@override final  String message;
@override final  String? details;
@override final  String operation;
@override final  DateTime timestamp;
@override final  String? userId;

/// Create a copy of AuthError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthErrorCopyWith<_AuthError> get copyWith => __$AuthErrorCopyWithImpl<_AuthError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,userId);

@override
String toString() {
  return 'AuthError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$AuthErrorCopyWith<$Res> implements $AuthErrorCopyWith<$Res> {
  factory _$AuthErrorCopyWith(_AuthError value, $Res Function(_AuthError) _then) = __$AuthErrorCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, String? userId
});




}
/// @nodoc
class __$AuthErrorCopyWithImpl<$Res>
    implements _$AuthErrorCopyWith<$Res> {
  __$AuthErrorCopyWithImpl(this._self, this._then);

  final _AuthError _self;
  final $Res Function(_AuthError) _then;

/// Create a copy of AuthError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? userId = freezed,}) {
  return _then(_AuthError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DatabaseError {

 String get code; String get message; String? get details; String get operation; DateTime get timestamp; String? get table; String? get constraint; Map<String, dynamic>? get queryParams;
/// Create a copy of DatabaseError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatabaseErrorCopyWith<DatabaseError> get copyWith => _$DatabaseErrorCopyWithImpl<DatabaseError>(this as DatabaseError, _$identity);

  /// Serializes this DatabaseError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DatabaseError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.table, table) || other.table == table)&&(identical(other.constraint, constraint) || other.constraint == constraint)&&const DeepCollectionEquality().equals(other.queryParams, queryParams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,table,constraint,const DeepCollectionEquality().hash(queryParams));

@override
String toString() {
  return 'DatabaseError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, table: $table, constraint: $constraint, queryParams: $queryParams)';
}


}

/// @nodoc
abstract mixin class $DatabaseErrorCopyWith<$Res>  {
  factory $DatabaseErrorCopyWith(DatabaseError value, $Res Function(DatabaseError) _then) = _$DatabaseErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, String? table, String? constraint, Map<String, dynamic>? queryParams
});




}
/// @nodoc
class _$DatabaseErrorCopyWithImpl<$Res>
    implements $DatabaseErrorCopyWith<$Res> {
  _$DatabaseErrorCopyWithImpl(this._self, this._then);

  final DatabaseError _self;
  final $Res Function(DatabaseError) _then;

/// Create a copy of DatabaseError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? table = freezed,Object? constraint = freezed,Object? queryParams = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,table: freezed == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as String?,constraint: freezed == constraint ? _self.constraint : constraint // ignore: cast_nullable_to_non_nullable
as String?,queryParams: freezed == queryParams ? _self.queryParams : queryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DatabaseError].
extension DatabaseErrorPatterns on DatabaseError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DatabaseError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DatabaseError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DatabaseError value)  $default,){
final _that = this;
switch (_that) {
case _DatabaseError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DatabaseError value)?  $default,){
final _that = this;
switch (_that) {
case _DatabaseError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? table,  String? constraint,  Map<String, dynamic>? queryParams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DatabaseError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.table,_that.constraint,_that.queryParams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? table,  String? constraint,  Map<String, dynamic>? queryParams)  $default,) {final _that = this;
switch (_that) {
case _DatabaseError():
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.table,_that.constraint,_that.queryParams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? table,  String? constraint,  Map<String, dynamic>? queryParams)?  $default,) {final _that = this;
switch (_that) {
case _DatabaseError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.table,_that.constraint,_that.queryParams);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DatabaseError extends DatabaseError {
  const _DatabaseError({required this.code, required this.message, this.details, required this.operation, required this.timestamp, this.table, this.constraint, final  Map<String, dynamic>? queryParams}): _queryParams = queryParams,super._();
  factory _DatabaseError.fromJson(Map<String, dynamic> json) => _$DatabaseErrorFromJson(json);

@override final  String code;
@override final  String message;
@override final  String? details;
@override final  String operation;
@override final  DateTime timestamp;
@override final  String? table;
@override final  String? constraint;
 final  Map<String, dynamic>? _queryParams;
@override Map<String, dynamic>? get queryParams {
  final value = _queryParams;
  if (value == null) return null;
  if (_queryParams is EqualUnmodifiableMapView) return _queryParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of DatabaseError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatabaseErrorCopyWith<_DatabaseError> get copyWith => __$DatabaseErrorCopyWithImpl<_DatabaseError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatabaseErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DatabaseError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.table, table) || other.table == table)&&(identical(other.constraint, constraint) || other.constraint == constraint)&&const DeepCollectionEquality().equals(other._queryParams, _queryParams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,table,constraint,const DeepCollectionEquality().hash(_queryParams));

@override
String toString() {
  return 'DatabaseError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, table: $table, constraint: $constraint, queryParams: $queryParams)';
}


}

/// @nodoc
abstract mixin class _$DatabaseErrorCopyWith<$Res> implements $DatabaseErrorCopyWith<$Res> {
  factory _$DatabaseErrorCopyWith(_DatabaseError value, $Res Function(_DatabaseError) _then) = __$DatabaseErrorCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, String? table, String? constraint, Map<String, dynamic>? queryParams
});




}
/// @nodoc
class __$DatabaseErrorCopyWithImpl<$Res>
    implements _$DatabaseErrorCopyWith<$Res> {
  __$DatabaseErrorCopyWithImpl(this._self, this._then);

  final _DatabaseError _self;
  final $Res Function(_DatabaseError) _then;

/// Create a copy of DatabaseError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? table = freezed,Object? constraint = freezed,Object? queryParams = freezed,}) {
  return _then(_DatabaseError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,table: freezed == table ? _self.table : table // ignore: cast_nullable_to_non_nullable
as String?,constraint: freezed == constraint ? _self.constraint : constraint // ignore: cast_nullable_to_non_nullable
as String?,queryParams: freezed == queryParams ? _self._queryParams : queryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$StorageError {

 String get code; String get message; String? get details; String get operation; DateTime get timestamp; String? get bucket; String? get path; int? get sizeLimit;
/// Create a copy of StorageError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageErrorCopyWith<StorageError> get copyWith => _$StorageErrorCopyWithImpl<StorageError>(this as StorageError, _$identity);

  /// Serializes this StorageError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&(identical(other.path, path) || other.path == path)&&(identical(other.sizeLimit, sizeLimit) || other.sizeLimit == sizeLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,bucket,path,sizeLimit);

@override
String toString() {
  return 'StorageError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, bucket: $bucket, path: $path, sizeLimit: $sizeLimit)';
}


}

/// @nodoc
abstract mixin class $StorageErrorCopyWith<$Res>  {
  factory $StorageErrorCopyWith(StorageError value, $Res Function(StorageError) _then) = _$StorageErrorCopyWithImpl;
@useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, String? bucket, String? path, int? sizeLimit
});




}
/// @nodoc
class _$StorageErrorCopyWithImpl<$Res>
    implements $StorageErrorCopyWith<$Res> {
  _$StorageErrorCopyWithImpl(this._self, this._then);

  final StorageError _self;
  final $Res Function(StorageError) _then;

/// Create a copy of StorageError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? bucket = freezed,Object? path = freezed,Object? sizeLimit = freezed,}) {
  return _then(_self.copyWith(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,bucket: freezed == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,sizeLimit: freezed == sizeLimit ? _self.sizeLimit : sizeLimit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [StorageError].
extension StorageErrorPatterns on StorageError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StorageError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StorageError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StorageError value)  $default,){
final _that = this;
switch (_that) {
case _StorageError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StorageError value)?  $default,){
final _that = this;
switch (_that) {
case _StorageError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? bucket,  String? path,  int? sizeLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StorageError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.bucket,_that.path,_that.sizeLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? bucket,  String? path,  int? sizeLimit)  $default,) {final _that = this;
switch (_that) {
case _StorageError():
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.bucket,_that.path,_that.sizeLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String message,  String? details,  String operation,  DateTime timestamp,  String? bucket,  String? path,  int? sizeLimit)?  $default,) {final _that = this;
switch (_that) {
case _StorageError() when $default != null:
return $default(_that.code,_that.message,_that.details,_that.operation,_that.timestamp,_that.bucket,_that.path,_that.sizeLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StorageError extends StorageError {
  const _StorageError({required this.code, required this.message, this.details, required this.operation, required this.timestamp, this.bucket, this.path, this.sizeLimit}): super._();
  factory _StorageError.fromJson(Map<String, dynamic> json) => _$StorageErrorFromJson(json);

@override final  String code;
@override final  String message;
@override final  String? details;
@override final  String operation;
@override final  DateTime timestamp;
@override final  String? bucket;
@override final  String? path;
@override final  int? sizeLimit;

/// Create a copy of StorageError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StorageErrorCopyWith<_StorageError> get copyWith => __$StorageErrorCopyWithImpl<_StorageError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StorageErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StorageError&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.details, details) || other.details == details)&&(identical(other.operation, operation) || other.operation == operation)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.bucket, bucket) || other.bucket == bucket)&&(identical(other.path, path) || other.path == path)&&(identical(other.sizeLimit, sizeLimit) || other.sizeLimit == sizeLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message,details,operation,timestamp,bucket,path,sizeLimit);

@override
String toString() {
  return 'StorageError(code: $code, message: $message, details: $details, operation: $operation, timestamp: $timestamp, bucket: $bucket, path: $path, sizeLimit: $sizeLimit)';
}


}

/// @nodoc
abstract mixin class _$StorageErrorCopyWith<$Res> implements $StorageErrorCopyWith<$Res> {
  factory _$StorageErrorCopyWith(_StorageError value, $Res Function(_StorageError) _then) = __$StorageErrorCopyWithImpl;
@override @useResult
$Res call({
 String code, String message, String? details, String operation, DateTime timestamp, String? bucket, String? path, int? sizeLimit
});




}
/// @nodoc
class __$StorageErrorCopyWithImpl<$Res>
    implements _$StorageErrorCopyWith<$Res> {
  __$StorageErrorCopyWithImpl(this._self, this._then);

  final _StorageError _self;
  final $Res Function(_StorageError) _then;

/// Create a copy of StorageError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? message = null,Object? details = freezed,Object? operation = null,Object? timestamp = null,Object? bucket = freezed,Object? path = freezed,Object? sizeLimit = freezed,}) {
  return _then(_StorageError(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String?,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,bucket: freezed == bucket ? _self.bucket : bucket // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,sizeLimit: freezed == sizeLimit ? _self.sizeLimit : sizeLimit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
