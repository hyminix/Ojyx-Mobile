import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/utils/safe_ref_mixin.dart';

// Test provider
final testProvider = StateProvider<int>((ref) => 0);

// Test widget using SafeRefMixin
class TestWidget extends ConsumerStatefulWidget {
  final VoidCallback? onInit;
  final VoidCallback? onDispose;
  
  const TestWidget({
    super.key,
    this.onInit,
    this.onDispose,
  });

  @override
  ConsumerState<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends ConsumerState<TestWidget> with SafeRefMixin {
  int? lastValue;
  bool cleanupCalled = false;
  
  @override
  void initState() {
    super.initState();
    
    widget.onInit?.call();
    
    // Test cleanup callback
    addCleanupCallback(() {
      cleanupCalled = true;
    });
    
    // Test safe listener
    safeListen(testProvider, (previous, next) {
      lastValue = next;
    });
  }
  
  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final value = safeWatch(testProvider);
    
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text('Value: $value'),
              ElevatedButton(
                onPressed: () {
                  safeRef(() {
                    ref.read(testProvider.notifier).state++;
                  });
                },
                child: const Text('Increment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('SafeRefMixin', () {
    testWidgets('should safely handle ref operations', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TestWidget(),
        ),
      );
      
      // Find and tap the increment button
      await tester.tap(find.text('Increment'));
      await tester.pump();
      
      // Verify the value was incremented
      expect(find.text('Value: 1'), findsOneWidget);
    });
    
    testWidgets('should handle cleanup callbacks on disposal', (tester) async {
      bool initCalled = false;
      bool disposeCalled = false;
      
      await tester.pumpWidget(
        ProviderScope(
          child: TestWidget(
            onInit: () => initCalled = true,
            onDispose: () => disposeCalled = true,
          ),
        ),
      );
      
      expect(initCalled, isTrue);
      expect(disposeCalled, isFalse);
      
      // Dispose the widget
      await tester.pumpWidget(const SizedBox());
      
      expect(disposeCalled, isTrue);
    });
    
    testWidgets('should not crash when using ref after disposal', (tester) async {
      late _TestWidgetState state;
      
      await tester.pumpWidget(
        ProviderScope(
          child: TestWidget(
            onInit: () {
              // Get reference to state
              final context = tester.element(find.byType(TestWidget));
              state = context.findAncestorStateOfType<_TestWidgetState>()!;
            },
          ),
        ),
      );
      
      // Dispose the widget
      await tester.pumpWidget(const SizedBox());
      
      // Try to use ref after disposal - should not crash
      final result = state.safeRef(() => state.ref.read(testProvider));
      expect(result, isNull);
      
      // Try async operation after disposal
      final asyncResult = await state.safeAsyncRef(() async {
        return state.ref.read(testProvider);
      });
      expect(asyncResult, isNull);
    });
    
    testWidgets('should handle delayed operations safely', (tester) async {
      bool delayedExecuted = false;
      
      await tester.pumpWidget(
        ProviderScope(
          child: TestWidget(
            onInit: () {
              final context = tester.element(find.byType(TestWidget));
              final state = context.findAncestorStateOfType<_TestWidgetState>()!;
              
              // Schedule delayed operation
              state.safeDelayed(
                const Duration(milliseconds: 100),
                () => delayedExecuted = true,
              );
            },
          ),
        ),
      );
      
      // Dispose before delay completes
      await tester.pumpWidget(const SizedBox());
      
      // Wait for delay
      await tester.pump(const Duration(milliseconds: 200));
      
      // Operation should not have executed
      expect(delayedExecuted, isFalse);
    });
  });
}