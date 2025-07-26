import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Centralizes app initialization logic
class AppInitializer {
  AppInitializer._();

  /// Initialize all app services and configurations
  static Future<void> initialize() async {
    try {
      // Initialize Flutter bindings
      WidgetsFlutterBinding.ensureInitialized();

      // Load environment variables
      await _loadEnvironmentVariables();

      // Initialize Supabase
      await _initializeSupabase();

      // Initialize Sentry (if not in debug mode)
      if (!kDebugMode) {
        await _initializeSentry();
      }
    } catch (e, stackTrace) {
      // Log initialization errors
      debugPrint('App initialization failed: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Re-throw to prevent app from starting in broken state
      rethrow;
    }
  }

  /// Load environment variables from .env file
  static Future<void> _loadEnvironmentVariables() async {
    try {
      await dotenv.load(fileName: '.env');
      
      // Validate required environment variables
      _validateEnvironmentVariables();
      
      debugPrint('Environment variables loaded successfully');
    } catch (e) {
      // In debug mode, allow running without .env file
      if (kDebugMode) {
        debugPrint('Warning: .env file not found. Using default values.');
        // Load from compile-time constants if available
        _loadFromDartDefine();
      } else {
        throw Exception('Failed to load environment variables: $e');
      }
    }
  }

  /// Validate that all required environment variables are present
  static void _validateEnvironmentVariables() {
    final requiredVars = [
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
    ];

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
      storageOptions: const StorageClientOptions(
        retryAttempts: 3,
      ),
    );

    debugPrint('Supabase initialized successfully');
  }

  /// Initialize Sentry with enhanced performance monitoring
  static Future<void> _initializeSentry() async {
    final sentryDsn = dotenv.env['SENTRY_DSN'];
    
    if (sentryDsn == null || sentryDsn.isEmpty) {
      debugPrint('Sentry DSN not found, skipping Sentry initialization');
      return;
    }

    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDsn;
        
        // Enhanced configuration for performance monitoring
        options.tracesSampleRate = _getTracesSampleRate();
        options.profilesSampleRate = _getProfilesSampleRate();
        options.enableAutoPerformanceTracing = true;
        options.enableUserInteractionTracing = true;
        
        // Screenshot and view hierarchy for better debugging
        options.attachScreenshot = _shouldAttachScreenshot();
        options.attachViewHierarchy = true;
        
        // Environment configuration
        options.environment = _getEnvironment();
        
        // Release tracking
        options.release = _getAppRelease();
        
        // Breadcrumb configuration
        options.maxBreadcrumbs = 100;
        options.enableAutoNativeBreadcrumbs = true;
        
        // Session tracking
        options.enableAutoSessionTracking = true;
      },
    );

    debugPrint('Sentry initialized successfully');
  }

  /// Get traces sample rate based on environment
  static double _getTracesSampleRate() {
    final environment = _getEnvironment();
    
    switch (environment) {
      case 'production':
        return 0.1; // 10% in production
      case 'staging':
        return 0.5; // 50% in staging
      default:
        return 1.0; // 100% in development
    }
  }

  /// Get profiles sample rate based on environment
  static double _getProfilesSampleRate() {
    final environment = _getEnvironment();
    
    switch (environment) {
      case 'production':
        return 0.1; // 10% in production
      case 'staging':
        return 0.3; // 30% in staging
      default:
        return 1.0; // 100% in development
    }
  }

  /// Check if screenshots should be attached
  static bool _shouldAttachScreenshot() {
    final enableScreenshots = dotenv.env['ENABLE_ERROR_SCREENSHOTS'];
    return enableScreenshots?.toLowerCase() == 'true';
  }

  /// Get current environment
  static String _getEnvironment() {
    return dotenv.env['ENVIRONMENT'] ?? 'development';
  }

  /// Get app release version
  static String _getAppRelease() {
    // This would typically come from your pubspec.yaml version
    // For now, we'll use a placeholder
    return 'ojyx@1.0.0+1';
  }

  /// Get the Supabase client instance
  static SupabaseClient get supabaseClient => Supabase.instance.client;
}