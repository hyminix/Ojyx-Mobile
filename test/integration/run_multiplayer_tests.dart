import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

// Import all test files
import 'multiplayer/join_leave_simultaneous_test.dart' as join_leave_tests;
import 'multiplayer/disconnection_reconnection_test.dart' as disconnection_tests;
import 'multiplayer/load_test_8_players.dart' as load_tests;
import 'multiplayer/rls_consistency_test.dart' as rls_tests;

/// Main test runner for all multiplayer integration tests
void main() {
  print('🚀 Starting Ojyx Multiplayer Integration Tests');
  print('=' * 60);
  
  // Check environment variables
  final supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  final supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
  
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    print('❌ ERROR: Missing required environment variables!');
    print('Please run with:');
    print('flutter test --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key');
    exit(1);
  }
  
  print('✅ Environment variables configured');
  print('📍 Supabase URL: ${supabaseUrl.substring(0, 20)}...');
  print('');
  
  setUpAll(() async {
    print('🔧 Initializing Supabase...');
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      print('✅ Supabase initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Supabase: $e');
      exit(1);
    }
    print('');
  });
  
  group('🎮 Multiplayer Integration Test Suite', () {
    group('1️⃣ Join/Leave Simultaneous Operations', () {
      print('Running join/leave tests...');
      join_leave_tests.main();
    });
    
    group('2️⃣ Disconnection/Reconnection Handling', () {
      print('Running disconnection/reconnection tests...');
      disconnection_tests.main();
    });
    
    group('3️⃣ Load Testing with 8 Players', () {
      print('Running load tests...');
      load_tests.main();
    });
    
    group('4️⃣ RLS Policy Consistency', () {
      print('Running RLS consistency tests...');
      rls_tests.main();
    });
  });
  
  tearDownAll(() async {
    print('\n🧹 Cleaning up test data...');
    try {
      // Additional cleanup if needed
      await Supabase.instance.client.dispose();
      print('✅ Cleanup completed');
    } catch (e) {
      print('⚠️  Cleanup warning: $e');
    }
    
    print('\n📊 Test suite completed!');
    print('=' * 60);
  });
}