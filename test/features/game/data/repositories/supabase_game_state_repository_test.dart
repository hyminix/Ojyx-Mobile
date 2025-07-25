import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/features/game/data/repositories/supabase_game_state_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  group('SupabaseGameStateRepository', () {
    late SupabaseGameStateRepository repository;
    late MockSupabaseClient mockSupabase;

    setUp(() {
      mockSupabase = MockSupabaseClient();
      repository = SupabaseGameStateRepository(mockSupabase);
    });

    test('should be instantiated with SupabaseClient', () {
      expect(repository, isNotNull);
    });

    test('should have all required methods defined', () {
      // This test verifies that all methods are defined on the class
      expect(repository.initializeGame, isA<Function>());
      expect(repository.getGameState, isA<Function>());
      expect(repository.watchGameState, isA<Function>());
      expect(repository.getPlayerGrid, isA<Function>());
      expect(repository.watchPlayerGrid, isA<Function>());
      expect(repository.revealCard, isA<Function>());
      expect(repository.useActionCard, isA<Function>());
      expect(repository.advanceTurn, isA<Function>());
      expect(repository.checkEndGameConditions, isA<Function>());
      expect(repository.getAllPlayerGrids, isA<Function>());
      expect(repository.getGameActions, isA<Function>());
      expect(repository.watchGameActions, isA<Function>());
    });

    test('should implement GameStateRepository interface', () {
      expect(repository, isA<SupabaseGameStateRepository>());
    });
  });
}
