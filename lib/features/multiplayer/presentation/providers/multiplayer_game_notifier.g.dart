// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiplayer_game_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$multiplayerGameNotifierHash() =>
    r'd9fd82c0e1573d4bd46aa32e4f25a74b3748d137';

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

abstract class _$MultiplayerGameNotifier
    extends BuildlessAutoDisposeAsyncNotifier<void> {
  late final String roomId;

  FutureOr<void> build(String roomId);
}

/// See also [MultiplayerGameNotifier].
@ProviderFor(MultiplayerGameNotifier)
const multiplayerGameNotifierProvider = MultiplayerGameNotifierFamily();

/// See also [MultiplayerGameNotifier].
class MultiplayerGameNotifierFamily extends Family<AsyncValue<void>> {
  /// See also [MultiplayerGameNotifier].
  const MultiplayerGameNotifierFamily();

  /// See also [MultiplayerGameNotifier].
  MultiplayerGameNotifierProvider call(String roomId) {
    return MultiplayerGameNotifierProvider(roomId);
  }

  @override
  MultiplayerGameNotifierProvider getProviderOverride(
    covariant MultiplayerGameNotifierProvider provider,
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
  String? get name => r'multiplayerGameNotifierProvider';
}

/// See also [MultiplayerGameNotifier].
class MultiplayerGameNotifierProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<MultiplayerGameNotifier, void> {
  /// See also [MultiplayerGameNotifier].
  MultiplayerGameNotifierProvider(String roomId)
    : this._internal(
        () => MultiplayerGameNotifier()..roomId = roomId,
        from: multiplayerGameNotifierProvider,
        name: r'multiplayerGameNotifierProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$multiplayerGameNotifierHash,
        dependencies: MultiplayerGameNotifierFamily._dependencies,
        allTransitiveDependencies:
            MultiplayerGameNotifierFamily._allTransitiveDependencies,
        roomId: roomId,
      );

  MultiplayerGameNotifierProvider._internal(
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
  FutureOr<void> runNotifierBuild(covariant MultiplayerGameNotifier notifier) {
    return notifier.build(roomId);
  }

  @override
  Override overrideWith(MultiplayerGameNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: MultiplayerGameNotifierProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<MultiplayerGameNotifier, void>
  createElement() {
    return _MultiplayerGameNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MultiplayerGameNotifierProvider && other.roomId == roomId;
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
mixin MultiplayerGameNotifierRef on AutoDisposeAsyncNotifierProviderRef<void> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _MultiplayerGameNotifierProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<MultiplayerGameNotifier, void>
    with MultiplayerGameNotifierRef {
  _MultiplayerGameNotifierProviderElement(super.provider);

  @override
  String get roomId => (origin as MultiplayerGameNotifierProvider).roomId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
