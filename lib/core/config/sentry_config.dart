import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'env_config.dart';

class SentryConfig {
  static Future<void> initialize({required AppRunner appRunner}) async {
    if (kDebugMode && EnvConfig.sentryDsn.isEmpty) {
      // In debug mode without Sentry DSN, run app normally
      await appRunner();
      return;
    }

    await SentryFlutter.init((options) {
      options.dsn = EnvConfig.sentryDsn;
      options.environment = EnvConfig.sentryEnvironment;

      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = EnvConfig.isProduction ? 0.1 : 1.0;

      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions
      options.profilesSampleRate = 1.0;

      // Capture failed HTTP requests
      options.captureFailedRequests = true;

      // Set diagnostic level
      options.diagnosticLevel = EnvConfig.isProduction
          ? SentryLevel.error
          : SentryLevel.debug;

      // Attach screenshots on errors (mobile only)
      options.attachScreenshot = true;

      // Attach view hierarchy on errors
      options.attachViewHierarchy = true;

      // Before send callback to filter events
      options.beforeSend = (event, hint) {
        // Don't send events in debug mode unless explicitly configured
        if (kDebugMode && !EnvConfig.isProduction) {
          return null;
        }
        return event;
      };
    }, appRunner: appRunner);
  }

  static void captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, dynamic>? extra,
  }) {
    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  static void captureMessage(
    String message, {
    SentryLevel? level,
    Map<String, dynamic>? extra,
  }) {
    Sentry.captureMessage(
      message,
      level: level ?? SentryLevel.info,
      withScope: (scope) {
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  static ISentrySpan? startTransaction(String name, String operation) {
    return Sentry.startTransaction(name, operation);
  }

  static void setUser(String? userId, {Map<String, dynamic>? data}) {
    if (userId == null) {
      Sentry.configureScope((scope) => scope.setUser(null));
    } else {
      Sentry.configureScope(
        (scope) => scope.setUser(SentryUser(id: userId, data: data)),
      );
    }
  }
}
