// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_card_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$actionCardLocalDataSourceHash() =>
    r'4901dfe9a9f84f45883289a0a0435fbbaaa34d51';

/// See also [actionCardLocalDataSource].
@ProviderFor(actionCardLocalDataSource)
final actionCardLocalDataSourceProvider =
    AutoDisposeProvider<ActionCardLocalDataSource>.internal(
      actionCardLocalDataSource,
      name: r'actionCardLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actionCardLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActionCardLocalDataSourceRef =
    AutoDisposeProviderRef<ActionCardLocalDataSource>;
String _$actionCardRepositoryHash() =>
    r'58b476d5fda252c3fe64f091fe954a6c38bc9ea2';

/// See also [actionCardRepository].
@ProviderFor(actionCardRepository)
final actionCardRepositoryProvider =
    AutoDisposeProvider<ActionCardRepository>.internal(
      actionCardRepository,
      name: r'actionCardRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actionCardRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActionCardRepositoryRef = AutoDisposeProviderRef<ActionCardRepository>;
String _$supabaseActionCardRepositoryHash() =>
    r'a56329548b3e6ab79a859bf0fbb72187ba683732';

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

/// See also [supabaseActionCardRepository].
@ProviderFor(supabaseActionCardRepository)
const supabaseActionCardRepositoryProvider =
    SupabaseActionCardRepositoryFamily();

/// See also [supabaseActionCardRepository].
class SupabaseActionCardRepositoryFamily extends Family<ActionCardRepository> {
  /// See also [supabaseActionCardRepository].
  const SupabaseActionCardRepositoryFamily();

  /// See also [supabaseActionCardRepository].
  SupabaseActionCardRepositoryProvider call(String gameStateId) {
    return SupabaseActionCardRepositoryProvider(gameStateId);
  }

  @override
  SupabaseActionCardRepositoryProvider getProviderOverride(
    covariant SupabaseActionCardRepositoryProvider provider,
  ) {
    return call(provider.gameStateId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'supabaseActionCardRepositoryProvider';
}

/// See also [supabaseActionCardRepository].
class SupabaseActionCardRepositoryProvider
    extends AutoDisposeProvider<ActionCardRepository> {
  /// See also [supabaseActionCardRepository].
  SupabaseActionCardRepositoryProvider(String gameStateId)
    : this._internal(
        (ref) => supabaseActionCardRepository(
          ref as SupabaseActionCardRepositoryRef,
          gameStateId,
        ),
        from: supabaseActionCardRepositoryProvider,
        name: r'supabaseActionCardRepositoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$supabaseActionCardRepositoryHash,
        dependencies: SupabaseActionCardRepositoryFamily._dependencies,
        allTransitiveDependencies:
            SupabaseActionCardRepositoryFamily._allTransitiveDependencies,
        gameStateId: gameStateId,
      );

  SupabaseActionCardRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gameStateId,
  }) : super.internal();

  final String gameStateId;

  @override
  Override overrideWith(
    ActionCardRepository Function(SupabaseActionCardRepositoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SupabaseActionCardRepositoryProvider._internal(
        (ref) => create(ref as SupabaseActionCardRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gameStateId: gameStateId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ActionCardRepository> createElement() {
    return _SupabaseActionCardRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SupabaseActionCardRepositoryProvider &&
        other.gameStateId == gameStateId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gameStateId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SupabaseActionCardRepositoryRef
    on AutoDisposeProviderRef<ActionCardRepository> {
  /// The parameter `gameStateId` of this provider.
  String get gameStateId;
}

class _SupabaseActionCardRepositoryProviderElement
    extends AutoDisposeProviderElement<ActionCardRepository>
    with SupabaseActionCardRepositoryRef {
  _SupabaseActionCardRepositoryProviderElement(super.provider);

  @override
  String get gameStateId =>
      (origin as SupabaseActionCardRepositoryProvider).gameStateId;
}

String _$useActionCardUseCaseHash() =>
    r'18cf40308275d1f830793d1e2691376171607364';

/// See also [useActionCardUseCase].
@ProviderFor(useActionCardUseCase)
final useActionCardUseCaseProvider =
    AutoDisposeProvider<UseActionCardUseCase>.internal(
      useActionCardUseCase,
      name: r'useActionCardUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$useActionCardUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UseActionCardUseCaseRef = AutoDisposeProviderRef<UseActionCardUseCase>;
String _$playerActionCardsHash() => r'712af947de989a0703f7647eb2f199f491317b4e';

/// See also [playerActionCards].
@ProviderFor(playerActionCards)
const playerActionCardsProvider = PlayerActionCardsFamily();

/// See also [playerActionCards].
class PlayerActionCardsFamily extends Family<AsyncValue<List<ActionCard>>> {
  /// See also [playerActionCards].
  const PlayerActionCardsFamily();

  /// See also [playerActionCards].
  PlayerActionCardsProvider call(
    ({String gameStateId, String playerId}) params,
  ) {
    return PlayerActionCardsProvider(params);
  }

  @override
  PlayerActionCardsProvider getProviderOverride(
    covariant PlayerActionCardsProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playerActionCardsProvider';
}

/// See also [playerActionCards].
class PlayerActionCardsProvider
    extends AutoDisposeFutureProvider<List<ActionCard>> {
  /// See also [playerActionCards].
  PlayerActionCardsProvider(({String gameStateId, String playerId}) params)
    : this._internal(
        (ref) => playerActionCards(ref as PlayerActionCardsRef, params),
        from: playerActionCardsProvider,
        name: r'playerActionCardsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playerActionCardsHash,
        dependencies: PlayerActionCardsFamily._dependencies,
        allTransitiveDependencies:
            PlayerActionCardsFamily._allTransitiveDependencies,
        params: params,
      );

  PlayerActionCardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ({String gameStateId, String playerId}) params;

  @override
  Override overrideWith(
    FutureOr<List<ActionCard>> Function(PlayerActionCardsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlayerActionCardsProvider._internal(
        (ref) => create(ref as PlayerActionCardsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ActionCard>> createElement() {
    return _PlayerActionCardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerActionCardsProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlayerActionCardsRef on AutoDisposeFutureProviderRef<List<ActionCard>> {
  /// The parameter `params` of this provider.
  ({String gameStateId, String playerId}) get params;
}

class _PlayerActionCardsProviderElement
    extends AutoDisposeFutureProviderElement<List<ActionCard>>
    with PlayerActionCardsRef {
  _PlayerActionCardsProviderElement(super.provider);

  @override
  ({String gameStateId, String playerId}) get params =>
      (origin as PlayerActionCardsProvider).params;
}

String _$canUseActionCardHash() => r'f1d8147520bdd36cc410163d778d590368b594a3';

/// See also [canUseActionCard].
@ProviderFor(canUseActionCard)
const canUseActionCardProvider = CanUseActionCardFamily();

/// See also [canUseActionCard].
class CanUseActionCardFamily extends Family<AsyncValue<bool>> {
  /// See also [canUseActionCard].
  const CanUseActionCardFamily();

  /// See also [canUseActionCard].
  CanUseActionCardProvider call(
    ({ActionCard? actionCard, String gameStateId, String playerId}) params,
  ) {
    return CanUseActionCardProvider(params);
  }

  @override
  CanUseActionCardProvider getProviderOverride(
    covariant CanUseActionCardProvider provider,
  ) {
    return call(provider.params);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'canUseActionCardProvider';
}

/// See also [canUseActionCard].
class CanUseActionCardProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [canUseActionCard].
  CanUseActionCardProvider(
    ({ActionCard? actionCard, String gameStateId, String playerId}) params,
  ) : this._internal(
        (ref) => canUseActionCard(ref as CanUseActionCardRef, params),
        from: canUseActionCardProvider,
        name: r'canUseActionCardProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$canUseActionCardHash,
        dependencies: CanUseActionCardFamily._dependencies,
        allTransitiveDependencies:
            CanUseActionCardFamily._allTransitiveDependencies,
        params: params,
      );

  CanUseActionCardProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final ({ActionCard? actionCard, String gameStateId, String playerId}) params;

  @override
  Override overrideWith(
    FutureOr<bool> Function(CanUseActionCardRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CanUseActionCardProvider._internal(
        (ref) => create(ref as CanUseActionCardRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _CanUseActionCardProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CanUseActionCardProvider && other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CanUseActionCardRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `params` of this provider.
  ({ActionCard? actionCard, String gameStateId, String playerId}) get params;
}

class _CanUseActionCardProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with CanUseActionCardRef {
  _CanUseActionCardProviderElement(super.provider);

  @override
  ({ActionCard? actionCard, String gameStateId, String playerId}) get params =>
      (origin as CanUseActionCardProvider).params;
}

String _$actionCardNotifierHash() =>
    r'9c201be34b19e0aa40817baec41adda6b56d4364';

/// See also [ActionCardNotifier].
@ProviderFor(ActionCardNotifier)
final actionCardNotifierProvider =
    AutoDisposeNotifierProvider<ActionCardNotifier, AsyncValue<void>>.internal(
      ActionCardNotifier.new,
      name: r'actionCardNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$actionCardNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActionCardNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
