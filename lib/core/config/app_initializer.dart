import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Centralizes app initialization logic
class AppInitializer {
  AppInitializer._();

  /// Initialize all app services and configurations
  /// Note: WidgetsFlutterBinding.ensureInitialized() and dotenv.load() 
  /// are now handled in main.dart before runZonedGuarded to avoid Zone mismatch
  static Future<void> initialize() async {
    try {
      // Validate that environment variables are loaded
      // (they should have been loaded in main.dart)
      _validateEnvironmentVariables();

      // Initialize Supabase
      await _initializeSupabase();

      // Initialize Sentry if enabled
      await _initializeSentry();
    } catch (e, stackTrace) {
      // Log initialization errors
      debugPrint('App initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');

      // Re-throw to prevent app from starting in broken state
      rethrow;
    }
  }


  /// Validate that all required environment variables are present
  static void _validateEnvironmentVariables() {
    // First check if dotenv has loaded the variables
    if (dotenv.env.isEmpty && kDebugMode) {
      // If dotenv is empty, try to load from dart-define
      _loadFromDartDefine();
    }

    final requiredVars = ['SUPABASE_URL', 'SUPABASE_ANON_KEY'];

    for (final varName in requiredVars) {
      if (dotenv.env[varName] == null || dotenv.env[varName]!.isEmpty) {
        throw Exception('Missing required environment variable: $varName');
      }
    }
  }

  /// Load environment variables from --dart-define if .env is not available
  static void _loadFromDartDefine() {
    // These values are set at compile time using --dart-define
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const sentryDsn = String.fromEnvironment('SENTRY_DSN');

    if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
      // Override dotenv values with dart-define values
      dotenv.env['SUPABASE_URL'] = supabaseUrl;
      dotenv.env['SUPABASE_ANON_KEY'] = supabaseAnonKey;

      if (sentryDsn.isNotEmpty) {
        dotenv.env['SENTRY_DSN'] = sentryDsn;
      }
    }
  }

  /// Initialize Supabase with enhanced configuration
  static Future<void> _initializeSupabase() async {
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Supabase credentials not found');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.implicit,
        autoRefreshToken: true,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
        timeout: Duration(seconds: 30),
      ),
      storageOptions: const StorageClientOptions(retryAttempts: 3),
    );

    debugPrint('Supabase initialized successfully');
  }

  /// Initialize Sentry automatically if DSN is available
  static Future<void> _initializeSentry() async {
    final sentryDsn = dotenv.env['SENTRY_DSN'];

    // Skip initialization if DSN is not available
    if (sentryDsn == null || sentryDsn.isEmpty) {
      if (kDebugMode) {
        debugPrint('Sentry DSN not found, skipping Sentry initialization');
      }
      return;
    }

    try {
      // Get app release version before initializing Sentry
      final appRelease = await _getAppRelease();

      await SentryFlutter.init((options) {
        options.dsn = sentryDsn;

        // Automatic environment detection
        options.environment = kDebugMode ? 'debug' : 'release';

        // Performance monitoring optimized for environment
        options.tracesSampleRate = kDebugMode ? 1.0 : 0.1;
        options.profilesSampleRate = kDebugMode ? 1.0 : 0.1;
        options.enableAutoPerformanceTracing = true;
        options.enableUserInteractionTracing = true;

        // Debug features - more verbose in debug mode
        options.attachScreenshot = true;
        options.attachViewHierarchy = kDebugMode;

        // Release tracking
        options.release = appRelease;

        // Breadcrumb configuration
        options.maxBreadcrumbs = kDebugMode ? 100 : 50;
        options.enableAutoNativeBreadcrumbs = true;

        // Session tracking
        options.enableAutoSessionTracking = true;

        // Debug configuration
        options.debug = kDebugMode;

        // Filter errors with beforeSend to avoid spam
        options.beforeSend = (event, hint) {
          // Skip certain development-related errors in debug mode
          if (kDebugMode && event.throwable != null) {
            final errorMessage = event.throwable.toString().toLowerCase();
            
            // Filter out common development errors that aren't critical
            if (errorMessage.contains('hot reload') ||
                errorMessage.contains('hot restart') ||
                errorMessage.contains('debug service') ||
                errorMessage.contains('observatory')) {
              return null; // Don't send to Sentry
            }
          }

          // Add custom context to all events
          event.contexts.app?.buildType = kDebugMode ? 'debug' : 'release';

          return event;
        };
      });

      if (kDebugMode) {
        debugPrint('Sentry initialized successfully in ${kDebugMode ? 'debug' : 'release'} mode');
      }
    } catch (e, stackTrace) {
      // Silently fail if Sentry initialization fails
      if (kDebugMode) {
        debugPrint('Warning: Sentry initialization failed: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      // Don't rethrow - app should continue even if Sentry fails
    }
  }


  /// Get app release version dynamically
  static Future<String> _getAppRelease() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.appName}@${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      // Fallback to static version if package info fails
      return 'ojyx@1.0.0+1';
    }
  }

  /// Get the Supabase client instance
  static SupabaseClient get supabaseClient => Supabase.instance.client;
}
