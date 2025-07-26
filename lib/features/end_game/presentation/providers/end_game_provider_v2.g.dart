// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_game_provider_v2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$voteToContineHash() => r'51d3d6a90f84082ebbedbf4eb737b38b48460e35';

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

/// Provider to handle vote to continue action
///
/// Copied from [voteToContine].
@ProviderFor(voteToContine)
const voteToContineProvider = VoteToContineFamily();

/// Provider to handle vote to continue action
///
/// Copied from [voteToContine].
class VoteToContineFamily extends Family<void> {
  /// Provider to handle vote to continue action
  ///
  /// Copied from [voteToContine].
  const VoteToContineFamily();

  /// Provider to handle vote to continue action
  ///
  /// Copied from [voteToContine].
  VoteToContineProvider call(String playerId) {
    return VoteToContineProvider(playerId);
  }

  @override
  VoteToContineProvider getProviderOverride(
    covariant VoteToContineProvider provider,
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
  String? get name => r'voteToContineProvider';
}

/// Provider to handle vote to continue action
///
/// Copied from [voteToContine].
class VoteToContineProvider extends AutoDisposeProvider<void> {
  /// Provider to handle vote to continue action
  ///
  /// Copied from [voteToContine].
  VoteToContineProvider(String playerId)
    : this._internal(
        (ref) => voteToContine(ref as VoteToContineRef, playerId),
        from: voteToContineProvider,
        name: r'voteToContineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$voteToContineHash,
        dependencies: VoteToContineFamily._dependencies,
        allTransitiveDependencies:
            VoteToContineFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  VoteToContineProvider._internal(
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
  Override overrideWith(void Function(VoteToContineRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: VoteToContineProvider._internal(
        (ref) => create(ref as VoteToContineRef),
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
  AutoDisposeProviderElement<void> createElement() {
    return _VoteToContineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VoteToContineProvider && other.playerId == playerId;
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
mixin VoteToContineRef on AutoDisposeProviderRef<void> {
  /// The parameter `playerId` of this provider.
  String get playerId;
}

class _VoteToContineProviderElement extends AutoDisposeProviderElement<void>
    with VoteToContineRef {
  _VoteToContineProviderElement(super.provider);

  @override
  String get playerId => (origin as VoteToContineProvider).playerId;
}

String _$navigateToHomeHash() => r'd74662e582428f3f6289a7f7f532cca4bbb58406';

/// Provider to navigate to home (to be implemented with go_router)
///
/// Copied from [navigateToHome].
@ProviderFor(navigateToHome)
final navigateToHomeProvider = Provider<void>.internal(
  navigateToHome,
  name: r'navigateToHomeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$navigateToHomeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NavigateToHomeRef = ProviderRef<void>;
String _$endGameStateNotifierHash() =>
    r'9e886ded11cdb65e002f7fb93a66491edcb78ea8';

/// Provider for the end game state
///
/// Copied from [EndGameStateNotifier].
@ProviderFor(EndGameStateNotifier)
final endGameStateNotifierProvider =
    AutoDisposeNotifierProvider<EndGameStateNotifier, EndGameState?>.internal(
      EndGameStateNotifier.new,
      name: r'endGameStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$endGameStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EndGameStateNotifier = AutoDisposeNotifier<EndGameState?>;
String _$endGameSaveNotifierHash() =>
    r'ead364728fad974c80a91fc370e806c209e3249d';

/// Provider to save global scores when game ends
///
/// Copied from [EndGameSaveNotifier].
@ProviderFor(EndGameSaveNotifier)
final endGameSaveNotifierProvider =
    AutoDisposeAsyncNotifierProvider<EndGameSaveNotifier, void>.internal(
      EndGameSaveNotifier.new,
      name: r'endGameSaveNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$endGameSaveNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EndGameSaveNotifier = AutoDisposeAsyncNotifier<void>;
String _$endGameActionHash() => r'a3075cabd5e506449dbe31e840945cb18a247d53';

/// Provider to handle end game action
///
/// Copied from [EndGameAction].
@ProviderFor(EndGameAction)
final endGameActionProvider =
    AutoDisposeNotifierProvider<EndGameAction, void>.internal(
      EndGameAction.new,
      name: r'endGameActionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$endGameActionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EndGameAction = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
