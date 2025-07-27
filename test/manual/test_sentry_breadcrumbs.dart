// Manual test to verify Sentry breadcrumbs and error enrichment
// Run with: flutter run test/manual/test_sentry_breadcrumbs.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/config/app_initializer.dart';
import 'package:ojyx/core/errors/supabase_exceptions.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
        appBar: AppBar(title: const Text('Test Sentry Breadcrumbs')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Test Sentry Breadcrumbs & Context',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Test 1: Successful operation with breadcrumbs
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== TEST 1: Successful Operation ===');
                  try {
                    final result = await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () async {
                        // Simulate a successful database query
                        await Future.delayed(const Duration(milliseconds: 150));
                        return {
                          'id': 'test-123',
                          'name': 'Success Test',
                          'created_at': DateTime.now().toIso8601String(),
                        };
                      },
                      operation: 'test_successful_query',
                      context: {
                        'test_type': 'success',
                        'user_id': 'test-user',
                      },
                    );
                    debugPrint('Success result: $result');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Operation succeeded! Check console for breadcrumbs'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    debugPrint('Unexpected error: $e');
                  }
                },
                child: const Text('Test Successful Operation'),
              ),
              const SizedBox(height: 10),
              
              // Test 2: Network error with retry
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== TEST 2: Network Error with Retry ===');
                  var attemptCount = 0;
                  try {
                    await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () async {
                        attemptCount++;
                        debugPrint('Attempt $attemptCount - Throwing SocketException');
                        throw const SocketException('Connection refused');
                      },
                      operation: 'test_network_error',
                      context: {
                        'test_type': 'network_error',
                        'endpoint': 'api.example.com',
                      },
                      maxRetries: 3,
                      retryDelay: const Duration(seconds: 1),
                    );
                  } catch (e) {
                    debugPrint('Final error after $attemptCount attempts: $e');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Network error after $attemptCount retries: $e'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: const Text('Test Network Error (with retry)'),
              ),
              const SizedBox(height: 10),
              
              // Test 3: Database constraint error (no retry)
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== TEST 3: Database Constraint Error ===');
                  try {
                    await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () async {
                        throw PostgrestException(
                          message: 'duplicate key value violates unique constraint "rooms_pkey"',
                          code: '23505',
                          details: 'Key (id)=(test-room) already exists.',
                        );
                      },
                      operation: 'insert_duplicate_room',
                      context: {
                        'room_id': 'test-room',
                        'user_id': 'test-user',
                        'sensitive_email': 'user@example.com', // Will be sanitized
                      },
                    );
                  } catch (e) {
                    debugPrint('Database error (no retry): $e');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Database error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Test Database Error (no retry)'),
              ),
              const SizedBox(height: 10),
              
              // Test 4: Auth error
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== TEST 4: Auth Error ===');
                  try {
                    await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () async {
                        throw const AuthException(
                          'Invalid login credentials',
                          statusCode: '401',
                        );
                      },
                      operation: 'user_login',
                      context: {
                        'login_method': 'email',
                        'password': 'should_be_redacted', // Sensitive key
                      },
                    );
                  } catch (e) {
                    debugPrint('Auth error: $e');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Auth error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Test Auth Error'),
              ),
              const SizedBox(height: 10),
              
              // Test 5: Timeout with performance metrics
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== TEST 5: Timeout Error ===');
                  var attemptCount = 0;
                  try {
                    await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () async {
                        attemptCount++;
                        debugPrint('Attempt $attemptCount - Simulating timeout');
                        await Future.delayed(const Duration(seconds: 2));
                        throw TimeoutException('Request timeout', const Duration(seconds: 2));
                      },
                      operation: 'slow_query',
                      context: {
                        'query': 'SELECT * FROM large_table',
                        'expected_rows': 10000,
                      },
                      maxRetries: 2,
                    );
                  } catch (e) {
                    debugPrint('Timeout error after $attemptCount attempts: $e');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Timeout after $attemptCount attempts: $e'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: const Text('Test Timeout (slow operation)'),
              ),
              const SizedBox(height: 10),
              
              // Test 6: Complex scenario with eventual success
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== TEST 6: Eventual Success After Retry ===');
                  var attemptCount = 0;
                  try {
                    final result = await SupabaseExceptionHandler.handleSupabaseCall(
                      call: () async {
                        attemptCount++;
                        debugPrint('Attempt $attemptCount');
                        
                        if (attemptCount < 2) {
                          throw const SocketException('Network unstable');
                        }
                        
                        // Success on second attempt
                        await Future.delayed(const Duration(milliseconds: 100));
                        return {
                          'id': 'retry-success',
                          'attempt': attemptCount,
                          'message': 'Success after retry!',
                        };
                      },
                      operation: 'flaky_network_operation',
                      context: {
                        'test_type': 'eventual_success',
                      },
                      maxRetries: 3,
                      retryDelay: const Duration(milliseconds: 500),
                    );
                    
                    debugPrint('Success after $attemptCount attempts: $result');
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Success after $attemptCount attempts!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    debugPrint('Failed after retries: $e');
                  }
                },
                child: const Text('Test Eventual Success'),
              ),
              const SizedBox(height: 20),
              
              // Manual breadcrumb addition
              ElevatedButton(
                onPressed: () async {
                  debugPrint('\n=== Manual Breadcrumb ===');
                  await Sentry.addBreadcrumb(
                    Breadcrumb(
                      message: 'User clicked manual breadcrumb button',
                      category: 'user_interaction',
                      level: SentryLevel.info,
                      data: {
                        'button': 'manual_breadcrumb',
                        'timestamp': DateTime.now().toIso8601String(),
                      },
                    ),
                  );
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Manual breadcrumb added to Sentry'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                child: const Text('Add Manual Breadcrumb'),
              ),
              const SizedBox(height: 10),
              
              // Trigger error to see all breadcrumbs
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  debugPrint('\n=== TRIGGER ERROR TO SEND BREADCRUMBS ===');
                  try {
                    throw Exception('Manual error to send breadcrumbs to Sentry');
                  } catch (e, stack) {
                    await Sentry.captureException(e, stackTrace: stack);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error sent to Sentry with all breadcrumbs!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Send Error to Sentry (with breadcrumbs)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}