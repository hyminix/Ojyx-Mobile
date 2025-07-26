// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentry_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$performanceMonitorHash() =>
    r'ebd0901bcdc60e077de5251079b20adf266ff8d6';

/// Provider for performance monitoring mixin
///
/// Copied from [performanceMonitor].
@ProviderFor(performanceMonitor)
final performanceMonitorProvider =
    AutoDisposeProvider<PerformanceMonitor>.internal(
      performanceMonitor,
      name: r'performanceMonitorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$performanceMonitorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PerformanceMonitorRef = AutoDisposeProviderRef<PerformanceMonitor>;
String _$sentryServiceProviderHash() =>
    r'a4f45b529d155d79d33cff202403d6764173f653';

/// Provider for accessing Sentry service functionality
///
/// Copied from [SentryServiceProvider].
@ProviderFor(SentryServiceProvider)
final sentryServiceProviderProvider =
    NotifierProvider<SentryServiceProvider, SentryService>.internal(
      SentryServiceProvider.new,
      name: r'sentryServiceProviderProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sentryServiceProviderHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SentryServiceProvider = Notifier<SentryService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
