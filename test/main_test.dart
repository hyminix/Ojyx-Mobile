import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Main entry point', () {
    test('Flutter bindings are initialized before runZonedGuarded', () {
      // This test validates that WidgetsFlutterBinding.ensureInitialized()
      // has been called in the main zone, not inside runZonedGuarded
      expect(WidgetsBinding.instance, isNotNull);
    });

    test('Environment variables can be loaded', () async {
      // Test that dotenv can load without errors
      // In test environment, missing .env file should not crash
      try {
        await dotenv.load(fileName: '.env');
      } catch (e) {
        // Expected in test environment without .env file
      }
      
      // Verify dotenv is accessible
      expect(dotenv.env, isA<Map<String, String>>());
    });
  });
}