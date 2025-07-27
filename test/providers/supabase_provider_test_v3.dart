import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/riverpod_test_helpers.dart';
import 'package:ojyx/core/providers/supabase_provider.dart' as legacy;
import 'package:ojyx/core/providers/supabase_provider_v2.dart' as modern;
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('SupabaseProvider Migration', () {
    setUpAll(() async {
      // Initialize Supabase for testing
      await Supabase.initialize(
        url: 'https://test.supabase.co',
        anonKey: 'test-anon-key',
      );
    });

    test('legacy provider should provide SupabaseClient', () {
      final container = createTestContainer();
      final client = container.read(legacy.supabaseClientProvider);

      expect(client, isNotNull);
      expect(client, isA<SupabaseClient>());

      container.dispose();
    });

    test('modern provider should provide same SupabaseClient', () {
      final container = createTestContainer();
      final client = container.read(modern.supabaseClientProvider);

      expect(client, isNotNull);
      expect(client, isA<SupabaseClient>());
      expect(client, equals(Supabase.instance.client));

      container.dispose();
    });

    test('both providers should return the same instance', () {
      final container = createTestContainer();
      // Note: In real migration, we'd import only one
      // This is just to verify they work the same way
      final legacyClient = container.read(legacy.supabaseClientProvider);
import './helpers/supabase_test_helpers.dart';
      final modernClient = container.read(modern.supabaseClientProvider);

      expect(modernClient, equals(legacyClient));

      container.dispose();
    });
  });
}
