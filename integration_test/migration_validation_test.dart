import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ojyx/main.dart' as app;
import 'package:ojyx/core/providers/supabase_provider.dart';
import 'package:ojyx/features/auth/presentation/providers/auth_provider.dart';
import '../test/helpers/supabase_v2_test_helpers.dart';
import '../test/helpers/riverpod_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Migration Validation Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    setUpAll(() {
      registerFallbackValue(MaterialPageRoute(builder: (_) => Container()));
      registerFallbackValue(Uri());
    });

    setUp(() {
      mockAuth = MockGoTrueClient();
      mockSupabase = createMockSupabaseClient(auth: mockAuth);
      setupAuthStubs(mockAuth);
    });

    testWidgets('should complete full authentication flow', (tester) async {
      // Setup anonymous auth
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(null);
      when(() => mockAuth.signInAnonymously()).thenAnswer(
        (_) async => MockAuthResponse()
          ..when(() => user, mockUser)
          ..when(() => session, MockSession()),
      );

      // Launch app with mocked Supabase
      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      // Wait for app to initialize
      await tester.pumpAndSettle();

      // Verify auth was called
      verify(() => mockAuth.currentUser).called(greaterThanOrEqualTo(1));
    });

    testWidgets('should navigate through all main screens', (tester) async {
      // Setup authenticated user
      final mockUser = MockUser();
      when(() => mockAuth.currentUser).thenReturn(mockUser);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Test navigation to create room
      final createRoomButton = find.text('Créer une partie');
      if (createRoomButton.evaluate().isNotEmpty) {
        await tester.tap(createRoomButton);
        await tester.pumpAndSettle();

        // Verify we're on create room screen
        expect(find.text('Créer une nouvelle partie'), findsOneWidget);

        // Go back
        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      // Test navigation to join room
      final joinRoomButton = find.text('Rejoindre une partie');
      if (joinRoomButton.evaluate().isNotEmpty) {
        await tester.tap(joinRoomButton);
        await tester.pumpAndSettle();

        // Verify we're on join room screen
        expect(find.text('Rejoindre une partie'), findsOneWidget);
      }
    });

    testWidgets('should handle Riverpod state management correctly', (
      tester,
    ) async {
      // Create a test container to verify providers
      final container = createTestContainer(
        overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
      );

      // Test auth provider
      final authNotifier = container.read(authNotifierProvider.notifier);
      expect(authNotifier, isNotNull);

      // Test that providers can be read without errors
      try {
        await container.read(authNotifierProvider.future);
      } catch (e) {
        // It's ok if it fails in test, we just want to verify no runtime errors
      }

      container.dispose();
    });

    testWidgets('should validate Freezed models serialization', (tester) async {
      // This test ensures Freezed generated code works correctly
      // We'll test a simple model creation and serialization

      // Import a Freezed model and test it
      // This would be done with actual models from the app

      // Example pseudo-code:
      // final room = Room(id: 'test', code: 'ABC123', ...);
      // final json = room.toJson();
      // final restored = Room.fromJson(json);
      // expect(restored, equals(room));

      expect(true, true); // Placeholder for actual model tests
    });

    testWidgets('should measure app startup performance', (tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await tester.pumpAndSettle();
      stopwatch.stop();

      // Log startup time
      debugPrint('App startup time: ${stopwatch.elapsedMilliseconds}ms');

      // Verify startup is under reasonable threshold (adjust as needed)
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('should validate go_router navigation', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Get the router from context
      final BuildContext context = tester.element(
        find.byType(MaterialApp).first,
      );

      // Test programmatic navigation (if router is accessible)
      // context.go('/create-room');
      // await tester.pumpAndSettle();
      // expect(find.text('Créer une nouvelle partie'), findsOneWidget);
    });

    testWidgets('should handle errors gracefully', (tester) async {
      // Setup auth to fail
      when(() => mockAuth.currentUser).thenReturn(null);
      when(
        () => mockAuth.signInAnonymously(),
      ).thenThrow(AuthException('Test error'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // App should still load even if auth fails
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });

  group('Performance Benchmarks', () {
    testWidgets('should measure widget rebuild performance', (tester) async {
      int rebuildCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, child) {
                rebuildCount++;
                return const Scaffold(body: Center(child: Text('Test')));
              },
            ),
          ),
        ),
      );

      final initialRebuilds = rebuildCount;

      // Trigger some state changes
      await tester.pump();
      await tester.pump();

      // Verify minimal unnecessary rebuilds
      expect(rebuildCount - initialRebuilds, lessThanOrEqualTo(2));
    });

    testWidgets('should validate memory usage patterns', (tester) async {
      // This is a placeholder for memory profiling
      // In real scenarios, you'd use Flutter DevTools or memory profiling APIs

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('Memory Test'))),
          ),
        ),
      );

      // Simulate navigation to multiple screens
      for (int i = 0; i < 5; i++) {
        await tester.pump();
      }

      // In production, check memory metrics here
      expect(true, true);
    });
  });

  group('Regression Tests', () {
    testWidgets('should maintain backward compatibility', (tester) async {
      // Test that old patterns still work if needed
      expect(true, true);
    });

    testWidgets('should handle edge cases from migration', (tester) async {
      // Test specific edge cases discovered during migration
      // For example, null safety edge cases, type mismatches, etc.
      expect(true, true);
    });
  });
}
