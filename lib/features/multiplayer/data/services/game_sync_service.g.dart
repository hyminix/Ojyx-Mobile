// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameSyncServiceHash() => r'254d087e6a9153116543a512bfece8bd3e480b6e';

/// Service central unifié pour gérer toute la synchronisation du jeu
///
/// Copied from [GameSyncService].
@ProviderFor(GameSyncService)
final gameSyncServiceProvider =
    AutoDisposeAsyncNotifierProvider<GameSyncService, void>.internal(
      GameSyncService.new,
      name: r'gameSyncServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameSyncServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameSyncService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
