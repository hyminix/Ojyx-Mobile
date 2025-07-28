import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ojyx/core/utils/safe_ref_mixin.dart';

// Test provider
final testProvider = StateProvider<int>((ref) => 0);

// Test widget
class TestWidget extends ConsumerStatefulWidget {
  const TestWidget({super.key});
  
  @override
  ConsumerState<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends ConsumerState<TestWidget> with SafeRefMixin {
  int? delayedValue;
  bool callbackExecuted = false;
  
  @override
  void initState() {
    super.initState();
    
    // Test delayed operation
    safeDelayed(const Duration(milliseconds: 100), () {
      safeRef(() {
        delayedValue = ref.read(testProvider);
      });
    });
    
    // Test cleanup callback
    addCleanupCallback(() {
      callbackExecuted = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('Value: ${ref.watch(testProvider)}');
  }
}

void main() {
  group('SafeRefMixin Unit Tests', () {
    testWidgets('should safely handle delayed operations', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestWidget(),
          ),
        ),
      );
      
      // Widget should be mounted
      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      expect(state.isSafeToUseRef, isTrue);
      
      // Wait for delayed operation
      await tester.pump(const Duration(milliseconds: 150));
      expect(state.delayedValue, equals(0));
      
      // Dispose widget
      await tester.pumpWidget(Container());
      
      // After disposal, should not be safe
      expect(state.isSafeToUseRef, isFalse);
    });
    
    testWidgets('should execute cleanup callbacks on disposal', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestWidget(),
          ),
        ),
      );
      
      final state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      expect(state.callbackExecuted, isFalse);
      
      // Dispose widget
      await tester.pumpWidget(Container());
      
      // Cleanup callback should have been executed
      expect(state.callbackExecuted, isTrue);
    });
    
    testWidgets('safeRef should return null after disposal', (tester) async {
      late _TestWidgetState state;
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                return TestWidget();
              },
            ),
          ),
        ),
      );
      
      state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      
      // Before disposal, safeRef should work
      final result1 = state.safeRef(() => 'success');
      expect(result1, equals('success'));
      
      // Dispose widget
      await tester.pumpWidget(Container());
      
      // After disposal, safeRef should return null
      final result2 = state.safeRef(() => 'should not execute');
      expect(result2, isNull);
    });
    
    testWidgets('safeAsyncRef should handle async operations safely', (tester) async {
      late _TestWidgetState state;
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TestWidget(),
          ),
        ),
      );
      
      state = tester.state<_TestWidgetState>(find.byType(TestWidget));
      
      // Start async operation
      final future = state.safeAsyncRef(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return 'async result';
      });
      
      // Dispose widget before async completes
      await tester.pumpWidget(Container());
      
      // Async operation should return null
      final result = await future;
      expect(result, isNull);
    });
  });
}