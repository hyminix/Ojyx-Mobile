import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'core/config/app_initializer.dart';
import 'core/config/router_config.dart';
import 'core/services/sentry_monitoring_service.dart';
import 'features/multiplayer/presentation/providers/room_providers.dart';

/// Main entry point - follows the pattern required to avoid Zone mismatch errors.
/// WidgetsFlutterBinding.ensureInitialized() must be called in the main zone,
/// before runZonedGuarded creates a custom zone.
Future<void> main() async {
  // CRITICAL: Initialize Flutter bindings in the main zone
  // This must happen before runZonedGuarded to avoid Zone mismatch errors
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables early in the main zone
  // This is safe to do before runZonedGuarded
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Warning: .env file not found. Using compile-time constants.');
    }
  }

  // Set up global error handlers for comprehensive error capture
  _setupGlobalErrorHandlers();

  // Wrap the app execution with Sentry's runZonedGuarded for Dart error capture
  // All app initialization that doesn't require bindings goes inside this zone
  runZonedGuarded(
    () async {
      // Initialize remaining services (Supabase, Sentry, etc.)
      // This is now safe because bindings are already initialized
      await AppInitializer.initialize();

      // Initialize monitoring service and log zone success
      final monitoring = SentryMonitoringService();
      await monitoring.initializeMonitoring();
      monitoring.logZoneInitialization(success: true);

      // Run the app with Sentry's wrapper for Flutter error capture
      runApp(
        SentryWidget(
          child: const ProviderScope(child: OjyxApp()),
        ),
      );
    },
    (error, stackTrace) {
      // Log zone initialization failure if it happens early
      if (!Sentry.isEnabled) {
        // Sentry not yet initialized, just print
        if (kDebugMode) {
          print('Early error before Sentry init: $error');
        }
      } else {
        // Capture unhandled Dart errors with monitoring context
        final monitoring = SentryMonitoringService();
        monitoring.logZoneInitialization(success: false, error: error.toString());
        
        Sentry.captureException(error, stackTrace: stackTrace);
        if (kDebugMode) {
          print('Unhandled Dart error caught: $error');
        }
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
    
    // Start connection monitoring service
    ref.watch(connectionMonitorServiceProvider);

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
