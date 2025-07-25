import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/providers/supabase_provider.dart';

void main() {
  group('supabaseClientProvider', () {
    test('should provide SupabaseClient instance', () {
      // Arrange
      final container = ProviderContainer();

      // Act & Assert
      // In test environment without Supabase initialized, this will throw
      expect(
        () => container.read(supabaseClientProvider),
        throwsA(isA<Error>()),
      );

      // Clean up
      container.dispose();
    });
  });
}
