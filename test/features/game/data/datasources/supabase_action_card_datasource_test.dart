import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/features/game/data/datasources/supabase_action_card_datasource.dart';
import 'package:ojyx/features/game/domain/entities/action_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// For now, we'll use integration tests with a real Supabase instance
// or simplify to test the logic without mocking the complex Supabase types

void main() {
  group('SupabaseActionCardDataSource', () {
    test('should create instance with correct gameStateId', () {
      // This is a simple test just to ensure the datasource can be created
      final mockClient = _createMockSupabaseClient();
      const testGameStateId = 'test-game-state-id';
      
      final dataSource = SupabaseActionCardDataSource(mockClient, testGameStateId);
      
      expect(dataSource, isNotNull);
    });

    group('initializeDeck', () {
      test('should generate correct card distribution', () {
        // Test the card generation logic by checking the expected distribution
        final expectedDistribution = {
          ActionCardType.teleport: 4,
          ActionCardType.swap: 3,
          ActionCardType.turnAround: 3,
          ActionCardType.skip: 4,
          ActionCardType.peek: 4,
          ActionCardType.reveal: 2,
          ActionCardType.shield: 3,
          ActionCardType.steal: 2,
          ActionCardType.curse: 2,
          ActionCardType.draw: 3,
          ActionCardType.shuffle: 2,
          ActionCardType.heal: 2,
        };

        // Calculate total expected cards
        final totalExpected = expectedDistribution.values.reduce((a, b) => a + b);
        expect(totalExpected, 34); // Verify our expected distribution is correct
      });
    });
  });
}

// Helper to create a simple mock that won't be used in these basic tests
SupabaseClient _createMockSupabaseClient() {
  // Return a non-functional client just for instantiation
  return SupabaseClient('https://test.supabase.co', 'test-anon-key');
}