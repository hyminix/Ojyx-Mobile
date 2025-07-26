import 'package:flutter/material.dart';
import '../services/sentry_service.dart';

/// Navigation observer for tracking route changes
class AppNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackNavigation(
      from: previousRoute?.settings.name,
      to: route.settings.name,
      action: 'push',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _trackNavigation(
      from: route.settings.name,
      to: previousRoute?.settings.name,
      action: 'pop',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _trackNavigation(
      from: oldRoute?.settings.name,
      to: newRoute?.settings.name,
      action: 'replace',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _trackNavigation(
      from: route.settings.name,
      to: previousRoute?.settings.name,
      action: 'remove',
    );
  }

  void _trackNavigation({String? from, String? to, required String action}) {
    // Extract route parameters from the route settings
    final Map<String, dynamic> params = {};

    if (to != null) {
      // Extract path parameters from route name
      final uri = Uri.tryParse(to);
      if (uri != null) {
        params['path'] = uri.path;
        params['queryParams'] = uri.queryParameters;
      }
    }

    // Track navigation with Sentry
    SentryService.trackNavigation(
      from: from ?? 'unknown',
      to: to ?? 'unknown',
      params: {'action': action, ...params},
    );

    // Debug logging in development
    assert(() {
      debugPrint('Navigation: $action from $from to $to');
      return true;
    }());
  }
}
