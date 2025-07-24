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
String _$playerActionCardsHash() => r'905945a2fcbaae595f50907533575e5c8c39241e';

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

/// See also [playerActionCards].
@ProviderFor(playerActionCards)
const playerActionCardsProvider = PlayerActionCardsFamily();

/// See also [playerActionCards].
class PlayerActionCardsFamily extends Family<List<ActionCard>> {
  /// See also [playerActionCards].
  const PlayerActionCardsFamily();

  /// See also [playerActionCards].
  PlayerActionCardsProvider call(String playerId) {
    return PlayerActionCardsProvider(playerId);
  }

  @override
  PlayerActionCardsProvider getProviderOverride(
    covariant PlayerActionCardsProvider provider,
  ) {
    return call(provider.playerId);
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
class PlayerActionCardsProvider extends AutoDisposeProvider<List<ActionCard>> {
  /// See also [playerActionCards].
  PlayerActionCardsProvider(String playerId)
    : this._internal(
        (ref) => playerActionCards(ref as PlayerActionCardsRef, playerId),
        from: playerActionCardsProvider,
        name: r'playerActionCardsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playerActionCardsHash,
        dependencies: PlayerActionCardsFamily._dependencies,
        allTransitiveDependencies:
            PlayerActionCardsFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  PlayerActionCardsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playerId,
  }) : super.internal();

  final String playerId;

  @override
  Override overrideWith(
    List<ActionCard> Function(PlayerActionCardsRef provider) create,
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
        playerId: playerId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ActionCard>> createElement() {
    return _PlayerActionCardsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerActionCardsProvider && other.playerId == playerId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playerId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlayerActionCardsRef on AutoDisposeProviderRef<List<ActionCard>> {
  /// The parameter `playerId` of this provider.
  String get playerId;
}

class _PlayerActionCardsProviderElement
    extends AutoDisposeProviderElement<List<ActionCard>>
    with PlayerActionCardsRef {
  _PlayerActionCardsProviderElement(super.provider);

  @override
  String get playerId => (origin as PlayerActionCardsProvider).playerId;
}

String _$canUseActionCardHash() => r'7d687ae1d741221527d69c10903de9172bac6ab1';

/// See also [canUseActionCard].
@ProviderFor(canUseActionCard)
const canUseActionCardProvider = CanUseActionCardFamily();

/// See also [canUseActionCard].
class CanUseActionCardFamily extends Family<bool> {
  /// See also [canUseActionCard].
  const CanUseActionCardFamily();

  /// See also [canUseActionCard].
  CanUseActionCardProvider call(
    ({ActionCard? actionCard, String playerId}) params,
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
class CanUseActionCardProvider extends AutoDisposeProvider<bool> {
  /// See also [canUseActionCard].
  CanUseActionCardProvider(({ActionCard? actionCard, String playerId}) params)
    : this._internal(
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

  final ({ActionCard? actionCard, String playerId}) params;

  @override
  Override overrideWith(bool Function(CanUseActionCardRef provider) create) {
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
  AutoDisposeProviderElement<bool> createElement() {
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
mixin CanUseActionCardRef on AutoDisposeProviderRef<bool> {
  /// The parameter `params` of this provider.
  ({ActionCard? actionCard, String playerId}) get params;
}

class _CanUseActionCardProviderElement extends AutoDisposeProviderElement<bool>
    with CanUseActionCardRef {
  _CanUseActionCardProviderElement(super.provider);

  @override
  ({ActionCard? actionCard, String playerId}) get params =>
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
