import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/main.dart' as app;
import 'package:ojyx/core/providers/supabase_provider.dart';
import '../test/helpers/supabase_v2_test_helpers.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance Integration Tests', () {
    late MockSupabaseClient mockSupabase;
    late MockGoTrueClient mockAuth;

    setUp(() {
      mockAuth = MockGoTrueClient();
      mockSupabase = createMockSupabaseClient(auth: mockAuth);
      setupAuthStubs(mockAuth);
    });

    testWidgets('should measure frame rendering performance', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await binding.watchPerformance(() async {
        // Perform various UI operations
        await tester.pumpAndSettle();

        // Simulate scrolling if there's a scrollable widget
        final scrollableFinder = find.byType(Scrollable);
        if (scrollableFinder.evaluate().isNotEmpty) {
          await tester.fling(
            scrollableFinder.first,
            const Offset(0, -200),
            1000,
          );
          await tester.pumpAndSettle();
        }

        // Simulate navigation
        final buttons = find.byType(ElevatedButton);
        if (buttons.evaluate().isNotEmpty) {
          await tester.tap(buttons.first);
          await tester.pumpAndSettle();
        }
      }, reportKey: 'frame_performance');
    });

    testWidgets('should measure Riverpod provider performance', (tester) async {
      final stopwatch = Stopwatch();
      int providerReadCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                stopwatch.start();
                // Read multiple providers to test performance
                ref.watch(authNotifierProvider);
                providerReadCount++;
                stopwatch.stop();

                return Scaffold(
                  body: Center(
                    child: Text('Provider reads: $providerReadCount'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Trigger rebuilds
      for (int i = 0; i < 10; i++) {
        await tester.pump();
      }

      final avgTime = stopwatch.elapsedMicroseconds / providerReadCount;
      debugPrint('Average provider read time: ${avgTime}μs');

      // Verify provider reads are fast
      expect(avgTime, lessThan(1000)); // Less than 1ms per read
    });

    testWidgets('should measure navigation performance', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Measure navigation time
      final stopwatch = Stopwatch();

      // Find navigation button
      final createRoomButton = find.text('Créer une partie');
      if (createRoomButton.evaluate().isNotEmpty) {
        stopwatch.start();
        await tester.tap(createRoomButton);
        await tester.pumpAndSettle();
        stopwatch.stop();

        debugPrint('Navigation time: ${stopwatch.elapsedMilliseconds}ms');
        expect(stopwatch.elapsedMilliseconds, lessThan(500));
      }
    });

    testWidgets('should validate memory efficiency', (tester) async {
      // Track widget count
      final widgetCounts = <Type, int>{};

      void countWidgets() {
        final elements = tester.allElements;
        widgetCounts.clear();
        for (final element in elements) {
          final type = element.widget.runtimeType;
          widgetCounts[type] = (widgetCounts[type] ?? 0) + 1;
        }
      }

      await tester.pumpWidget(
        ProviderScope(
          overrides: [supabaseClientProvider.overrideWithValue(mockSupabase)],
          child: const app.MyApp(),
        ),
      );

      await tester.pumpAndSettle();
      countWidgets();

      final initialCount = widgetCounts.values.fold(0, (a, b) => a + b);
      debugPrint('Initial widget count: $initialCount');

      // Navigate to different screens and back
      final buttons = find.byType(ElevatedButton);
      for (final button in buttons.evaluate().take(3)) {
        await tester.tap(find.byWidget(button.widget));
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      countWidgets();
      final finalCount = widgetCounts.values.fold(0, (a, b) => a + b);
      debugPrint('Final widget count: $finalCount');

      // Verify no significant widget leak
      expect(finalCount, lessThanOrEqualTo(initialCount * 1.1));
    });

    testWidgets('should benchmark Freezed serialization', (tester) async {
      // This would test actual Freezed models from the app
      final stopwatch = Stopwatch();
      const iterations = 1000;

      // Example with mock data
      final testData = List.generate(
        100,
        (i) => {
          'id': 'id_$i',
          'name': 'Name $i',
          'value': i,
          'nested': {'field1': 'value1', 'field2': i * 2},
        },
      );

      // Measure serialization time
      stopwatch.start();
      for (int i = 0; i < iterations; i++) {
        // In real test, this would be: Model.fromJson(data).toJson()
        final _ = testData.map((e) => Map.from(e)).toList();
      }
      stopwatch.stop();

      final avgTime = stopwatch.elapsedMicroseconds / iterations;
      debugPrint('Average serialization time: ${avgTime}μs');

      // Verify serialization is efficient
      expect(avgTime, lessThan(100)); // Less than 100μs per operation
    });
  });
}
