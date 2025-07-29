// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameSyncEventStreamHash() =>
    r'ccf0ff22a794173633f41f752230cec82932ec7b';

/// Provider pour accéder au stream d'événements de synchronisation
///
/// Copied from [gameSyncEventStream].
@ProviderFor(gameSyncEventStream)
final gameSyncEventStreamProvider =
    AutoDisposeStreamProvider<GameSyncEvent>.internal(
      gameSyncEventStream,
      name: r'gameSyncEventStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameSyncEventStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameSyncEventStreamRef = AutoDisposeStreamProviderRef<GameSyncEvent>;
String _$chatMessageStreamHash() => r'ad9c86f2c7f42ef322381cf62f04a55ed0163468';

/// Provider pour filtrer les événements par type
/// Note: Les providers génériques ne sont pas supportés par riverpod_annotation
/// On crée des providers spécifiques pour chaque type d'événement nécessaire
/// Provider pour les événements de chat uniquement
///
/// Copied from [chatMessageStream].
@ProviderFor(chatMessageStream)
final chatMessageStreamProvider =
    AutoDisposeStreamProvider<ChatMessageEvent>.internal(
      chatMessageStream,
      name: r'chatMessageStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatMessageStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatMessageStreamRef = AutoDisposeStreamProviderRef<ChatMessageEvent>;
String _$criticalGameEventsStreamHash() =>
    r'9cbb3f3fbd2ebe55de96c247e681bcfddea8f034';

/// Provider pour les événements de jeu critiques
///
/// Copied from [criticalGameEventsStream].
@ProviderFor(criticalGameEventsStream)
final criticalGameEventsStreamProvider =
    AutoDisposeStreamProvider<GameSyncEvent>.internal(
      criticalGameEventsStream,
      name: r'criticalGameEventsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$criticalGameEventsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CriticalGameEventsStreamRef =
    AutoDisposeStreamProviderRef<GameSyncEvent>;
String _$syncErrorStreamHash() => r'e8103be2a0e05c54daea079076ae991943af3fef';

/// Provider pour les événements d'erreur
///
/// Copied from [syncErrorStream].
@ProviderFor(syncErrorStream)
final syncErrorStreamProvider =
    AutoDisposeStreamProvider<SyncErrorEvent>.internal(
      syncErrorStream,
      name: r'syncErrorStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$syncErrorStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncErrorStreamRef = AutoDisposeStreamProviderRef<SyncErrorEvent>;
String _$gameSyncControllerHash() =>
    r'9ca2ae761afdc2bc71cce3415258c224dc950502';

/// Controller pour gérer le GameSyncService unifié
///
/// Copied from [GameSyncController].
@ProviderFor(GameSyncController)
final gameSyncControllerProvider =
    AutoDisposeAsyncNotifierProvider<GameSyncController, void>.internal(
      GameSyncController.new,
      name: r'gameSyncControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameSyncControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameSyncController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
