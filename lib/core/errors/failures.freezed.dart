// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
    _$ServerFailureImpl value,
    $Res Function(_$ServerFailureImpl) then,
  ) = __$$ServerFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? error, StackTrace? stackTrace});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
    _$ServerFailureImpl _value,
    $Res Function(_$ServerFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _$ServerFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error ? _value.error : error,
        stackTrace: freezed == stackTrace
            ? _value.stackTrace
            : stackTrace // ignore: cast_nullable_to_non_nullable
                  as StackTrace?,
      ),
    );
  }
}

/// @nodoc

class _$ServerFailureImpl implements ServerFailure {
  const _$ServerFailureImpl({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  final String message;
  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'Failure.server(message: $message, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
    stackTrace,
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return server(message, error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return server?.call(message, error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(message, error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerFailure implements Failure {
  const factory ServerFailure({
    required final String message,
    final Object? error,
    final StackTrace? stackTrace,
  }) = _$ServerFailureImpl;

  @override
  String get message;
  Object? get error;
  StackTrace? get stackTrace;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? error, StackTrace? stackTrace});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _$NetworkFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error ? _value.error : error,
        stackTrace: freezed == stackTrace
            ? _value.stackTrace
            : stackTrace // ignore: cast_nullable_to_non_nullable
                  as StackTrace?,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  final String message;
  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'Failure.network(message: $message, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
    stackTrace,
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return network(message, error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return network?.call(message, error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({
    required final String message,
    final Object? error,
    final StackTrace? stackTrace,
  }) = _$NetworkFailureImpl;

  @override
  String get message;
  Object? get error;
  StackTrace? get stackTrace;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(
    _$ValidationFailureImpl value,
    $Res Function(_$ValidationFailureImpl) then,
  ) = __$$ValidationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Map<String, String>? errors});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(
    _$ValidationFailureImpl _value,
    $Res Function(_$ValidationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? errors = freezed}) {
    return _then(
      _$ValidationFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        errors: freezed == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
      ),
    );
  }
}

/// @nodoc

class _$ValidationFailureImpl implements ValidationFailure {
  const _$ValidationFailureImpl({
    required this.message,
    final Map<String, String>? errors,
  }) : _errors = errors;

  @override
  final String message;
  final Map<String, String>? _errors;
  @override
  Map<String, String>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Failure.validation(message: $message, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return validation(message, errors);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return validation?.call(message, errors);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message, errors);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure implements Failure {
  const factory ValidationFailure({
    required final String message,
    final Map<String, String>? errors,
  }) = _$ValidationFailureImpl;

  @override
  String get message;
  Map<String, String>? get errors;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameLogicFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$GameLogicFailureImplCopyWith(
    _$GameLogicFailureImpl value,
    $Res Function(_$GameLogicFailureImpl) then,
  ) = __$$GameLogicFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$GameLogicFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$GameLogicFailureImpl>
    implements _$$GameLogicFailureImplCopyWith<$Res> {
  __$$GameLogicFailureImplCopyWithImpl(
    _$GameLogicFailureImpl _value,
    $Res Function(_$GameLogicFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$GameLogicFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$GameLogicFailureImpl implements GameLogicFailure {
  const _$GameLogicFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'Failure.gameLogic(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameLogicFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameLogicFailureImplCopyWith<_$GameLogicFailureImpl> get copyWith =>
      __$$GameLogicFailureImplCopyWithImpl<_$GameLogicFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return gameLogic(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return gameLogic?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (gameLogic != null) {
      return gameLogic(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return gameLogic(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return gameLogic?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (gameLogic != null) {
      return gameLogic(this);
    }
    return orElse();
  }
}

abstract class GameLogicFailure implements Failure {
  const factory GameLogicFailure({
    required final String message,
    final String? code,
  }) = _$GameLogicFailureImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameLogicFailureImplCopyWith<_$GameLogicFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthenticationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AuthenticationFailureImplCopyWith(
    _$AuthenticationFailureImpl value,
    $Res Function(_$AuthenticationFailureImpl) then,
  ) = __$$AuthenticationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$AuthenticationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AuthenticationFailureImpl>
    implements _$$AuthenticationFailureImplCopyWith<$Res> {
  __$$AuthenticationFailureImplCopyWithImpl(
    _$AuthenticationFailureImpl _value,
    $Res Function(_$AuthenticationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$AuthenticationFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AuthenticationFailureImpl implements AuthenticationFailure {
  const _$AuthenticationFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'Failure.authentication(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationFailureImplCopyWith<_$AuthenticationFailureImpl>
  get copyWith =>
      __$$AuthenticationFailureImplCopyWithImpl<_$AuthenticationFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return authentication(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return authentication?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (authentication != null) {
      return authentication(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return authentication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return authentication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (authentication != null) {
      return authentication(this);
    }
    return orElse();
  }
}

abstract class AuthenticationFailure implements Failure {
  const factory AuthenticationFailure({
    required final String message,
    final String? code,
  }) = _$AuthenticationFailureImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthenticationFailureImplCopyWith<_$AuthenticationFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimeoutFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$TimeoutFailureImplCopyWith(
    _$TimeoutFailureImpl value,
    $Res Function(_$TimeoutFailureImpl) then,
  ) = __$$TimeoutFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Duration? duration});
}

/// @nodoc
class __$$TimeoutFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$TimeoutFailureImpl>
    implements _$$TimeoutFailureImplCopyWith<$Res> {
  __$$TimeoutFailureImplCopyWithImpl(
    _$TimeoutFailureImpl _value,
    $Res Function(_$TimeoutFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? duration = freezed}) {
    return _then(
      _$TimeoutFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
      ),
    );
  }
}

/// @nodoc

class _$TimeoutFailureImpl implements TimeoutFailure {
  const _$TimeoutFailureImpl({required this.message, this.duration});

  @override
  final String message;
  @override
  final Duration? duration;

  @override
  String toString() {
    return 'Failure.timeout(message: $message, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeoutFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, duration);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeoutFailureImplCopyWith<_$TimeoutFailureImpl> get copyWith =>
      __$$TimeoutFailureImplCopyWithImpl<_$TimeoutFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return timeout(message, duration);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return timeout?.call(message, duration);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(message, duration);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return timeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return timeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(this);
    }
    return orElse();
  }
}

abstract class TimeoutFailure implements Failure {
  const factory TimeoutFailure({
    required final String message,
    final Duration? duration,
  }) = _$TimeoutFailureImpl;

  @override
  String get message;
  Duration? get duration;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeoutFailureImplCopyWith<_$TimeoutFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(
    _$UnknownFailureImpl value,
    $Res Function(_$UnknownFailureImpl) then,
  ) = __$$UnknownFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? error, StackTrace? stackTrace});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
    _$UnknownFailureImpl _value,
    $Res Function(_$UnknownFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(
      _$UnknownFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error ? _value.error : error,
        stackTrace: freezed == stackTrace
            ? _value.stackTrace
            : stackTrace // ignore: cast_nullable_to_non_nullable
                  as StackTrace?,
      ),
    );
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl({
    required this.message,
    this.error,
    this.stackTrace,
  });

  @override
  final String message;
  @override
  final Object? error;
  @override
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'Failure.unknown(message: $message, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
    stackTrace,
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    server,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    network,
    required TResult Function(String message, Map<String, String>? errors)
    validation,
    required TResult Function(String message, String? code) gameLogic,
    required TResult Function(String message, String? code) authentication,
    required TResult Function(String message, Duration? duration) timeout,
    required TResult Function(
      String message,
      Object? error,
      StackTrace? stackTrace,
    )
    unknown,
  }) {
    return unknown(message, error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult? Function(String message, Map<String, String>? errors)? validation,
    TResult? Function(String message, String? code)? gameLogic,
    TResult? Function(String message, String? code)? authentication,
    TResult? Function(String message, Duration? duration)? timeout,
    TResult? Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
  }) {
    return unknown?.call(message, error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    server,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    network,
    TResult Function(String message, Map<String, String>? errors)? validation,
    TResult Function(String message, String? code)? gameLogic,
    TResult Function(String message, String? code)? authentication,
    TResult Function(String message, Duration? duration)? timeout,
    TResult Function(String message, Object? error, StackTrace? stackTrace)?
    unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) server,
    required TResult Function(NetworkFailure value) network,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(GameLogicFailure value) gameLogic,
    required TResult Function(AuthenticationFailure value) authentication,
    required TResult Function(TimeoutFailure value) timeout,
    required TResult Function(UnknownFailure value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? server,
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(GameLogicFailure value)? gameLogic,
    TResult? Function(AuthenticationFailure value)? authentication,
    TResult? Function(TimeoutFailure value)? timeout,
    TResult? Function(UnknownFailure value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? server,
    TResult Function(NetworkFailure value)? network,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(GameLogicFailure value)? gameLogic,
    TResult Function(AuthenticationFailure value)? authentication,
    TResult Function(TimeoutFailure value)? timeout,
    TResult Function(UnknownFailure value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure({
    required final String message,
    final Object? error,
    final StackTrace? stackTrace,
  }) = _$UnknownFailureImpl;

  @override
  String get message;
  Object? get error;
  StackTrace? get stackTrace;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
