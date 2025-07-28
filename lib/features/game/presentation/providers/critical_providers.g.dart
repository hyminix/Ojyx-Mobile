// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'critical_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$criticalHeartbeatServiceManagerHash() =>
    r'8e8a86233a3c52ad72d7dfaa76091cb8f6290887';

/// Critical providers that should survive widget disposal
/// These providers maintain important state that shouldn't be lost during navigation
/// Provider for HeartbeatService that keeps alive
/// This ensures heartbeat continues even when navigating between screens
///
/// Copied from [CriticalHeartbeatServiceManager].
@ProviderFor(CriticalHeartbeatServiceManager)
final criticalHeartbeatServiceManagerProvider =
    NotifierProvider<CriticalHeartbeatServiceManager, void>.internal(
      CriticalHeartbeatServiceManager.new,
      name: r'criticalHeartbeatServiceManagerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$criticalHeartbeatServiceManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CriticalHeartbeatServiceManager = Notifier<void>;
String _$criticalGameStateManagerHash() =>
    r'46d4e49adc184bd14504e17dbe911a54df2acdd9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$CriticalGameStateManager
    extends BuildlessAsyncNotifier<GameState?> {
  late final String gameId;

  FutureOr<GameState?> build(String gameId);
}

/// Provider for critical game state management
/// Keeps game state alive during navigation to prevent state loss
///
/// Copied from [CriticalGameStateManager].
@ProviderFor(CriticalGameStateManager)
const criticalGameStateManagerProvider = CriticalGameStateManagerFamily();

/// Provider for critical game state management
/// Keeps game state alive during navigation to prevent state loss
///
/// Copied from [CriticalGameStateManager].
class CriticalGameStateManagerFamily extends Family<AsyncValue<GameState?>> {
  /// Provider for critical game state management
  /// Keeps game state alive during navigation to prevent state loss
  ///
  /// Copied from [CriticalGameStateManager].
  const CriticalGameStateManagerFamily();

  /// Provider for critical game state management
  /// Keeps game state alive during navigation to prevent state loss
  ///
  /// Copied from [CriticalGameStateManager].
  CriticalGameStateManagerProvider call(String gameId) {
    return CriticalGameStateManagerProvider(gameId);
  }

  @override
  CriticalGameStateManagerProvider getProviderOverride(
    covariant CriticalGameStateManagerProvider provider,
  ) {
    return call(provider.gameId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'criticalGameStateManagerProvider';
}

/// Provider for critical game state management
/// Keeps game state alive during navigation to prevent state loss
///
/// Copied from [CriticalGameStateManager].
class CriticalGameStateManagerProvider
    extends AsyncNotifierProviderImpl<CriticalGameStateManager, GameState?> {
  /// Provider for critical game state management
  /// Keeps game state alive during navigation to prevent state loss
  ///
  /// Copied from [CriticalGameStateManager].
  CriticalGameStateManagerProvider(String gameId)
    : this._internal(
        () => CriticalGameStateManager()..gameId = gameId,
        from: criticalGameStateManagerProvider,
        name: r'criticalGameStateManagerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$criticalGameStateManagerHash,
        dependencies: CriticalGameStateManagerFamily._dependencies,
        allTransitiveDependencies:
            CriticalGameStateManagerFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  CriticalGameStateManagerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gameId,
  }) : super.internal();

  final String gameId;

  @override
  FutureOr<GameState?> runNotifierBuild(
    covariant CriticalGameStateManager notifier,
  ) {
    return notifier.build(gameId);
  }

  @override
  Override overrideWith(CriticalGameStateManager Function() create) {
    return ProviderOverride(
      origin: this,
      override: CriticalGameStateManagerProvider._internal(
        () => create()..gameId = gameId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gameId: gameId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<CriticalGameStateManager, GameState?>
  createElement() {
    return _CriticalGameStateManagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CriticalGameStateManagerProvider && other.gameId == gameId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gameId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CriticalGameStateManagerRef on AsyncNotifierProviderRef<GameState?> {
  /// The parameter `gameId` of this provider.
  String get gameId;
}

class _CriticalGameStateManagerProviderElement
    extends AsyncNotifierProviderElement<CriticalGameStateManager, GameState?>
    with CriticalGameStateManagerRef {
  _CriticalGameStateManagerProviderElement(super.provider);

  @override
  String get gameId => (origin as CriticalGameStateManagerProvider).gameId;
}

String _$activeGamesTrackerHash() =>
    r'ce58d37567cadbcf765d53b309dbb5a836504541';

/// Provider for active game tracking
/// Keeps track of which games are currently active to manage lifecycle
///
/// Copied from [ActiveGamesTracker].
@ProviderFor(ActiveGamesTracker)
final activeGamesTrackerProvider =
    NotifierProvider<ActiveGamesTracker, Set<String>>.internal(
      ActiveGamesTracker.new,
      name: r'activeGamesTrackerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeGamesTrackerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveGamesTracker = Notifier<Set<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
