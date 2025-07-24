// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameInitializationUseCaseHash() =>
    r'8a15b1719c410fd31c5046637be4bede5ee1e7d3';

/// See also [gameInitializationUseCase].
@ProviderFor(gameInitializationUseCase)
final gameInitializationUseCaseProvider =
    AutoDisposeProvider<GameInitializationUseCase>.internal(
      gameInitializationUseCase,
      name: r'gameInitializationUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameInitializationUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameInitializationUseCaseRef =
    AutoDisposeProviderRef<GameInitializationUseCase>;
String _$gameStateNotifierHash() => r'4c0fe805e5a8dbf262456a01d4ac7ff6bd318e60';

/// See also [GameStateNotifier].
@ProviderFor(GameStateNotifier)
final gameStateNotifierProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, GameState?>.internal(
      GameStateNotifier.new,
      name: r'gameStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gameStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GameStateNotifier = AutoDisposeNotifier<GameState?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
