// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_realtime_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roomRealtimeServiceHash() =>
    r'149033f90738ceb0aed77dfd10200d704d36a8b8';

/// Service unifié pour gérer toute la synchronisation realtime d'une room
/// Utilise un seul channel room:{roomId} avec Supabase Presence
///
/// Copied from [RoomRealtimeService].
@ProviderFor(RoomRealtimeService)
final roomRealtimeServiceProvider =
    AutoDisposeAsyncNotifierProvider<RoomRealtimeService, void>.internal(
      RoomRealtimeService.new,
      name: r'roomRealtimeServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$roomRealtimeServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RoomRealtimeService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
