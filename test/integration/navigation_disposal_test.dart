import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ojyx/core/utils/safe_ref_mixin.dart';
import 'package:ojyx/core/utils/riverpod_debug_observer.dart';

// Test providers
final testCounterProvider = StateProvider<int>((ref) => 0);
final testServiceProvider = Provider((ref) => TestService());

class TestService {
  bool isDisposed = false;
  int operationCount = 0;
  
  void performOperation() {
    operationCount++;
  }
  
  void dispose() {
    isDisposed = true;
  }
}

// Test screens
class TestHomeScreen extends ConsumerWidget {
  const TestHomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(testCounterProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Counter: $counter'),
            ElevatedButton(
              onPressed: () => context.go('/details'),
              child: const Text('Go to Details'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(testCounterProvider.notifier).state++;
              },
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

class TestDetailsScreen extends ConsumerStatefulWidget {
  const TestDetailsScreen({super.key});
  
  @override
  ConsumerState<TestDetailsScreen> createState() => _TestDetailsScreenState();
}

class _TestDetailsScreenState extends ConsumerState<TestDetailsScreen> 
    with SafeRefMixin {
  late TestService _service;
  
  @override
  void initState() {
    super.initState();
    
    // Get service reference
    _service = ref.read(testServiceProvider);
    
    // Register cleanup
    addCleanupCallback(() {
      _service.dispose();
    });
    
    // Simulate async operation
    safeDelayed(const Duration(milliseconds: 100), () {
      safeRef(() {
        _service.performOperation();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Operations: ${_service.operationCount}'),
            ElevatedButton(
              onPressed: () {
                safeRef(() {
                  _service.performOperation();
                });
              },
              child: const Text('Perform Operation'),
            ),
          ],
        ),
      ),
    );
  }
}

// Test router
final testRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TestHomeScreen(),
    ),
    GoRoute(
      path: '/details',
      builder: (context, state) => const TestDetailsScreen(),
    ),
  ],
);

// Test app
class TestApp extends StatelessWidget {
  final List<ProviderObserver>? observers;
  
  const TestApp({super.key, this.observers});
  
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      observers: observers ?? [],
      child: MaterialApp.router(
        routerConfig: testRouter,
      ),
    );
  }
}

void main() {
  group('Navigation and Disposal Tests', () {
    testWidgets('rapid navigation should not cause ref errors', (tester) async {
      final errors = <String>[];
      final observer = RiverpodDebugObserver();
      
      // Capture any errors
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (details) {
        errors.add(details.exception.toString());
        originalOnError?.call(details);
      };
      
      try {
        await tester.pumpWidget(TestApp(observers: [observer]));
        
        // Navigate to details
        await tester.tap(find.text('Go to Details'));
        await tester.pumpAndSettle();
        
        // Quickly navigate back
        await tester.tap(find.byIcon(Icons.arrow_back));
        await tester.pump(); // Don't settle, navigate immediately
        
        // Navigate to details again
        await tester.tap(find.text('Go to Details'));
        await tester.pumpAndSettle();
        
        // Verify no errors occurred
        expect(errors, isEmpty);
      } finally {
        // Restore original error handler
        FlutterError.onError = originalOnError;
      }
    });
    
    testWidgets('delayed operations should be cancelled on disposal', (tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Navigate to details
      await tester.tap(find.text('Go to Details'));
      await tester.pump(); // Start navigation but don't settle
      
      // Get service before disposal
      final element = tester.element(find.byType(TestDetailsScreen));
      final container = ProviderScope.containerOf(element);
      final service = container.read(testServiceProvider);
      final initialCount = service.operationCount;
      
      // Navigate back immediately (before async operation completes)
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Wait for what would have been the async operation
      await tester.pump(const Duration(milliseconds: 200));
      
      // Operation count should not have increased
      expect(service.operationCount, equals(initialCount));
    });
    
    testWidgets('cleanup callbacks should be executed on disposal', (tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Navigate to details
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();
      
      // Get service
      final element = tester.element(find.byType(TestDetailsScreen));
      final container = ProviderScope.containerOf(element);
      final service = container.read(testServiceProvider);
      
      expect(service.isDisposed, isFalse);
      
      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Service should be disposed
      expect(service.isDisposed, isTrue);
    });
    
    testWidgets('state should persist with keepAlive providers', (tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Increment counter
      await tester.tap(find.text('Increment'));
      await tester.pump();
      expect(find.text('Counter: 1'), findsOneWidget);
      
      // Navigate to details
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();
      
      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Counter should still be 1 (state persisted)
      expect(find.text('Counter: 1'), findsOneWidget);
    });
    
    testWidgets('multiple rapid navigations should not leak', (tester) async {
      await tester.pumpWidget(const TestApp());
      
      // Perform rapid navigation cycles
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.text('Go to Details'));
        await tester.pump();
        
        if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pump();
        }
      }
      
      await tester.pumpAndSettle();
      
      // Should be back at home screen
      expect(find.text('Home'), findsOneWidget);
    });
  });
  
  group('SafeRefMixin Edge Cases', () {
    testWidgets('operations after disposal should not crash', (tester) async {
      late _TestDetailsScreenState detailsState;
      
      await tester.pumpWidget(
        TestApp(
          observers: [
            RiverpodDebugObserver(),
          ],
        ),
      );
      
      // Navigate to details
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();
      
      // Get state reference
      final element = tester.element(find.byType(TestDetailsScreen));
      detailsState = element.findAncestorStateOfType<_TestDetailsScreenState>()!;
      
      // Navigate back
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      
      // Try to use ref after disposal - should not crash
      final result = detailsState.safeRef(() => 'Should not execute');
      expect(result, isNull);
    });
  });
}