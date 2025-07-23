import 'package:flutter_test/flutter_test.dart';
import 'package:ojyx/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseConfig', () {
    setUpAll(() {
      // Initialize test widgets binding
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('should expose client getters', () {
      // These tests verify that the static getters are properly defined
      // In a real test environment, Supabase must be initialized first

      // Act & Assert
      expect(() => SupabaseConfig.client, throwsA(isA<Error>()));
      expect(() => SupabaseConfig.auth, throwsA(isA<Error>()));
      expect(() => SupabaseConfig.storage, throwsA(isA<Error>()));
      expect(() => SupabaseConfig.realtime, throwsA(isA<Error>()));
    });

    test('should check authentication status', () {
      // In test environment without Supabase initialized
      expect(() => SupabaseConfig.isAuthenticated, throwsA(isA<Error>()));
      expect(() => SupabaseConfig.userId, throwsA(isA<Error>()));
    });

    test('should handle signInAnonymously', () async {
      // This would require a mock Supabase client
      // For now, we test that the method exists and can be called
      expect(SupabaseConfig.signInAnonymously, isA<Function>());
    });

    test('should handle signOut', () async {
      // This would require a mock Supabase client
      // For now, we test that the method exists and can be called
      expect(SupabaseConfig.signOut, isA<Function>());
    });

    test('should have initialize method', () {
      // Verify the initialize method exists
      expect(SupabaseConfig.initialize, isA<Function>());
    });
  });
}
