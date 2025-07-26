import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sentry_provider.dart';
import '../services/sentry_service.dart';

/// Example base widget with built-in performance monitoring
abstract class PerformanceMonitoredWidget extends ConsumerWidget {
  const PerformanceMonitoredWidget({super.key});

  /// The widget name for tracking
  String get widgetName;

  /// Build method to be implemented by subclasses
  Widget buildWidget(BuildContext context, WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Track navigation to this widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SentryService.trackNavigation(from: 'previous', to: widgetName);
    });

    // Track widget build performance
    return FutureBuilder<Widget>(
      future: ref
          .read(performanceMonitorProvider)
          .trackWidgetBuild(
            widgetName: widgetName,
            buildFunction: () async {
              return buildWidget(context, ref);
            },
          ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }

        // Fallback to direct build if tracking fails
        return buildWidget(context, ref);
      },
    );
  }
}

/// Example stateful widget with performance monitoring
abstract class PerformanceMonitoredStatefulWidget
    extends ConsumerStatefulWidget {
  const PerformanceMonitoredStatefulWidget({super.key});

  String get widgetName;
}

abstract class PerformanceMonitoredState<
  T extends PerformanceMonitoredStatefulWidget
>
    extends ConsumerState<T> {
  @override
  void initState() {
    super.initState();

    // Track widget lifecycle
    SentryService.trackAppLifecycle('${widget.widgetName}.initState');

    // Add breadcrumb for widget initialization
    SentryService.addBreadcrumb(
      message: '${widget.widgetName} initialized',
      category: 'widget.lifecycle',
    );
  }

  @override
  void dispose() {
    // Track widget disposal
    SentryService.trackAppLifecycle('${widget.widgetName}.dispose');

    super.dispose();
  }

  /// Track an async operation with performance monitoring
  Future<T> trackOperation<T>({
    required String operationName,
    required Future<T> Function() operation,
    Map<String, dynamic>? context,
  }) {
    return ref
        .read(performanceMonitorProvider)
        .trackAsyncOperation(
          operationName: '${widget.widgetName}.$operationName',
          operation: operation,
          context: context,
        );
  }

  /// Track user interaction
  Future<T> trackInteraction<T>({
    required String action,
    required Future<T> Function() interaction,
    Map<String, dynamic>? extra,
  }) {
    return SentryService.trackUserInteraction(
      widget: widget.widgetName,
      action: action,
      interaction: interaction,
      extra: extra,
    );
  }
}

/// Example usage of performance monitored widget
class ExampleMonitoredWidget extends PerformanceMonitoredWidget {
  const ExampleMonitoredWidget({super.key});

  @override
  String get widgetName => 'ExampleWidget';

  @override
  Widget buildWidget(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance Monitored Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Track button interaction
            await SentryService.trackUserInteraction(
              widget: widgetName,
              action: 'button_tap',
              interaction: () async {
                // Simulate some work
                await Future.delayed(const Duration(milliseconds: 100));
              },
            );
          },
          child: const Text('Tracked Button'),
        ),
      ),
    );
  }
}
