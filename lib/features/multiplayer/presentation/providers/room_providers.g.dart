// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$supabaseRoomDatasourceHash() =>
    r'5872d87fa4f230b162da7428e761ab993079b121';

/// See also [supabaseRoomDatasource].
@ProviderFor(supabaseRoomDatasource)
final supabaseRoomDatasourceProvider =
    AutoDisposeProvider<SupabaseRoomDatasource>.internal(
      supabaseRoomDatasource,
      name: r'supabaseRoomDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supabaseRoomDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SupabaseRoomDatasourceRef =
    AutoDisposeProviderRef<SupabaseRoomDatasource>;
String _$roomDatasourceHash() => r'dab29ceca2f77ffa43a9275a814aa42e8b29472b';

/// See also [roomDatasource].
@ProviderFor(roomDatasource)
final roomDatasourceProvider = AutoDisposeProvider<RoomDatasource>.internal(
  roomDatasource,
  name: r'roomDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roomDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomDatasourceRef = AutoDisposeProviderRef<RoomDatasource>;
String _$roomRepositoryHash() => r'6ec55a7764a456a6ab135d85f1f7c9ebbed03861';

/// See also [roomRepository].
@ProviderFor(roomRepository)
final roomRepositoryProvider = AutoDisposeProvider<RoomRepository>.internal(
  roomRepository,
  name: r'roomRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roomRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomRepositoryRef = AutoDisposeProviderRef<RoomRepository>;
String _$createRoomUseCaseHash() => r'0dde7f8bfb94be3e5701a74e5349da72b431b0dd';

/// See also [createRoomUseCase].
@ProviderFor(createRoomUseCase)
final createRoomUseCaseProvider =
    AutoDisposeProvider<CreateRoomUseCase>.internal(
      createRoomUseCase,
      name: r'createRoomUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$createRoomUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateRoomUseCaseRef = AutoDisposeProviderRef<CreateRoomUseCase>;
String _$joinRoomUseCaseHash() => r'1f8375a6817a54f69d649f798ecd570c761d4fc5';

/// See also [joinRoomUseCase].
@ProviderFor(joinRoomUseCase)
final joinRoomUseCaseProvider = AutoDisposeProvider<JoinRoomUseCase>.internal(
  joinRoomUseCase,
  name: r'joinRoomUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$joinRoomUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef JoinRoomUseCaseRef = AutoDisposeProviderRef<JoinRoomUseCase>;
String _$syncGameStateUseCaseHash() =>
    r'877325225d031d4f497ff8d3cb5fe147b63ee920';

/// See also [syncGameStateUseCase].
@ProviderFor(syncGameStateUseCase)
final syncGameStateUseCaseProvider =
    AutoDisposeProvider<SyncGameStateUseCase>.internal(
      syncGameStateUseCase,
      name: r'syncGameStateUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncGameStateUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncGameStateUseCaseRef = AutoDisposeProviderRef<SyncGameStateUseCase>;
String _$currentRoomHash() => r'18716550b922e624704df6dbc99b031edc156b1c';

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

/// See also [currentRoom].
@ProviderFor(currentRoom)
const currentRoomProvider = CurrentRoomFamily();

/// See also [currentRoom].
class CurrentRoomFamily extends Family<AsyncValue<Room>> {
  /// See also [currentRoom].
  const CurrentRoomFamily();

  /// See also [currentRoom].
  CurrentRoomProvider call(String roomId) {
    return CurrentRoomProvider(roomId);
  }

  @override
  CurrentRoomProvider getProviderOverride(
    covariant CurrentRoomProvider provider,
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
  String? get name => r'currentRoomProvider';
}

/// See also [currentRoom].
class CurrentRoomProvider extends AutoDisposeStreamProvider<Room> {
  /// See also [currentRoom].
  CurrentRoomProvider(String roomId)
    : this._internal(
        (ref) => currentRoom(ref as CurrentRoomRef, roomId),
        from: currentRoomProvider,
        name: r'currentRoomProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$currentRoomHash,
        dependencies: CurrentRoomFamily._dependencies,
        allTransitiveDependencies: CurrentRoomFamily._allTransitiveDependencies,
        roomId: roomId,
      );

  CurrentRoomProvider._internal(
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
  Override overrideWith(Stream<Room> Function(CurrentRoomRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: CurrentRoomProvider._internal(
        (ref) => create(ref as CurrentRoomRef),
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
  AutoDisposeStreamProviderElement<Room> createElement() {
    return _CurrentRoomProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentRoomProvider && other.roomId == roomId;
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
mixin CurrentRoomRef on AutoDisposeStreamProviderRef<Room> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _CurrentRoomProviderElement extends AutoDisposeStreamProviderElement<Room>
    with CurrentRoomRef {
  _CurrentRoomProviderElement(super.provider);

  @override
  String get roomId => (origin as CurrentRoomProvider).roomId;
}

String _$roomEventsHash() => r'8658c3fddd7230471b9e81367db6018ebc6d8e9b';

/// See also [roomEvents].
@ProviderFor(roomEvents)
const roomEventsProvider = RoomEventsFamily();

/// See also [roomEvents].
class RoomEventsFamily extends Family<AsyncValue<RoomEvent>> {
  /// See also [roomEvents].
  const RoomEventsFamily();

  /// See also [roomEvents].
  RoomEventsProvider call(String roomId) {
    return RoomEventsProvider(roomId);
  }

  @override
  RoomEventsProvider getProviderOverride(
    covariant RoomEventsProvider provider,
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
  String? get name => r'roomEventsProvider';
}

/// See also [roomEvents].
class RoomEventsProvider extends AutoDisposeStreamProvider<RoomEvent> {
  /// See also [roomEvents].
  RoomEventsProvider(String roomId)
    : this._internal(
        (ref) => roomEvents(ref as RoomEventsRef, roomId),
        from: roomEventsProvider,
        name: r'roomEventsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$roomEventsHash,
        dependencies: RoomEventsFamily._dependencies,
        allTransitiveDependencies: RoomEventsFamily._allTransitiveDependencies,
        roomId: roomId,
      );

  RoomEventsProvider._internal(
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
  Override overrideWith(
    Stream<RoomEvent> Function(RoomEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RoomEventsProvider._internal(
        (ref) => create(ref as RoomEventsRef),
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
  AutoDisposeStreamProviderElement<RoomEvent> createElement() {
    return _RoomEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RoomEventsProvider && other.roomId == roomId;
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
mixin RoomEventsRef on AutoDisposeStreamProviderRef<RoomEvent> {
  /// The parameter `roomId` of this provider.
  String get roomId;
}

class _RoomEventsProviderElement
    extends AutoDisposeStreamProviderElement<RoomEvent>
    with RoomEventsRef {
  _RoomEventsProviderElement(super.provider);

  @override
  String get roomId => (origin as RoomEventsProvider).roomId;
}

String _$availableRoomsHash() => r'c2059f2b0aaf624b7e0e420afdd0c4e7dc181e14';

/// See also [availableRooms].
@ProviderFor(availableRooms)
final availableRoomsProvider = AutoDisposeFutureProvider<List<Room>>.internal(
  availableRooms,
  name: r'availableRoomsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableRoomsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableRoomsRef = AutoDisposeFutureProviderRef<List<Room>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
