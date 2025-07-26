import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/sentry_service.dart';

part 'sentry_provider.g.dart';

/// Provider for accessing Sentry service functionality
@Riverpod(keepAlive: true)
class SentryServiceProvider extends _$SentryServiceProvider {
  @override
  SentryService build() {
    // Return static access to SentryService
    // Since SentryService uses static methods, we don't instantiate it
    return SentryService as SentryService;
  }

  /// Track a transaction with Sentry
  Future<T> trackTransaction<T>({
    required String name,
    required String operation,
    required Future<T> Function() action,
    Map<String, dynamic>? data,
  }) {
    return SentryService.trackTransaction(
      name: name,
      operation: operation,
      action: action,
      data: data,
    );
  }

  /// Track a database operation
  Future<T> trackDatabaseOperation<T>({
    required String description,
    required String operation,
    required Future<T> Function() query,
    String? table,
  }) {
    return SentryService.trackDatabaseOperation(
      description: description,
      operation: operation,
      query: query,
      table: table,
    );
  }

  /// Track a network request
  Future<T> trackNetworkRequest<T>({
    required String url,
    required String method,
    required Future<T> Function() request,
  }) {
    return SentryService.trackNetworkRequest(
      url: url,
      method: method,
      request: request,
    );
  }

  /// Track user interaction
  Future<T> trackUserInteraction<T>({
    required String widget,
    required String action,
    required Future<T> Function() interaction,
    Map<String, dynamic>? extra,
  }) {
    return SentryService.trackUserInteraction(
      widget: widget,
      action: action,
      interaction: interaction,
      extra: extra,
    );
  }

  /// Add a breadcrumb
  void addBreadcrumb({
    required String message,
    required String category,
    Map<String, dynamic>? data,
  }) {
    SentryService.addBreadcrumb(
      message: message,
      category: category,
      data: data,
    );
  }

  /// Track navigation
  void trackNavigation({
    required String from,
    required String to,
    Map<String, dynamic>? params,
  }) {
    SentryService.trackNavigation(
      from: from,
      to: to,
      params: params,
    );
  }

  /// Track Supabase operation
  Future<T> trackSupabaseOperation<T>({
    required String operation,
    required String table,
    required Future<T> Function() query,
    Map<String, dynamic>? filters,
  }) {
    return SentryService.trackSupabaseOperation(
      operation: operation,
      table: table,
      query: query,
      filters: filters,
    );
  }
}

/// Provider for performance monitoring mixin
@riverpod
PerformanceMonitor performanceMonitor(Ref ref) {
  return PerformanceMonitor(ref);
}

/// Mixin for adding performance monitoring to widgets
class PerformanceMonitor {
  final Ref _ref;
  
  PerformanceMonitor(this._ref);

  /// Track widget build performance
  Future<T> trackWidgetBuild<T>({
    required String widgetName,
    required Future<T> Function() buildFunction,
  }) async {
    final sentry = _ref.read(sentryServiceProviderProvider.notifier);
    
    return sentry.trackTransaction(
      name: '$widgetName.build',
      operation: 'ui.render',
      action: buildFunction,
    );
  }

  /// Track async operation in widget
  Future<T> trackAsyncOperation<T>({
    required String operationName,
    required Future<T> Function() operation,
    Map<String, dynamic>? context,
  }) async {
    final sentry = _ref.read(sentryServiceProviderProvider.notifier);
    
    return sentry.trackTransaction(
      name: operationName,
      operation: 'async',
      action: operation,
      data: context,
    );
  }
}