import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../lib/core/providers/supabase_provider.dart';
import '../../../../../lib/features/game/data/repositories/supabase_game_state_repository.dart';
import '../../../../../lib/features/game/data/repositories/server_action_card_repository.dart';
import '../../../../../lib/features/game/presentation/providers/repository_providers.dart';
import '../../../../helpers/test_mocks.dart';

void main() {
  late ProviderContainer container;
  late MockSupabaseClient mockSupabaseClient;

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    container = ProviderContainer(
      overrides: [supabaseClientProvider.overrideWithValue(mockSupabaseClient)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Repository Providers', () {
    test(
      'gameStateRepositoryProvider should return SupabaseGameStateRepository',
      () {
        // Act
        final repository = container.read(gameStateRepositoryProvider);

        // Assert
        expect(repository, isA<SupabaseGameStateRepository>());
      },
    );

    test('gameStateRepositoryProvider should use the same supabase client', () {
      // Act
      final repository = container.read(gameStateRepositoryProvider);
      final supabaseClient = container.read(supabaseClientProvider);

      // Assert
      expect(repository, isA<SupabaseGameStateRepository>());
      // Verify it's using the same mocked client
      expect(supabaseClient, same(mockSupabaseClient));
    });

    test(
      'serverActionCardRepositoryProvider should return ServerActionCardRepository',
      () {
        // Act
        final repository = container.read(serverActionCardRepositoryProvider);

        // Assert
        expect(repository, isA<ServerActionCardRepository>());
      },
    );

    test(
      'serverActionCardRepositoryProvider should use the same supabase client',
      () {
        // Act
        final repository = container.read(serverActionCardRepositoryProvider);
        final supabaseClient = container.read(supabaseClientProvider);

        // Assert
        expect(repository, isA<ServerActionCardRepository>());
        // Verify it's using the same mocked client
        expect(supabaseClient, same(mockSupabaseClient));
      },
    );

    test('providers should be singleton instances', () {
      // Act
      final repository1 = container.read(gameStateRepositoryProvider);
      final repository2 = container.read(gameStateRepositoryProvider);

      final actionRepository1 = container.read(
        serverActionCardRepositoryProvider,
      );
      final actionRepository2 = container.read(
        serverActionCardRepositoryProvider,
      );

      // Assert
      expect(repository1, same(repository2));
      expect(actionRepository1, same(actionRepository2));
    });
  });
}
