// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_realtime_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomPresenceStreamHash() =>
    r'547c4f012d74cb4b1aedb39ceee4fa9909167e4b';

/// Provider pour accéder au stream de présence
///
/// Copied from [roomPresenceStream].
@ProviderFor(roomPresenceStream)
final roomPresenceStreamProvider =
    AutoDisposeStreamProvider<Map<String, LobbyPlayer>>.internal(
      roomPresenceStream,
      name: r'roomPresenceStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomPresenceStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomPresenceStreamRef =
    AutoDisposeStreamProviderRef<Map<String, LobbyPlayer>>;
String _$roomRealtimeEventStreamHash() =>
    r'90d69ef8d4df810d2087c97ab2061c158f085d5d';

/// Provider pour accéder au stream d'événements de room
///
/// Copied from [roomRealtimeEventStream].
@ProviderFor(roomRealtimeEventStream)
final roomRealtimeEventStreamProvider =
    AutoDisposeStreamProvider<RoomEvent>.internal(
      roomRealtimeEventStream,
      name: r'roomRealtimeEventStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomRealtimeEventStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoomRealtimeEventStreamRef = AutoDisposeStreamProviderRef<RoomEvent>;
String _$gameActionStreamHash() => r'3e352580e09670d4de263f5ac4dd94bd4a1e34ec';

/// Provider pour accéder au stream d'actions de jeu
///
/// Copied from [gameActionStream].
@ProviderFor(gameActionStream)
final gameActionStreamProvider =
    AutoDisposeStreamProvider<Map<String, dynamic>>.internal(
      gameActionStream,
      name: r'gameActionStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameActionStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameActionStreamRef =
    AutoDisposeStreamProviderRef<Map<String, dynamic>>;
String _$currentPresenceStateHash() =>
    r'5f3f14548887a3491dd8beed93334476a0a1845a';

/// Provider pour obtenir l'état actuel de présence
///
/// Copied from [currentPresenceState].
@ProviderFor(currentPresenceState)
final currentPresenceStateProvider =
    AutoDisposeProvider<Map<String, LobbyPlayer>>.internal(
      currentPresenceState,
      name: r'currentPresenceStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentPresenceStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentPresenceStateRef =
    AutoDisposeProviderRef<Map<String, LobbyPlayer>>;
String _$roomRealtimeControllerHash() =>
    r'70d98d7b98f42550926baeee7c804c812f665187';

/// Controller pour gérer le service realtime unifié d'une room
///
/// Copied from [RoomRealtimeController].
@ProviderFor(RoomRealtimeController)
final roomRealtimeControllerProvider =
    AutoDisposeAsyncNotifierProvider<RoomRealtimeController, void>.internal(
      RoomRealtimeController.new,
      name: r'roomRealtimeControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomRealtimeControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoomRealtimeController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
