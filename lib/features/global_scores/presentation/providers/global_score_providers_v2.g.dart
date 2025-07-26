// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_score_providers_v2.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalScoreRepositoryHash() =>
    r'2948c6c5292057fb1bd7b067a2e8803c073c2361';

/// See also [globalScoreRepository].
@ProviderFor(globalScoreRepository)
final globalScoreRepositoryProvider = Provider<GlobalScoreRepository>.internal(
  globalScoreRepository,
  name: r'globalScoreRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalScoreRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GlobalScoreRepositoryRef = ProviderRef<GlobalScoreRepository>;
String _$saveGlobalScoreUseCaseHash() =>
    r'162e6b2b7b366e20b8766193cf2777bcd7a20cb7';

/// See also [saveGlobalScoreUseCase].
@ProviderFor(saveGlobalScoreUseCase)
final saveGlobalScoreUseCaseProvider =
    Provider<SaveGlobalScoreUseCase>.internal(
      saveGlobalScoreUseCase,
      name: r'saveGlobalScoreUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$saveGlobalScoreUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SaveGlobalScoreUseCaseRef = ProviderRef<SaveGlobalScoreUseCase>;
String _$getPlayerStatsUseCaseHash() =>
    r'e2a345fcd48737c9cc2b705048f3c00099c0feab';

/// See also [getPlayerStatsUseCase].
@ProviderFor(getPlayerStatsUseCase)
final getPlayerStatsUseCaseProvider = Provider<GetPlayerStatsUseCase>.internal(
  getPlayerStatsUseCase,
  name: r'getPlayerStatsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPlayerStatsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPlayerStatsUseCaseRef = ProviderRef<GetPlayerStatsUseCase>;
String _$getTopPlayersUseCaseHash() =>
    r'a7d2103fde32f9cc60280c1523dcdafec50902cf';

/// See also [getTopPlayersUseCase].
@ProviderFor(getTopPlayersUseCase)
final getTopPlayersUseCaseProvider = Provider<GetTopPlayersUseCase>.internal(
  getTopPlayersUseCase,
  name: r'getTopPlayersUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getTopPlayersUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetTopPlayersUseCaseRef = ProviderRef<GetTopPlayersUseCase>;
String _$playerStatsNotifierHash() =>
    r'b5368bbde862930f956c1f2550c0a2649fa5c389';

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

abstract class _$PlayerStatsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<PlayerStats?> {
  late final String playerId;

  FutureOr<PlayerStats?> build(String playerId);
}

/// See also [PlayerStatsNotifier].
@ProviderFor(PlayerStatsNotifier)
const playerStatsNotifierProvider = PlayerStatsNotifierFamily();

/// See also [PlayerStatsNotifier].
class PlayerStatsNotifierFamily extends Family<AsyncValue<PlayerStats?>> {
  /// See also [PlayerStatsNotifier].
  const PlayerStatsNotifierFamily();

  /// See also [PlayerStatsNotifier].
  PlayerStatsNotifierProvider call(String playerId) {
    return PlayerStatsNotifierProvider(playerId);
  }

  @override
  PlayerStatsNotifierProvider getProviderOverride(
    covariant PlayerStatsNotifierProvider provider,
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
  String? get name => r'playerStatsNotifierProvider';
}

/// See also [PlayerStatsNotifier].
class PlayerStatsNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PlayerStatsNotifier,
          PlayerStats?
        > {
  /// See also [PlayerStatsNotifier].
  PlayerStatsNotifierProvider(String playerId)
    : this._internal(
        () => PlayerStatsNotifier()..playerId = playerId,
        from: playerStatsNotifierProvider,
        name: r'playerStatsNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playerStatsNotifierHash,
        dependencies: PlayerStatsNotifierFamily._dependencies,
        allTransitiveDependencies:
            PlayerStatsNotifierFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  PlayerStatsNotifierProvider._internal(
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
  FutureOr<PlayerStats?> runNotifierBuild(
    covariant PlayerStatsNotifier notifier,
  ) {
    return notifier.build(playerId);
  }

  @override
  Override overrideWith(PlayerStatsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlayerStatsNotifierProvider._internal(
        () => create()..playerId = playerId,
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
  AutoDisposeAsyncNotifierProviderElement<PlayerStatsNotifier, PlayerStats?>
  createElement() {
    return _PlayerStatsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlayerStatsNotifierProvider && other.playerId == playerId;
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
mixin PlayerStatsNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<PlayerStats?> {
  /// The parameter `playerId` of this provider.
  String get playerId;
}

class _PlayerStatsNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PlayerStatsNotifier,
          PlayerStats?
        >
    with PlayerStatsNotifierRef {
  _PlayerStatsNotifierProviderElement(super.provider);

  @override
  String get playerId => (origin as PlayerStatsNotifierProvider).playerId;
}

String _$topPlayersNotifierHash() =>
    r'adfff8108a124098c032a9305f603a72bb47d0c5';

/// See also [TopPlayersNotifier].
@ProviderFor(TopPlayersNotifier)
final topPlayersNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      TopPlayersNotifier,
      List<PlayerStats>
    >.internal(
      TopPlayersNotifier.new,
      name: r'topPlayersNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$topPlayersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TopPlayersNotifier = AutoDisposeAsyncNotifier<List<PlayerStats>>;
String _$recentGamesNotifierHash() =>
    r'199735c58bfaa10bc0a4f206bae6dd1471151442';

abstract class _$RecentGamesNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<GlobalScore>> {
  late final String playerId;

  FutureOr<List<GlobalScore>> build(String playerId);
}

/// See also [RecentGamesNotifier].
@ProviderFor(RecentGamesNotifier)
const recentGamesNotifierProvider = RecentGamesNotifierFamily();

/// See also [RecentGamesNotifier].
class RecentGamesNotifierFamily extends Family<AsyncValue<List<GlobalScore>>> {
  /// See also [RecentGamesNotifier].
  const RecentGamesNotifierFamily();

  /// See also [RecentGamesNotifier].
  RecentGamesNotifierProvider call(String playerId) {
    return RecentGamesNotifierProvider(playerId);
  }

  @override
  RecentGamesNotifierProvider getProviderOverride(
    covariant RecentGamesNotifierProvider provider,
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
  String? get name => r'recentGamesNotifierProvider';
}

/// See also [RecentGamesNotifier].
class RecentGamesNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          RecentGamesNotifier,
          List<GlobalScore>
        > {
  /// See also [RecentGamesNotifier].
  RecentGamesNotifierProvider(String playerId)
    : this._internal(
        () => RecentGamesNotifier()..playerId = playerId,
        from: recentGamesNotifierProvider,
        name: r'recentGamesNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentGamesNotifierHash,
        dependencies: RecentGamesNotifierFamily._dependencies,
        allTransitiveDependencies:
            RecentGamesNotifierFamily._allTransitiveDependencies,
        playerId: playerId,
      );

  RecentGamesNotifierProvider._internal(
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
  FutureOr<List<GlobalScore>> runNotifierBuild(
    covariant RecentGamesNotifier notifier,
  ) {
    return notifier.build(playerId);
  }

  @override
  Override overrideWith(RecentGamesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RecentGamesNotifierProvider._internal(
        () => create()..playerId = playerId,
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
  AutoDisposeAsyncNotifierProviderElement<
    RecentGamesNotifier,
    List<GlobalScore>
  >
  createElement() {
    return _RecentGamesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentGamesNotifierProvider && other.playerId == playerId;
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
mixin RecentGamesNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<GlobalScore>> {
  /// The parameter `playerId` of this provider.
  String get playerId;
}

class _RecentGamesNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          RecentGamesNotifier,
          List<GlobalScore>
        >
    with RecentGamesNotifierRef {
  _RecentGamesNotifierProviderElement(super.provider);

  @override
  String get playerId => (origin as RecentGamesNotifierProvider).playerId;
}

String _$roomScoresNotifierHash() =>
    r'd3f5bf2a12c78233a3952604ad4a75aea42b0ee3';

abstract class _$RoomScoresNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<GlobalScore>> {
  late final String roomId;

  FutureOr<List<GlobalScore>> build(String roomId);
}

/// See also [RoomScoresNotifier].
@ProviderFor(RoomScoresNotifier)
const roomScoresNotifierProvider = RoomScoresNotifierFamily();

/// See also [RoomScoresNotifier].
class RoomScoresNotifierFamily extends Family<AsyncValue<List<GlobalScore>>> {
  /// See also [RoomScoresNotifier].
  const RoomScoresNotifierFamily();

  /// See also [RoomScoresNotifier].
  RoomScoresNotifierProvider call(String roomId) {
    return RoomScoresNotifierProvider(roomId);
  }

  @override
  RoomScoresNotifierProvider getProviderOverride(
    covariant RoomScoresNotifierProvider provider,
  ) {
    return call(provider.roomId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'roomScoresNotifierProvider';
}

/// See also [RoomScoresNotifier].
class RoomScoresNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          RoomScoresNotifier,
          List<GlobalScore>
        > {
  /// See also [RoomScoresNotifier].
  RoomScoresNotifierProvider(String roomId)
    : this._internal(
        () => RoomScoresNotifier()..roomId = roomId,
        from: roomScoresNotifierProvider,
        name: r'roomScoresNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$roomScoresNotifierHash,
        dependencies: RoomScoresNotifierFamily._dependencies,
        allTransitiveDependencies:
            RoomScoresNotifierFamily._allTransitiveDependencies,
        roomId: roomId,
      );

  RoomScoresNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.roomId,
  }) : super.internal();

  final String roomId;

  @override
  FutureOr<List<GlobalScore>> runNotifierBuild(
    covariant RoomScoresNotifier notifier,
  ) {
    return notifier.build(roomId);
  }

  @override
  Override overrideWith(RoomScoresNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RoomScoresNotifierProvider._internal(
        () => create()..roomId = roomId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        roomId: roomId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<RoomScoresNotifier, List<GlobalScore>>
  createElement() {
    return _RoomScoresNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomScoresNotifierProvider && other.roomId == roomId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, roomId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RoomScoresNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<GlobalScore>> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _RoomScoresNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          RoomScoresNotifier,
          List<GlobalScore>
        >
    with RoomScoresNotifierRef {
  _RoomScoresNotifierProviderElement(super.provider);

  @override
  String get roomId => (origin as RoomScoresNotifierProvider).roomId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
