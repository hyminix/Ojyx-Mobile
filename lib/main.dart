import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/app_initializer.dart';
import 'core/config/router_config.dart';

Future<void> main() async {
  // Initialize all app services (including Sentry)
  await AppInitializer.initialize();

  // Set up global error handlers for comprehensive error capture
  _setupGlobalErrorHandlers();

  // Wrap the app with Sentry's runZonedGuarded for Dart error capture
  runZonedGuarded(
    () {
      // Run the app with Sentry's wrapper for Flutter error capture
      runApp(
        SentryWidget(
          child: const ProviderScope(child: OjyxApp()),
        ),
      );
    },
    (error, stackTrace) {
      // Capture unhandled Dart errors
      Sentry.captureException(error, stackTrace: stackTrace);
      if (kDebugMode) {
        print('Unhandled Dart error caught: $error');
      }
    },
  );
}

/// Set up global error handlers for Flutter and platform errors
void _setupGlobalErrorHandlers() {
  // Capture Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    // Send to Sentry
    Sentry.captureException(
      details.exception,
      stackTrace: details.stack,
      withScope: (scope) {
        scope.setTag('error_type', 'flutter_error');
        scope.level = SentryLevel.error;
        scope.setTag('error_library', details.library ?? 'unknown');
        scope.setTag('error_context', details.context?.toString() ?? 'unknown');
        scope.setTag('error_silent', details.silent.toString());
      },
    );

    // Also print to console in debug mode
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };

  // Capture platform dispatcher errors (for platform channel errors)
  PlatformDispatcher.instance.onError = (error, stack) {
    Sentry.captureException(
      error,
      stackTrace: stack,
      withScope: (scope) {
        scope.setTag('error_type', 'platform_error');
        scope.level = SentryLevel.error;
      },
    );
    
    if (kDebugMode) {
      print('Platform error caught: $error');
    }
    
    return true; // Indicate that the error was handled
  };
}

class OjyxApp extends ConsumerWidget {
  const OjyxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Ojyx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: const CardThemeData(elevation: 2, margin: EdgeInsets.all(8)),
      ),
      routerConfig: router,
    );
  }
}
