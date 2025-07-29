// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_monitor_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$connectionStatusHash() => r'8edc886c684783312b1f903ddf58621d64580884';

/// Provider pour accéder facilement au statut de connexion
///
/// Copied from [connectionStatus].
@ProviderFor(connectionStatus)
final connectionStatusProvider = AutoDisposeProvider<ConnectionStatus>.internal(
  connectionStatus,
  name: r'connectionStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectionStatusRef = AutoDisposeProviderRef<ConnectionStatus>;
String _$isConnectionStableHash() =>
    r'1540fd0dcf1bbdf869073e86fb75aec7d94a4421';

/// Provider pour vérifier si la connexion est stable
///
/// Copied from [isConnectionStable].
@ProviderFor(isConnectionStable)
final isConnectionStableProvider = AutoDisposeProvider<bool>.internal(
  isConnectionStable,
  name: r'isConnectionStableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isConnectionStableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsConnectionStableRef = AutoDisposeProviderRef<bool>;
String _$reconnectAttemptsHash() => r'a97a7e477fb9203e5465c1c7628395cde44067e4';

/// Provider pour obtenir le nombre de tentatives de reconnexion
///
/// Copied from [reconnectAttempts].
@ProviderFor(reconnectAttempts)
final reconnectAttemptsProvider = AutoDisposeProvider<int>.internal(
  reconnectAttempts,
  name: r'reconnectAttemptsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reconnectAttemptsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReconnectAttemptsRef = AutoDisposeProviderRef<int>;
String _$connectionMonitorHash() => r'c5b6906362eb1e509b077ed65fe958f7ad03cfe8';

/// Moniteur de connexion pour la gestion optimiste
///
/// Copied from [ConnectionMonitor].
@ProviderFor(ConnectionMonitor)
final connectionMonitorProvider =
    AutoDisposeNotifierProvider<
      ConnectionMonitor,
      ConnectionMonitorState
    >.internal(
      ConnectionMonitor.new,
      name: r'connectionMonitorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectionMonitorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConnectionMonitor = AutoDisposeNotifier<ConnectionMonitorState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
