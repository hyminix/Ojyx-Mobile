// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_rooms_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableRoomsNotifierHash() =>
    r'88eaa1bd77e3bcf9b86b50c93bc334e380645172';

/// Provider qui maintient une liste en temps réel des parties disponibles
///
/// Copied from [AvailableRoomsNotifier].
@ProviderFor(AvailableRoomsNotifier)
final availableRoomsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      AvailableRoomsNotifier,
      List<Room>
    >.internal(
      AvailableRoomsNotifier.new,
      name: r'availableRoomsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableRoomsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AvailableRoomsNotifier = AutoDisposeAsyncNotifier<List<Room>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
