// Manual test to verify Supabase error handling
// Run with: flutter run test/manual/test_supabase_errors.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/config/app_initializer.dart';
import 'package:ojyx/core/errors/supabase_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app (including Sentry)
  await AppInitializer.initialize();
  
  runApp(const ProviderScope(child: TestApp()));
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Supabase Errors')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    // This should fail with a PostgrestException
                    final result = await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () => Supabase.instance.client
                          .from('non_existent_table')
                          .select()
                          .single(),
                      operation: 'test_non_existent_table',
                    );
                    print('Result: $result');
                  } catch (e) {
                    print('Caught error: $e');
                  }
                },
                child: const Text('Test Non-Existent Table'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // This should fail with duplicate key
                    final result = await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () => Supabase.instance.client
                          .from('rooms')
                          .insert({
                            'id': 'test-duplicate-id',
                            'creator_id': 'test-user',
                            'player_ids': ['test-user'],
                            'status': 'waiting',
                            'max_players': 4,
                          })
                          .select()
                          .single(),
                      operation: 'test_duplicate_insert',
                    );
                    print('Result: $result');
                  } catch (e) {
                    print('Caught error: $e');
                  }
                },
                child: const Text('Test Duplicate Insert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}