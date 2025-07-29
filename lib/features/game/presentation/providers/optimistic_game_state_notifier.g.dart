// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimistic_game_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$optimisticGameStateHash() =>
    r'4aac53c4b1406a3a0fe56a4c3fbe6b030d27b026';

/// Provider pour accéder facilement à l'état local
///
/// Copied from [optimisticGameState].
@ProviderFor(optimisticGameState)
final optimisticGameStateProvider = AutoDisposeProvider<GameState>.internal(
  optimisticGameState,
  name: r'optimisticGameStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$optimisticGameStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OptimisticGameStateRef = AutoDisposeProviderRef<GameState>;
String _$isGameStateSyncingHash() =>
    r'36cf5443211d320f4d6e50cdb1d9ad036e0a05ce';

/// Provider pour accéder au statut de synchronisation
///
/// Copied from [isGameStateSyncing].
@ProviderFor(isGameStateSyncing)
final isGameStateSyncingProvider = AutoDisposeProvider<bool>.internal(
  isGameStateSyncing,
  name: r'isGameStateSyncingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isGameStateSyncingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsGameStateSyncingRef = AutoDisposeProviderRef<bool>;
String _$gameSyncErrorHash() => r'005ebf8773a9e9c3b7382c952e121a683e09a6eb';

/// Provider pour accéder aux erreurs de synchronisation
///
/// Copied from [gameSyncError].
@ProviderFor(gameSyncError)
final gameSyncErrorProvider = AutoDisposeProvider<String?>.internal(
  gameSyncError,
  name: r'gameSyncErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameSyncErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameSyncErrorRef = AutoDisposeProviderRef<String?>;
String _$optimisticGameStateNotifierHash() =>
    r'933cc39bc48ea0e97833ef5f2bc83568431e0d00';

/// Notifier pour gérer l'état optimiste du jeu avec synchronisation
///
/// Copied from [OptimisticGameStateNotifier].
@ProviderFor(OptimisticGameStateNotifier)
final optimisticGameStateNotifierProvider =
    AutoDisposeNotifierProvider<
      OptimisticGameStateNotifier,
      OptimisticState<GameState>
    >.internal(
      OptimisticGameStateNotifier.new,
      name: r'optimisticGameStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$optimisticGameStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OptimisticGameStateNotifier =
    AutoDisposeNotifier<OptimisticState<GameState>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
