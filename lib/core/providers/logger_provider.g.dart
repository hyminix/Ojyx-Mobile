// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$errorLoggerHash() => r'ec3784cd77ccc2354a02143458f4bcd459bc503a';

/// Provider for the error logger instance
///
/// Copied from [errorLogger].
@ProviderFor(errorLogger)
final errorLoggerProvider = AutoDisposeProvider<IErrorLogger>.internal(
  errorLogger,
  name: r'errorLoggerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$errorLoggerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ErrorLoggerRef = AutoDisposeProviderRef<IErrorLogger>;
String _$loggerConfigHash() => r'f98988e7771077df179bbdf98fa8a6506c7e14f3';

/// Provider for logger configuration
///
/// Copied from [LoggerConfig].
@ProviderFor(LoggerConfig)
final loggerConfigProvider =
    AutoDisposeNotifierProvider<LoggerConfig, LoggerConfigState>.internal(
      LoggerConfig.new,
      name: r'loggerConfigProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loggerConfigHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoggerConfig = AutoDisposeNotifier<LoggerConfigState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
