// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseHash() => r'fb098cc6e867811a983d533c1ec70af181985fcf';

/// Provider pour l'instance Supabase
///
/// Copied from [supabase].
@ProviderFor(supabase)
final supabaseProvider = AutoDisposeProvider<SupabaseClient>.internal(
  supabase,
  name: r'supabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$supabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseRef = AutoDisposeProviderRef<SupabaseClient>;
String _$gameRepositoryHash() => r'07b12cf1bd06eb0e4c46015283fe668ee6700bce';

/// Provider pour le GameRepository
///
/// Copied from [gameRepository].
@ProviderFor(gameRepository)
final gameRepositoryProvider = AutoDisposeProvider<GameRepository>.internal(
  gameRepository,
  name: r'gameRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameRepositoryRef = AutoDisposeProviderRef<GameRepository>;
String _$gameLoaderHash() => r'b1508155307d39293a8c834091335399977568df';

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

/// Provider pour charger un jeu par son ID
///
/// Copied from [gameLoader].
@ProviderFor(gameLoader)
const gameLoaderProvider = GameLoaderFamily();

/// Provider pour charger un jeu par son ID
///
/// Copied from [gameLoader].
class GameLoaderFamily extends Family<AsyncValue<GameState?>> {
  /// Provider pour charger un jeu par son ID
  ///
  /// Copied from [gameLoader].
  const GameLoaderFamily();

  /// Provider pour charger un jeu par son ID
  ///
  /// Copied from [gameLoader].
  GameLoaderProvider call(String gameId) {
    return GameLoaderProvider(gameId);
  }

  @override
  GameLoaderProvider getProviderOverride(
    covariant GameLoaderProvider provider,
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
  String? get name => r'gameLoaderProvider';
}

/// Provider pour charger un jeu par son ID
///
/// Copied from [gameLoader].
class GameLoaderProvider extends AutoDisposeFutureProvider<GameState?> {
  /// Provider pour charger un jeu par son ID
  ///
  /// Copied from [gameLoader].
  GameLoaderProvider(String gameId)
    : this._internal(
        (ref) => gameLoader(ref as GameLoaderRef, gameId),
        from: gameLoaderProvider,
        name: r'gameLoaderProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gameLoaderHash,
        dependencies: GameLoaderFamily._dependencies,
        allTransitiveDependencies: GameLoaderFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  GameLoaderProvider._internal(
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
  Override overrideWith(
    FutureOr<GameState?> Function(GameLoaderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GameLoaderProvider._internal(
        (ref) => create(ref as GameLoaderRef),
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
  AutoDisposeFutureProviderElement<GameState?> createElement() {
    return _GameLoaderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameLoaderProvider && other.gameId == gameId;
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
mixin GameLoaderRef on AutoDisposeFutureProviderRef<GameState?> {
  /// The parameter `gameId` of this provider.
  String get gameId;
}

class _GameLoaderProviderElement
    extends AutoDisposeFutureProviderElement<GameState?>
    with GameLoaderRef {
  _GameLoaderProviderElement(super.provider);

  @override
  String get gameId => (origin as GameLoaderProvider).gameId;
}

String _$gameStreamHash() => r'29cfb940fde2320597ccbca776161a6f56cb67a7';

/// Provider pour écouter les changements d'un jeu en temps réel
///
/// Copied from [gameStream].
@ProviderFor(gameStream)
const gameStreamProvider = GameStreamFamily();

/// Provider pour écouter les changements d'un jeu en temps réel
///
/// Copied from [gameStream].
class GameStreamFamily extends Family<AsyncValue<GameState>> {
  /// Provider pour écouter les changements d'un jeu en temps réel
  ///
  /// Copied from [gameStream].
  const GameStreamFamily();

  /// Provider pour écouter les changements d'un jeu en temps réel
  ///
  /// Copied from [gameStream].
  GameStreamProvider call(String gameId) {
    return GameStreamProvider(gameId);
  }

  @override
  GameStreamProvider getProviderOverride(
    covariant GameStreamProvider provider,
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
  String? get name => r'gameStreamProvider';
}

/// Provider pour écouter les changements d'un jeu en temps réel
///
/// Copied from [gameStream].
class GameStreamProvider extends AutoDisposeStreamProvider<GameState> {
  /// Provider pour écouter les changements d'un jeu en temps réel
  ///
  /// Copied from [gameStream].
  GameStreamProvider(String gameId)
    : this._internal(
        (ref) => gameStream(ref as GameStreamRef, gameId),
        from: gameStreamProvider,
        name: r'gameStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gameStreamHash,
        dependencies: GameStreamFamily._dependencies,
        allTransitiveDependencies: GameStreamFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  GameStreamProvider._internal(
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
  Override overrideWith(
    Stream<GameState> Function(GameStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GameStreamProvider._internal(
        (ref) => create(ref as GameStreamRef),
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
  AutoDisposeStreamProviderElement<GameState> createElement() {
    return _GameStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameStreamProvider && other.gameId == gameId;
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
mixin GameStreamRef on AutoDisposeStreamProviderRef<GameState> {
  /// The parameter `gameId` of this provider.
  String get gameId;
}

class _GameStreamProviderElement
    extends AutoDisposeStreamProviderElement<GameState>
    with GameStreamRef {
  _GameStreamProviderElement(super.provider);

  @override
  String get gameId => (origin as GameStreamProvider).gameId;
}

String _$heartbeatServiceManagerHash() =>
    r'0712b9f49e938278175662519527c7956f08fdce';

/// Provider pour le HeartbeatService
///
/// Copied from [HeartbeatServiceManager].
@ProviderFor(HeartbeatServiceManager)
final heartbeatServiceManagerProvider =
    AutoDisposeNotifierProvider<HeartbeatServiceManager, void>.internal(
      HeartbeatServiceManager.new,
      name: r'heartbeatServiceManagerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$heartbeatServiceManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HeartbeatServiceManager = AutoDisposeNotifier<void>;
String _$gameStateManagerHash() => r'7a51b2bf1c7f1fc9ccbfc5841d15ecca5c634e9c';

abstract class _$GameStateManager
    extends BuildlessAutoDisposeAsyncNotifier<GameState?> {
  late final String gameId;

  FutureOr<GameState?> build(String gameId);
}

/// Provider pour gérer l'état du jeu avec le nouveau système
///
/// Copied from [GameStateManager].
@ProviderFor(GameStateManager)
const gameStateManagerProvider = GameStateManagerFamily();

/// Provider pour gérer l'état du jeu avec le nouveau système
///
/// Copied from [GameStateManager].
class GameStateManagerFamily extends Family<AsyncValue<GameState?>> {
  /// Provider pour gérer l'état du jeu avec le nouveau système
  ///
  /// Copied from [GameStateManager].
  const GameStateManagerFamily();

  /// Provider pour gérer l'état du jeu avec le nouveau système
  ///
  /// Copied from [GameStateManager].
  GameStateManagerProvider call(String gameId) {
    return GameStateManagerProvider(gameId);
  }

  @override
  GameStateManagerProvider getProviderOverride(
    covariant GameStateManagerProvider provider,
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
  String? get name => r'gameStateManagerProvider';
}

/// Provider pour gérer l'état du jeu avec le nouveau système
///
/// Copied from [GameStateManager].
class GameStateManagerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<GameStateManager, GameState?> {
  /// Provider pour gérer l'état du jeu avec le nouveau système
  ///
  /// Copied from [GameStateManager].
  GameStateManagerProvider(String gameId)
    : this._internal(
        () => GameStateManager()..gameId = gameId,
        from: gameStateManagerProvider,
        name: r'gameStateManagerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$gameStateManagerHash,
        dependencies: GameStateManagerFamily._dependencies,
        allTransitiveDependencies:
            GameStateManagerFamily._allTransitiveDependencies,
        gameId: gameId,
      );

  GameStateManagerProvider._internal(
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
  FutureOr<GameState?> runNotifierBuild(covariant GameStateManager notifier) {
    return notifier.build(gameId);
  }

  @override
  Override overrideWith(GameStateManager Function() create) {
    return ProviderOverride(
      origin: this,
      override: GameStateManagerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<GameStateManager, GameState?>
  createElement() {
    return _GameStateManagerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GameStateManagerProvider && other.gameId == gameId;
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
mixin GameStateManagerRef on AutoDisposeAsyncNotifierProviderRef<GameState?> {
  /// The parameter `gameId` of this provider.
  String get gameId;
}

class _GameStateManagerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<GameStateManager, GameState?>
    with GameStateManagerRef {
  _GameStateManagerProviderElement(super.provider);

  @override
  String get gameId => (origin as GameStateManagerProvider).gameId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
