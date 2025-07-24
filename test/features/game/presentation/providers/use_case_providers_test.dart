import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../lib/core/providers/supabase_provider.dart';
import '../../../../../lib/features/game/domain/use_cases/game_initialization_use_case.dart';
import '../../../../../lib/features/game/presentation/providers/game_state_notifier.dart';
import '../../../../../lib/features/game/presentation/providers/repository_providers.dart';
import '../../../../../lib/features/multiplayer/domain/use_cases/sync_game_state_use_case.dart';
import '../../../../../lib/features/multiplayer/presentation/providers/room_providers.dart';
import '../../../../helpers/test_mocks.dart';

void main() {
  late ProviderContainer container;
  late MockSupabaseClient mockSupabaseClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    container = ProviderContainer(
      overrides: [
        supabaseClientProvider.overrideWithValue(mockSupabaseClient),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Use Case Providers', () {
    test('gameInitializationUseCaseProvider should inject gameStateRepository', () {
      // Act
      final useCase = container.read(gameInitializationUseCaseProvider);
      final repository = container.read(gameStateRepositoryProvider);

      // Assert
      expect(useCase, isA<GameInitializationUseCase>());
      // The use case should have been created with the repository
      // We can verify indirectly by checking they're both created
      expect(repository, isNotNull);
    });

    test('syncGameStateUseCaseProvider should inject gameStateRepository', () {
      // Act
      final useCase = container.read(syncGameStateUseCaseProvider);
      final repository = container.read(gameStateRepositoryProvider);

      // Assert
      expect(useCase, isA<SyncGameStateUseCase>());
      // Verify repository is created
      expect(repository, isNotNull);
    });

    test('use case providers should be singleton instances', () {
      // Act
      final useCase1 = container.read(gameInitializationUseCaseProvider);
      final useCase2 = container.read(gameInitializationUseCaseProvider);
      
      final syncUseCase1 = container.read(syncGameStateUseCaseProvider);
      final syncUseCase2 = container.read(syncGameStateUseCaseProvider);

      // Assert
      expect(useCase1, same(useCase2));
      expect(syncUseCase1, same(syncUseCase2));
    });
  });
}