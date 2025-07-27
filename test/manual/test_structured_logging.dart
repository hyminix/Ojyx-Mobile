// Manual test to verify structured logging
// Run with: flutter run test/manual/test_structured_logging.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/config/app_initializer.dart';
import 'package:ojyx/core/services/logging/console_logger.dart';
import 'package:ojyx/core/services/logging/i_error_logger.dart';
import 'package:ojyx/core/providers/logger_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app
  await AppInitializer.initialize();
  
  // Initialize logger with colors
  ErrorLogger.initialize(
    useColors: true,
    onLogCallback: (entry) {
      // This callback could be used to send logs to a file or remote service
      print('Log callback: ${entry.toMap()}');
    },
  );
  
  runApp(const ProviderScope(child: TestApp()));
}

class TestApp extends ConsumerWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Test Structured Logging')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Structured Logging Test',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              
              // Test different log levels
              ElevatedButton(
                onPressed: () {
                  ErrorLogger.debug(
                    'Debug information about app state',
                    category: 'app.state',
                    data: {
                      'screen': 'test_logging',
                      'user_authenticated': false,
                    },
                  );
                },
                child: const Text('Log Debug (only in debug mode)'),
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                onPressed: () {
                  ErrorLogger.info(
                    'User clicked button',
                    category: 'user.interaction',
                    data: {
                      'button': 'info_log',
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );
                },
                child: const Text('Log Info'),
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                onPressed: () {
                  ErrorLogger.warning(
                    'Low memory detected',
                    category: 'system.performance',
                    data: {
                      'available_mb': 50,
                      'threshold_mb': 100,
                    },
                  );
                },
                child: const Text('Log Warning'),
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {
                  ErrorLogger.error(
                    'Failed to load user profile',
                    category: 'api.error',
                    data: {
                      'endpoint': '/api/profile',
                      'status_code': 404,
                      'user_id': 'test-123',
                    },
                    stackTrace: StackTrace.current,
                  );
                },
                child: const Text('Log Error (with stack trace)'),
              ),
              const SizedBox(height: 20),
              
              const Divider(),
              const Text(
                'Supabase Error Simulation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                onPressed: () async {
                  final stopwatch = Stopwatch()..start();
                  
                  // Simulate a Supabase operation
                  await Future.delayed(const Duration(milliseconds: 150));
                  
                  stopwatch.stop();
                  
                  ErrorLogger.supabaseError(
                    operation: 'create_room',
                    errorMessage: 'duplicate key value violates unique constraint "rooms_pkey"',
                    errorCode: '23505',
                    retryCount: 0,
                    duration: stopwatch.elapsed,
                    additionalData: {
                      'room_id': 'test-room-123',
                      'max_players': 4,
                    },
                  );
                },
                child: const Text('Simulate Supabase Error'),
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                onPressed: () async {
                  final stopwatch = Stopwatch()..start();
                  
                  // Simulate retries
                  for (int i = 1; i <= 3; i++) {
                    await Future.delayed(const Duration(milliseconds: 500));
                    
                    if (i < 3) {
                      ErrorLogger.warning(
                        'Network timeout, retrying...',
                        category: 'supabase.network',
                        data: {
                          'operation': 'fetch_rooms',
                          'attempt': '$i/3',
                          'elapsed_ms': stopwatch.elapsedMilliseconds,
                        },
                      );
                    } else {
                      stopwatch.stop();
                      ErrorLogger.supabaseError(
                        operation: 'fetch_rooms',
                        errorMessage: 'Connection timeout after 3 retries',
                        errorCode: 'TIMEOUT',
                        retryCount: 3,
                        duration: stopwatch.elapsed,
                      );
                    }
                  }
                },
                child: const Text('Simulate Retry with Timeout'),
              ),
              const SizedBox(height: 20),
              
              const Divider(),
              const Text(
                'Rate Limiting Test',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  // Spam logs to test rate limiting
                  for (int i = 0; i < 150; i++) {
                    ErrorLogger.info(
                      'Spam message $i',
                      category: 'spam.test',
                      data: {'index': i},
                    );
                  }
                  
                  ErrorLogger.instance.flush();
                  
                  ErrorLogger.info(
                    'Rate limiting test completed',
                    category: 'test.complete',
                  );
                },
                child: const Text('Test Rate Limiting (150 logs)'),
              ),
              const SizedBox(height: 20),
              
              const Divider(),
              const Text(
                'Logger Configuration',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              Consumer(
                builder: (context, ref, child) {
                  final config = ref.watch(loggerConfigProvider);
                  
                  return Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Use Colors'),
                        value: config.useColors,
                        onChanged: (value) {
                          ref.read(loggerConfigProvider.notifier)
                              .setUseColors(value);
                          
                          ErrorLogger.info(
                            'Colors ${value ? "enabled" : "disabled"}',
                            category: 'config.change',
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Buffer Size'),
                        subtitle: Text('${config.bufferSize} logs'),
                      ),
                      ListTile(
                        title: const Text('Rate Limit'),
                        subtitle: Text('${config.maxLogsPerMinute} logs/minute'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 10),
              
              ElevatedButton(
                onPressed: () async {
                  ErrorLogger.info(
                    'Flushing all buffered logs',
                    category: 'manual.flush',
                  );
                  
                  await ErrorLogger.instance.flush();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All logs flushed to console'),
                    ),
                  );
                },
                child: const Text('Flush Logs Manually'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}