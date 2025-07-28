import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'safe_ref_mixin.dart';

// Example provider
final exampleServiceProvider = Provider<ExampleService>((ref) => ExampleService());

class ExampleService {
  void startOperation() => print('Starting operation');
  void stopOperation() => print('Stopping operation');
}

/// Example widget demonstrating SafeRefMixin usage
class SafeRefExampleWidget extends ConsumerStatefulWidget {
  const SafeRefExampleWidget({super.key});

  @override
  ConsumerState<SafeRefExampleWidget> createState() => _SafeRefExampleWidgetState();
}

class _SafeRefExampleWidgetState extends ConsumerState<SafeRefExampleWidget> 
    with SafeRefMixin {
  
  @override
  void initState() {
    super.initState();
    
    // Example 1: Safe delayed operation
    safeDelayed(const Duration(seconds: 2), () {
      // This will only execute if widget is still mounted
      safeRef(() {
        final service = ref.read(exampleServiceProvider);
        service.startOperation();
      });
    });
    
    // Example 2: Add cleanup callback for disposal
    // Instead of using ref.read in dispose(), register the cleanup in initState
    final service = ref.read(exampleServiceProvider);
    addCleanupCallback(() {
      // This is safe because we captured the service reference in initState
      service.stopOperation();
    });
    
    // Example 3: Safe listener with auto-cleanup
    safeListen(
      exampleServiceProvider,
      (previous, next) {
        // This listener will automatically be cleaned up on disposal
        print('Service changed from $previous to $next');
      },
    );
    
    // Example 4: Safe periodic timer
    safePeriodic(const Duration(seconds: 5), (timer) {
      // This will automatically stop when widget is disposed
      print('Periodic check - widget still alive');
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Example 5: Safe watch in build method
    final service = safeWatch(exampleServiceProvider);
    
    if (service == null) {
      // Widget is being disposed
      return const SizedBox.shrink();
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('SafeRef Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example 6: Safe ref in callbacks
            safeRef(() {
              final svc = ref.read(exampleServiceProvider);
              svc.startOperation();
            });
          },
          child: const Text('Safe Operation'),
        ),
      ),
    );
  }
}