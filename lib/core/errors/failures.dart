import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@Freezed()
abstract class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = NetworkFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;

  const factory Failure.gameLogic({required String message, String? code}) =
      GameLogicFailure;

  const factory Failure.authentication({
    required String message,
    String? code,
  }) = AuthenticationFailure;

  const factory Failure.timeout({required String message, Duration? duration}) =
      TimeoutFailure;

  const factory Failure.unknown({
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownFailure;
}
